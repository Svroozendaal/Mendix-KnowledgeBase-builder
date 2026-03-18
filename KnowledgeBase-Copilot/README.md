# KnowledgeBase Copilot

AI-powered chat application that lets users query a generated Mendix knowledge base conversationally. The Copilot reads KB files on-the-fly using tool calls, starting from `READER.md` and following the L0/L1/L2 navigation pattern — like Claude Code but scoped to the KB.

## Architecture

```text
KnowledgeBase-Copilot/
├── shared/          TypeScript types shared between backend and frontend
├── backend/         Node.js + Express + WebSocket server
├── frontend/        React 18 + Vite SPA
├── mendix-extension/  C# Mendix Studio Pro dockable pane (WebView shell)
└── build-extension.ps1  Publish the C# extension
```

**Monorepo** managed via npm workspaces (`shared`, `backend`, `frontend`).

### Backend (`backend/src/`)

Express server on port `3001` with WebSocket support.

| Layer | Path | Purpose |
|---|---|---|
| Routes | `routes/config.routes.ts` | Read/write `copilot-config.json` |
| Routes | `routes/kb.routes.ts` | Browse KB files, search, get KB info |
| Routes | `routes/conversation.routes.ts` | List, create, delete conversations |
| WebSocket | `ws/chat.handler.ts` | Real-time chat — streams AI responses to the frontend |
| AI Providers | `services/ai-provider/` | Pluggable CLI-based providers (Claude CLI, Codex CLI) |
| KB Navigator | `services/kb-navigator/` | File listing, search, and path-sandboxed reads |
| Conversation | `services/conversation/` | Orchestrates message processing, system prompt, tool execution |
| Conversation Store | `services/conversation-store/` | Persists conversations as JSON files |
| System Prompt | `services/system-prompt/` | Builds the system prompt from KB metadata |
| Question Classifier | `services/question-classifier/` | Fast-path routing for question types |
| Tool Executor | `services/tool-executor/` | Executes tool calls (file read, search, list) |
| Config | `services/config/` | Loads and saves copilot configuration |

### Frontend (`frontend/src/`)

React 18 SPA with CSS Modules.

| Component | Purpose |
|---|---|
| `ChatPanel` | Message list + input, streams AI responses via WebSocket |
| `ConversationSidebar` | Conversation list, create/delete |
| `KBPicker` | Select a knowledge base root folder |
| `SettingsPanel` | Configure AI provider, CLI path, model |
| `MessageRenderer` | Renders markdown messages with syntax highlighting |
| `ToolCallRenderer` | Displays tool call/result blocks inline |

State is managed via React Context (`context/AppContext.tsx`).

### Mendix Extension (`mendix-extension/`)

A C# Mendix Studio Pro extension that embeds the Copilot as a dockable pane. Uses `WebViewDockablePaneViewModel` to load `http://localhost:3001` inside Studio Pro.

- `CopilotDockablePane.cs` — registers the dockable pane
- `CopilotMenu.cs` — adds an "Open KB Copilot" menu item

### Shared Types (`shared/src/`)

TypeScript package exporting types used by both backend and frontend:

- `AiProvider`, `AiSettings` — AI provider configuration
- `Message`, `Conversation`, `ConversationMeta` — chat data model
- `KBInfo`, `KBFileEntry`, `KBSearchResult` — KB navigation types
- `CopilotConfig` — application configuration
- `WSClientMessage`, `WSServerEvent` — WebSocket protocol types

## Prerequisites

- Node.js 18+
- npm 9+
- A generated knowledge base (from the KnowledgeBase Creator pipeline)
- Claude CLI or Codex CLI installed and authenticated

## Quick Start

```bash
# Install dependencies
cd KnowledgeBase-Copilot
npm install

# Build all packages (shared -> backend -> frontend)
npm run build

# Run in development mode (backend + frontend with hot reload)
npm run dev
```

- **Backend** runs on `http://localhost:3001`
- **Frontend** dev server runs on `http://localhost:5173` (proxied to backend)
- **WebSocket** endpoint at `ws://localhost:3001/ws`

In production or when serving from the Mendix extension, the backend serves the built frontend from `frontend/dist/` on port `3001`.

```bash
# Production start
npm start
```

## Configuration

On first launch, open **Settings** in the UI to configure:

1. **AI Provider** — `claude-cli` or `codex-cli`
2. **CLI Path** — path to the CLI executable (auto-detected if on PATH)

Then use **Select KB** to point the Copilot at a knowledge base root folder (the folder containing `READER.md`).

Configuration is persisted in `backend/copilot-config.json`.

## API Endpoints

| Method | Path | Purpose |
|---|---|---|
| GET | `/api/health` | Health check |
| GET | `/api/config` | Read configuration |
| PUT | `/api/config` | Update configuration |
| GET | `/api/kb/info?root=<path>` | Get KB metadata |
| GET | `/api/kb/files?root=<path>` | List KB files |
| GET | `/api/kb/search?root=<path>&q=<query>` | Search KB content |
| GET | `/api/conversations` | List all conversations |
| POST | `/api/conversations` | Create a new conversation |
| DELETE | `/api/conversations/:id` | Delete a conversation |

Chat messages are handled over WebSocket, not REST.

## WebSocket Protocol

**Client → Server:**

```json
{ "type": "message", "conversationId": "...", "content": "How does module X work?" }
{ "type": "cancel" }
```

**Server → Client:**

```json
{ "type": "text_delta", "text": "..." }
{ "type": "tool_call", "toolCallId": "...", "name": "...", "arguments": {...} }
{ "type": "tool_result", "toolCallId": "...", "content": "..." }
{ "type": "done", "conversationId": "..." }
{ "type": "error", "message": "...", "code": "..." }
```

## Building the Mendix Extension

```powershell
.\build-extension.ps1
```

This publishes the C# extension to `KnowledgeBase-Creator/artifacts/CoPilot/`. To install, copy the contents to the Mendix Studio Pro extensions directory.

The extension requires the backend to be running on `localhost:3001`.

## Development Prompts

Implementation prompts that built this application:

- Copilot track (01–07): `.app-info/development/prompts/copilot/INDEX.md`
- Copilot improvement track (01–10): `.app-info/development/prompts/copilot improvement/INDEX.md`
- Unified extension rewrite track (01–07): `.app-info/development/prompts/extension/INDEX.md`

## Future Direction

The current Node.js backend + thin C# shell architecture is being superseded by a unified Mendix Studio Pro extension that ports all services to C#. See `.app-info/product-plan/12-UNIFIED_EXTENSION_SPEC.md` for the full specification.
