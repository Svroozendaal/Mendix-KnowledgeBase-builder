import { randomUUID } from 'node:crypto';
import type { AiSettings, Message, Conversation, ToolCall } from '@kb-copilot/shared';
import type { WSServerEvent } from '@kb-copilot/shared';
import { AIProviderService } from '../ai-provider/index.js';
import type { StreamChunk } from '../ai-provider/index.js';
import { ToolExecutor } from '../tool-executor/index.js';
import { KB_TOOLS } from '../tool-executor/tool-definitions.js';
import { SystemPromptBuilder } from '../system-prompt/index.js';

const MAX_TOOL_LOOPS = 20;

const providerService = new AIProviderService();
const toolExecutor = new ToolExecutor();
const systemPromptBuilder = new SystemPromptBuilder();

export class ConversationService {
  async processMessage(
    settings: AiSettings,
    kbRoot: string,
    conversation: Conversation,
    userMessage: string,
    onEvent: (event: WSServerEvent) => void,
    signal?: AbortSignal,
  ): Promise<Message[]> {
    // Add user message
    const userMsg: Message = {
      id: randomUUID(),
      role: 'user',
      content: [{ type: 'text', text: userMessage }],
      timestamp: new Date().toISOString(),
    };
    conversation.messages.push(userMsg);

    const systemPrompt = await systemPromptBuilder.buildSystemPrompt(kbRoot);
    const newMessages: Message[] = [userMsg];

    let loopCount = 0;

    while (loopCount < MAX_TOOL_LOOPS) {
      loopCount++;

      // Send conversation to AI
      const stream = providerService.sendMessage(settings, {
        messages: conversation.messages,
        systemPrompt,
        tools: KB_TOOLS,
        onCancel: signal,
      });

      // Collect the response
      const { assistantMessage, toolCalls, stopReason, usage } =
        await this.collectStream(stream, onEvent);

      // Add assistant message to conversation
      conversation.messages.push(assistantMessage);
      newMessages.push(assistantMessage);

      // If the AI returned tool calls, execute them and loop
      if (toolCalls.length > 0 && stopReason === 'tool_use') {
        const toolResults = await toolExecutor.executeTools(kbRoot, toolCalls);

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
        continue;
      }

      // No tool calls — we're done
      onEvent({
        type: 'done',
        conversationId: conversation.id,
        usage: usage ?? undefined,
      });

      break;
    }

    if (loopCount >= MAX_TOOL_LOOPS) {
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

    return newMessages;
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
          currentToolId = chunk.toolCallId ?? randomUUID();
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
}
