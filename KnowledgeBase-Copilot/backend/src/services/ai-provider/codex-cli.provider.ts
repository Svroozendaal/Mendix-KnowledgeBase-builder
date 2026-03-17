import { spawn } from 'node:child_process';
import type { AiSettings, Message } from '@kb-copilot/shared';
import type { AIProvider, AIProviderOptions, StreamChunk } from './types.js';
import { resolveCodexCliPath } from './cli-resolver.js';
import { CliNotFoundError, ProviderError } from './errors.js';

function messagesToPrompt(messages: Message[]): string {
  const parts: string[] = [];
  for (const msg of messages) {
    for (const block of msg.content) {
      if (block.type === 'text') {
        parts.push(block.text);
      }
    }
  }
  return parts.join('\n\n');
}

export class CodexCliProvider implements AIProvider {
  constructor(private settings: AiSettings) {}

  async *sendMessage(options: AIProviderOptions): AsyncIterable<StreamChunk> {
    const cliPath = resolveCodexCliPath(this.settings.codexCliPath);
    if (!cliPath) {
      throw new CliNotFoundError('Codex');
    }

    const prompt = messagesToPrompt(options.messages);
    const args = ['-q', '--full-auto', prompt];

    const child = spawn(cliPath, args, {
      stdio: ['ignore', 'pipe', 'pipe'],
      cwd: options.cwd ?? process.cwd(),
    });

    if (options.onCancel) {
      options.onCancel.addEventListener('abort', () => {
        child.kill('SIGTERM');
      }, { once: true });
    }

    const decoder = new TextDecoder();
    let buffer = '';
    const stdout = child.stdout;
    if (!stdout) throw new ProviderError('Failed to capture Codex CLI stdout');

    for await (const rawChunk of stdout) {
      buffer += decoder.decode(rawChunk as Buffer, { stream: true });
      const lines = buffer.split('\n');
      buffer = lines.pop() ?? '';

      for (const line of lines) {
        if (line.trim()) {
          yield { type: 'text_delta', text: line + '\n' };
        }
      }
    }

    if (buffer.trim()) {
      yield { type: 'text_delta', text: buffer };
    }

    const exitCode = await new Promise<number>((resolve) => {
      child.on('close', (code) => resolve(code ?? 0));
    });

    yield { type: 'message_stop', stopReason: 'end_turn' };

    if (exitCode !== 0) {
      throw new ProviderError(`Codex CLI exited with code ${exitCode}`, exitCode);
    }
  }

  async validateConfig(): Promise<{ valid: boolean; error?: string }> {
    const cliPath = resolveCodexCliPath(this.settings.codexCliPath);
    if (!cliPath) {
      return { valid: false, error: 'Codex CLI not found' };
    }
    return { valid: true };
  }
}
