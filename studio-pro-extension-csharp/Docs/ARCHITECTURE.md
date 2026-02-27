# AutoCommitMessage Architecture

## Purpose and scope

The extension provides a Studio Pro dockable pane for analysing uncommitted Mendix changes and exporting structured change data for downstream processing.

Current implementation scope:

- Uncommitted Git changes for `*.mpr` and `*.mprops`.
- Model-level analysis for changed `*.mpr` files via `mx.exe dump-mpr`.
- Module-grouped UI presentation of model changes.
- JSON export with deterministic file naming and persisted dump artefacts.

Out of scope in current implementation:

- Full Git client replacement.
- Commit creation or push/pull actions.
- Cloud-hosted services or remote APIs.

## Runtime component map

| Layer | Component | File | Responsibility |
|---|---|---|---|
| Studio Pro UI | Dockable pane registration | `UI/DockablePane/AutoCommitMessageDockablePaneExtension.cs` | Registers pane and builds web route URL |
| Studio Pro UI | WebView pane view model | `UI/DockablePane/AutoCommitMessageDockablePaneViewModel.cs` | Sets pane title and initial URL |
| Studio Pro UI | Menu extension | `UI/Menu/AutoCommitMessageMenuExtension.cs` | Open/close commands for pane |
| Web route | Extension HTTP handler | `UI/Web/AutoCommitMessageWebServerExtension.cs` | Handles default, `refresh`, and `export` actions |
| Web route | Embedded UI HTML/JS/CSS | `UI/Web/AutoCommitMessagePanelHtml.cs` | Renders payload and handles client actions |
| Processing | Git + model analysis service | `Processing/Services/AutoCommitMessageChangeService.cs` | Reads status, patch, model changes |
| Processing | Export service | `Processing/Services/AutoCommitMessageExportService.cs` | Builds and writes JSON export |
| Processing | `mx.exe` discovery/execution | `Processing/Services/MxToolService.cs` | Finds compatible Studio Pro tool and runs `dump-mpr` |
| Processing | Dump diff engine | `Processing/ModelDiff/MendixModelDiffService.cs` | Produces semantic model changes |
| Processing | Model change grouping | `Processing/ModelDiff/MendixModelChangeStructurer.cs` | Groups changes by module and category |
| Processing | Display text formatter | `Processing/Formatting/MendixModelChangeDisplayTextFormatter.cs` | Produces deterministic row text |

## Request lifecycle

### Pane open

1. Studio Pro opens pane through `AutoCommitMessageDockablePaneExtension`.
2. Pane URL is built under route prefix `autocommitmessage/` with cache-buster `_v` and optional `projectPath`.
3. `AutoCommitMessageWebServerExtension` default route reads changes and returns HTML.
4. `AutoCommitMessagePanelHtml` renders current payload.

### Refresh

1. UI issues `GET ?action=refresh&projectPath=...`.
2. Web handler calls `AutoCommitMessageChangeService.ReadChanges(projectPath)`.
3. JSON payload is returned.
4. UI re-renders file table, grouped model changes, and selected diff.

### Export

1. UI issues `POST ?action=export&projectPath=...`.
2. Web handler calls `ReadChanges(projectPath, persistModelDumps: true)`.
3. Handler validates Git state, payload errors, and non-empty changes.
4. `AutoCommitMessageExportService.ExportChanges(...)` writes export JSON.
5. Response returns success, output path, and change count.

## Data flow and storage

### Inputs

- Current Studio Pro project path.
- Local Git repository state through `LibGit2Sharp`.
- Current working `*.mpr` file and reconstructed `HEAD` `*.mpr` snapshot.

### Intermediate artefacts

- Temporary dump JSON files in `%TEMP%`.
- Temporary reconstructed `HEAD` workspace for `mprcontents` consistency.

### Persistent outputs

Data root folders:

- `exports` (primary JSON payloads)
- `processed` (reserved for downstream pipeline)
- `errors` (reserved for downstream pipeline)
- `structured` (reserved for downstream pipeline)
- `dumps` (optional persisted `working/head` dump snapshots during export)

## Data root resolution priority

`ExtensionDataPaths` resolves the data root using:

1. Environment variable `MENDIX_GIT_DATA_ROOT`.
2. Assembly metadata key `MendixDataRoot` (set at build/deploy).
3. Fallback `%LocalAppData%\MendixAutoCommitMessage\mendix-data`.

This allows both local development and deployed app instances to keep consistent export locations.

## Error handling strategy

- Non-Git projects return explicit non-error state (`IsGitRepo = false`).
- Change analysis catches model-analysis failures per file and returns a synthetic "Model Analysis" entry instead of failing the full payload.
- `mx.exe` environment inconsistencies (such as `mprcontents` mismatch) are treated as recoverable for model diffing paths.
- Export writes to a temporary file first and then moves atomically to destination to reduce partial-file risks.

## Security and trust boundaries

- All logic runs local to Studio Pro extension context.
- No outbound network calls are made by the extension runtime.
- Export responses include filesystem paths; these are local and intended for developer tooling only.
- Route handlers are internal Studio Pro extension routes, but still treated as sensitive due to export side effects.

## Performance notes

- Diff and status retrieval are limited to `*.mpr` and `*.mprops`.
- Model dump generation occurs only for changed `*.mpr` files.
- `mx.exe` processes are timeout-guarded.
- Large model dumps can still be costly; refresh performance depends on project size and number of changed models.

## Known limitations in current implementation

- No cancellation token propagation into deep model-diff loops.
- Limited telemetry and no structured diagnostic log stream.
- No built-in retention/cleanup policy for persistent export and dump folders.
- No automated schema file published for export payload consumers.

## Related documents

- `PROCESSING_PIPELINE.md`
- `EXPORT_CONTRACT.md`
- `REPOSITORY_WORKFLOWS.md`
- `OPEN_QUESTIONS.md`
