import type { AiSettings, Message } from '@kb-copilot/shared';
import type { AIProvider, AIProviderOptions, StreamChunk, ToolDefinition } from './types.js';
import { AuthenticationError, ApiError } from './errors.js';

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

function convertTools(tools: ToolDefinition[]): Array<{ name: string; description: string; input_schema: unknown }> {
  return tools.map((t) => ({
    name: t.name,
    description: t.description,
    input_schema: t.input_schema,
  }));
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

    const body: Record<string, unknown> = {
      model,
      max_tokens: options.maxTokens ?? 8192,
      system: options.systemPrompt,
      messages,
      stream: true,
    };

    if (options.tools && options.tools.length > 0) {
      body.tools = convertTools(options.tools);
    }

    const response = await fetch('https://api.anthropic.com/v1/messages', {
      method: 'POST',
      headers: {
        'x-api-key': apiKey,
        'anthropic-version': '2023-06-01',
        'content-type': 'application/json',
      },
      body: JSON.stringify(body),
      signal: options.onCancel,
    });

    if (!response.ok) {
      const errorBody = await response.text().catch(() => '');
      if (response.status === 401) {
        throw new AuthenticationError('Claude API');
      }
      throw new ApiError(`API request failed (${response.status}): ${errorBody.slice(0, 200)}`);
    }

    if (!response.body) {
      throw new ApiError('No response body received');
    }

    const reader = response.body.getReader();
    const decoder = new TextDecoder();
    let buffer = '';

    try {
      while (true) {
        const { done, value } = await reader.read();
        if (done) break;

        buffer += decoder.decode(value, { stream: true });
        const lines = buffer.split('\n');
        buffer = lines.pop() ?? '';

        for (const line of lines) {
          const chunk = parseSSELine(line);
          if (chunk) yield chunk;
        }
      }
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

function parseSSELine(line: string): StreamChunk | null {
  if (!line.startsWith('data: ')) return null;
  const data = line.slice(6).trim();
  if (data === '[DONE]') return null;

  try {
    const obj = JSON.parse(data);

    if (obj.type === 'content_block_start') {
      if (obj.content_block?.type === 'tool_use') {
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
      return { type: 'tool_use_end' };
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
      return { type: 'message_stop', stopReason: 'end_turn' };
    }

    if (obj.type === 'error') {
      return { type: 'error', error: obj.error?.message ?? 'Unknown API error' };
    }

    return null;
  } catch {
    return null;
  }
}
