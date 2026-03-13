# AGENTS
## Mendix Data Package Framework

This file is the entry point for AI assistants working with the standalone `{{DATA_ROOT}}` package.

## Purpose

Route agents to the right evidence layer inside this package:

1. `{{KB_ROOT}}` for normal application understanding
2. `{{APP_OVERVIEW_ROOT}}` for export-backed verification
3. `{{DUMPS_ROOT}}` for parser or raw-evidence debugging

## First Step Rule

Before handling any task:

1. Read `.agents/AGENTS.md` (this file)
2. Read `.agents/FRAMEWORK.md`
3. Read `.agents/AI_WORKFLOW.md`
4. Read [CURRENT_RUN.md](../CURRENT_RUN.md)
5. For most app questions, continue with [{{KB_AGENTS}}](../{{KB_AGENTS}})

## Routing Rules

1. If the task is about app behaviour, module purpose, flows, pages, entities, or security, start in `{{KB_ROOT}}`.
2. If the KB contains `Unknown`, weak traceability, or insufficient proof, escalate to `{{RUN_FOLDER}}`.
3. If the overview export still lacks the needed evidence, escalate to `{{DUMPS_ROOT}}`.
4. Do not start in `{{DUMPS_ROOT}}` unless the task is specifically about parser behaviour or missing export fields.

## Scope Boundary

This package is read-only evidence.

Agents may:

- read and compare files inside `{{DATA_ROOT}}`
- explain trust levels and evidence gaps
- trace statements from KB back to overview export and raw dump

Agents must not:

- regenerate the package from inside this package
- assume `{{KB_ROOT}}` is sufficient when it clearly marks `Unknown`
- skip directly to raw dumps for routine questions

## Handoff Rule

Once the task is clearly within the knowledge base layer, use [{{KB_AGENTS}}](../{{KB_AGENTS}}) as the specialised agent framework for detailed KB work.
