# FRAMEWORK
## Standalone Mendix Data Operating Model

This package contains three evidence layers with different strengths.

## Layers

| Layer | Path | Strength | Use case |
|---|---|---|---|
| Knowledge base | `C:\Workspaces\Mendix-KnowledgeBase-builder\.app-info\smartexpenses-regression-output\run_20260314092612\mendix-data\knowledge-base` | Fastest to navigate | Normal app understanding and question answering |
| Overview export | `C:\Workspaces\Mendix-KnowledgeBase-builder\.app-info\smartexpenses-regression-output\run_20260314092612\mendix-data\app-overview\cli_2026-03-14T09-26-12.835Z` | Strongest structured source evidence | Verification, tracing, and `Unknown` follow-up |
| Raw dump | `dumps/` | Lowest-level fallback | Parser-gap and deep-debug investigation |

## Reading Strategy

1. Start with the knowledge base.
2. Escalate to the overview export only when needed.
3. Use the raw dump only when both higher layers are insufficient.

## Current Mapping

- Active run: `C:\Workspaces\Mendix-KnowledgeBase-builder\.app-info\smartexpenses-regression-output\run_20260314092612\mendix-data\app-overview\cli_2026-03-14T09-26-12.835Z`
- Active KB: `C:\Workspaces\Mendix-KnowledgeBase-builder\.app-info\smartexpenses-regression-output\run_20260314092612\mendix-data\knowledge-base`
- KB entry guide: `C:\Workspaces\Mendix-KnowledgeBase-builder\.app-info\smartexpenses-regression-output\run_20260314092612\mendix-data\knowledge-base/READER.md`

## Package Principle

The package is easiest to understand when agents treat it as a funnel:

1. broad navigation in the KB,
2. source verification in the overview export,
3. root-cause debugging in the raw dump.

