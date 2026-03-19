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
- `mxcli project-tree -p <app.mpr>` works and returns a JSON tree on stdout.
- `mxcli show modules|associations|constants -p <app.mpr>` works as table or explicit zero-result text output.
- `mxcli describe entity|enumeration|page|microflow|snippet -p <app.mpr>` works as MDL output.
- `mxcli callers <qualified-name> --transitive -p <app.mpr>` works.
- `mxcli refs <qualified-name> -p <app.mpr>` works.
- `mxcli search -p <app.mpr> <term> --format json` works, but clean machine-readable stdout requires `-q` or preamble stripping.
- `mxcli lint -p <app.mpr> --format json` works, but the runner must strip the connection/status preamble before JSON parsing.
- `mxcli report -p <app.mpr> --format json` works, but the runner must strip the connection/status preamble before JSON parsing.
- `mxcli -p <app.mpr> -c "REFRESH CATALOG FULL; SELECT ... FROM CATALOG..."` is the supported route for catalog queries and full-mode data.
- `mxcli -p <app.mpr> -c "SHOW PROJECT SECURITY"` works and is the baseline source for project-security metadata.
- `mxcli -p <app.mpr> -c "SHOW USER ROLES"` works as table output.
- `mxcli -p <app.mpr> -c "SHOW MODULE ROLES IN <module>"` works as table output.
- `mxcli describe userrole <role> -p <app.mpr>` works as MDL output for project-user-role assignments.
- `CATALOG.pages` can expose truncated qualified names for long page names; extraction must normalise this before `describe page`.
- `CATALOG.microflows` includes nanoflows, but the installed CLI has no `describe nanoflow` command.

## Rejected or Unverified Assumptions

These research assumptions must not be used without revalidation:

- No user-facing `mxcli open` command exists in the installed CLI.
- No user-facing `mxcli snapshot` command exists in the installed CLI.
- `mxcli show` does not support `--format json` in the installed CLI.
- `--format json` does not guarantee clean JSON on stdout across command families. In the baseline, `project-tree` parsed cleanly, `search` needed `-q`, and raw `lint` and `report` output needed preamble stripping.
- Research that assumes catalog-only access for associations and constants is stale; command-level access exists and should be preferred when validated.
- Research that assumes the installed CLI exposes a working `CATALOG.role_mappings` table is stale for this machine.

## Baseline Validation Highlights

- `mxcli structure -d 1` confirmed the custom-module baseline and surfaced scheduled-event counts for `Inspection` and `Notification`.
- `mxcli project-tree` returned a programmatic JSON tree with top-level system overview, navigation, project security, and module nodes.
- `mxcli show associations Inspection` returned parent, child, type, owner, and storage columns for 8 associations.
- `mxcli show constants Inspection` returned `No constants found.`, confirming that empty-result handling is part of the contract.
- `mxcli refs Inspection.Dashboard_Home` returned 4 navigation references, while `mxcli callers Inspection.ACT_Task_Save --transitive` returned a valid empty result.

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
- The creator pipeline keeps dual extraction paths, with `MxCli` as default and `LegacyDumpParser` as explicit fallback.

### What Does Not Change Yet

- No `mxcli` repo changes are assumed.
- No package-local `mxcli` bundling is implemented in this track.
- The static KB remains the primary answer surface even after live-query enhancements.

## Migration Stages

### Stage 1 - Baseline and Architecture

Lock the real installed `mxcli` contract, reject stale assumptions, and establish the target system description, command capability matrix, and parity gap ledger.

### Stage 2 - Extraction Foundation

Add a reusable `mxcli` runner, PATH resolution, output parsing rules, and catalog-refresh staging. Keep the legacy extraction path untouched.

Current implementation anchor:

- `KnowledgeBase-Creator/wizard/lib/mxcli-foundation.ps1`
- `KnowledgeBase-Creator/wizard/run-mxcli-foundation-check.ps1`

### Stage 3 - Partial JSON Generation

Generate `manifest.json`, `general/*`, module inventory files, marketplace module files, and `domain-model.json` in v2.0-compatible form.

Current implementation anchor:

- `KnowledgeBase-Creator/wizard/lib/mxcli-json-v2-general-domain.ps1`
- `KnowledgeBase-Creator/wizard/run-mxcli-json-v2-general-domain.ps1`
- `KnowledgeBase-Creator/wizard/run-mxcli-json-v2-general-domain-check.ps1`

### Stage 4 - Full Run-Folder Generation

Generate flows, pages, resources, detail files, and `.pseudo.txt` compatibility outputs. Validate the resulting run folder with the existing composer and KB validation scripts.

Current implementation anchor:

- `KnowledgeBase-Creator/wizard/lib/mxcli-json-v2-full-run.ps1`
- `KnowledgeBase-Creator/wizard/run-mxcli-json-v2-full-run.ps1`

Current validation evidence:

- Run folder generated: `mendix-data/app-overview/mxcli_prompt04_smoke2`
- Composer output generated: `mendix-data/knowledge-base-mxcli-p04-smoke2`
- Validation commands passed on 2026-03-18:
  - `run-kb-scaffold.ps1 -Validate`
  - `run-kb-quality-gate.ps1`
  - `run-kb-semantic-benchmark.ps1`

### Stage 5 - Dual Path Integration

Expose the new extraction path in the creator scripts and wizard without making it the default.

Current implementation anchor:

- `KnowledgeBase-Creator/wizard/run-dump-parser.ps1`
- `KnowledgeBase-Creator/wizard/run-initkb.ps1`
- `KnowledgeBase-Creator/wizard/src/KnowledgeBaseCreator.Wizard/`

Stage 5 extraction-mode contract:

- Script parameter: `-ExtractionMode LegacyDumpParser|MxCli`
- Environment and `.env`: `KB_EXTRACTION_MODE=LegacyDumpParser|MxCli`
- Wizard UI label: `Extraction mode`
- Wizard persisted config key: `LastExtractionMode` (`config.last.json`)
- Prompt 05 default mode: `LegacyDumpParser`
- Prompt 06 switch target: `MxCli`

### Stage 6 - Switchover

Make `mxcli` the default extraction path only after parity and validation evidence is green. Update docs, agents, and skills to match the new default.

Current implementation anchor:

- `KnowledgeBase-Creator/wizard/run-dump-parser.ps1`
- `KnowledgeBase-Creator/wizard/run-initkb.ps1`
- `KnowledgeBase-Creator/wizard/src/KnowledgeBaseCreator.Wizard/WizardRuntime.cs`
- `KnowledgeBase-Creator/wizard/src/KnowledgeBaseCreator.Wizard/WizardForm.cs`

Current switchover contract:

- Default mode: `MxCli`
- Legacy fallback: `LegacyDumpParser` via explicit script/UI/env override
- `.env`/environment key: `KB_EXTRACTION_MODE=LegacyDumpParser|MxCli`
- Wizard persisted key: `LastExtractionMode`
- No change to downstream compose, scaffold validation, quality gate, or benchmark stages

### Stage 7 - Live Query Enhancements

Add optional read-only `mxcli` live-query behaviour to the KB reader side while keeping the static KB as the primary evidence source.

Current implementation anchor:

- `.app-info/agents/OVERVIEW_KB_READER.md`
- `KnowledgeBase-Creator/artifacts/templates/KNOWLEDGEBASE_READER.md`
- `mendix-data/knowledge-base/READER.md`
- `.app-info/skills/mendix-mxcli/SKILL.md`

Current live-query contract:

- Escalation model: static KB first, `mxcli-live` second, raw data only with explicit approval
- `.mpr` resolution: `knowledge-base/_sources/creator-link.json -> mprPath`
- No `.mpr` guessing when link data is missing
- Allowlisted read-only commands only (see capability matrix and `mendix-mxcli` skill)
- Confidence labels include `mxcli-live` alongside `export-backed`, `inferred`, and `unknown`

## Required Architectural Rules

- Treat `.app-info/development/prompts/MxCLI integration/App information/` as research, not source of truth.
- Use only validated commands from the capability matrix, or revalidate before adoption.
- The extraction runner must normalise per-command stream behaviour. Do not assume every JSON-oriented command can be piped directly into a JSON parser.
- Reuse the shared creator MxCLI foundation for PATH resolution, warning separation, and catalog-stage decisions instead of reimplementing per-script shell calls.
- Reuse the Prompt 03 general/domain generator for manifest, general, and domain-model outputs instead of duplicating ad hoc extraction logic.
- If a field cannot be extracted safely, record the gap in the parity gap ledger; do not invent data.
- Keep default extraction at `MxCli` unless validation evidence requires temporary rollback.
- Keep the legacy extraction path available as explicit fallback until deprecation is explicitly approved.
- Keep reader escalation static-first; do not treat live queries as primary narrative source.

## Validation Reference

Use `mendix-data/knowledge-base/` as the folder and content-pattern reference. It is a contract reference, not a strict numeric parity oracle.
