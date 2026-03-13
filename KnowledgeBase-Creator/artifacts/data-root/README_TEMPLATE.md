# Mendix Data Package

This folder is a standalone Mendix analysis package for `{{APP_NAME}}`.

It contains three evidence layers:

1. `{{KB_ROOT}}` - the fastest, AI-friendly knowledge base
2. `{{APP_OVERVIEW_ROOT}}` - the structured overview export used to build the KB
3. `{{DUMPS_ROOT}}` - raw dump material for parser or deep-debug investigation

## Start Here

- Agents: read [.agents/AGENTS.md](.agents/AGENTS.md)
- Current package mapping: read [CURRENT_RUN.md](CURRENT_RUN.md)
- Most application questions: start with [{{KB_READER}}]({{KB_READER}}), then [{{KB_ROUTING}}]({{KB_ROUTING}})

## Folder Map

| Folder | Purpose | When to use it |
|---|---|---|
| `{{KB_ROOT}}` | Composed, navigable KB | Default for app, module, flow, page, and security questions |
| `{{APP_OVERVIEW_ROOT}}` | Export-backed structured evidence | Use when the KB says `Unknown` or you need proof |
| `{{DUMPS_ROOT}}` | Raw Mendix dump evidence | Use only for parser-gap or low-level debugging |

## Trust Order

1. `{{KB_ROOT}}` for fast navigation and normal answers
2. `{{RUN_FOLDER}}` for export-backed verification
3. `{{DUMP_GUIDANCE}}` only when the export is still insufficient

## Task Guide

| Need | Start here | Escalate when |
|---|---|---|
| Understand what the app does | `{{KB_ROOT}}/app/APP_OVERVIEW.md` | The summary is too shallow or marked `Unknown` |
| Find module, flow, page, or entity links | `{{KB_ROUTING}}` | A route index is incomplete or ambiguous |
| Verify why a KB statement exists | `{{RUN_FOLDER}}` | The KB does not show enough evidence |
| Investigate parser blind spots | `{{RUN_FOLDER}}` | The overview export still lacks the needed field |
| Debug the lowest-level source | `{{DUMPS_ROOT}}` | Only after KB and overview export are exhausted |

## Current Package State

- App: `{{APP_NAME}}`
- Generated at: `{{GENERATED_AT_UTC}}`
- Current run: `{{RUN_FOLDER}}`
- Current KB root: `{{KB_ROOT}}`

## Guidance

- Do not start in `{{DUMPS_ROOT}}` unless the task is specifically about parser behaviour or missing export evidence.
- Treat `{{KB_ROOT}}/.agents/AGENTS.md` as the specialised KB-only framework once the task has been routed into the knowledge base.
