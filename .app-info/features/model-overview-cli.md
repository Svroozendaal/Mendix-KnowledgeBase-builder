# Model Overview CLI Test Harness

## Status

- `DONE`

## Summary

Standalone console test harness for model overview generation from pre-existing dump files. Calls the extension's parser directly — no code duplication. Enables rapid iteration on parser and pseudocode formatting without opening Mendix Studio Pro.

## Key files

- `model-overview-cli/ModelOverviewCli.csproj` — .NET 8.0 console project referencing the extension
- `model-overview-cli/Program.cs` — CLI entry point
- `run-model-overview.ps1` — interactive PowerShell launcher

## Extension changes

- `studio-pro-extension-csharp/AutoCommitMessage.csproj` — `InternalsVisibleTo("ModelOverviewCli")` added
- `studio-pro-extension-csharp/Processing/Services/AutoCommitMessageModelOverviewService.cs` — `ModuleOverviewExport` changed from `private` to `internal`

## Capabilities

1. List modules from a dump JSON file (`--list-modules`).
2. Generate app and module overview artefacts (JSON + pseudocode) identical to extension output.
3. Interactive dump selection and module multi-select via PowerShell launcher.
4. Direct parameter mode for scripting: `-DumpPath`, `-Modules`, `-OutputPath`, `-SkipBuild`.

## Output contract

Identical to the extension's model overview pipeline. See `studio-pro-extension-csharp/Docs/MODEL_OVERVIEW_EXPORT_CONTRACT.md`.

## Guardrails

1. CLI is a test harness only — the extension remains the production entry point.
2. No parser code is duplicated; changes to the extension's parser are automatically picked up on rebuild.
3. Output artefacts write to `mendix-data/app-overview/` using the same folder conventions.
