# How to Read This Knowledge Base

## What is this?

This knowledge base is generated from Mendix model-overview export JSON and is tuned for AI-assisted reasoning.

Confidence: Export-backed

## How to navigate

- Start at [ROUTING.md](ROUTING.md), then open a route index or module collection abstract first.
- Use [app/APP_OVERVIEW.md](app/APP_OVERVIEW.md) for app mission and key behaviours.
- Use `modules/<Module>/` for app and system modules, and `modules/_marktplace/<Module>/` for marketplace modules.
- Use `routes/` files for cross-cut indexes by entity, page, and flow.
- Open collection abstracts first, then object overview files second.
- Open object JSON in `app-overview/current/...` only for exact verification.
- If L1 and L2 differ, trust L2.

Confidence: Export-backed

## How to answer questions

- For behaviour questions, trace: trigger -> flow chain -> entity mutations -> shown pages -> role constraints.
- For exact microflow, retrieve, XPath, datasource, or client-action questions, follow route-table L2 links into `app-overview/current/...`.
- For business interpretation, open `INTERPRETATION.md` only after the summary/evidence layers.
- Prefer custom modules for deep app-specific answers.
- Use support modules mainly for dependencies that affect custom behaviour.

Confidence: Inferred

## KB Commands

- This KB remains read-only for normal interpretation.
- `/enrichkb` is the explicit in-place AI enrichment command.
- `/initkb` remains available as a compatibility entry point and rebuild handoff.
- Both commands use `_sources/creator-link.json` to find the linked `lastRunFolder`.
- If the source run folder is missing, `/initkb` should fall back to a creator-side rebuild handoff.

Confidence: Export-backed

## Confidence levels

- `Export-backed`: direct from JSON export.
- `Inferred`: deterministic synthesis from export data (for example tier ranking, capability grouping).
- `Unknown`: source data is absent or non-derivable.

## Source

- Generated at: 2026-03-14T09:26:24.3092096+00:00
- Run folder: C:\Workspaces\Mendix-KnowledgeBase-builder\.app-info\smartexpenses-regression-output\run_20260314092612\mendix-data\app-overview\cli_2026-03-14T09-26-12.835Z
- Current alias: C:\Workspaces\Mendix-KnowledgeBase-builder\.app-info\smartexpenses-regression-output\run_20260314092612\mendix-data\app-overview\current
- KB Format Version: 1.0
- Schema version: 2.0
- Unknown TODO backlog: [_reports/UNKNOWN_TODO.md](_reports/UNKNOWN_TODO.md)
- If present, `_sources/creator-link.json` links this KB back to its creator workspace.
