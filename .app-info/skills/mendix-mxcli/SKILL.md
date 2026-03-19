---
name: mendix-mxcli
description: Validated mxcli contract for KnowledgeBase Creator extraction and read-only reader live queries.
---

# MENDIX MXCLI

## Purpose

Provide the authoritative, validated `mxcli` contract used by this repository for:
1. default extraction (`MxCli`) in creator workflows,
2. safe read-only live-query escalation on KB reader flows.

## When To Use

Use this skill when:
1. implementing or validating extraction behaviour in `KnowledgeBase-Creator/wizard/`,
2. updating docs/agents for extraction-mode contracts,
3. answering reader questions that need targeted live structure lookup,
4. verifying command allowlists and guardrails.

## Required Inputs

1. `.app-info/docs/MXCLI_COMMAND_CAPABILITY_MATRIX.md`
2. `.app-info/docs/MXCLI_PARITY_GAP_LEDGER.md`
3. `.app-info/docs/MXCLI_KB_CREATOR_TARGET_ARCHITECTURE.md`
4. `KnowledgeBase-Creator/wizard/run-dump-parser.ps1`
5. `KnowledgeBase-Creator/wizard/run-initkb.ps1`
6. KB linkage file when in reader mode:
   - `<kb-root>/_sources/creator-link.json`

## Validated Command Set

Use only commands validated in the capability matrix. Core command families used in this track:

1. CLI/version:
   - `mxcli --version`
2. describe:
   - `mxcli describe entity <qualified-name> -p <app.mpr>`
   - `mxcli describe enumeration <qualified-name> -p <app.mpr>`
   - `mxcli describe page <qualified-name> -p <app.mpr>`
   - `mxcli describe microflow <qualified-name> -p <app.mpr>`
3. relationship lookups:
   - `mxcli callers <qualified-name> -p <app.mpr> --transitive`
   - `mxcli refs <qualified-name> -p <app.mpr>`
4. module resource lookups:
   - `mxcli show associations <module> -p <app.mpr>`
   - `mxcli show constants <module> -p <app.mpr>`
5. project security:
   - `mxcli -p <app.mpr> -c "SHOW PROJECT SECURITY"`

## Output Modes

1. Table/text mode:
   - `show`, `callers`, `refs`, many `-c` queries
2. MDL mode:
   - `describe entity|enumeration|page|microflow`
3. JSON mode (command-specific caveats apply):
   - `project-tree` (clean JSON in validated baseline)
   - `search --format json -q` (preferred)
   - `lint/report --format json` (requires preamble stripping)

## Full-Catalog Rules

1. Use full-catalog refresh only when a required table/field depends on it:
   - `mxcli -p <app.mpr> -c "REFRESH CATALOG FULL; <query>"`
2. Do not assume full-mode data is required for basic reader allowlist commands.
3. Prefer command-level surfaces before introducing new SQL-style table dependencies.

## Reader Live-Query Allowlist

Only the following commands are allowlisted for approval-free `mxcli-live` escalation:

1. `mxcli describe entity <qualified-name> -p <app.mpr>`
2. `mxcli describe enumeration <qualified-name> -p <app.mpr>`
3. `mxcli describe page <qualified-name> -p <app.mpr>`
4. `mxcli describe microflow <qualified-name> -p <app.mpr>`
5. `mxcli callers <qualified-name> -p <app.mpr> --transitive`
6. `mxcli refs <qualified-name> -p <app.mpr>`
7. `mxcli show associations <module> -p <app.mpr>`
8. `mxcli show constants <module> -p <app.mpr>`
9. `mxcli -p <app.mpr> -c "SHOW PROJECT SECURITY"`

All non-allowlisted commands remain approval-gated.

## Gap Handling

1. If required data cannot be extracted safely, do not fabricate values.
2. Record the gap in `.app-info/docs/MXCLI_PARITY_GAP_LEDGER.md`.
3. Classify as `Resolved`, `Mitigated`, `Deferred`, or `Open` with evidence and handling notes.
4. Keep switchover and live-query behaviour aligned with architecture and capability docs.

## Verification Checklist

1. Confirm `mxcli --version` succeeds from `PATH`.
2. Confirm default creator run uses `Extraction mode: MxCli` with no explicit override.
3. Confirm explicit legacy fallback still works.
4. Confirm reader live queries resolve `.mpr` via `creator-link.json -> mprPath`.
5. Validate at least:
   - one microflow live query,
   - one page live query,
   - one security/reference live query.
6. Re-run compose/scaffold validation/quality gate/semantic benchmark on default mode.
