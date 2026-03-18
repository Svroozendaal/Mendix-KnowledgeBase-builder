# MxCLI KB Creator Target Architecture

## Purpose

This document is the source of truth for the intended end state of the MxCLI-based KnowledgeBase Creator migration. Prompt 01 owns the initial baseline. Later prompts must update this document before continuing whenever the intended system shape changes.

## Baseline Date

- Baseline captured on: 2026-03-18
- Validated CLI: `mxcli version 0.1.0`
- Validation app: `C:\Workspaces\Mendix\Emixa_InspectionApp\Emixa_InspectionApp.mpr`
- KB reference: `mendix-data/knowledge-base/`
- Research notes: `.app-info/development/prompts/MxCLI integration/App information/`

## Validated CLI Contract

The installed CLI contract overrides stale research notes. The baseline validated the following behaviours against a real Mendix app:

- `mxcli` is available on `PATH`; package-local bundling is out of scope for this track.
- `mxcli structure -p <app.mpr>` works and builds a cached catalog.
- `mxcli project-tree -p <app.mpr>` works and returns JSON.
- `mxcli show modules|associations|constants -p <app.mpr>` works as table output.
- `mxcli describe entity|enumeration|page|microflow -p <app.mpr>` works as MDL output.
- `mxcli callers <qualified-name> --transitive -p <app.mpr>` works.
- `mxcli refs <qualified-name> -p <app.mpr>` works.
- `mxcli search -p <app.mpr> <term> --format json` works.
- `mxcli lint -p <app.mpr> --format json` works.
- `mxcli report -p <app.mpr> --format json` works.
- `mxcli -p <app.mpr> -c "REFRESH CATALOG FULL; SELECT ... FROM CATALOG..."` is the supported route for catalog queries and full-mode data.

## Rejected or Unverified Assumptions

These research assumptions must not be used without revalidation:

- No user-facing `mxcli open` command exists in the installed CLI.
- No user-facing `mxcli snapshot` command exists in the installed CLI.
- `mxcli show` does not support `--format json` in the installed CLI.
- Research that assumes catalog-only access for associations and constants is stale; command-level access exists and should be preferred when validated.

## Target System Shape

### End State

Replace the current extraction layer in KnowledgeBase Creator with an MxCLI-based extractor that reads the Mendix `.mpr` directly and writes a run folder compatible with the existing JSON v2.0 app-overview contract.

### What Must Stay Stable Through the Core Migration

- `mendix-data/app-overview/<run>/` remains the extraction output root.
- `run-kb-compose.ps1` remains the composer of record during the core migration.
- The generated KB remains a static on-disk artefact.
- The current `knowledge-base/` folder contract remains the compatibility target.
- Existing quality-gate and semantic-benchmark scripts remain part of the validation path.

### What Changes

- `mx dump-mpr + C# parser` is replaced by `mxcli` on `PATH`.
- Extraction relies on validated command categories: table output, MDL output, JSON output, and `-c` catalog queries.
- Phase 1 keeps `.pseudo.txt` compatibility instead of forcing downstream composer or enrichment rewrites.
- The creator pipeline temporarily supports dual extraction paths until parity is validated and the default can switch safely.

### What Does Not Change Yet

- No `mxcli` repo changes are assumed.
- No package-local `mxcli` bundling is implemented in this track.
- No live-query behaviour is introduced during the core extraction migration.
- The KB reader remains static-KB-first until Prompt 07.

## Migration Stages

### Stage 1 - Baseline and Architecture

Lock the real installed `mxcli` contract, reject stale assumptions, and establish the target system description, command capability matrix, and parity gap ledger.

### Stage 2 - Extraction Foundation

Add a reusable `mxcli` runner, PATH resolution, output parsing rules, and catalog-refresh staging. Keep the legacy extraction path untouched.

### Stage 3 - Partial JSON Generation

Generate `manifest.json`, `general/*`, module inventory files, marketplace module files, and `domain-model.json` in v2.0-compatible form.

### Stage 4 - Full Run-Folder Generation

Generate flows, pages, resources, detail files, and `.pseudo.txt` compatibility outputs. Validate the resulting run folder with the existing composer and KB validation scripts.

### Stage 5 - Dual Path Integration

Expose the new extraction path in the creator scripts and wizard without making it the default.

### Stage 6 - Switchover

Make `mxcli` the default extraction path only after parity and validation evidence is green. Update docs, agents, and skills to match the new default.

### Stage 7 - Live Query Enhancements

Add optional read-only `mxcli` live-query behaviour to the KB reader side while keeping the static KB as the primary evidence source.

## Required Architectural Rules

- Treat `.app-info/development/prompts/MxCLI integration/App information/` as research, not source of truth.
- Use only validated commands from the capability matrix, or revalidate before adoption.
- If a field cannot be extracted safely, record the gap in the parity gap ledger; do not invent data.
- Do not switch defaults while composer, quality gate, or semantic benchmark validation is red.
- Keep the legacy extraction path available until switchover evidence is recorded.

## Validation Reference

Use `mendix-data/knowledge-base/` as the folder and content-pattern reference. It is a contract reference, not a strict numeric parity oracle.
