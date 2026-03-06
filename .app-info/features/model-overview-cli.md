# Model Overview CLI

## Status

- `DONE`

## Summary

Standalone console tool for model overview generation from `mx dump-mpr` output. Calls the parser library directly. Enables rapid iteration on parser and pseudocode formatting.

## Key files

- `KnowledgeBase-Creator/Mendix-model-overview-parser/src/mendix-model-overview-parser/MendixModelOverviewParser.csproj` — parser library
- `KnowledgeBase-Creator/Mendix-model-overview-parser/src/model-overview-cli/ModelOverviewCli.csproj` — .NET 8.0 console project referencing the parser
- `KnowledgeBase-Creator/Mendix-model-overview-parser/src/model-overview-cli/Program.cs` — CLI entry point
- `KnowledgeBase-Creator/run-dump-parser.ps1` — central PowerShell launcher

## Capabilities

1. List modules from a dump JSON file (`--list-modules`).
2. Generate app and module overview artefacts (JSON + pseudocode).
3. Interactive dump selection and module multi-select via PowerShell launcher.
4. Direct parameter mode for scripting: `-DumpPath`, `-Modules`, `-OutputPath`, `-SkipBuild`.

## Output contract

See `.app-info/docs/MODEL_OVERVIEW_EXPORT_CONTRACT.md`.

## Guardrails

1. No parser code is duplicated; changes to the parser library are automatically picked up on rebuild.
2. Output artefacts write to `mendix-data/app-overview/` using the same folder conventions.
