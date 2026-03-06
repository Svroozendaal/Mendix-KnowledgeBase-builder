# Model Overview Export Pipeline

## Status

- `DONE`

## Summary

Full-model overview pipeline that exports complete application and module-level model inventories from a working `.mpr` dump, including deterministic flow execution ordering.

## Scope

1. Parse a single working dump into a full inventory:
   - domain model (`Entity`, `Association`, `Enumeration`)
   - flows (`Microflow`, `Nanoflow`, `Rule`, `Workflow`)
2. Build flow graphs from `StartEvent` + `SequenceFlow(origin -> destination)`.
3. Detect cross-flow calls (`MicroflowCallAction`, `NanoflowCallAction`).
4. Export AI-readable pseudocode and machine-readable JSON.

## Key files

- `KnowledgeBase-Creator/Mendix-model-overview-parser/src/mendix-model-overview-parser/MendixModelOverviewParser.cs` — the parser
- `KnowledgeBase-Creator/Mendix-model-overview-parser/src/model-overview-cli/Program.cs` — CLI entry point
- `KnowledgeBase-Creator/run-dump-parser.ps1` — central dump+parser launcher
- `.app-info/docs/MODEL_OVERVIEW_EXPORT_CONTRACT.md` — export format contract

## Output contract

- Location: `mendix-data/app-overview/<run-folder>`
- Artefacts:
  - app overview JSON + pseudocode
  - module overview JSON + pseudocode
  - module index + run manifest

## Guardrails

1. Keep output deterministic to support parser/AI downstream usage.
2. Keep artefact naming and folder contracts stable.
