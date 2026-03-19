# How to Read This Knowledge Base

## What is this?

This knowledge base describes the Mendix application `{{APP_NAME}}`.

## How to navigate

1. Start at [ROUTING.md](ROUTING.md).
2. Use [app/APP_OVERVIEW.md](app/APP_OVERVIEW.md) for app-level context.
3. Use `modules/<Module>/` for app and system modules, and `modules/_marktplace/<Module>/` for marketplace modules.
4. Open collection abstracts first, object overview files second, and object JSON only for exact verification.
5. Use `routes/` for cross-module lookup.

## How to answer questions

1. Identify whether the question is app, module, entity, flow, or page scoped.
2. Use ROUTING.md to choose the source file.
3. Trust L2 (`app-overview/current/...`) over L1 if they differ.
4. Cross-reference routes when a question spans modules.
5. Mark uncertainty explicitly.

## KB Commands

- This KB remains read-only for normal interpretation.
- `/enrichkb` is the explicit in-place AI enrichment command.
- `/initkb` remains available as a compatibility entry point and rebuild handoff.
- Both commands use `_sources/creator-link.json` to find the linked `lastRunFolder`.
- If the source run folder is missing, `/initkb` should fall back to a creator-side rebuild handoff.

## Confidence levels

- Export-backed: direct from model export.
- Inferred: derived from naming or structural patterns.
- Unknown: source did not provide enough data.

## Source

- KB Format Version: {{KB_FORMAT_VERSION}}
- Run folder: {{RUN_FOLDER}}
- Generated at: {{GENERATED_AT_UTC}}
- See `_sources/SOURCE_REF.md`.
- If present, `_sources/creator-link.json` links this KB back to its creator workspace.
