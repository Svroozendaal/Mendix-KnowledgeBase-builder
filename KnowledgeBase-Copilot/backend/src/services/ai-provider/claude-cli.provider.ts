import { spawn } from 'node:child_process';
import type { AiSettings, Message, MessageContent } from '@kb-copilot/shared';
import type { AIProvider, AIProviderOptions, StreamChunk, ToolDefinition } from './types.js';
import { resolveClaudeCliPath } from './cli-resolver.js';
import { CliNotFoundError, AuthenticationError, ProviderError } from './errors.js';

function messagesToCliInput(messages: Message[]): string {
  // Claude CLI expects a single prompt via -p flag.
  // We concatenate the conversation into a structured prompt.
  const parts: string[] = [];
  for (const msg of messages) {
    const role = msg.role === 'user' ? 'Human' : 'Assistant';
    const textParts: string[] = [];
    for (const block of msg.content) {
      if (block.type === 'text') {
        textParts.push(block.text);
      } else if (block.type === 'tool_use') {
        textParts.push(`[Tool call: ${block.toolCall.name}(${JSON.stringify(block.toolCall.arguments)})]`);
      } else if (block.type === 'tool_result') {
        textParts.push(`[Tool result for ${block.toolResult.toolCallId}: ${block.toolResult.content}]`);
      }
    }
    if (textParts.length > 0) {
      parts.push(`${role}: ${textParts.join('\n')}`);
    }
  }
  return parts.join('\n\n');
}

function buildToolPromptSection(tools: ToolDefinition[]): string {
  const lines = ['You have access to the following tools:\n'];
  for (const tool of tools) {
    lines.push(`## ${tool.name}`);
    lines.push(tool.description);
    lines.push(`Parameters: ${JSON.stringify(tool.input_schema, null, 2)}`);
    lines.push(`To use this tool, respond with a JSON block: {"tool": "${tool.name}", "arguments": {...}}`);
    lines.push('');
  }
  return lines.join('\n');
}

export class ClaudeCliProvider implements AIProvider {
  constructor(private settings: AiSettings) {}

  async *sendMessage(options: AIProviderOptions): AsyncIterable<StreamChunk> {
    const cliPath = resolveClaudeCliPath(this.settings.claudeCliPath);
    if (!cliPath) {
      throw new CliNotFoundError('Claude');
    }

    const prompt = messagesToCliInput(options.messages);
    const args = [
      '-p', prompt,
      '--print',
      '--output-format', 'stream-json',
      '--max-turns', '1',
    ];

    if (options.systemPrompt) {
      args.push('--system-prompt', options.systemPrompt);
    }

    // Include tool definitions in system prompt for Claude CLI
    if (options.tools && options.tools.length > 0) {
      const toolSection = buildToolPromptSection(options.tools);
      if (options.systemPrompt) {
        args[args.indexOf('--system-prompt') + 1] = options.systemPrompt + '\n\n' + toolSection;
      } else {
        args.push('--system-prompt', toolSection);
      }
    }

    const child = spawn(cliPath, args, {
      stdio: ['ignore', 'pipe', 'pipe'],
    });

    // Handle cancellation
    if (options.onCancel) {
      options.onCancel.addEventListener('abort', () => {
        child.kill('SIGTERM');
      }, { once: true });
    }

    const decoder = new TextDecoder();
    let buffer = '';

    const stdout = child.stdout;
    if (!stdout) {
      throw new ProviderError('Failed to capture CLI stdout');
    }

    for await (const rawChunk of stdout) {
      buffer += decoder.decode(rawChunk as Buffer, { stream: true });
      const lines = buffer.split('\n');
      buffer = lines.pop() ?? '';

      for (const line of lines) {
        const trimmed = line.trim();
        if (!trimmed) continue;

        const chunk = parseStreamJsonLine(trimmed);
        if (chunk) yield chunk;
      }
    }

    // Process remaining buffer
    if (buffer.trim()) {
      const chunk = parseStreamJsonLine(buffer.trim());
      if (chunk) yield chunk;
    }

    // Wait for process to exit
    const exitCode = await new Promise<number>((resolve) => {
      child.on('close', (code) => resolve(code ?? 0));
    });

    if (exitCode === 1) {
      throw new AuthenticationError('Claude CLI');
    } else if (exitCode !== 0) {
      throw new ProviderError(`Claude CLI exited with code ${exitCode}`, exitCode);
    }
  }

  async validateConfig(): Promise<{ valid: boolean; error?: string }> {
    const cliPath = resolveClaudeCliPath(this.settings.claudeCliPath);
    if (!cliPath) {
      return { valid: false, error: 'Claude CLI not found' };
    }
    return { valid: true };
  }
}

function parseStreamJsonLine(line: string): StreamChunk | null {
  try {
    const obj = JSON.parse(line);

    // Claude CLI stream-json: "assistant" message type
    if (obj.type === 'assistant' && obj.message?.content) {
      // Yield individual content blocks
      for (const block of obj.message.content) {
        if (block.type === 'text' && block.text) {
          return { type: 'text_delta', text: block.text };
        }
        if (block.type === 'tool_use') {
          return {
            type: 'tool_use_start',
            toolCallId: block.id,
            toolName: block.name,
            partialJson: JSON.stringify(block.input),
          };
        }
      }
    }

    // "result" type — final text
    if (obj.type === 'result' && obj.result) {
      return { type: 'text_delta', text: obj.result };
    }

    // Content block events (streaming mode)
    if (obj.type === 'content_block_start' && obj.content_block?.type === 'tool_use') {
      return {
        type: 'tool_use_start',
        toolCallId: obj.content_block.id,
        toolName: obj.content_block.name,
      };
    }

    if (obj.type === 'content_block_delta') {
      if (obj.delta?.type === 'text_delta') {
        return { type: 'text_delta', text: obj.delta.text };
      }
      if (obj.delta?.type === 'input_json_delta') {
        return { type: 'tool_use_delta', partialJson: obj.delta.partial_json };
      }
    }

    if (obj.type === 'content_block_stop') {
      return { type: 'tool_use_end' };
    }

    if (obj.type === 'message_stop') {
      return { type: 'message_stop', stopReason: 'end_turn' };
    }

    if (obj.type === 'message_delta' && obj.delta?.stop_reason) {
      return { type: 'message_stop', stopReason: obj.delta.stop_reason };
    }

    if (obj.type === 'error') {
      return { type: 'error', error: obj.error?.message ?? String(obj.error) };
    }

    return null;
  } catch {
    // Not JSON — treat as raw text
    return { type: 'text_delta', text: line };
  }
}
