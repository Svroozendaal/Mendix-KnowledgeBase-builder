# info_processing

## Purpose

- Encapsulates all non-UI logic for collecting, structuring, and exporting Mendix change data.
- Separates deterministic formatting logic from model-diff extraction logic.
- Provides stable contracts consumed by the UI and export pipeline.

## Files and responsibilities

### Core

| File | Responsibility |
|---|---|
| `Processing/Core/ExtensionConstants.cs` | Shared pane IDs, labels, route/action constants |
| `Processing/Core/ExtensionDataPaths.cs` | Runtime/build-time data-root resolution and folder paths |

### Contracts

| File | Responsibility |
|---|---|
| `Processing/Contracts/AutoCommitMessagePayload.cs` | Payload contracts for file changes, grouped model changes, and dump artifacts |
| `Processing/Contracts/MendixModelChange.cs` | Atomic model-change record and computed `DisplayText` property |

### Services

| File | Responsibility |
|---|---|
| `Processing/Services/AutoCommitMessageChangeService.cs` | Reads repository status/diff and coordinates model analysis |
| `Processing/Services/AutoCommitMessageExportService.cs` | Builds export payload and writes JSON to disk |
| `Processing/Services/MxToolService.cs` | Locates and executes `mx.exe dump-mpr` |

### ModelDiff

| File | Responsibility |
|---|---|
| `Processing/ModelDiff/MendixModelDiffService.cs` | Semantic diff between working/head model dumps |
| `Processing/ModelDiff/MendixModelChangeStructurer.cs` | Groups model changes by module and category |

### Formatting

| File | Responsibility |
|---|---|
| `Processing/Formatting/MendixModelChangeDisplayTextFormatter.cs` | Deterministic converter-rule formatting for `displayText` |

## Public entry points

- `AutoCommitMessageChangeService.ReadChanges(...)`
- `AutoCommitMessageExportService.ExportChanges(...)`
- `MxToolService.FindMxExe()`
- `MxToolService.DumpMpr(...)`

## Data and storage touched

- Local Git repository metadata and patches via `LibGit2Sharp`.
- Temporary files under `%TEMP%` for dump snapshots.
- Export/dump outputs under resolved data root:
  - `exports`
  - `processed`
  - `errors`
  - `structured`
  - `dumps`

## Dependencies

- `LibGit2Sharp`
- `Mendix.StudioPro.ExtensionsAPI`
- `mx.exe` from Studio Pro installation
- `System.Text.Json`

## Operational notes

- `mx.exe` execution and dump file handling are high-impact paths; failures are handled with guarded fallbacks.
- Export path generation is deterministic and writes a temporary file first, then atomically moves to final destination.
- `displayText` is generated at export time using converter rules before JSON serialization.
