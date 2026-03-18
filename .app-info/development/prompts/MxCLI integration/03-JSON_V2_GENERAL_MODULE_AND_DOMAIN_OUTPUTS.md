# PROMPT 03: JSON v2 General, Module, and Domain Outputs

## Priority

Critical - this prompt creates the first v2.0-compatible extraction outputs from the new `mxcli` foundation.

## Depends On

- `02-EXTRACTION_FOUNDATION.md`

## Context

Read before starting:

1. `.agents/AGENTS.md`
2. `.agents/FRAMEWORK.md`
3. `.app-info/development/prompts/MxCLI integration/INDEX.md`
4. `.app-info/docs/MXCLI_KB_CREATOR_TARGET_ARCHITECTURE.md`
5. `.app-info/docs/MXCLI_COMMAND_CAPABILITY_MATRIX.md`
6. `.app-info/docs/MXCLI_PARITY_GAP_LEDGER.md`
7. `.app-info/development/prompts/MxCLI integration/App information/02-JSON-V2-SCHEMA.md`
8. `.app-info/development/prompts/MxCLI integration/App information/04-SCHEMA-MAPPING.md`
9. `.app-info/development/prompts/MxCLI integration/App information/06-ROUTING-ANALYSIS.md`
10. `KnowledgeBase-Creator/wizard/run-dump-parser.ps1`
11. `mendix-data/knowledge-base/`

If any workflow or implementation ambiguity remains after reading the context, ask clarifying questions before changing files. If not, state that no workflow questions remain and continue.

## Problem Statement

The migration now needs generator output, not just execution plumbing. This prompt must produce the JSON v2.0 files that describe app summary, security, module inventory, marketplace module inventory, and domain-model information, while remaining compatible with the existing composer contract.

## Entry Criteria

1. Prompt 02 is complete and its validation gate passed.
2. The `mxcli` runner and parsers are available for reuse.
3. The v2.0 schema reference and current KB reference are available.

## Deliverable

Generate the following outputs from `mxcli` for a run folder under `mendix-data/app-overview/<run>/`:

- `manifest.json`
- `general/app-info.json`
- `general/user-roles.json`
- `general/all-modules.json`
- `general/marketplace-modules.json`
- `modules/<Module>/domain-model.json`

Implementation rules:

1. Use only commands validated in the capability matrix, or revalidate and document any additional command before adoption.
2. Prefer `show associations` over speculative association parsing where it satisfies the contract.
3. Use `describe entity` and `describe enumeration` where field-level detail cannot be sourced safely from simpler commands.
4. Keep `manifest.json.schemaVersion` at `"2.0"` and add `manifest.json.generator = "mxcli"` so downstream validation can distinguish the extraction path without changing the file location or schema version.
5. In `general/app-info.json`, keep `sourceMprPath` populated and set `sourceDumpPath` to `null` in MxCLI mode rather than omitting the field.
6. Preserve JSON v2.0 field names, null handling, and file locations.
7. Do not switch the composer or legacy pipeline yet.
8. Record every unresolved field mismatch in the parity gap ledger instead of inventing data.

## Acceptance Criteria

1. The generated run folder contains the expected v2.0 file tree for manifest, general files, and per-module domain-model files.
2. `manifest.json` and `general/*` files follow the current v2.0 naming and structural conventions closely enough for downstream consumers to read them unchanged, including `manifest.json.generator = "mxcli"` and `general/app-info.json.sourceDumpPath = null`.
3. `domain-model.json` contains entity, attribute, enumeration, access-rule, and association information sourced from validated `mxcli` commands.
4. Module and marketplace classification logic is documented and produces stable results from current `mxcli` output.
5. Every field that cannot yet be made evidence-backed is documented in the parity gap ledger with its current handling and impact.
6. No composer or KB-reader changes are required yet to consume the files produced by this prompt.

## Verification Steps

1. Generate a real run folder from `C:\Workspaces\Mendix\Emixa_InspectionApp\Emixa_InspectionApp.mpr`.
2. Compare the generated file tree and top-level JSON keys to the current v2.0 schema reference.
3. Confirm `manifest.json` contains `generator = "mxcli"` and `general/app-info.json` keeps `sourceDumpPath` with a `null` value in MxCLI mode.
4. Spot-check at least one custom module domain model against live `mxcli` output:
   - `mxcli show associations Inspection -p <app.mpr>`
   - `mxcli describe entity Inspection.Task -p <app.mpr>`
   - `mxcli describe enumeration Inspection.Enum_TaskStatus -p <app.mpr>`
5. Confirm the parity gap ledger captures any unresolved field mappings.
6. Confirm the legacy path still remains the active default and that this prompt does not yet change the composer.

## Exit Criteria

1. The v2.0 general and domain-model outputs exist from the `mxcli` path.
2. The outputs are structurally compatible enough for the next prompt to build flows, pages, resources, and detail files.
3. Remaining mapping gaps are documented rather than hidden.
4. Prompt 04 can proceed without making new decisions about general or domain-model extraction.

## Design Gate

If the implementation changes the intended file contract, field contract, or association strategy, update the target architecture, capability matrix, and parity gap ledger before closing this prompt. Do not move to Prompt 04 while the design docs and implementation disagree.

## Validation Gate

Claude must rerun the verification steps after implementation and explicitly report PASS or FAIL for every acceptance criterion plus an overall PASS or FAIL. If any criterion fails, stop and fix the output generation or log the blocker before proceeding.

## Skill Suggestions

- `testing`
- `documentation`
- Developer and Tester agents
