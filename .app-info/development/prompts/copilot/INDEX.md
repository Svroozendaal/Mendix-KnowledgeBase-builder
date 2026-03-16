# Copilot Prompt Index

## Purpose

Implementation prompts for the KnowledgeBase-Copilot — a chat application that lets users query a generated Mendix knowledge base conversationally. The Copilot acts like Claude Code but against the KB: the AI reads KB files on-the-fly using tool calls, starting from `READER.md`, following the L0/L1/L2 navigation pattern.

The final version will be embedded as a Mendix Studio Pro extension (React/TypeScript pluggable widget). All UI components are designed for reuse in that context.

## Tech Stack

- **Frontend:** React 18 + TypeScript + Vite
- **Backend:** Node.js + Express + TypeScript
- **Shared types:** npm workspace package
- **Structure:** Monorepo in `/KnowledgeBase-Copilot/`

## Execution Rules

1. Before executing any prompt, read `.agents/AGENTS.md` and `.agents/FRAMEWORK.md`.
2. Read the **Context** section of each prompt for required reference files.
3. Ask clarifying questions if scope is ambiguous.
4. Confirm assumptions before changing files.
5. Run `npm run build` after each phase to verify compilation.
6. Run `npm run dev` to verify runtime behaviour where applicable.

## Prompt Map

### Copilot Development Track

| # | Prompt | Priority | Depends On | Target Package |
|---|---|---|---|---|
| 01 | [01-PROJECT_SCAFFOLD.md](01-PROJECT_SCAFFOLD.md) | Critical | — | `shared/`, `backend/`, `frontend/` |
| 02 | [02-AI_PROVIDER_SERVICE.md](02-AI_PROVIDER_SERVICE.md) | Critical | 01 | `backend/` |
| 03 | [03-KB_NAVIGATOR_AND_TOOLS.md](03-KB_NAVIGATOR_AND_TOOLS.md) | Critical | 02 | `backend/` |
| 04 | [04-API_AND_WEBSOCKET.md](04-API_AND_WEBSOCKET.md) | High | 03 | `backend/` |
| 05 | [05-FRONTEND_CHAT_UI.md](05-FRONTEND_CHAT_UI.md) | High | 04 | `frontend/` |
| 06 | [06-INTEGRATION_AND_POLISH.md](06-INTEGRATION_AND_POLISH.md) | High | 05 | All |

### Copilot Optimisation Track

| # | Prompt | Priority | Depends On | Target Package |
|---|---|---|---|---|
| 07 | [07-QUESTION_CLASSIFIER.md](07-QUESTION_CLASSIFIER.md) | High | 06 | `backend/` |

## Dependency Graph

```text
Phase 1 (Scaffold)
  -> Phase 2 (AI Provider)
    -> Phase 3 (KB Navigator + Tools)
      -> Phase 4 (API + WebSocket)
        -> Phase 5 (Frontend Chat UI)
          -> Phase 6 (Integration + Polish)
            -> Phase 7 (Question Classifier — fast-path routing)
```

Phases 1–6 are strictly sequential. Phase 7+ (optimisation track) requires phase 6 to be complete but can be developed independently of each other.

## Parallel Execution Notes

1. Phases must run in order — each builds on the previous.
2. Within a phase, backend and frontend work may be split across sessions if needed.
3. Phase 6 requires a generated knowledge base (from the KnowledgeBase Creator pipeline) for integration testing.
