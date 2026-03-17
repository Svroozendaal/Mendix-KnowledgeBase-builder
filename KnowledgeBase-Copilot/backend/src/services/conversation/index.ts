import { randomUUID } from 'node:crypto';
import { AiProvider } from '@kb-copilot/shared';
import type { AiSettings, Message, Conversation, ToolCall } from '@kb-copilot/shared';
import type { WSServerEvent } from '@kb-copilot/shared';
import { AIProviderService } from '../ai-provider/index.js';
import type { StreamChunk } from '../ai-provider/index.js';
import { ToolExecutor } from '../tool-executor/index.js';
import { KB_TOOLS } from '../tool-executor/tool-definitions.js';
import { SystemPromptBuilder } from '../system-prompt/index.js';
import { KBNavigator } from '../kb-navigator/index.js';
import { QuestionClassifier, CLASSIFICATION_HINTS } from '../question-classifier/index.js';
import type { ClassificationResult } from '../question-classifier/index.js';
import { createLogger } from '../../logger.js';

const log = createLogger('Conversation');
const MAX_TOOL_LOOPS = 8;
/** Max number of messages to keep in full when sending to the provider. */
const HISTORY_WINDOW_SIZE = 10;
/** Max files to pre-fetch for direct-lookup questions. */
const MAX_PREFETCH_FILES = 2;

const providerService = new AIProviderService();
const toolExecutor = new ToolExecutor();
const systemPromptBuilder = new SystemPromptBuilder();
const kbNavigator = new KBNavigator();
/** One classifier per kbRoot, lazily initialised. */
const classifierCache = new Map<string, QuestionClassifier>();

export class ConversationService {
  async processMessage(
    settings: AiSettings,
    kbRoot: string,
    conversation: Conversation,
    userMessage: string,
    onEvent: (event: WSServerEvent) => void,
    signal?: AbortSignal,
  ): Promise<Message[]> {
    log.info(`Processing message for conversation ${conversation.id}`, { userMessage: userMessage.slice(0, 100) });

    // On the first turn, pre-seed READER.md and ROUTING.md as a synthetic tool
    // exchange so the AI already has KB context without needing extra API calls.
    if (conversation.messages.length === 0) {
      const seeded = await this.seedKbContext(kbRoot);
      if (seeded.length > 0) {
        conversation.messages.push(...seeded);
        log.info(`Pre-seeded KB context`, { messageCount: seeded.length });
      }
    }

    // Add user message
    const userMsg: Message = {
      id: randomUUID(),
      role: 'user',
      content: [{ type: 'text', text: userMessage }],
      timestamp: new Date().toISOString(),
    };
    conversation.messages.push(userMsg);

    // --- Question classification & pre-fetch ---
    const classifier = await this.getClassifier(kbRoot);
    const classification = classifier.classify(userMessage);
    log.info('Question classified', { category: classification.category, confidence: classification.confidence, artifacts: classification.detectedArtifacts });

    if (classification.confidence === 'high' && classification.category.startsWith('direct-')) {
      const prefetched = await this.prefetchContext(kbRoot, classification);
      if (prefetched.length > 0) {
        conversation.messages.push(...prefetched);
        log.info('Pre-fetched context injected', { messageCount: prefetched.length });
      }
    }

    // Build system prompt with optional classification hint.
    // CLI providers use their own native tools (Read, Grep, Glob) and need
    // the KB root path in the prompt so the model can form absolute paths.
    const useCliTools = settings.provider === AiProvider.ClaudeCli || settings.provider === AiProvider.CodexCli;
    const hint = CLASSIFICATION_HINTS[classification.category];
    const systemPrompt = await systemPromptBuilder.buildSystemPrompt(kbRoot, hint, useCliTools);
    log.debug(`System prompt built`, { length: systemPrompt.length, kbRoot, useCliTools, hint: hint?.slice(0, 60) });
    const newMessages: Message[] = [userMsg];

    let loopCount = 0;

    while (loopCount < MAX_TOOL_LOOPS) {
      loopCount++;
      log.info(`Tool loop iteration ${loopCount}/${MAX_TOOL_LOOPS}`, { totalMessages: conversation.messages.length });

      // Build a compressed view of the history for the provider call.
      // Original conversation.messages is never mutated — full history is preserved for storage.
      const optimisedMessages = this.buildApiView(conversation.messages);
      log.debug(`Optimised message view`, { original: conversation.messages.length, optimised: optimisedMessages.length });

      // Send conversation to AI
      const stream = providerService.sendMessage(settings, {
        messages: optimisedMessages,
        systemPrompt,
        tools: KB_TOOLS,
        onCancel: signal,
        cwd: kbRoot,
      });

      log.debug(`Collecting stream...`);
      const collectResult = await this.collectStream(stream, onEvent);

      const { assistantMessage, toolCalls, stopReason, usage } = collectResult;

      log.info(`Stream collected`, {
        stopReason,
        toolCallCount: toolCalls.length,
        contentBlockCount: assistantMessage.content.length,
        usage,
      });

      // Add assistant message to conversation
      conversation.messages.push(assistantMessage);
      newMessages.push(assistantMessage);

      // If the AI returned tool calls, execute them and loop
      if (toolCalls.length > 0 && stopReason === 'tool_use') {
        log.info(`Executing ${toolCalls.length} tool call(s)`, {
          tools: toolCalls.map(tc => ({ name: tc.name, id: tc.id })),
        });
        const toolResults = await toolExecutor.executeTools(kbRoot, toolCalls);

        log.info(`Tool results received`, {
          results: toolResults.map(r => ({
            toolCallId: r.toolCallId,
            isError: r.isError,
            contentLength: r.content.length,
          })),
        });

        // Send tool result events
        for (const result of toolResults) {
          onEvent({
            type: 'tool_result',
            toolCallId: result.toolCallId,
            content: result.content,
            isError: result.isError,
          });
        }

        // Add tool results as a user message (Anthropic API convention)
        const toolResultMsg: Message = {
          id: randomUUID(),
          role: 'user',
          content: toolResults.map((r) => ({
            type: 'tool_result' as const,
            toolResult: r,
          })),
          timestamp: new Date().toISOString(),
        };
        conversation.messages.push(toolResultMsg);
        newMessages.push(toolResultMsg);

        // Continue the loop — send back to AI
        log.debug(`Continuing tool loop — sending results back to AI`);
        continue;
      }

      // No tool calls — we're done
      log.info(`Conversation turn complete`, { stopReason, loopCount });
      onEvent({
        type: 'done',
        conversationId: conversation.id,
        usage: usage ?? undefined,
      });

      break;
    }

    if (loopCount >= MAX_TOOL_LOOPS) {
      log.warn(`Max tool loops reached (${MAX_TOOL_LOOPS})`);
      onEvent({
        type: 'error',
        message: 'Maximum tool-use iterations reached.',
        code: 'MAX_LOOPS',
      });
      onEvent({
        type: 'done',
        conversationId: conversation.id,
      });
    }

    log.info(`processMessage finished`, { newMessageCount: newMessages.length, totalMessages: conversation.messages.length });
    return newMessages;
  }

  // ---------------------------------------------------------------------------
  // Question classification helpers
  // ---------------------------------------------------------------------------

  /** Get or create a classifier for the given kbRoot. */
  private async getClassifier(kbRoot: string): Promise<QuestionClassifier> {
    let classifier = classifierCache.get(kbRoot);
    if (!classifier) {
      classifier = new QuestionClassifier(kbRoot);
      await classifier.initialize();
      classifierCache.set(kbRoot, classifier);
    }
    return classifier;
  }

  /**
   * Pre-fetch KB files matching the classification's suggested searches.
   * Returns synthetic tool_use / tool_result message pairs so the AI
   * sees the content as if it had already called search_content + read_file.
   */
  private async prefetchContext(kbRoot: string, classification: ClassificationResult): Promise<Message[]> {
    const messages: Message[] = [];
    const now = new Date().toISOString();
    const filesRead = new Set<string>();

    for (const query of classification.suggestedSearches) {
      if (filesRead.size >= MAX_PREFETCH_FILES) break;

      let results;
      try {
        results = await kbNavigator.searchContent(kbRoot, query);
      } catch {
        continue;
      }
      if (results.length === 0) continue;

      // Deduplicate by file — read the top-ranked file
      const topFile = results[0].file;
      if (filesRead.has(topFile)) continue;
      filesRead.add(topFile);

      let content: string;
      try {
        content = await kbNavigator.readFile(kbRoot, topFile);
      } catch {
        continue;
      }

      const toolCallId = `prefetch_${randomUUID().slice(0, 8)}`;

      const assistantMsg: Message = {
        id: `prefetch_assistant_${randomUUID()}`,
        role: 'assistant',
        content: [{
          type: 'tool_use',
          toolCall: {
            id: toolCallId,
            name: 'read_file',
            arguments: { path: topFile },
          },
        }],
        timestamp: now,
      };

      const resultMsg: Message = {
        id: `prefetch_result_${randomUUID()}`,
        role: 'user',
        content: [{
          type: 'tool_result',
          toolResult: {
            toolCallId,
            content,
            isError: false,
          },
        }],
        timestamp: now,
      };

      messages.push(assistantMsg, resultMsg);
    }

    return messages;
  }

  private async collectStream(
    stream: AsyncIterable<StreamChunk>,
    onEvent: (event: WSServerEvent) => void,
  ): Promise<{
    assistantMessage: Message;
    toolCalls: ToolCall[];
    stopReason: string;
    usage?: { inputTokens: number; outputTokens: number };
  }> {
    const contentBlocks: Message['content'] = [];
    const toolCalls: ToolCall[] = [];
    let currentText = '';
    let currentToolId = '';
    let currentToolName = '';
    let currentToolJson = '';
    let stopReason = 'end_turn';
    let usage: { inputTokens: number; outputTokens: number } | undefined;

    for await (const chunk of stream) {
      switch (chunk.type) {
        case 'text_delta':
          currentText += chunk.text ?? '';
          onEvent({ type: 'text_delta', content: chunk.text ?? '' });
          break;

        case 'tool_use_start':
          // Flush accumulated text
          if (currentText) {
            contentBlocks.push({ type: 'text', text: currentText });
            currentText = '';
          }
          currentToolId = chunk.toolCallId ?? `toolu_${randomUUID().replace(/-/g, '').slice(0, 20)}`;
          currentToolName = chunk.toolName ?? 'unknown';
          currentToolJson = chunk.partialJson ?? '';
          break;

        case 'tool_use_delta':
          currentToolJson += chunk.partialJson ?? '';
          break;

        case 'tool_use_end': {
          let args: Record<string, unknown> = {};
          try {
            args = JSON.parse(currentToolJson || '{}');
          } catch { /* use empty args */ }

          const toolCall: ToolCall = {
            id: currentToolId,
            name: currentToolName,
            arguments: args,
          };
          toolCalls.push(toolCall);
          contentBlocks.push({ type: 'tool_use', toolCall });

          onEvent({
            type: 'tool_call',
            id: toolCall.id,
            name: toolCall.name,
            arguments: toolCall.arguments,
          });

          currentToolId = '';
          currentToolName = '';
          currentToolJson = '';
          break;
        }

        case 'message_stop':
          stopReason = chunk.stopReason ?? 'end_turn';
          if (chunk.usage) usage = chunk.usage;
          break;

        case 'error':
          onEvent({ type: 'error', message: chunk.error ?? 'Unknown error' });
          break;
      }
    }

    // Flush any remaining text
    if (currentText) {
      contentBlocks.push({ type: 'text', text: currentText });
    }

    const assistantMessage: Message = {
      id: randomUUID(),
      role: 'assistant',
      content: contentBlocks,
      timestamp: new Date().toISOString(),
    };

    // If tool calls are present, the stop_reason is tool_use
    if (toolCalls.length > 0) {
      stopReason = 'tool_use';
    }

    return { assistantMessage, toolCalls, stopReason, usage };
  }

  // ---------------------------------------------------------------------------
  // KB context seeding
  // ---------------------------------------------------------------------------

  /**
   * Pre-load READER.md and ROUTING.md as synthetic tool_use / tool_result
   * message pairs.  This has two benefits over plain-text seeding:
   * 1. The existing compressOldToolResults() logic will automatically shrink
   *    these results once newer tool calls push them out of the keep window.
   * 2. The AI sees them as "already called read_file" so it won't re-request.
   */
  private async seedKbContext(kbRoot: string): Promise<Message[]> {
    const files = ['READER.md', 'ROUTING.md'];
    const messages: Message[] = [];
    const now = new Date().toISOString();

    for (const file of files) {
      let content: string;
      try {
        content = await kbNavigator.readFile(kbRoot, file);
      } catch {
        continue; // file not found — skip
      }

      const toolCallId = `seed_${file.replace('.', '_')}_${randomUUID().slice(0, 8)}`;

      // Assistant message with a synthetic tool_use block (as if AI called read_file)
      const assistantMsg: Message = {
        id: `seed_assistant_${randomUUID()}`,
        role: 'assistant',
        content: [{
          type: 'tool_use',
          toolCall: {
            id: toolCallId,
            name: 'read_file',
            arguments: { path: file },
          },
        }],
        timestamp: now,
      };

      // User message with the tool_result (as if KB Navigator returned the content)
      const resultMsg: Message = {
        id: `seed_result_${randomUUID()}`,
        role: 'user',
        content: [{
          type: 'tool_result',
          toolResult: {
            toolCallId,
            content,
            isError: false,
          },
        }],
        timestamp: now,
      };

      messages.push(assistantMsg, resultMsg);
    }

    return messages;
  }

  // ---------------------------------------------------------------------------
  // Token optimisation helpers
  // ---------------------------------------------------------------------------

  /**
   * Build a lightweight view of the message history for the API call.
   * 1. Compress tool results from previous turns (before turnStartIndex).
   * 2. Window old messages if the history is long.
   * The original conversation.messages array is never mutated.
   */
  private buildApiView(messages: Message[]): Message[] {
    let view = this.compressOldToolResults(messages);
    view = this.windowMessages(view);
    return view;
  }

  /**
   * Replace tool_result content with short placeholders, keeping only the most
   * recent KEEP_FULL_RESULTS tool-result messages in full. This applies both to
   * previous turns AND earlier iterations within the current turn's tool loop —
   * the key insight is that within a single question the AI can make 10+ tool
   * calls, and resending all results in full each time is the #1 token cost.
   */
  private compressOldToolResults(messages: Message[]): Message[] {
    const KEEP_FULL_RESULTS = 2;

    // Find indices of all tool-result messages (newest last)
    const toolResultIndices: number[] = [];
    for (let i = 0; i < messages.length; i++) {
      if (messages[i].role === 'user' && messages[i].content.some(b => b.type === 'tool_result')) {
        toolResultIndices.push(i);
      }
    }

    // Keep the last KEEP_FULL_RESULTS tool-result messages in full
    const keepFullSet = new Set(toolResultIndices.slice(-KEEP_FULL_RESULTS));

    return messages.map((msg, idx) => {
      if (keepFullSet.has(idx)) return msg;
      if (msg.role !== 'user') return msg;

      const hasToolResult = msg.content.some(b => b.type === 'tool_result');
      if (!hasToolResult) return msg;

      return {
        ...msg,
        content: msg.content.map(block => {
          if (block.type !== 'tool_result') return block;
          const tr = block.toolResult;
          const summary = tr.isError
            ? `[Tool error: ${tr.content.slice(0, 80)}]`
            : `[Previously returned: ${tr.content.length} chars]`;
          return {
            type: 'tool_result' as const,
            toolResult: { toolCallId: tr.toolCallId, content: summary, isError: tr.isError },
          };
        }),
      };
    });
  }

  /**
   * If the message history exceeds HISTORY_WINDOW_SIZE, keep only the most
   * recent messages and replace older ones with a short conversation summary.
   * The cut point is always at a real user message (text-bearing, not a
   * tool_result-only message) to avoid orphaning tool_use blocks.
   */
  private windowMessages(messages: Message[]): Message[] {
    if (messages.length <= HISTORY_WINDOW_SIZE) return messages;

    // Find a safe cut point: a text-bearing user message near the window boundary.
    let cutIndex = messages.length - HISTORY_WINDOW_SIZE;
    while (cutIndex < messages.length) {
      const msg = messages[cutIndex];
      if (msg.role === 'user' && msg.content.some(b => b.type === 'text')) break;
      cutIndex++;
    }
    // If we couldn't find a safe cut, keep everything
    if (cutIndex >= messages.length - 2) return messages;

    const old = messages.slice(0, cutIndex);
    const recent = messages.slice(cutIndex);

    // Build a concise summary of older turns
    const summaryParts: string[] = [];
    for (const msg of old) {
      const textContent = msg.content
        .filter((b): b is { type: 'text'; text: string } => b.type === 'text')
        .map(b => b.text)
        .join(' ');
      if (!textContent.trim()) continue;

      if (msg.role === 'user') {
        summaryParts.push(`User asked: ${textContent.slice(0, 150)}`);
      } else if (msg.role === 'assistant') {
        summaryParts.push(`Assistant answered: ${textContent.slice(0, 150)}`);
      }
    }

    if (summaryParts.length === 0) return recent;

    // Cap summary to avoid it growing larger than the messages it replaces
    const MAX_SUMMARY_LINES = 6;
    const trimmedSummary = summaryParts.length > MAX_SUMMARY_LINES
      ? [`[${summaryParts.length - MAX_SUMMARY_LINES} earlier exchanges omitted]`, ...summaryParts.slice(-MAX_SUMMARY_LINES)]
      : summaryParts;

    const summaryMsg: Message = {
      id: 'conversation-summary',
      role: 'user',
      content: [{
        type: 'text',
        text: `[Earlier conversation summary]\n${trimmedSummary.join('\n')}`,
      }],
      timestamp: old[old.length - 1]?.timestamp ?? new Date().toISOString(),
    };

    return [summaryMsg, ...recent];
  }
}
