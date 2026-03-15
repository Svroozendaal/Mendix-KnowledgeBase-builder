# PROMPT 01: Project Scaffold and Shared Types

## Priority

Critical — this prompt establishes the monorepo structure that all subsequent phases build upon.

## Context

Read before starting:

1. `.agents/AGENTS.md`
2. `.agents/FRAMEWORK.md`
3. `.app-info/development/prompts/copilot/INDEX.md`
4. `KnowledgeBase-Creator/wizard/src/KnowledgeBaseCreator.Wizard/WizardRuntime.cs` — reference for `AiSettings` and `AiProvider` enum shapes that the shared types must mirror in TypeScript.

## Problem Statement

The KnowledgeBase-Copilot needs a clean monorepo foundation with shared types used by both the backend and frontend. The project lives in `/KnowledgeBase-Copilot/` and uses npm workspaces to manage three packages: shared types, Express backend, and React frontend.

## Entry Criteria

1. The `/KnowledgeBase-Copilot/` directory exists (currently empty).
2. Node.js 18+ and npm are available on the development machine.

## Deliverable

Bootstrap the monorepo with working build and dev tooling.

### Root package (`/KnowledgeBase-Copilot/`)

- `package.json` — npm workspaces config pointing to `shared`, `backend`, `frontend`
- `tsconfig.base.json` — shared TypeScript compiler options (strict mode, ES2022 target)
- `.gitignore` — Node.js defaults (`node_modules/`, `dist/`, `.env`)

### Shared types package (`shared/`)

- `package.json` — name `@kb-copilot/shared`, main/types pointing to `dist/`
- `tsconfig.json` — extends `../tsconfig.base.json`, declaration: true
- `src/types/ai-provider.ts`:
  - `AiProvider` enum: `ClaudeCli = 'ClaudeCli'`, `CodexCli = 'CodexCli'`, `ClaudeApi = 'ClaudeApi'`
  - `AiSettings` interface: `provider`, `claudeCliPath`, `codexCliPath`, `claudeApiKey`, `claudeApiModel`
  - Must mirror the C# `AiProvider` enum and `AiSettings` class from `WizardRuntime.cs`
- `src/types/chat.ts`:
  - `Role` type: `'user' | 'assistant' | 'system'`
  - `ToolCall` interface: `id`, `name`, `arguments` (parsed object)
  - `ToolResult` interface: `toolCallId`, `content`, `isError`
  - `MessageContent` type: text block or tool-use block or tool-result block
  - `Message` interface: `id`, `role`, `content` (array of `MessageContent`), `timestamp`
  - `Conversation` interface: `id`, `title`, `messages`, `kbRoot`, `createdAt`, `updatedAt`
  - `ConversationMeta` interface: `id`, `title`, `messageCount`, `createdAt`, `updatedAt` (for list views without loading full messages)
- `src/types/kb.ts`:
  - `KBFileEntry` interface: `name`, `path`, `type` (`'file' | 'directory'`), `size`
  - `KBSearchResult` interface: `file`, `line`, `content`, `lineNumber`
  - `KBInfo` interface: `appName`, `kbRoot`, `hasReader`, `hasRouting`, `moduleCount`
- `src/types/config.ts`:
  - `CopilotConfig` interface: `aiSettings` (`AiSettings`), `lastKbRoot` (string, nullable)
- `src/types/ws-events.ts`:
  - `WSClientMessage` type: `{ type: 'message', conversationId: string, content: string }` | `{ type: 'cancel' }`
  - `WSServerEvent` type: union of `TextDeltaEvent`, `ToolCallEvent`, `ToolResultEvent`, `DoneEvent`, `ErrorEvent`
  - Each event type with appropriate fields (`type` discriminator, `content`, `toolCallId`, `usage`, etc.)
- `src/index.ts` — barrel export of all types

### Backend package (`backend/`)

- `package.json` — name `@kb-copilot/backend`, dependencies: `express`, `ws`, `cors`; dev-deps: `typescript`, `tsx`, `@types/express`, `@types/ws`, `@types/cors`
- `tsconfig.json` — extends `../tsconfig.base.json`, references `../shared`
- `src/index.ts` — minimal Express server:
  - Serves on port 3001 (configurable via `PORT` env var)
  - CORS enabled for `http://localhost:5173` (Vite dev server)
  - `GET /api/health` returns `{ status: 'ok', timestamp }`
  - Placeholder log on startup: `KB Copilot backend running on port 3001`

### Frontend package (`frontend/`)

- `package.json` — name `@kb-copilot/frontend`, dependencies: `react`, `react-dom`; dev-deps: `typescript`, `vite`, `@vitejs/plugin-react`, `@types/react`, `@types/react-dom`
- `tsconfig.json` — extends `../tsconfig.base.json`, JSX: `react-jsx`
- `vite.config.ts` — React plugin, dev server on port 5173, proxy `/api` and `/ws` to `http://localhost:3001`
- `index.html` — minimal HTML shell with `<div id="root">`
- `src/main.tsx` — React 18 `createRoot` render
- `src/App.tsx` — placeholder component that:
  - Fetches `/api/health` on mount
  - Displays "KnowledgeBase Copilot" heading and backend status

### Root scripts

Add these to root `package.json` scripts:
- `build` — builds shared, then backend, then frontend (sequential)
- `dev` — runs backend and frontend dev servers concurrently
- `dev:backend` — runs backend with `tsx watch`
- `dev:frontend` — runs frontend with `vite`

## Acceptance Criteria

1. `npm install` from root runs cleanly with no errors.
2. `npm run build` compiles all three packages without TypeScript errors.
3. Shared types are importable from both backend and frontend (verified by import statements in each).
4. `npm run dev:backend` starts Express on port 3001; `curl http://localhost:3001/api/health` returns JSON.
5. `npm run dev:frontend` starts Vite on port 5173; browser shows heading and backend status.
6. `npm run dev` starts both servers concurrently.

## Verification Steps

1. Run `npm install` from `/KnowledgeBase-Copilot/` — no errors.
2. Run `npm run build` — no TypeScript errors, `dist/` folders created in each package.
3. Run `npm run dev` — both servers start. Open `http://localhost:5173` in browser — heading visible, health status shown.
4. Verify that editing a shared type and rebuilding propagates to both backend and frontend.

## Exit Criteria

1. Monorepo structure is complete and builds cleanly.
2. All shared type interfaces are defined and exported.
3. Both dev servers start and the frontend can reach the backend health endpoint.

## Skill Suggestions

- **Developer** agent for TypeScript configuration and npm workspace setup.
- **Architect** agent if workspace layout decisions need review.
