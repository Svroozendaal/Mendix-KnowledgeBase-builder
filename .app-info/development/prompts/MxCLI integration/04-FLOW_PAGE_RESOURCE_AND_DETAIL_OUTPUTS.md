# PROMPT 04: Flow, Page, Resource, and Detail Outputs

## Priority

Critical - this prompt completes the `app-overview` run-folder contract and proves that the existing composer can consume the MxCLI-generated extraction output.

## Depends On

- `03-JSON_V2_GENERAL_MODULE_AND_DOMAIN_OUTPUTS.md`

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
9. `.app-info/development/prompts/MxCLI integration/App information/05-ENRICHMENT-STRATEGY.md`
10. `KnowledgeBase-Creator/wizard/run-kb-compose.ps1`
11. `KnowledgeBase-Creator/wizard/run-kb-scaffold.ps1`
12. `KnowledgeBase-Creator/wizard/run-kb-quality-gate.ps1`
13. `KnowledgeBase-Creator/wizard/run-kb-semantic-benchmark.ps1`
14. `mendix-data/knowledge-base/`

If any workflow or implementation ambiguity remains after reading the context, ask clarifying questions before changing files. If not, state that no workflow questions remain and continue.

## Problem Statement

The extractor is not credible until it can produce a full run folder that the existing composer and KB validation pipeline can consume. This prompt must generate flows, pages, resources, and detail files, define the phase-1 `.pseudo.txt` compatibility strategy, and prove the run folder works end to end.

## Entry Criteria

1. Prompt 03 is complete and its validation gate passed.
2. General, module, and domain-model outputs already exist from the MxCLI path.
3. The parity gap ledger is current.

## Deliverable

Generate the remaining v2.0-compatible extraction outputs for a full run folder:

- `modules/<Module>/flows.json`
- `modules/<Module>/flows/INDEX.json`
- `modules/<Module>/flows/<slug>.json`
- `modules/<Module>/pages.json`
- `modules/<Module>/pages/INDEX.json`
- `modules/<Module>/pages/<slug>.json`
- `modules/<Module>/resources.json`
- all required `.pseudo.txt` companions for phase-1 compatibility

Implementation rules:

1. Use validated `mxcli` commands only, or revalidate and document any additional command before adoption.
2. Parse `describe microflow` and `describe page` where catalog or table output does not provide enough structure.
3. Use Option A from the research notes as the phase-1 decision: the extraction layer must generate `.pseudo.txt` companions itself, and downstream builder/skill consumers must remain unchanged in Prompts 04-06.
4. Treat `.pseudo.txt` compatibility as a file-and-consumer contract, not a loose narrative goal. For every general or module JSON file, the companion `.pseudo.txt` must exist at the same relative path, be UTF-8 without BOM, preserve stable ordering, and cover the same objects as the JSON companion. For flows, keep both `flows.json[].pseudocode` populated and `flows.pseudo.txt` generated as the aggregate human-readable export.
5. Do not silently fake missing fields. If a field is blocked by current `mxcli` capabilities, record it in the parity gap ledger and either implement a validated fallback or stop the prompt.
6. Use the current `mendix-data/knowledge-base/` output as the contract reference for what the composer expects to consume.

## Acceptance Criteria

1. A full `app-overview/<run>/` tree is generated from the `mxcli` path with flows, pages, resources, detail files, and `.pseudo.txt` companions in the expected locations.
2. `.pseudo.txt` compatibility uses the phase-1 Option A contract: downstream builder and interpretation skills continue reading `.pseudo.txt` without requiring a new MDL-only path in this prompt.
3. The existing composer can run against the generated run folder without requiring a contract-breaking rewrite.
4. `run-kb-scaffold.ps1 -Validate`, `run-kb-quality-gate.ps1`, and `run-kb-semantic-benchmark.ps1` all pass against the generated KB, or this prompt fails and records the blocker.
5. Flow, page, and resource outputs are evidence-backed by validated `mxcli` commands or explicitly documented fallbacks.
6. The parity gap ledger is updated for every unresolved mismatch, including any residual risk around resources, scheduled events, or pseudo compatibility.
7. Prompt 05 can integrate the new path without needing to redesign the extraction contract.

## Verification Steps

1. Generate a full run folder from `C:\Workspaces\Mendix\Emixa_InspectionApp\Emixa_InspectionApp.mpr`.
2. Run the composer against that run folder.
3. Resolve the validation variables once and reuse them consistently:
   - `$appName` = the resolved application name already used by the extraction run
   - `$kbRoot` = the exact output root passed to compose, normally `<data-root>/knowledge-base`
   - `$customScenariosPath` = configured custom benchmark file only if it exists; otherwise omit the parameter
4. Run the validation commands exactly as follows:
   - `.\wizard\run-kb-scaffold.ps1 -Validate -OutputRoot $kbRoot -AppName $appName`
   - `.\wizard\run-kb-quality-gate.ps1 -OutputRoot $kbRoot -AppName $appName`
   - `.\wizard\run-kb-semantic-benchmark.ps1 -OutputRoot $kbRoot -AppName $appName`
   - If a valid custom benchmark file exists: `.\wizard\run-kb-semantic-benchmark.ps1 -OutputRoot $kbRoot -AppName $appName -CustomScenarios $customScenariosPath`
5. Spot-check representative evidence sources:
   - `mxcli describe microflow Inspection.ACT_Task_Save -p <app.mpr>`
   - `mxcli describe page Inspection.Dashboard_Home -p <app.mpr>`
   - `mxcli refs Inspection.Dashboard_Home -p <app.mpr>`
   - `mxcli callers Inspection.ACT_Task_Save -p <app.mpr> --transitive`
   - `mxcli show constants Inspection -p <app.mpr>`
6. Compare the generated KB structure with `mendix-data/knowledge-base/` as the contract reference.
7. Confirm the gap ledger captures every unresolved difference.

## Exit Criteria

1. The MxCLI path can produce a composer-consumable full run folder.
2. Composer, scaffold validation, quality gate, and semantic benchmark are green for the generated KB.
3. Remaining mismatches are documented and no data is silently fabricated.
4. Prompt 05 can focus on creator integration rather than extraction-contract repair.

## Design Gate

If the implementation changes the intended extraction contract, pseudo strategy, or composer compatibility model, update the target architecture, capability matrix, and parity gap ledger before closing this prompt. Do not move to Prompt 05 while the design docs and generated outputs disagree.

## Validation Gate

Claude must rerun the verification steps after implementation and explicitly report PASS or FAIL for every acceptance criterion plus an overall PASS or FAIL. If any criterion fails, stop and fix the extraction outputs or log the blocker before proceeding.

## Skill Suggestions

- `testing`
- `documentation`
- Developer and Tester agents
