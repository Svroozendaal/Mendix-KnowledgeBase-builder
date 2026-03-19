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

**RAW DATA ACCESS BLOCKED.** Do NOT open files in `app-overview/` or `dumps/` without explicit user approval. If the KB cannot answer a question, stop and ask the user before escalating to raw data â€” it costs significantly more tokens and time.

Confidence: Export-backed

## How to answer questions

- For behaviour questions, trace: trigger -> flow chain -> entity mutations -> shown pages -> role constraints.
- For exact microflow, retrieve, XPath, datasource, or client-action questions, answer from L0/L1 KB files first. **Do NOT follow L2 links into `app-overview/` without explicit user approval.**
- For business interpretation, open `INTERPRETATION.md` only after the summary/evidence layers.
- Prefer custom modules for deep app-specific answers.
- Use support modules mainly for dependencies that affect custom behaviour.
- **If a question cannot be answered from KB files alone**, tell the user what is missing and ask: _"Answering this requires reading raw app data, which costs more tokens and time. May I proceed?"_

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

- Generated at: 2026-03-18T20:45:19.1648241+00:00
- Run folder: C:\Workspaces\Mendix-KnowledgeBase-builder-mendix-cli-implementation\mendix-data-p05-legacy\app-overview\cli_2026-03-18T20-44-56.522Z
- Current alias: C:\Workspaces\Mendix-KnowledgeBase-builder-mendix-cli-implementation\mendix-data-p05-legacy\app-overview\current
- KB Format Version: 1.0
- Schema version: 2.0
- Unknown TODO backlog: [_reports/UNKNOWN_TODO.md](_reports/UNKNOWN_TODO.md)
- If present, `_sources/creator-link.json` links this KB back to its creator workspace.
