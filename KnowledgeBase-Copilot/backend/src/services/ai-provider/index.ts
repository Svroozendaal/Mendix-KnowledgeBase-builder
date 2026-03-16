import { AiProvider } from '@kb-copilot/shared';
import type { AiSettings } from '@kb-copilot/shared';
import type { AIProvider, AIProviderOptions, StreamChunk } from './types.js';
import { ClaudeCliProvider } from './claude-cli.provider.js';
import { CodexCliProvider } from './codex-cli.provider.js';
import { ClaudeApiProvider } from './claude-api.provider.js';
import { resolveClaudeCliPath, resolveCodexCliPath } from './cli-resolver.js';
import { ProviderError } from './errors.js';

export class AIProviderService {
  private getProvider(settings: AiSettings): AIProvider {
    switch (settings.provider) {
      case AiProvider.ClaudeCli:
        return new ClaudeCliProvider(settings);
      case AiProvider.CodexCli:
        return new CodexCliProvider(settings);
      case AiProvider.ClaudeApi:
        return new ClaudeApiProvider(settings);
      default:
        throw new ProviderError(`Unknown provider: ${settings.provider}`);
    }
  }

  sendMessage(settings: AiSettings, options: AIProviderOptions): AsyncIterable<StreamChunk> {
    const provider = this.getProvider(settings);
    return provider.sendMessage(options);
  }

  async validateProvider(settings: AiSettings): Promise<{ valid: boolean; error?: string }> {
    const provider = this.getProvider(settings);
    return provider.validateConfig();
  }

  detectCli(type: 'claude' | 'codex'): { found: boolean; path?: string } {
    const path = type === 'claude'
      ? resolveClaudeCliPath()
      : resolveCodexCliPath();
    return path ? { found: true, path } : { found: false };
  }
}

export { type AIProvider, type AIProviderOptions, type StreamChunk, type ToolDefinition } from './types.js';
export { CliNotFoundError, AuthenticationError, ApiError, RateLimitError, ProviderError } from './errors.js';
