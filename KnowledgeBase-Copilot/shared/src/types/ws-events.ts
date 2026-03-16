export interface WSMessageEvent {
  type: 'message';
  conversationId: string;
  content: string;
}

export interface WSCancelEvent {
  type: 'cancel';
}

export type WSClientMessage = WSMessageEvent | WSCancelEvent;

export interface TextDeltaEvent {
  type: 'text_delta';
  content: string;
}

export interface ToolCallEvent {
  type: 'tool_call';
  id: string;
  name: string;
  arguments: Record<string, unknown>;
}

export interface ToolResultEvent {
  type: 'tool_result';
  toolCallId: string;
  content: string;
  isError: boolean;
}

export interface DoneEvent {
  type: 'done';
  conversationId: string;
  usage?: {
    inputTokens: number;
    outputTokens: number;
  };
}

export interface ErrorEvent {
  type: 'error';
  message: string;
  code?: string;
}

export interface RateLimitEvent {
  type: 'rate_limit';
  retryAfterMs: number;
  message: string;
}

export type WSServerEvent =
  | TextDeltaEvent
  | ToolCallEvent
  | ToolResultEvent
  | DoneEvent
  | ErrorEvent
  | RateLimitEvent;
