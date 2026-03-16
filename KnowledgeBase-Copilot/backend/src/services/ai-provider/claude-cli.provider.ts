import { spawn } from 'node:child_process';
import type { AiSettings, Message } from '@kb-copilot/shared';
import type { AIProvider, AIProviderOptions, StreamChunk } from './types.js';
import { resolveClaudeCliPath } from './cli-resolver.js';
import { CliNotFoundError, AuthenticationError, ProviderError } from './errors.js';
import { createLogger } from '../../logger.js';

const log = createLogger('ClaudeCLI');

/** Max turns the CLI is allowed to run internally (tool calls + responses). */
const CLI_MAX_TURNS = 10;

function messagesToCliInput(messages: Message[]): string {
  // Claude CLI expects a single prompt via stdin.
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

export class ClaudeCliProvider implements AIProvider {
  constructor(private settings: AiSettings) {}

  async *sendMessage(options: AIProviderOptions): AsyncIterable<StreamChunk> {
    const cliPath = resolveClaudeCliPath(this.settings.claudeCliPath);
    if (!cliPath) {
      throw new CliNotFoundError('Claude');
    }

    const prompt = messagesToCliInput(options.messages);

    // The system prompt guides the model but we don't embed custom tool
    // definitions — the CLI has its own native tools (Read, Grep, Glob, etc.)
    // and the model will use those to navigate the KB.
    const systemPrompt = options.systemPrompt ?? '';

    // On Windows, cmd.exe has an ~8192 char command-line limit. The prompt and
    // system prompt easily exceed this. We pipe everything via stdin instead.
    // The system prompt is included as a <system> preamble in the piped input
    // so nothing large appears on the command line.
    const stdinContent = systemPrompt
      ? `<system>\n${systemPrompt}\n</system>\n\n${prompt}`
      : prompt;

    const args = [
      '--print',
      '--verbose',
      '--output-format', 'stream-json',
      '--max-turns', String(CLI_MAX_TURNS),
    ];

    log.info(`Spawning Claude CLI`, { cliPath, argCount: args.length, promptLength: prompt.length, systemPromptLength: systemPrompt.length, stdinLength: stdinContent.length });

    // Strip CLAUDECODE env var to allow spawning Claude CLI from within a
    // Claude Code session (e.g. when the backend is started via Claude Code).
    const env = { ...process.env };
    delete env.CLAUDECODE;

    const child = spawn(cliPath, args, {
      stdio: ['pipe', 'pipe', 'pipe'],
      shell: process.platform === 'win32',
      env,
    });

    // Write the combined prompt to stdin and close it
    child.stdin?.write(stdinContent);
    child.stdin?.end();

    // Capture stderr for diagnostics
    let stderrData = '';
    child.stderr?.on('data', (chunk: Buffer) => {
      stderrData += chunk.toString();
    });

    child.on('error', (err) => {
      log.error(`CLI spawn error`, { error: err.message });
    });

    // Handle cancellation
    if (options.onCancel) {
      options.onCancel.addEventListener('abort', () => {
        log.info(`Cancelling CLI process`);
        child.kill('SIGTERM');
      }, { once: true });
    }

    const decoder = new TextDecoder();
    let buffer = '';
    let chunkCount = 0;
    const parser = new StreamJsonParser();

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

        const chunks = parser.parseLine(trimmed);
        for (const chunk of chunks) {
          chunkCount++;
          if (chunk.type === 'error') {
            log.error(`CLI stream error`, { error: chunk.error });
          }
          yield chunk;
        }
      }
    }

    // Process remaining buffer
    if (buffer.trim()) {
      const chunks = parser.parseLine(buffer.trim());
      for (const chunk of chunks) {
        chunkCount++;
        yield chunk;
      }
    }

    log.info(`CLI stdout ended`, { chunkCount });

    // Wait for process to exit
    const exitCode = await new Promise<number>((resolve) => {
      child.on('close', (code) => resolve(code ?? 0));
    });

    if (stderrData.trim()) {
      log.warn(`CLI stderr`, { stderr: stderrData.trim().slice(0, 500) });
    }

    log.info(`CLI process exited`, { exitCode });

    if (exitCode !== 0) {
      const stderr = stderrData.trim().toLowerCase();
      if (stderr.includes('auth') || stderr.includes('credentials') || stderr.includes('api key') || stderr.includes('unauthorized')) {
        throw new AuthenticationError('Claude CLI');
      }
      throw new ProviderError(`Claude CLI exited with code ${exitCode}: ${stderrData.trim().slice(0, 200)}`, exitCode);
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

/**
 * Stateful parser for Claude CLI stream-json output.
 *
 * Claude CLI `--output-format stream-json` emits summary events:
 *   - "system"    — init info (ignored)
 *   - "assistant" — full assistant message with content blocks (text, tool_use, thinking)
 *   - "user"      — tool results from the CLI's internal tool execution (ignored —
 *                    the CLI handles its own tool loop)
 *   - "result"    — final completion summary with stop_reason and usage
 *   - "rate_limit_event" — rate limit info (ignored)
 *
 * We extract text content from "assistant" events and forward them as text_delta
 * chunks. The "result" event signals completion.
 */
class StreamJsonParser {
  parseLine(line: string): StreamChunk[] {
    try {
      const obj = JSON.parse(line);

      // Assistant message — extract text content blocks
      if (obj.type === 'assistant') {
        const content = obj.message?.content;
        if (!Array.isArray(content)) return [];

        const chunks: StreamChunk[] = [];
        for (const block of content) {
          if (block.type === 'text' && block.text) {
            chunks.push({ type: 'text_delta', text: block.text });
          }
          // thinking blocks and tool_use blocks from the CLI's internal tools
          // are not forwarded — the CLI handles its own tool loop
        }
        return chunks;
      }

      // Result — signals completion
      if (obj.type === 'result') {
        const stopReason = obj.stop_reason ?? (obj.subtype === 'error_max_turns' ? 'end_turn' : 'end_turn');
        const chunks: StreamChunk[] = [
          { type: 'message_stop', stopReason },
        ];
        if (obj.is_error) {
          chunks.unshift({ type: 'error', error: obj.result ?? 'CLI execution failed' });
        }
        return chunks;
      }

      if (obj.type === 'error') {
        return [{ type: 'error', error: obj.error?.message ?? String(obj.error) }];
      }

      // system, user (tool results), rate_limit_event — ignored
      return [];
    } catch {
      // Not JSON — ignore non-JSON lines (CLI diagnostics, etc.)
      return [];
    }
  }
}
