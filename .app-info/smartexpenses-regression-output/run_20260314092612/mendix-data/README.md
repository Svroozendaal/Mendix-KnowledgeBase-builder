# Mendix Data Package

This folder is a standalone Mendix analysis package for `SmartExpenses`.

It contains three evidence layers:

1. `C:\Workspaces\Mendix-KnowledgeBase-builder\.app-info\smartexpenses-regression-output\run_20260314092612\mendix-data\knowledge-base` - the fastest, AI-friendly knowledge base
2. `app-overview/` - the structured overview export used to build the KB
3. `dumps/` - raw dump material for parser or deep-debug investigation

## Start Here

- Agents: read [.agents/AGENTS.md](.agents/AGENTS.md)
- Current package mapping: read [CURRENT_RUN.md](CURRENT_RUN.md)
- Most application questions: start with [C:\Workspaces\Mendix-KnowledgeBase-builder\.app-info\smartexpenses-regression-output\run_20260314092612\mendix-data\knowledge-base/READER.md](C:\Workspaces\Mendix-KnowledgeBase-builder\.app-info\smartexpenses-regression-output\run_20260314092612\mendix-data\knowledge-base/READER.md), then [C:\Workspaces\Mendix-KnowledgeBase-builder\.app-info\smartexpenses-regression-output\run_20260314092612\mendix-data\knowledge-base/ROUTING.md](C:\Workspaces\Mendix-KnowledgeBase-builder\.app-info\smartexpenses-regression-output\run_20260314092612\mendix-data\knowledge-base/ROUTING.md)

## Folder Map

| Folder | Purpose | When to use it |
|---|---|---|
| `C:\Workspaces\Mendix-KnowledgeBase-builder\.app-info\smartexpenses-regression-output\run_20260314092612\mendix-data\knowledge-base` | Composed, navigable KB | Default for app, module, flow, page, and security questions |
| `app-overview/` | Export-backed structured evidence | Use when the KB says `Unknown` or you need proof |
| `dumps/` | Raw Mendix dump evidence | Use only for parser-gap or low-level debugging |

## Trust Order

1. `C:\Workspaces\Mendix-KnowledgeBase-builder\.app-info\smartexpenses-regression-output\run_20260314092612\mendix-data\knowledge-base` for fast navigation and normal answers
2. `C:\Workspaces\Mendix-KnowledgeBase-builder\.app-info\smartexpenses-regression-output\run_20260314092612\mendix-data\app-overview\cli_2026-03-14T09-26-12.835Z` for export-backed verification
3. `C:\Workspaces\Mendix-KnowledgeBase-builder\.app-info\smartexpenses-regression-output\run_20260314092612\mendix-data\dumps\2026-03-14T09-26-12.835Z_SmartExpenses\working-dump.json` only when the export is still insufficient

## Task Guide

| Need | Start here | Escalate when |
|---|---|---|
| Understand what the app does | `C:\Workspaces\Mendix-KnowledgeBase-builder\.app-info\smartexpenses-regression-output\run_20260314092612\mendix-data\knowledge-base/app/APP_OVERVIEW.md` | The summary is too shallow or marked `Unknown` |
| Find module, flow, page, or entity links | `C:\Workspaces\Mendix-KnowledgeBase-builder\.app-info\smartexpenses-regression-output\run_20260314092612\mendix-data\knowledge-base/ROUTING.md` | A route index is incomplete or ambiguous |
| Verify why a KB statement exists | `C:\Workspaces\Mendix-KnowledgeBase-builder\.app-info\smartexpenses-regression-output\run_20260314092612\mendix-data\app-overview\cli_2026-03-14T09-26-12.835Z` | The KB does not show enough evidence |
| Investigate parser blind spots | `C:\Workspaces\Mendix-KnowledgeBase-builder\.app-info\smartexpenses-regression-output\run_20260314092612\mendix-data\app-overview\cli_2026-03-14T09-26-12.835Z` | The overview export still lacks the needed field |
| Debug the lowest-level source | `dumps/` | Only after KB and overview export are exhausted |

## Current Package State

- App: `SmartExpenses`
- Generated at: `2026-03-14T09:26:31Z`
- Current run: `C:\Workspaces\Mendix-KnowledgeBase-builder\.app-info\smartexpenses-regression-output\run_20260314092612\mendix-data\app-overview\cli_2026-03-14T09-26-12.835Z`
- Current KB root: `C:\Workspaces\Mendix-KnowledgeBase-builder\.app-info\smartexpenses-regression-output\run_20260314092612\mendix-data\knowledge-base`

## Guidance

- Do not start in `dumps/` unless the task is specifically about parser behaviour or missing export evidence.
- Treat `C:\Workspaces\Mendix-KnowledgeBase-builder\.app-info\smartexpenses-regression-output\run_20260314092612\mendix-data\knowledge-base/.agents/AGENTS.md` as the specialised KB-only framework once the task has been routed into the knowledge base.

