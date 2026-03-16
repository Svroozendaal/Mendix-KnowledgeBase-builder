import type { AiSettings, Message } from '@kb-copilot/shared';
import type { AIProvider, AIProviderOptions, StreamChunk, ToolDefinition } from './types.js';
import { AuthenticationError, ApiError, RateLimitError } from './errors.js';
import { createLogger } from '../../logger.js';

const log = createLogger('ClaudeAPI');

interface AnthropicMessage {
  role: 'user' | 'assistant';
  content: string | AnthropicContentBlock[];
}

interface AnthropicContentBlock {
  type: string;
  text?: string;
  id?: string;
  name?: string;
  input?: Record<string, unknown>;
  tool_use_id?: string;
  content?: string;
  is_error?: boolean;
}

function convertMessages(messages: Message[]): AnthropicMessage[] {
  const result: AnthropicMessage[] = [];

  for (const msg of messages) {
    if (msg.role === 'system') continue;

    const blocks: AnthropicContentBlock[] = [];
    for (const block of msg.content) {
      if (block.type === 'text') {
        blocks.push({ type: 'text', text: block.text });
      } else if (block.type === 'tool_use') {
        blocks.push({
          type: 'tool_use',
          id: block.toolCall.id,
          name: block.toolCall.name,
          input: block.toolCall.arguments,
        });
      } else if (block.type === 'tool_result') {
        blocks.push({
          type: 'tool_result',
          tool_use_id: block.toolResult.toolCallId,
          content: block.toolResult.content,
          is_error: block.toolResult.isError,
        });
      }
    }

    if (blocks.length > 0) {
      result.push({
        role: msg.role === 'assistant' ? 'assistant' : 'user',
        content: blocks,
      });
    }
  }

  return result;
}

function convertTools(tools: ToolDefinition[]): Array<{ name: string; description: string; input_schema: unknown; cache_control?: { type: string } }> {
  const converted = tools.map((t) => ({
    name: t.name,
    description: t.description,
    input_schema: t.input_schema,
  }));
  // Mark the last tool with cache_control so everything up to (and including)
  // system prompt + tools is cached across requests in the same conversation.
  if (converted.length > 0) {
    (converted[converted.length - 1] as Record<string, unknown>).cache_control = { type: 'ephemeral' };
  }
  return converted;
}

export class ClaudeApiProvider implements AIProvider {
  constructor(private settings: AiSettings) {}

  async *sendMessage(options: AIProviderOptions): AsyncIterable<StreamChunk> {
    const apiKey = this.settings.claudeApiKey;
    if (!apiKey) {
      throw new AuthenticationError('Claude API');
    }

    const model = this.settings.claudeApiModel ?? 'claude-sonnet-4-20250514';
    const messages = convertMessages(options.messages);

    log.info(`Sending request to Anthropic API`, { model, messageCount: messages.length, maxTokens: options.maxTokens ?? 8192 });

    // Wrap system prompt as a content block with cache_control for prompt caching
    const systemBlocks = [
      { type: 'text', text: options.systemPrompt, cache_control: { type: 'ephemeral' } },
    ];

    const body: Record<string, unknown> = {
      model,
      max_tokens: options.maxTokens ?? 8192,
      system: systemBlocks,
      messages,
      stream: true,
    };

    if (options.tools && options.tools.length > 0) {
      body.tools = convertTools(options.tools);
      log.debug(`Tools attached`, { toolCount: options.tools.length, names: options.tools.map(t => t.name) });
    }

    let response: Response;
    try {
      response = await fetch('https://api.anthropic.com/v1/messages', {
        method: 'POST',
        headers: {
          'x-api-key': apiKey,
          'anthropic-version': '2023-06-01',
          'anthropic-beta': 'prompt-caching-2024-07-31',
          'content-type': 'application/json',
        },
        body: JSON.stringify(body),
        signal: options.onCancel,
      });
    } catch (err) {
      log.error(`Fetch failed`, { error: (err as Error).message, name: (err as Error).name });
      throw err;
    }

    log.info(`API response status: ${response.status}`);

    if (!response.ok) {
      const errorBody = await response.text().catch(() => '');
      log.error(`API error response`, { status: response.status, body: errorBody.slice(0, 500) });
      if (response.status === 401) {
        throw new AuthenticationError('Claude API');
      }
      if (response.status === 429) {
        const retryAfterHeader = response.headers.get('retry-after');
        const retryAfterMs = retryAfterHeader ? parseInt(retryAfterHeader, 10) * 1000 : 60000;
        log.warn(`Rate limited (429)`, { retryAfterMs, retryAfterHeader });
        throw new RateLimitError(retryAfterMs);
      }
      throw new ApiError(`API request failed (${response.status}): ${errorBody.slice(0, 200)}`);
    }

    if (!response.body) {
      throw new ApiError('No response body received');
    }

    // Per-stream state (NOT module-level) to track tool_use block indices
    const activeToolBlockIndices = new Set<number>();

    const reader = response.body.getReader();
    const decoder = new TextDecoder();
    let buffer = '';
    let chunkCount = 0;

    try {
      while (true) {
        const { done, value } = await reader.read();
        if (done) {
          log.info(`SSE stream ended after ${chunkCount} chunks`);
          break;
        }

        buffer += decoder.decode(value, { stream: true });
        const lines = buffer.split('\n');
        buffer = lines.pop() ?? '';

        for (const line of lines) {
          const chunk = parseSSELine(line, activeToolBlockIndices);
          if (chunk) {
            chunkCount++;
            if (chunk.type === 'error') {
              log.error(`SSE stream error event`, { error: chunk.error });
            } else if (chunk.type === 'message_stop') {
              log.info(`Stream message_stop`, { stopReason: chunk.stopReason, usage: chunk.usage });
            } else if (chunk.type === 'tool_use_start') {
              log.info(`Tool use started`, { toolName: chunk.toolName, toolCallId: chunk.toolCallId });
            }
            yield chunk;
          }
        }
      }
    } catch (err) {
      log.error(`SSE read error`, { error: (err as Error).message, name: (err as Error).name, chunkCount });
      throw err;
    } finally {
      reader.releaseLock();
    }
  }

  async validateConfig(): Promise<{ valid: boolean; error?: string }> {
    const apiKey = this.settings.claudeApiKey;
    if (!apiKey) {
      return { valid: false, error: 'API key not set' };
    }

    try {
      const model = this.settings.claudeApiModel ?? 'claude-sonnet-4-20250514';
      const response = await fetch('https://api.anthropic.com/v1/messages', {
        method: 'POST',
        headers: {
          'x-api-key': apiKey,
          'anthropic-version': '2023-06-01',
          'content-type': 'application/json',
        },
        body: JSON.stringify({
          model,
          max_tokens: 32,
          messages: [{ role: 'user', content: 'Say hello in one word.' }],
        }),
      });

      if (!response.ok) {
        if (response.status === 401) {
          return { valid: false, error: 'Invalid API key' };
        }
        return { valid: false, error: `API error: ${response.status}` };
      }

      return { valid: true };
    } catch (err) {
      return { valid: false, error: `Connection failed: ${(err as Error).message}` };
    }
  }
}

function parseSSELine(line: string, activeToolBlockIndices: Set<number>): StreamChunk | null {
  if (!line.startsWith('data: ')) return null;
  const data = line.slice(6).trim();
  if (data === '[DONE]') return null;

  try {
    const obj = JSON.parse(data);

    if (obj.type === 'content_block_start') {
      if (obj.content_block?.type === 'tool_use') {
        activeToolBlockIndices.add(obj.index);
        return {
          type: 'tool_use_start',
          toolCallId: obj.content_block.id,
          toolName: obj.content_block.name,
        };
      }
      return null;
    }

    if (obj.type === 'content_block_delta') {
      if (obj.delta?.type === 'text_delta') {
        return { type: 'text_delta', text: obj.delta.text };
      }
      if (obj.delta?.type === 'input_json_delta') {
        return { type: 'tool_use_delta', partialJson: obj.delta.partial_json };
      }
      return null;
    }

    if (obj.type === 'content_block_stop') {
      // Only yield tool_use_end for blocks that were tool_use blocks
      if (activeToolBlockIndices.has(obj.index)) {
        activeToolBlockIndices.delete(obj.index);
        return { type: 'tool_use_end' };
      }
      return null;
    }

    if (obj.type === 'message_start') {
      const u = obj.message?.usage;
      if (u) {
        log.info(`Prompt caching stats`, {
          inputTokens: u.input_tokens,
          cacheCreation: u.cache_creation_input_tokens ?? 0,
          cacheRead: u.cache_read_input_tokens ?? 0,
        });
      }
      return null;
    }

    if (obj.type === 'message_delta') {
      return {
        type: 'message_stop',
        stopReason: obj.delta?.stop_reason ?? 'end_turn',
        usage: obj.usage ? {
          inputTokens: obj.usage.input_tokens,
          outputTokens: obj.usage.output_tokens,
        } : undefined,
      };
    }

    if (obj.type === 'message_stop') {
      // message_delta already handled the stop
      return null;
    }

    if (obj.type === 'error') {
      return { type: 'error', error: obj.error?.message ?? 'Unknown API error' };
    }

    return null;
  } catch (err) {
    log.warn(`Failed to parse SSE line`, { line: line.slice(0, 200), error: (err as Error).message });
    return null;
  }
}
