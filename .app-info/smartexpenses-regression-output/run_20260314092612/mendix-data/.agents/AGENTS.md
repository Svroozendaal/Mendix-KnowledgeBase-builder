# AGENTS
## Mendix Data Package Framework

This file is the entry point for AI assistants working with the standalone `mendix-data` package.

## Purpose

Route agents to the right evidence layer inside this package:

1. `C:\Workspaces\Mendix-KnowledgeBase-builder\.app-info\smartexpenses-regression-output\run_20260314092612\mendix-data\knowledge-base` for normal application understanding
2. `app-overview/` for export-backed verification
3. `dumps/` for parser or raw-evidence debugging

## First Step Rule

Before handling any task:

1. Read `.agents/AGENTS.md` (this file)
2. Read `.agents/FRAMEWORK.md`
3. Read `.agents/AI_WORKFLOW.md`
4. Read [CURRENT_RUN.md](../CURRENT_RUN.md)
5. For most app questions, continue with [C:\Workspaces\Mendix-KnowledgeBase-builder\.app-info\smartexpenses-regression-output\run_20260314092612\mendix-data\knowledge-base/.agents/AGENTS.md](../C:\Workspaces\Mendix-KnowledgeBase-builder\.app-info\smartexpenses-regression-output\run_20260314092612\mendix-data\knowledge-base/.agents/AGENTS.md)

## Routing Rules

1. If the task is about app behaviour, module purpose, flows, pages, entities, or security, start in `C:\Workspaces\Mendix-KnowledgeBase-builder\.app-info\smartexpenses-regression-output\run_20260314092612\mendix-data\knowledge-base`.
2. If the KB contains `Unknown`, weak traceability, or insufficient proof, escalate to `C:\Workspaces\Mendix-KnowledgeBase-builder\.app-info\smartexpenses-regression-output\run_20260314092612\mendix-data\app-overview\cli_2026-03-14T09-26-12.835Z`.
3. If the overview export still lacks the needed evidence, escalate to `dumps/`.
4. Do not start in `dumps/` unless the task is specifically about parser behaviour or missing export fields.

## Scope Boundary

This package is read-only evidence.

Agents may:

- read and compare files inside `mendix-data`
- explain trust levels and evidence gaps
- trace statements from KB back to overview export and raw dump

Agents must not:

- regenerate the package from inside this package
- assume `C:\Workspaces\Mendix-KnowledgeBase-builder\.app-info\smartexpenses-regression-output\run_20260314092612\mendix-data\knowledge-base` is sufficient when it clearly marks `Unknown`
- skip directly to raw dumps for routine questions

## Handoff Rule

Once the task is clearly within the knowledge base layer, use [C:\Workspaces\Mendix-KnowledgeBase-builder\.app-info\smartexpenses-regression-output\run_20260314092612\mendix-data\knowledge-base/.agents/AGENTS.md](../C:\Workspaces\Mendix-KnowledgeBase-builder\.app-info\smartexpenses-regression-output\run_20260314092612\mendix-data\knowledge-base/.agents/AGENTS.md) as the specialised agent framework for detailed KB work.

