# Feature: KnowledgeBase Copilot

## Status

DONE

## Summary

AI-powered chat application that queries a generated Mendix knowledge base conversationally. The Copilot reads KB files on-the-fly using tool calls, following the L0/L1/L2 navigation pattern — behaving like Claude Code but scoped to the KB.

## Scope

- Node.js + Express backend with WebSocket streaming
- React 18 + Vite frontend with real-time chat UI
- Pluggable AI provider abstraction (Claude CLI, Codex CLI)
- KB file navigation, search, and sandboxed reads
- Conversation persistence and management
- Question classifier for fast-path routing
- System prompt generation from KB metadata
- Mendix Studio Pro extension (C# dockable WebView pane)

## Location

`KnowledgeBase-Copilot/`

## Tech Stack

- **Backend:** Node.js, Express, TypeScript, WebSocket (`ws`)
- **Frontend:** React 18, Vite, TypeScript, CSS Modules
- **Shared:** npm workspace package with shared types
- **Extension:** C# (.NET), Mendix ExtensionsAPI

## Key Design Decisions

1. **CLI-based AI providers** — uses Claude CLI and Codex CLI as child processes rather than direct API calls, leveraging their built-in tool ecosystems.
2. **WebSocket streaming** — real-time token-by-token streaming for responsive chat UX.
3. **Path-sandboxed KB access** — the backend restricts file reads to within the configured KB root.
4. **Conversation-as-JSON** — conversations are persisted as individual JSON files for simplicity and portability.
5. **Monorepo structure** — shared types ensure type safety across backend and frontend.

## Development Prompts

- Copilot track: `.app-info/development/prompts/copilot/INDEX.md` (phases 01–07)
- Copilot improvement track: `.app-info/development/prompts/copilot improvement/INDEX.md` (phases 01–10)

## Improvement Notes

- The current Node.js backend is being superseded by a unified C# extension — see `unified-extension.md`.
- Copilot improvement prompts (01–10) define enhancements to keyword indexing, entity attributes, reading budgets, and cross-module reasoning.
