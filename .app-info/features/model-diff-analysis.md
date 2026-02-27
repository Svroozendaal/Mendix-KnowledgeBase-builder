# Model Dump Diff Analysis (`.mpr`)

## Status

- `DONE`

## Goal

Generate semantic model-level changes for modified Mendix model files (`.mpr`) by comparing working and `HEAD` JSON dumps.

## Current behaviour

1. For each changed `.mpr`, the extension creates a working dump using `mx dump-mpr`.
2. Reconstructs a `HEAD` workspace and dumps the historical `.mpr` snapshot.
3. Compares dumps semantically and outputs `MendixModelChange` records.
4. Adds resource-specific details for entities, associations, flows, pages, and enumerations.
5. Groups changes by module and category for UI and export payloads.

## Implementation references

- `studio-pro-extension-csharp/Processing/Services/AutoCommitMessageChangeService.cs`
- `studio-pro-extension-csharp/Processing/Services/MxToolService.cs`
- `studio-pro-extension-csharp/Processing/ModelDiff/MendixModelDiffService.cs`
- `studio-pro-extension-csharp/Processing/ModelDiff/MendixModelChangeStructurer.cs`
- `studio-pro-extension-csharp/Processing/Formatting/MendixModelChangeDisplayTextFormatter.cs`

## Error and fallback behaviour

- If `mx.exe` is unavailable or dump analysis fails for a file, analysis falls back to a synthetic model-analysis-unavailable entry.
- Known temporary `mprcontents` workspace issues are handled as recoverable to avoid total payload failure.

## Constraints

- Requires compatible Studio Pro installation with `mx.exe dump-mpr` support.
- Runtime cost grows with model size and number of changed model files.

## Improvement opportunities

1. Add targeted unit tests for semantic equality and resource-specific detail builders.
2. Add optional timing metrics for dump creation and comparison phases.
3. Improve cancellation support for long-running diff sessions.
