# Claude Code â€” Bootstrap

Before executing any task in this repository, read the following files in order:

1. `.agents/AGENTS.md` â€” governance, agent roster, and orchestration logic.
2. `.agents/FRAMEWORK.md` â€” dual-folder operating model.
3. `.app-info/ROUTING.md` â€” app-specific content navigation.

These files define how you should operate. Follow them.

## Raw Data Access Policy — HARD BLOCK

**All development-team agents (Developer, Designer, Architect, Debugger, Tester, Reviewer, Light, and any other non-KB-pipeline agent) are FORBIDDEN from reading raw Mendix app data.**

Blocked paths (relative to any `mendix-data/` folder):
- `app-overview/` — structured model-overview export JSON (L2 layer)
- `dumps/` — raw Mendix dump files

**Allowed path:** `knowledge-base/` — the composed, AI-navigable knowledge base.

### Escalation procedure

If the knowledge base cannot answer a question:
1. **Stop.** Do not silently fall through to raw data.
2. **Tell the user** what information is missing from the KB and that answering requires reading raw app data.
3. **Explain the cost:** reading raw data consumes significantly more tokens and time.
4. **Wait for explicit user approval** before accessing any file under `app-overview/` or `dumps/`.
5. If the user declines, report the gap and suggest a KB update via `KNOWLEDGEBASE_CREATOR` or `GAPSMITH`.

This policy does **not** apply to KB-pipeline agents (`KNOWLEDGEBASE_CREATOR`, `KNOWLEDGEBASE_INTERPRETER`, `GAPSMITH`, `OVERVIEWSMITH`) whose job is to process or interpret the knowledge base.

## About This Repository

This is the **Mendix KnowledgeBase Builder** â€” a pipeline that converts Mendix application model exports into AI-navigable knowledge bases.

### Key entry points

- **Portable KB creator package**: `KnowledgeBase-Creator/`
- **CLI entry point**: `KnowledgeBase-Creator/cli/run-initkb.ps1`
- **Pipeline bootstrap**: `KnowledgeBase-Creator/cli/run-dump-parser.ps1`
- **AI start file**: `KnowledgeBase-Creator/AGENTS.md`
- **Public tool skills**: `tool-usage/knowledgebase/` and `tool-usage/knowledgebase-reader/`
- **Understand a generated KB**: read `READER.md` inside `mendix-data/knowledge-base/`
- **Unified extension spec**: `.app-info/product-plan/12-UNIFIED_EXTENSION_SPEC.md`
