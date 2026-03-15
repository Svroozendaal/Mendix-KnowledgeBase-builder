import type {
  CopilotConfig,
  KBInfo,
  Conversation,
  ConversationMeta,
} from '@kb-copilot/shared';

const BASE = '/api';

async function request<T>(path: string, init?: RequestInit): Promise<T> {
  const res = await fetch(`${BASE}${path}`, {
    headers: { 'Content-Type': 'application/json' },
    ...init,
  });
  if (!res.ok) {
    const body = await res.text().catch(() => '');
    throw new Error(`API error ${res.status}: ${body}`);
  }
  if (res.status === 204) return undefined as unknown as T;
  return res.json() as Promise<T>;
}

// Config
export const getConfig = () => request<CopilotConfig>('/config');
export const saveConfig = (config: CopilotConfig) =>
  request<CopilotConfig>('/config', { method: 'PUT', body: JSON.stringify(config) });
export const validateProvider = () =>
  request<{ valid: boolean; error?: string }>('/config/validate-provider', { method: 'POST' });
export const detectCli = (type: 'claude' | 'codex') =>
  request<{ found: boolean; path?: string }>('/config/detect-cli', {
    method: 'POST',
    body: JSON.stringify({ type }),
  });

// KB
export const validateKb = (path: string) =>
  request<{ valid: boolean; info?: KBInfo; error?: string }>('/kb/validate', {
    method: 'POST',
    body: JSON.stringify({ path }),
  });
export const getKbInfo = () => request<KBInfo>('/kb/info');

// Conversations
export const getConversations = () => request<ConversationMeta[]>('/conversations');
export const getConversation = (id: string) => request<Conversation>(`/conversations/${id}`);
export const createConversation = (kbRoot?: string) =>
  request<Conversation>('/conversations', {
    method: 'POST',
    body: JSON.stringify({ kbRoot }),
  });
export const deleteConversation = (id: string) =>
  request<void>(`/conversations/${id}`, { method: 'DELETE' });
export const updateConversationTitle = (id: string, title: string) =>
  request<void>(`/conversations/${id}`, {
    method: 'PATCH',
    body: JSON.stringify({ title }),
  });
