# PROMPT 03: QUICKSTART.md Fast Context File

## Priority

Critical — cuts bot bootstrap from 6 files (~2,500 lines) to 1 file (~150 lines), saving 80% of cold-start tokens.

## Context

Read before starting:

1. `.agents/AGENTS.md`
2. `.app-info/development/prompts/copilot improvement/INDEX.md`
3. `KnowledgeBase-Creator/artifacts/templates/CLAUDE_MD_TEMPLATE.md` — current CLAUDE.md template
4. `KnowledgeBase-Creator/artifacts/templates/ROUTING_TEMPLATE.md` — current routing template
5. `KnowledgeBase-Creator/artifacts/.agents/AGENTS.md` — current agent governance
6. `KnowledgeBase-Creator/artifacts/.agents/FRAMEWORK.md` — current framework description
7. `KnowledgeBase-Creator/artifacts/.agents/AI_WORKFLOW.md` — current workflow
8. `KnowledgeBase-Creator/wizard/run-kb-compose.ps1` — compose script
9. Generated KB example: `mendix-data/knowledge-base/CLAUDE.md` (to see current output)

## Problem Statement

A bot must read 6 files before answering its first question:

1. `CLAUDE.md` — 30 lines, mostly pointers to other files.
2. `.agents/AGENTS.md` — 186 lines of governance, roster, scope boundaries.
3. `.agents/FRAMEWORK.md` — 71 lines explaining KB structure.
4. `.agents/AI_WORKFLOW.md` — 124 lines of workflow, query patterns, and phase descriptions.
5. `READER.md` — 56 lines of navigation and confidence levels.
6. `ROUTING.md` — variable length, module index and quick lookups.

Much of this content overlaps. A bot loading all 6 files burns ~2,500 tokens on bootstrapping before reading a single piece of application content.

## Entry Criteria

1. The compose script generates CLAUDE.md and ROUTING.md from templates.
2. Agent framework files are copied from `artifacts/.agents/`.

## Deliverable

### 1. New compose template: `KnowledgeBase-Creator/artifacts/templates/QUICKSTART_TEMPLATE.md`

```markdown
# Quick Start — {{AppName}}

Generated at: {{GeneratedAt}} | Format: {{FormatVersion}} | Enriched: {{EnrichedStatus}}

## This App

{{AppMissionSummary}}

## Modules

| Module | Type | Key Entities | Custom Flows | Priority |
|---|---|---|---|---|
{{ModuleRows}}

## Security Roles

{{RoleSummary}}

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

### 2. Add QUICKSTART generation to compose script

In `KnowledgeBase-Creator/wizard/run-kb-compose.ps1`, add a function to generate `QUICKSTART.md`:

1. Read the app name from the export metadata.
2. Build the module table from the module landscape data (already available during compose).
3. Build the role summary from the security export data.
4. Extract the app mission summary from the APP_OVERVIEW compose data.
5. Determine enrichment status by checking whether any INTERPRETATION.md files contain more than template stubs.
6. Fill the template and write to `{KB}/QUICKSTART.md`.

**Placement:** Generate QUICKSTART.md after APP_OVERVIEW.md and MODULE_LANDSCAPE.md are generated (it depends on both).

**Size constraint:** If the app has >15 modules, show only the top 15 by priority score and add "See `ROUTING.md` for the full list of {{TotalModules}} modules." Keep the file under 200 lines.

### 3. Update CLAUDE.md template

In `KnowledgeBase-Creator/artifacts/templates/CLAUDE_MD_TEMPLATE.md`, change the reading order:

```markdown
Before executing any task, read `QUICKSTART.md` for a fast-start overview.

For full detail, read:
1. `.agents/AGENTS.md` — governance and agent roster
2. `.agents/FRAMEWORK.md` — KB structure
3. `.agents/AI_WORKFLOW.md` — operating flow
4. `READER.md` — how to read this KB
5. `ROUTING.md` — module and route index
```

### 4. Add quality gate check

In `KnowledgeBase-Creator/wizard/run-kb-quality-gate.ps1`, add validation rules:
- `QUICKSTART.md` exists at KB root.
- It contains at least one module row.
- It contains the app name.
- It is under 200 lines.

### 5. Register in pipeline

In `KnowledgeBase-Creator/wizard/run-dump-parser.ps1`, ensure QUICKSTART.md generation is called after APP_OVERVIEW and MODULE_LANDSCAPE are composed.

## Files Changed (all under `KnowledgeBase-Creator/`)

| File | Change |
|---|---|
| `artifacts/templates/QUICKSTART_TEMPLATE.md` | **New** — template for fast-context file |
| `artifacts/templates/CLAUDE_MD_TEMPLATE.md` | Point to QUICKSTART.md as primary entry |
| `wizard/run-kb-compose.ps1` | Add QUICKSTART.md generation function |
| `wizard/run-kb-quality-gate.ps1` | Add QUICKSTART validation rules |
| `wizard/run-dump-parser.ps1` | Wire QUICKSTART generation into pipeline sequence |

## Exit Criteria

1. `QUICKSTART.md` is generated at KB root for every KB.
2. A bot can cold-start from `QUICKSTART.md` alone and know: what the app is, which modules exist, how to find things, and what the scope rules are.
3. The full reference files remain available for deep dives.
4. Generated CLAUDE.md points to QUICKSTART.md as the primary entry point.

## Skills to Use

- Agent: **Developer** (compose script, pipeline changes)
- Agent: **Documenter** (template creation)

## Notes

- QUICKSTART.md is regenerated every time the KB is rebuilt. It is a deterministic artifact.
- The "Enriched: Yes/No" flag tells the bot whether INTERPRETATION.md files are populated — this affects answer quality expectations.
- The Reading Depth Guide section is new guidance that does not exist in any current file. It is critical for token efficiency.
