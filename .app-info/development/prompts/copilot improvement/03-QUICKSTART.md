# PROMPT 03: QUICKSTART.md Fast Context File

## Priority

Critical — cuts bot bootstrap from 6 files (~2,500 lines) to 1 file (~150 lines), saving 80% of cold-start tokens.

## Context

Read before starting:

1. `.agents/AGENTS.md`
2. `.app-info/development/prompts/copilot improvement/INDEX.md`
3. Generated KB: `mendix-data/knowledge-base/CLAUDE.md`
4. Generated KB: `mendix-data/knowledge-base/READER.md`
5. Generated KB: `mendix-data/knowledge-base/ROUTING.md`
6. Generated KB: `mendix-data/knowledge-base/.agents/AGENTS.md`
7. Generated KB: `mendix-data/knowledge-base/.agents/FRAMEWORK.md`
8. Generated KB: `mendix-data/knowledge-base/.agents/AI_WORKFLOW.md`

## Problem Statement

A bot must read 6 files before answering its first question:

1. `CLAUDE.md` — 30 lines, mostly pointers to other files.
2. `.agents/AGENTS.md` — 186 lines of governance, roster, scope boundaries.
3. `.agents/FRAMEWORK.md` — 71 lines explaining KB structure.
4. `.agents/AI_WORKFLOW.md` — 124 lines of workflow, query patterns, and phase descriptions.
5. `READER.md` — 56 lines of navigation and confidence levels.
6. `ROUTING.md` — variable length, module index and quick lookups.

Much of this content overlaps (scope boundary is repeated in 3 files, navigation instructions in 4 files, agent routing rules in 2 files). A bot loading all 6 files burns ~2,500 tokens on bootstrapping before it reads a single piece of application content.

## Entry Criteria

1. The KB Creator pipeline generates CLAUDE.md, READER.md, and ROUTING.md.
2. The KB agent framework files (AGENTS.md, FRAMEWORK.md, AI_WORKFLOW.md) are generated or copied into the KB.

## Deliverable

### 1. New compose artifact: `QUICKSTART.md`

Generate a single file at KB root that contains everything a bot needs to start working, in ~150 lines:

```markdown
# Quick Start — [App Name]

Generated at: [timestamp] | Format: [version] | Enriched: [Yes/No]

## This App

[1-3 sentences from APP_OVERVIEW.md mission summary]

## Modules

| Module | Type | Key Entities | Custom Flows | Priority |
|---|---|---|---|---|
| MyFirstModule | Custom | Course, TrainingEvent, Registration, Location, Trainer, Trainee | 48 | Core |
| AdministrationExtension | Custom | — | 1 | Supporting |
| Administration | Marketplace | Account | 13 | Reference |
| ... | ... | ... | ... | ... |

## Security Roles

[Compact role list from SECURITY.md: role name → module roles]

## How to Find Things

| I want to... | Read this file |
|---|---|
| Understand the app | `app/APP_OVERVIEW.md` |
| Find an entity | `routes/by-entity.md` or `routes/keyword-index.md` |
| Find a flow | `routes/by-flow.md` or `routes/keyword-index.md` |
| Find a page | `routes/by-page.md` |
| Understand a module | `modules/<Name>/README.md` |
| See cross-module dependencies | `routes/cross-module.md` |
| Check security | `app/SECURITY.md` |
| Plan a feature | `/develop` → `.agents/agents/DEVELOPMENT_TEAM.md` |

## Agent Routing

| Question type | Agent/Skill |
|---|---|
| User story or `/develop` | Development Team |
| "How does X work?" (feature) | KB Feature Interpreter |
| "Trace flow X" | KB Flow Tracer |
| "What if I change X?" | KB Analyst (impact-analysis) |
| Security question | KB Security Reviewer |
| "How do I build X?" | Mendix Developer |
| Lookup / navigation | KB Navigator |

## Scope Rules

- This KB is **read-only**. Exception: `/enrichkb` can add AI narrative.
- Only cite what is in the KB. Do not fabricate.
- Only target **custom modules** for development. Marketplace/system modules are reference-only.
- Use UK English.
- Cite file paths in all answers.

## Reading Depth Guide

- **Quick answer**: ROUTING.md → 1 module README → answer
- **Feature understanding**: + FLOWS.md + top 3 L0 abstracts + 1 L1 overview
- **Full investigation**: + all related L1 overviews + DOMAIN.md + INTERPRETATION.md
- **Implementation plan**: everything above + routes + SECURITY.md

## Full Reference

For detailed governance: `.agents/AGENTS.md`
For KB structure detail: `.agents/FRAMEWORK.md`
For complete workflow: `.agents/AI_WORKFLOW.md`
For navigation rules: `READER.md`
For full module index: `ROUTING.md`
```

### 2. Update CLAUDE.md

Change the CLAUDE.md reading order to start with QUICKSTART.md:

```markdown
Before executing any task, read `QUICKSTART.md` for a fast-start overview.

For full detail, read:
1. `.agents/AGENTS.md` — governance and agent roster
2. `.agents/FRAMEWORK.md` — KB structure
3. `.agents/AI_WORKFLOW.md` — operating flow
4. `READER.md` — how to read this KB
5. `ROUTING.md` — module and route index
```

### 3. New compose template: `_artifacts/QUICKSTART_TEMPLATE.md`

Create the template with placeholders for app name, module table, role list, and generation metadata.

### 4. Quality gate check

Add a quality gate rule:
- `QUICKSTART.md` exists at KB root.
- It contains at least one module row.
- It contains the app name from APP_OVERVIEW.md.
- It is under 200 lines.

## Exit Criteria

1. `QUICKSTART.md` is generated during compose.
2. A bot can cold-start from `QUICKSTART.md` alone and know: what the app is, which modules exist, how to find things, and what the scope rules are.
3. The full reference files remain available for deep dives.
4. CLAUDE.md points to QUICKSTART.md as the primary entry point.

## Skills to Use

- Agent: **Developer** (compose step code changes)
- Agent: **Documenter** (template creation)

## Notes

- QUICKSTART.md must be regenerated every time the KB is rebuilt. It is a deterministic artifact.
- The "Enriched: Yes/No" flag tells the bot whether INTERPRETATION.md files are populated — this affects answer quality expectations.
- Keep the file under 200 lines. If the app has 50+ modules, show the top 10 by priority and add "See ROUTING.md for full list".
- The Reading Depth Guide section is new guidance that does not exist in any current file. It is critical for token efficiency.
