# ROUTING
## .app-info Master Routing

This file is the entry point for navigating all app-specific content in this repository.

Read this file after `.agents/AGENTS.md` and `.agents/FRAMEWORK.md` to understand where to find and write app-specific data.

## Folder Map

| Folder | Purpose | Key files |
|---|---|---|
| `agents/` | KB pipeline agents | `KNOWLEDGEBASE_CREATOR.md`, `OVERVIEW_KB_BUILDER.md`, `OVERVIEW_KB_READER.md`, `GAPSMITH.md` |
| `skills/` | Mendix-specific interpretation skills | `OVERVIEW.md`, per-skill `SKILL.md` |
| `features/` | Product direction and feature registry | `FEATURES.md`, `knowledgebase-creator-artifact.md` |
| `product-plan/` | Product plan and spec documents | `00-INDEX.md` (start here) |
| `development/prompts/` | Implementation prompts for gap fixes | `INDEX.md` (start here) |

## Navigation Rules

1. Start here, then follow the path to the relevant subfolder.
2. Each subfolder has an `OVERVIEW.md` that explains its contents and local structure.

## Quick Reference

- Generate a KB: `agents/KNOWLEDGEBASE_CREATOR.md`
- Build KB content: `agents/OVERVIEW_KB_BUILDER.md`
- Query a KB: `agents/OVERVIEW_KB_READER.md`
- Plan context interview agent: `product-plan/11-CONTEXT_CONVERSATION_AGENT_SPEC.md` and `development/prompts/11-CONTEXT_AGENT_ROLE_AND_BOUNDARY.md`
- Investigate structural gaps: `agents/GAPSMITH.md`
- Find a skill: `skills/OVERVIEW.md`
- Run portable drop-in package: `../KnowledgeBase-Creator/run-dump-parser.ps1`
- Build downloadable artifact package: `../.github/workflows/build-knowledgebase-creator-artifact.yml` (`workflow_dispatch`)

## Pipeline Overview

```text
Mendix .mpr file
  -> (mx dump-mpr + MendixModelOverviewParser)
Model Overview Export (v2.0) -> mendix-data/app-overview/<run>/
  -> (KNOWLEDGEBASE_CREATOR)
AI-Navigable Knowledge Base -> mendix-data/knowledge-base/<app-name>/
  -> (GAPSMITH structural gap audit)

Portable package output -> KnowledgeBase-Creator/
```

## Scripts

| Script | Purpose |
|---|---|
| `KnowledgeBase-Creator/run-dump-parser.ps1` | Run dump + parser + KB scaffold + template seeding + validation |
| `KnowledgeBase-Creator/run-kb-scaffold.ps1` | Scaffold KB folder structure or validate completeness |
| `KnowledgeBase-Creator/run-kb-quality-gate.ps1` | Validate KB content contract (required headings, links, and quality markers) |
