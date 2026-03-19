# How to Read This Knowledge Base

## What is this?

This knowledge base describes the Mendix application `{{APP_NAME}}`.
It is generated from a deterministic extraction pipeline (`MxCli` default) and is designed for static-KB-first reading.

## How to navigate

1. Start at [ROUTING.md](ROUTING.md).
2. Use [app/APP_OVERVIEW.md](app/APP_OVERVIEW.md) for app-level context.
3. Use `modules/<Module>/` for app and system modules, and `modules/_marktplace/<Module>/` for marketplace modules.
4. Open collection abstracts first, object overview files second, and object JSON only for exact verification.
5. Use `routes/` for cross-module lookup.

## How to answer questions

1. Identify whether the question is app, module, entity, flow, or page scoped.
2. Use ROUTING.md to choose the source file.
3. Prefer KB markdown evidence first (`app/`, `modules/`, `routes/`).
4. If a precise structural detail is missing, use the read-only `mxcli-live` allowlist below.
5. Use raw `app-overview/` or `dumps/` only after explicit user approval.
6. Mark uncertainty explicitly.

## Reader Live Query (mxcli-live)

Resolve the live-query `.mpr` path from `_sources/creator-link.json -> mprPath`.
If the link file or `mprPath` is missing, do not guess paths; disable live queries and report why.

Allowlisted read-only commands:

1. `mxcli describe entity <qualified-name> -p <app.mpr>`
2. `mxcli describe enumeration <qualified-name> -p <app.mpr>`
3. `mxcli describe page <qualified-name> -p <app.mpr>`
4. `mxcli describe microflow <qualified-name> -p <app.mpr>`
5. `mxcli callers <qualified-name> -p <app.mpr> --transitive`
6. `mxcli refs <qualified-name> -p <app.mpr>`
7. `mxcli show associations <module> -p <app.mpr>`
8. `mxcli show constants <module> -p <app.mpr>`
9. `mxcli -p <app.mpr> -c "SHOW PROJECT SECURITY"`

Approval is still required before:
- reading `app-overview/` or `dumps/`,
- running any non-allowlisted command.

## KB Commands

- This KB remains read-only for normal interpretation.
- `/enrichkb` is the explicit in-place AI enrichment command.
- `/initkb` remains available as a compatibility entry point and rebuild handoff.
- Both commands use `_sources/creator-link.json` to find the linked `lastRunFolder`.
- If the source run folder is missing, `/initkb` should fall back to a creator-side rebuild handoff.

## Confidence levels

- Export-backed: direct from model export.
- Inferred: derived from naming or structural patterns.
- mxcli-live: read-only live query result from allowlisted commands.
- Unknown: source did not provide enough data.

## Source

- KB Format Version: {{KB_FORMAT_VERSION}}
- Run folder: {{RUN_FOLDER}}
- Generated at: {{GENERATED_AT_UTC}}
- See `_sources/SOURCE_REF.md`.
- If present, `_sources/creator-link.json` links this KB back to its creator workspace.
