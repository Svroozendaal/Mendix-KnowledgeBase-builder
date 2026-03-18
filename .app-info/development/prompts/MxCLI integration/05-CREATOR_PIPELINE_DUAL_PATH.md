# PROMPT 05: Creator Pipeline Dual Path

## Priority

High - this prompt integrates the new extractor into the creator package while keeping the legacy route available and still default.

## Depends On

- `04-FLOW_PAGE_RESOURCE_AND_DETAIL_OUTPUTS.md`

## Context

Read before starting:

1. `.agents/AGENTS.md`
2. `.agents/FRAMEWORK.md`
3. `.app-info/development/prompts/MxCLI integration/INDEX.md`
4. `.app-info/docs/MXCLI_KB_CREATOR_TARGET_ARCHITECTURE.md`
5. `.app-info/docs/MXCLI_COMMAND_CAPABILITY_MATRIX.md`
6. `.app-info/docs/MXCLI_PARITY_GAP_LEDGER.md`
7. `KnowledgeBase-Creator/README.md`
8. `KnowledgeBase-Creator/AGENTS.md`
9. `KnowledgeBase-Creator/wizard/README.md`
10. `KnowledgeBase-Creator/wizard/run-dump-parser.ps1`
11. `KnowledgeBase-Creator/wizard/run-initkb.ps1`
12. `KnowledgeBase-Creator/wizard/src/KnowledgeBaseCreator.Wizard/`

If any workflow or implementation ambiguity remains after reading the context, ask clarifying questions before changing files. If not, state that no workflow questions remain and continue.

## Problem Statement

The extraction path is now viable, but users still need the creator package to expose it safely. This prompt adds a dual-path integration so the creator can run either the legacy dump/parser flow or the new `mxcli` flow, without changing the default extraction path yet.

## Entry Criteria

1. Prompt 04 is complete and its validation gate passed.
2. The new MxCLI extraction path can generate a validated KB end to end.
3. The parity gap ledger does not contain any blocker that prevents dual-path exposure.

## Deliverable

Integrate the MxCLI extractor into the creator package as a selectable dual path.

The deliverable must include:

1. a clear extraction-mode contract for scripts and wizard UI,
2. PATH-only `mxcli` detection and diagnostics,
3. dual-path logging so users can see which extractor ran,
4. unchanged output locations and validation flow, and
5. preserved legacy default behaviour.

Implementation rules:

- Use this exact extraction-mode contract:
  - PowerShell scripts expose `-ExtractionMode LegacyDumpParser|MxCli`.
  - Process environment and `.env` expose `KB_EXTRACTION_MODE=LegacyDumpParser|MxCli`.
  - Wizard UI label: `Extraction mode`.
  - Wizard persisted config key in `config.last.json`: `LastExtractionMode`.
  - Prompt 05 default: `LegacyDumpParser`.
  - Prompt 06 default switch target: `MxCli`.
- Keep the legacy dump/parser path available and default.
- Do not bundle `mxcli`; detect it from `PATH` only.
- Do not require changes in the external `mxcli` repo.
- Reuse the same run-folder and KB-validation pipeline after extraction.
- When `ExtractionMode = LegacyDumpParser`, keep the existing `mx.exe` path workflow active.
- When `ExtractionMode = MxCli`, validate `mxcli --version` from `PATH`, do not require an `mx.exe` path, and hide or disable any mandatory `mx.exe` validation for that path.

## Acceptance Criteria

1. The creator scripts and wizard expose both extraction paths without creating a second incompatible workflow.
2. `mxcli` is resolved from `PATH` only and failures are reported clearly.
3. The active extraction mode is visible in logs or UI so operators can validate which path ran.
4. The legacy dump/parser path still works and remains the default after this prompt.
5. The MxCLI path can be selected and completes the same downstream compose and validation flow.
6. Prompt 06 can switch the default without redesigning the public creator workflow.

## Verification Steps

1. Run the creator pipeline through the legacy path and confirm it still works.
2. Run the creator pipeline through the new path with the exact override `-ExtractionMode MxCli` or `KB_EXTRACTION_MODE=MxCli` and confirm it still produces the expected run folder and KB output.
3. Confirm the wizard persists `LastExtractionMode` and reports the chosen mode in logs or UI.
4. Confirm `mxcli` missing-from-PATH behaviour is surfaced as a clean, actionable error only for the `MxCli` mode.
5. Confirm output locations, compose flow, quality gate, and benchmark behaviour are unchanged after extraction completes.

## Exit Criteria

1. The creator package has a working dual-path extraction model.
2. The legacy path is still the default.
3. The MxCLI path is operational and validated.
4. Prompt 06 can focus on the default switch and documentation updates.

## Design Gate

If implementation changes the creator workflow, configuration contract, or extraction-mode behaviour, update the target architecture, capability matrix, and parity gap ledger before closing this prompt. Do not move to Prompt 06 while the design docs and creator behaviour disagree.

## Validation Gate

Claude must rerun the verification steps after implementation and explicitly report PASS or FAIL for every acceptance criterion plus an overall PASS or FAIL. If any criterion fails, stop and fix the dual-path integration or log the blocker before proceeding.

## Skill Suggestions

- `testing`
- `documentation`
- Developer, Tester, and Documenter agents
