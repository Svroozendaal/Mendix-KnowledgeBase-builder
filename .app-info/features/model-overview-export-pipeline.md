# Model Overview Export Pipeline

## Status

- `DONE`

## Summary

Adds a full-model overview pipeline that exports complete application and module-level model inventories from a working `.mpr` dump, including deterministic flow execution ordering.

## Scope

1. Parse a single working dump into a full inventory:
   - domain model (`Entity`, `Association`, `Enumeration`)
   - flows (`Microflow`, `Nanoflow`, `Rule`, `Workflow`)
2. Build flow graphs from `StartEvent` + `SequenceFlow(origin -> destination)`.
3. Detect cross-flow calls (`MicroflowCallAction`, `NanoflowCallAction`).
4. Export AI-readable pseudocode and machine-readable JSON.
5. Support three trigger modes:
   - app overview
   - module overviews
   - both

## Key files

- `studio-pro-extension-csharp/Processing/ModelDiff/MendixModelOverviewParser.cs`
- `studio-pro-extension-csharp/Processing/Services/AutoCommitMessageModelOverviewService.cs`
- `studio-pro-extension-csharp/UI/Web/AutoCommitMessageWebServerExtension.cs`
- `studio-pro-extension-csharp/UI/Web/AutoCommitMessagePanelHtml.cs`
- `studio-pro-extension-csharp/Docs/MODEL_OVERVIEW_EXPORT_CONTRACT.md`

## Output contract

- Location: `mendix-data/structured/overviews/<run-folder>`
- Artefacts:
  - app overview JSON + pseudocode
  - module overview JSON + pseudocode
  - module index + run manifest

## Guardrails

1. Reuse parser conventions from diff parsing where possible.
2. Do not change behaviour of diff export or diff parser output contracts.
3. Keep output deterministic to support parser/AI downstream usage.
