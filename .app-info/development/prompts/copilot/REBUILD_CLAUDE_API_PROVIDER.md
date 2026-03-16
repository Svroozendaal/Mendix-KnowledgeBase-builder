# REBUILD PROMPT: Claude API Provider — Restore Direct Anthropic API Integration

## Purpose

This prompt documents all Claude API-specific functionalities that were removed from the KnowledgeBase-Copilot application. Use it to rebuild the direct Anthropic API provider if needed in the future.

## What Was Removed

The copilot originally supported three AI providers: Claude CLI, Codex CLI, and **Claude API** (direct HTTP calls to the Anthropic Messages API). The Claude API provider and all supporting infrastructure were removed. This prompt captures everything needed to rebuild it.

---

## 1. Claude API Provider (`backend/src/services/ai-provider/claude-api.provider.ts`)

A full provider class implementing the `AIProvider` interface via direct HTTP calls to the Anthropic API.

### Key behaviours

- **Endpoint:** `POST https://api.anthropic.com/v1/messages` with `stream: true`
- **Headers:**
  - `x-api-key: <apiKey>` — API key from config
  - `anthropic-version: 2023-06-01`
  - `anthropic-beta: prompt-caching-2024-07-31` — enables prompt caching
  - `content-type: application/json`
- **Request body:** `{ model, max_tokens, system, messages, tools, stream: true }`
- **Default model:** `claude-sonnet-4-20250514`
- **Max tokens default:** `8192`

### Prompt Caching

The provider used Anthropic's prompt caching to reduce costs on multi-turn conversations:

- **System prompt:** Wrapped as a content block with `cache_control: { type: 'ephemeral' }`:
  ```typescript
  const systemBlocks = [
    { type: 'text', text: options.systemPrompt, cache_control: { type: 'ephemeral' } },
  ];
  ```
- **Tools:** The last tool definition was tagged with `cache_control: { type: 'ephemeral' }` so the entire system prompt + tools block is cached across requests in the same conversation.
- **Cache stats logging:** On `message_start` events, the provider logged `input_tokens`, `cache_creation_input_tokens`, and `cache_read_input_tokens`.

### Message Conversion

Internal `Message[]` format was converted to Anthropic API format:

```typescript
function convertMessages(messages: Message[]): AnthropicMessage[] {
  // Skip 'system' role messages
  // Map content blocks:
  //   text -> { type: 'text', text }
  //   tool_use -> { type: 'tool_use', id, name, input }
  //   tool_result -> { type: 'tool_result', tool_use_id, content, is_error }
  // Role mapping: 'assistant' -> 'assistant', everything else -> 'user'
}
```

### Tool Conversion

```typescript
function convertTools(tools: ToolDefinition[]): Array<{...}> {
  // Maps: { name, description, input_schema } for each tool
  // Last tool gets cache_control: { type: 'ephemeral' } for prompt caching
}
```

### SSE Stream Parsing

The provider parsed Server-Sent Events line by line:

| SSE Event | Action |
|---|---|
| `content_block_start` with `content_block.type === 'tool_use'` | Yield `tool_use_start` (track block index) |
| `content_block_delta` with `delta.type === 'text_delta'` | Yield `text_delta` |
| `content_block_delta` with `delta.type === 'input_json_delta'` | Yield `tool_use_delta` |
| `content_block_stop` (if block was tool_use) | Yield `tool_use_end` |
| `message_start` | Log prompt caching stats (no yield) |
| `message_delta` | Yield `message_stop` with `stop_reason` and `usage` |
| `message_stop` | Ignored (handled by `message_delta`) |
| `error` | Yield `error` |

Important: Tool block indices were tracked per-stream (not module-level) using a `Set<number>` to correctly pair `content_block_stop` events with their corresponding `content_block_start`.

### Error Handling

| HTTP Status | Error Thrown |
|---|---|
| 401 | `AuthenticationError('Claude API')` |
| 429 | `RateLimitError(retryAfterMs)` — parsed from `retry-after` header, default 60s |
| Other non-2xx | `ApiError('API request failed (status): body')` |
| No response body | `ApiError('No response body received')` |

### Config Validation

`validateConfig()` sent a minimal test message (`"Say hello in one word."` with `max_tokens: 32`) to verify the API key works.

---

## 2. API-Specific Error Classes (`backend/src/services/ai-provider/errors.ts`)

Two error classes specific to the API provider:

```typescript
export class ApiError extends ProviderError {
  constructor(message: string) {
    super(message, 4);
    this.name = 'ApiError';
  }
}

export class RateLimitError extends ProviderError {
  readonly retryAfterMs: number;
  constructor(retryAfterMs: number) {
    super(`Rate limited. Retry after ${Math.ceil(retryAfterMs / 1000)}s.`, 5);
    this.name = 'RateLimitError';
    this.retryAfterMs = retryAfterMs;
  }
}
```

---

## 3. Rate-Limit Retry Logic (`backend/src/services/conversation/index.ts`)

The conversation service had automatic rate-limit retry:

```typescript
const MAX_RATE_LIMIT_RETRIES = 5;

// Inside the tool loop:
catch (err) {
  if (err instanceof RateLimitError && rateLimitRetries < MAX_RATE_LIMIT_RETRIES) {
    rateLimitRetries++;
    const waitMs = err.retryAfterMs;
    onEvent({
      type: 'rate_limit',
      retryAfterMs: waitMs,
      message: `Rate limited. Retrying in ${Math.ceil(waitMs / 1000)} seconds... (${rateLimitRetries}/${MAX_RATE_LIMIT_RETRIES})`,
    });
    await abortableSleep(waitMs, signal);
    loopCount--; // don't count as a tool-loop iteration
    continue;
  }
  throw err;
}
```

Supporting utility:

```typescript
function abortableSleep(ms: number, signal?: AbortSignal): Promise<void> {
  return new Promise<void>((resolve, reject) => {
    if (signal?.aborted) { reject(signal.reason ?? new DOMException('Aborted', 'AbortError')); return; }
    const timer = setTimeout(resolve, ms);
    const onAbort = () => { clearTimeout(timer); reject(signal!.reason ?? new DOMException('Aborted', 'AbortError')); };
    signal?.addEventListener('abort', onAbort, { once: true });
  });
}
```

---

## 4. Rate-Limit WebSocket Event (`shared/src/types/ws-events.ts`)

```typescript
export interface RateLimitEvent {
  type: 'rate_limit';
  retryAfterMs: number;
  message: string;
}

// Added to WSServerEvent union:
export type WSServerEvent = ... | RateLimitEvent;
```

---

## 5. AiProvider Enum and Settings (`shared/src/types/ai-provider.ts`)

```typescript
export enum AiProvider {
  ClaudeCli = 'ClaudeCli',
  CodexCli = 'CodexCli',
  ClaudeApi = 'ClaudeApi',   // <-- removed
}

export interface AiSettings {
  provider: AiProvider;
  claudeCliPath: string | null;
  codexCliPath: string | null;
  claudeApiKey: string | null;    // <-- removed
  claudeApiModel: string | null;  // <-- removed
}
```

---

## 6. API Key Management (`backend/src/services/config/index.ts`)

### Default config

```typescript
const DEFAULT_CONFIG: CopilotConfig = {
  aiSettings: {
    provider: AiProvider.ClaudeApi,  // defaulted to API
    claudeApiKey: null,
    claudeApiModel: 'claude-sonnet-4-20250514',
    // ... CLI paths
  },
  lastKbRoot: null,
};
```

### API key masking (for frontend display)

```typescript
export function maskApiKey(key: string | null): string | null {
  if (!key) return null;
  if (key.length <= 12) return '...';
  return key.slice(0, 12) + '...';
}

export function isMaskedKey(key: string | null): boolean {
  return key !== null && key.endsWith('...');
}
```

### Masked config getter

```typescript
async getMaskedConfig(): Promise<CopilotConfig> {
  const config = await this.loadConfig();
  return {
    ...config,
    aiSettings: {
      ...config.aiSettings,
      claudeApiKey: maskApiKey(config.aiSettings.claudeApiKey),
    },
  };
}
```

---

## 7. Config Routes — API Key Preservation (`backend/src/routes/config.routes.ts`)

When saving config, the backend preserved the existing API key if the incoming value was the masked form (to prevent overwriting the real key with `"sk-ant-abc123..."`):

```typescript
router.put('/', async (req, res, next) => {
  const incoming = req.body as CopilotConfig;
  if (isMaskedKey(incoming.aiSettings.claudeApiKey)) {
    const existing = await configService.loadConfig();
    incoming.aiSettings.claudeApiKey = existing.aiSettings.claudeApiKey;
  }
  await configService.saveConfig(incoming);
  const masked = await configService.getMaskedConfig();
  res.json(masked);
});
```

The GET endpoint also returned masked config:

```typescript
router.get('/', async (_req, res, next) => {
  const config = await configService.getMaskedConfig();
  res.json(config);
});
```

---

## 8. Provider Service — API Provider Registration (`backend/src/services/ai-provider/index.ts`)

```typescript
import { ClaudeApiProvider } from './claude-api.provider.js';

// In getProvider():
case AiProvider.ClaudeApi:
  return new ClaudeApiProvider(settings);
```

Exports included `ApiError` and `RateLimitError`.

---

## 9. WebSocket Error Mapping (`backend/src/ws/chat.handler.ts`)

```typescript
import { ApiError, RateLimitError } from '../services/ai-provider/index.js';

function mapErrorToEvent(err: unknown, conversationId: string): WSServerEvent {
  // ...
  if (err instanceof RateLimitError) {
    return { type: 'error', message: `Rate limited. Max retries exceeded. ${err.message}`, code: 'RATE_LIMITED' };
  }
  if (err instanceof ApiError) {
    return { type: 'error', message: err.message, code: 'API_ERROR' };
  }
  // ...
}
```

---

## 10. Frontend Settings Panel — Claude API UI (`frontend/src/components/SettingsPanel/SettingsPanel.tsx`)

### Model options dropdown

```typescript
const MODEL_OPTIONS = [
  { value: 'claude-sonnet-4-20250514', label: 'Claude Sonnet 4' },
  { value: 'claude-haiku-4-5-20251001', label: 'Claude Haiku 4.5' },
  { value: 'claude-opus-4-6', label: 'Claude Opus 4.6' },
];
```

### Radio button

```tsx
{p === AiProvider.ClaudeApi && 'Claude API'}
```

### Provider panel (shown when Claude API is selected)

```tsx
{provider === AiProvider.ClaudeApi && (
  <div className={styles.providerPanel}>
    <label className={styles.label}>
      API Key
      <div className={styles.keyRow}>
        <input
          type={showKey ? 'text' : 'password'}
          value={draft.aiSettings.claudeApiKey ?? ''}
          onChange={(e) => setDraft({...draft, aiSettings: {...draft.aiSettings, claudeApiKey: e.target.value || null}})}
          placeholder="sk-ant-..."
        />
        <button onClick={() => setShowKey(!showKey)}>
          {showKey ? 'Hide' : 'Show'}
        </button>
      </div>
    </label>
    <label className={styles.label}>
      Model
      <select
        value={draft.aiSettings.claudeApiModel ?? 'claude-sonnet-4-20250514'}
        onChange={(e) => setDraft({...draft, aiSettings: {...draft.aiSettings, claudeApiModel: e.target.value}})}
      >
        {MODEL_OPTIONS.map((m) => (
          <option key={m.value} value={m.value}>{m.label}</option>
        ))}
      </select>
    </label>
  </div>
)}
```

### State for show/hide API key

```typescript
const [showKey, setShowKey] = useState(false);
```

---

## Rebuild Checklist

To restore the Claude API provider, re-implement in this order:

1. Add `ClaudeApi = 'ClaudeApi'` back to `AiProvider` enum
2. Add `claudeApiKey` and `claudeApiModel` fields to `AiSettings`
3. Add `ApiError` and `RateLimitError` to `errors.ts`
4. Create `claude-api.provider.ts` with the full provider (message conversion, tool conversion, prompt caching, SSE parsing)
5. Register the provider in `ai-provider/index.ts`
6. Add `RateLimitEvent` to `ws-events.ts` and the `WSServerEvent` union
7. Add rate-limit retry logic to `conversation/index.ts` (with `abortableSleep`)
8. Add `maskApiKey`, `isMaskedKey`, `getMaskedConfig` to `config/index.ts`
9. Update `config.routes.ts` to use masked config and preserve API keys
10. Update `chat.handler.ts` error mapping for `ApiError` and `RateLimitError`
11. Set default provider to `AiProvider.ClaudeApi` in `DEFAULT_CONFIG`
12. Add Claude API radio, API key input, model dropdown to `SettingsPanel.tsx`

---

## Non-Removed Optimisations (Shared Across All Providers)

The following features were originally motivated by API cost reduction but benefit all providers (including CLI). They were **NOT** removed:

- **Token optimisation** (`compressOldToolResults`, `windowMessages`, `buildApiView` in `conversation/index.ts`) — compresses old tool results and windows long histories to manage context window limits for all providers.
- **Question classifier** (`question-classifier/index.ts`) — pre-classifies questions and pre-fetches KB content to reduce the number of tool-loop iterations (fewer CLI invocations or API round trips).
- **KB context seeding** (`seedKbContext` in `conversation/index.ts`) — pre-loads READER.md and ROUTING.md as synthetic tool exchanges so the AI starts with context.
- **System prompt efficiency hints** — "limited token budget" guidance in the system prompt applies to all providers.
