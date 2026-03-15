export type Role = 'user' | 'assistant' | 'system';

export interface ToolCall {
  id: string;
  name: string;
  arguments: Record<string, unknown>;
}

export interface ToolResult {
  toolCallId: string;
  content: string;
  isError: boolean;
}

export interface TextBlock {
  type: 'text';
  text: string;
}

export interface ToolUseBlock {
  type: 'tool_use';
  toolCall: ToolCall;
}

export interface ToolResultBlock {
  type: 'tool_result';
  toolResult: ToolResult;
}

export type MessageContent = TextBlock | ToolUseBlock | ToolResultBlock;

export interface Message {
  id: string;
  role: Role;
  content: MessageContent[];
  timestamp: string;
}

export interface Conversation {
  id: string;
  title: string;
  messages: Message[];
  kbRoot: string;
  createdAt: string;
  updatedAt: string;
}

export interface ConversationMeta {
  id: string;
  title: string;
  messageCount: number;
  createdAt: string;
  updatedAt: string;
}
