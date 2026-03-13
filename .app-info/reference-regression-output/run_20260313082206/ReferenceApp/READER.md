# How to Read This Knowledge Base

## What is this?

This knowledge base is generated from Mendix model-overview export JSON and is tuned for AI-assisted reasoning.

Confidence: Export-backed

## How to navigate

- Start at [ROUTING.md](ROUTING.md) for index-style lookup.
- Use [app/APP_OVERVIEW.md](app/APP_OVERVIEW.md) for app mission and key behaviours.
- Use `modules/<Module>/` files for module-level behaviour, domain, pages, and resources.
- Use `routes/` files for cross-cut indexes by entity, page, and flow.

Confidence: Export-backed

## How to answer questions

- For behaviour questions, trace: trigger -> flow chain -> entity mutations -> shown pages -> role constraints.
- Prefer custom modules for deep app-specific answers.
- Use support modules mainly for dependencies that affect custom behaviour.

Confidence: Inferred

## Confidence levels

- `Export-backed`: direct from JSON export.
- `Inferred`: deterministic synthesis from export data (for example tier ranking, capability grouping).
- `Unknown`: source data is absent or non-derivable.

## Source

- Generated at: 2026-03-05T00:00:00Z
- Run folder: tests/reference/app-overview/cli_reference_minimal
- KB Format Version: 1.0
- Schema version: 2.0
- Unknown TODO backlog: [_reports/UNKNOWN_TODO.md](_reports/UNKNOWN_TODO.md)
