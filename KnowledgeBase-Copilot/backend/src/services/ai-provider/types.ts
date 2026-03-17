import type { Message } from '@kb-copilot/shared';

export interface ToolDefinition {
  name: string;
  description: string;
  input_schema: {
    type: 'object';
    properties: Record<string, unknown>;
    required?: string[];
  };
}

export interface AIProviderOptions {
  messages: Message[];
  systemPrompt: string;
  tools?: ToolDefinition[];
  maxTokens?: number;
  onCancel?: AbortSignal;
  /** Working directory for CLI providers (e.g. KB root). */
  cwd?: string;
}

export type StreamChunkType =
  | 'text_delta'
  | 'tool_use_start'
  | 'tool_use_delta'
  | 'tool_use_end'
  | 'message_stop'
  | 'error';

export interface StreamChunk {
  type: StreamChunkType;
  text?: string;
  toolCallId?: string;
  toolName?: string;
  partialJson?: string;
  usage?: { inputTokens: number; outputTokens: number };
  error?: string;
  stopReason?: string;
}

export interface AIProvider {
  sendMessage(options: AIProviderOptions): AsyncIterable<StreamChunk>;
  validateConfig(): Promise<{ valid: boolean; error?: string }>;
}
