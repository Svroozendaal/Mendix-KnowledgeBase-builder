# ROUTING
## .app-info Master Routing

This file is the entry point for navigating all app-specific content in this repository.

Read this file after `.agents/AGENTS.md` and `.agents/FRAMEWORK.md` to understand where to find and write app-specific data.

## Folder Map

| Folder | Purpose | Key files |
|---|---|---|
| `agents/` | App-specific agent extensions | Per-agent `<AGENT>.md` extension files |
| `app/` | Application identity and vision | `PRODUCT_PLAN.md` |
| `development/` | Development resources | `prompts/`, `commands/` |
| `skills/` | App-specific skills and rules | `OVERVIEW.md`, per-skill `SKILL.md` |
| `docs/` | Documentation produced during development | Per-topic `.md` files |
| `features/` | Feature registry — what the app does | `FEATURES.md`, per-feature `.md` |
| `memory/` | Live agent memory logs | `SESSION_STATE.md`, `DECISIONS_LOG.md`, etc. |
| `config/` | App configuration context | Environment, stack, tool versions |

## Navigation Rules

1. Start here, then follow the path to the relevant subfolder.
2. Each subfolder has an `OVERVIEW.md` that explains its contents and local structure.
3. Write all session progress and decisions to `memory/`.
4. Write produced documentation to `docs/`.
5. Register completed features in `features/FEATURES.md`.

## Agent Extensions

When an agent from `.agents/agents/` needs app-specific behaviour, place an extension file at:

```
.app-info/agents/<AGENT>.md
```

See `.agents/FRAMEWORK.md` for the extension model and `.agents/skills/agent-extender/SKILL.md` for the procedure.

## Quick Reference

- **Find a prompt**: `development/prompts/OVERVIEW.md`
- **Find a skill**: `skills/OVERVIEW.md`
- **Find an agent extension**: `agents/OVERVIEW.md`
- **Find app context**: `app/PRODUCT_PLAN.md`
- **Write session state**: `memory/SESSION_STATE.md`
- **Track features**: `features/FEATURES.md`
