# PROMPT 04: REST API and WebSocket Streaming

## Priority

High — this prompt builds the API layer that connects the backend services to the frontend.

## Context

Read before starting:

1. `.agents/AGENTS.md`
2. `.agents/FRAMEWORK.md`
3. `.app-info/development/prompts/copilot/INDEX.md`
4. Phase 2 deliverables — AI provider service in `backend/src/services/ai-provider/`
5. Phase 3 deliverables — KB navigator, tool executor, conversation service in `backend/src/services/`
6. Shared types in `shared/src/types/` — especially `ws-events.ts`, `config.ts`, `chat.ts`

## Problem Statement

The backend services from Phases 2-3 need to be exposed via REST endpoints (for configuration, KB validation, and conversation management) and a WebSocket connection (for real-time streaming of AI responses and tool calls).

## Entry Criteria

1. Phase 3 complete — KB navigator, tool executor, and conversation service working.
2. Shared types for WebSocket events, config, and chat exist in `@kb-copilot/shared`.

## Deliverable

### Config Service (`backend/src/services/config/index.ts`)

Manages copilot configuration:

- Config file: `copilot-config.json` stored in the backend root directory
- `loadConfig(): Promise<CopilotConfig>` — reads config file, returns defaults if not found
- `saveConfig(config: CopilotConfig): Promise<void>` — writes config to file
- `getMaskedConfig(): Promise<CopilotConfig>` — returns config with API key masked (first 12 chars + `...`)
- Default config:
  ```json
  {
    "aiSettings": {
      "provider": "ClaudeApi",
      "claudeCliPath": null,
      "codexCliPath": null,
      "claudeApiKey": null,
      "claudeApiModel": "claude-sonnet-4-20250514"
    },
    "lastKbRoot": null
  }
  ```

### Conversation Store Service (`backend/src/services/conversation-store/index.ts`)

File-based conversation persistence:

- Storage directory: `conversations/` inside the backend root
- Each conversation is a JSON file: `conversations/<id>.json`
- `listConversations(): Promise<ConversationMeta[]>` — reads all conversation files, returns metadata sorted by `updatedAt` descending
- `loadConversation(id: string): Promise<Conversation>` — reads a specific conversation
- `saveConversation(conversation: Conversation): Promise<void>` — writes/overwrites a conversation file
- `createConversation(kbRoot: string): Promise<Conversation>` — creates a new conversation with a unique ID (UUID v4), empty messages, title "New conversation"
- `deleteConversation(id: string): Promise<void>` — deletes the conversation file
- `updateTitle(id: string, title: string): Promise<void>` — updates conversation title
- Auto-title: after the first AI response, derive a title from the user's first message (truncate to 60 chars)

### Config Routes (`backend/src/routes/config.routes.ts`)

- `GET /api/config` — returns masked config (`getMaskedConfig()`)
- `PUT /api/config` — saves config. Request body: `CopilotConfig`. If `aiSettings.claudeApiKey` equals the masked form (ends with `...`), preserve the existing key rather than overwriting with the masked value.
- `POST /api/config/validate-provider` — tests AI provider connectivity. Sends a minimal "Say hello" message. Returns `{ valid: boolean, error?: string }`.
- `POST /api/config/detect-cli` — body: `{ type: 'claude' | 'codex' }`. Returns `{ found: boolean, path?: string }`.

### KB Routes (`backend/src/routes/kb.routes.ts`)

- `POST /api/kb/validate` — body: `{ path: string }`. Validates the folder is a valid KB:
  1. Check the directory exists
  2. Check `READER.md` exists
  3. Check `ROUTING.md` exists
  4. Parse basic KB info (app name from READER.md if possible, count modules in `modules/`)
  5. Returns `{ valid: boolean, info?: KBInfo, error?: string }`

- `GET /api/kb/info` — returns cached info for the currently configured KB root (from config). Returns 404 if no KB is configured or validated.

### Conversation Routes (`backend/src/routes/conversation.routes.ts`)

- `GET /api/conversations` — returns `ConversationMeta[]` sorted by most recent
- `GET /api/conversations/:id` — returns full `Conversation` with messages
- `POST /api/conversations` — body: `{ kbRoot?: string }`. Creates a new conversation using the provided kbRoot or the configured default. Returns the new `Conversation`.
- `DELETE /api/conversations/:id` — deletes a conversation. Returns 204.
- `PATCH /api/conversations/:id` — body: `{ title: string }`. Updates conversation title.

### WebSocket Chat Handler (`backend/src/ws/chat.handler.ts`)

Real-time streaming for chat interactions:

- WebSocket endpoint: `/ws`
- **Client → Server messages** (`WSClientMessage`):
  - `{ type: 'message', conversationId: string, content: string }` — send a user message
  - `{ type: 'cancel' }` — cancel an in-progress AI response

- **Server → Client events** (`WSServerEvent`):
  - `{ type: 'text_delta', content: string }` — streamed text chunk from the AI
  - `{ type: 'tool_call', id: string, name: string, arguments: object }` — AI is calling a KB tool
  - `{ type: 'tool_result', toolCallId: string, content: string, isError: boolean }` — result of tool execution
  - `{ type: 'done', conversationId: string, usage?: { inputTokens: number, outputTokens: number } }` — response complete, conversation saved
  - `{ type: 'error', message: string, code?: string }` — error occurred

- **Message handling flow:**
  1. Receive `message` event from client
  2. Load the conversation from store
  3. Load config for AI settings
  4. Call `conversationService.processMessage()` with the `onEvent` callback wired to WebSocket `send()`
  5. After completion, save the updated conversation
  6. Send `done` event

- **Cancellation:**
  - When `cancel` is received, abort the current AI request via `AbortController`
  - Send a `done` event with partial results

- **Error handling:**
  - Catch provider errors (`CliNotFoundError`, `AuthenticationError`, `ApiError`) and send appropriate `error` events
  - Catch unexpected errors and send generic `error` events without leaking internals

### Updated Entry Point (`backend/src/index.ts`)

Update the Express server to mount all routes and the WebSocket server:

- Mount `configRoutes` at `/api/config`
- Mount `kbRoutes` at `/api/kb`
- Mount `conversationRoutes` at `/api/conversations`
- Create `ws.Server` on the same HTTP server, path `/ws`
- Add centralised error handling middleware
- Add JSON body parsing middleware
- Add CORS middleware (allow `http://localhost:5173`)

### Error Handler Middleware (`backend/src/middleware/error-handler.ts`)

- Catches all unhandled errors from route handlers
- Returns structured JSON: `{ error: string, code?: string }`
- Maps known error types to HTTP status codes:
  - `FileNotFoundError` → 404
  - `PathTraversalError` → 403
  - `ValidationError` → 400
  - Other → 500
- Logs errors server-side but does not expose stack traces to clients

## Acceptance Criteria

1. `GET /api/config` returns masked config.
2. `PUT /api/config` saves and preserves unmasked API key.
3. `POST /api/config/validate-provider` tests provider connectivity.
4. `POST /api/config/detect-cli` finds installed CLIs.
5. `POST /api/kb/validate` correctly identifies valid and invalid KB folders.
6. Conversation CRUD works: create, list, load, delete.
7. WebSocket connects, receives a user message, streams AI response with tool calls, and sends `done`.
8. Cancellation interrupts an in-progress response.
9. Error events are sent for provider failures without leaking internals.

## Verification Steps

1. Start the backend with `npm run dev:backend`.
2. Test REST endpoints with curl:
   ```bash
   curl http://localhost:3001/api/config
   curl -X PUT http://localhost:3001/api/config -H 'Content-Type: application/json' -d '{"aiSettings":{"provider":"ClaudeApi","claudeApiKey":"sk-ant-test","claudeApiModel":"claude-sonnet-4-20250514"},"lastKbRoot":null}'
   curl -X POST http://localhost:3001/api/kb/validate -H 'Content-Type: application/json' -d '{"path":"C:/Workspaces/Mendix-KnowledgeBase-builder/mendix-data/knowledge-base"}'
   curl -X POST http://localhost:3001/api/conversations -H 'Content-Type: application/json' -d '{}'
   curl http://localhost:3001/api/conversations
   ```
3. Test WebSocket with a tool like `wscat`:
   ```bash
   wscat -c ws://localhost:3001/ws
   > {"type":"message","conversationId":"<id>","content":"What does this app do?"}
   ```
   Verify streamed events: `text_delta`, `tool_call`, `tool_result`, `done`.
4. Run `npm run build` — no TypeScript errors.

## Exit Criteria

1. All REST endpoints respond correctly.
2. WebSocket streams a full AI conversation with tool calls visible.
3. Conversations persist to disk and can be reloaded.
4. Config saves and loads with API key masking.
5. Error handling is consistent across all endpoints.

## Skill Suggestions

- **Developer** agent for Express API implementation.
- **API design** skill for REST endpoint conventions.
- **Security review** skill for API key masking and error message safety.
