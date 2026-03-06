# AutoCommitMessage Architecture

## Purpose and scope

`AutoCommitMessage` is a Mendix Studio Pro 10 extension that inspects local uncommitted Mendix changes, derives semantic model deltas, and stores deterministic artefacts for downstream automation.

Current implementation scope:

- Uncommitted Git analysis for `*.mpr` and `*.mprops`.
- Semantic diffing for changed `*.mpr` files via `mx dump-mpr`.
- In-pane model-change review grouped by module and category.
- Raw-change JSON export (`schemaVersion: 1.0`).
- Full model-overview export from committed (`HEAD`) model state.
- Commit-message text persistence endpoint for downstream workflows.

Out of scope:

- Full Git client operations (history, push/pull, merge/rebase).
- Remote API calls or hosted processing.
- Direct Git commit execution from extension runtime.

## Runtime component map

| Layer | Component | File | Responsibility |
|---|---|---|---|
| Studio Pro UI | Dockable pane extension | `UI/DockablePane/AutoCommitMessageDockablePaneExtension.cs` | Registers pane and builds route URL |
| Studio Pro UI | Pane view model | `UI/DockablePane/AutoCommitMessageDockablePaneViewModel.cs` | Binds pane title and initial web address |
| Studio Pro UI | Menu extension | `UI/Menu/AutoCommitMessageMenuExtension.cs` | Exposes open/close menu commands |
| Web route | Route handler | `UI/Web/AutoCommitMessageWebServerExtension.cs` | Handles HTML, refresh, export, overview, and commit-message endpoints |
| Web route | Embedded UI | `UI/Web/AutoCommitMessagePanelHtml.cs` | Renders model changes, model overview, settings, and commit-message compose UI |
| Processing | Change analysis | `Processing/Services/AutoCommitMessageChangeService.cs` | Reads Git status/diff and `.mpr` model changes |
| Processing | Raw-change export | `Processing/Services/AutoCommitMessageExportService.cs` | Writes deterministic raw-change JSON |
| Processing | Model overview export | `Processing/Services/AutoCommitMessageModelOverviewService.cs` | Builds app/module overviews from committed dumps |
| Processing | Commit-message storage | `Processing/Services/AutoCommitMessageCommitMessageStoreService.cs` | Persists supplied commit-message text to disk |
| Processing | `mx.exe` execution | `Processing/Services/MxToolService.cs` | Finds compatible `mx.exe` and runs `dump-mpr` |
| Processing | Diff engine | `Processing/ModelDiff/MendixModelDiffService.cs` | Computes semantic resource-level model changes |
| Processing | Overview parser | `Processing/ModelDiff/MendixModelOverviewParser.cs` | Builds full model inventory and pseudocode from a dump |
| Processing | Grouping | `Processing/ModelDiff/MendixModelChangeStructurer.cs` | Groups model changes by module/category |
| Processing | Display formatter | `Processing/Formatting/MendixModelChangeDisplayTextFormatter.cs` | Produces deterministic `displayText` strings |
| Processing | Installation detection | `Processing/Services/MendixInstallationDetectorService.cs` | Auto-detects correct mx.exe for a given .mpr file |
| Processing | Configuration service | `Processing/Services/ExtensionConfigurationService.cs` | Stores detection result and install-root override state |
| Processing | Commit message store | `Processing/Services/AutoCommitMessageCommitMessageStoreService.cs` | Stores commit messages with deterministic naming and git hash header |
| Processing | Commit message history | `Processing/Services/AutoCommitMessageHistoryService.cs` | Lists and reads stored commit messages with path traversal guards |

## Mendix Installation Detection

The extension automatically detects and uses the correct `mx.exe` installation for each project without requiring manual configuration.

### Detection algorithm

Detection runs once at pane startup and follows three steps:

**Step 1 — Determine required version:**
- Scans the Mendix installations root (default: `C:\Program Files\Mendix\`) for any available `mx.exe`.
- Runs `mx.exe show-version <mprFilePath>` on the first found to determine the Mendix version required by the project.

**Step 2 — Find matching installation:**
- Searches for `<installRoot>\<requiredVersion>\modeler\mx.exe` (exact version match).
- Returns this path if found.

**Step 3 — Fallback to major.minor match:**
- If no exact match exists, searches for `<installRoot>\<majorMinor>.x\modeler\mx.exe` (e.g., `10.24.x`).
- Logs a warning if fallback matching is used.
- Fails with a user-facing error if no match is found.

### Installation root resolution

Installation root is resolved in this order:

1. Manual override from Settings UI (stored as `mendixInstallRoot` in localStorage).
2. Environment variable `MENDIX_INSTALL_ROOT`.
3. Default: `C:\Program Files\Mendix`.

### Integration points

- **Startup detection:** `AutoCommitMessageDockablePaneExtension.Open()` runs detection once per pane load.
- **Configuration storage:** Detection result and manual override are stored in `ExtensionConfigurationService`.
- **MxToolService fallback:** `MxToolService.FindMxExe()` first checks the detection result; falls back to legacy detection if not available.
- **Settings UI:** Displays detected version and path, with a "Re-detect" button and manual override input.
- **API endpoint:** `GET /autocommitmessage/api/detection?override=<path>` re-runs detection with optional override.

### Settings panel

The **Mendix Installation** section in Settings displays:

- **Detected version:** The version string from `show-version`.
- **mx.exe path:** The full path to the detected (or fallback) `mx.exe`.
- **Status indicator:**
  - Green (✓) if exact match found.
  - Amber (⚠) if fallback major.minor match used.
  - Red (✗) with failure reason if detection failed.
- **Manual override input:** Allows user to specify an alternative Mendix installations folder.
- **Re-detect button:** Triggers detection with the current override and updates the status display.

### Failure handling

If detection fails:

- Status shows red indicator with failure reason.
- Refresh and Export actions remain available (fallback to legacy mx.exe detection).
- User can provide a manual override path and click "Re-detect".
- No blocking modals are shown; detection failure is non-fatal.

### Environment variable

Previously, the extension relied on development-time `.env` values for Mendix path/version. This dependency has been replaced by auto-detection. The `.env` file is not deleted; any Mendix configuration keys in it are now ignored.

## Commit Message Storage and History

The extension stores commit messages with deterministic filenames and git commit metadata, enabling history tracking and re-use.

### Storage Format

**Filename pattern:**
```
<storyId>_<signature>_<yyyyMMdd>.txt
```

- `storyId` and `signature` are sanitized to `[A-Za-z0-9_-]` only.
- Empty `storyId` is retained as empty segment (e.g., `_JD_20260228.txt`).
- Date uses local system time.

**File content:**
```
#commit:<shortCommitHash>

<message body>
```

- `#commit:` header is required and contains first 8 chars of HEAD SHA.
- Header is stripped in history view/copy output.

### Collision Strategy

For same date/storyId/signature:
1. If file doesn't exist: create it.
2. If exists:
   - Read first-line hash.
   - If hash matches current HEAD: overwrite same file.
   - If differs: try `_2`, `_3`, ... suffixes until free slot or matching hash found.

### History View

Accessible via History tab (extended mode only):
- **List panel:** Shows stored messages by date (newest first), with date/story/signature/filename columns.
- **Detail panel:** Lazy-loads message content on row click, strips `#commit:` header.
- **Copy button:** Copies detail content (without header) to clipboard.
- **Path guard:** `read-commit-message` validates file path remains within commit messages folder.

### Integration Points

- **Store endpoint:** `POST /store-commit-message` with `storyId`, `signature` query params; resolves git hash server-side.
- **List endpoint:** `GET /list-commit-messages` returns metadata (filename, story, signature, date, path).
- **Read endpoint:** `GET /read-commit-message?filePath=<path>` returns content with header stripped.
- **Settings UI:** Toggle `Save commit messages to disk` and configure base path (extended mode only).

## Web actions and endpoints

Route prefix: `autocommitmessage/`

| Action query value | Method | Behaviour |
|---|---|---|
| _(none)_ | `GET` | Returns embedded HTML shell |
| `refresh` | `GET` | Returns latest `AutoCommitMessagePayload` |
| `export` | `POST` | Stores selected outputs (raw changes, dumps, overview structured/pseudocode) |
| `list-overview-modules` | `GET` | Lists modules from committed dump inventory |
| `generate-overview-app` | `GET` | Generates app overview artefacts |
| `generate-overview-modules` | `GET` | Generates module overview artefacts for selected modules |
| `generate-overview-module` | `GET` | Generates module overview using `module` or `modules` query selection |
| `generate-overview-both` / `generate-overview` | `GET` | Generates app and module overview artefacts |
| `store-commit-message` | `POST` | Stores commit message with deterministic filename and git hash header |
| `list-commit-messages` | `GET` | Lists stored commit messages from history folder |
| `read-commit-message` | `GET` | Reads content of specific commit message file |
| `/api/detection` | `GET` | Runs Mendix installation detection with optional `override=<path>` parameter |

Important query keys include:

- `projectPath`
- `dataRootBasePath`
- `commitMessagesBasePath`
- `persistDumps`
- `persistRawChanges`
- `persistOverviewStructured`
- `persistOverviewPseudocode`
- `module`
- `modules` (comma-separated)

## Request lifecycles

### Pane load

1. Pane extension builds URL with cache-buster `_v` and optional `projectPath`.
2. Web route returns HTML UI shell.
3. UI waits for explicit `Refresh` to load analysis payload.

### Refresh

1. UI calls `?action=refresh`.
2. `AutoCommitMessageChangeService.ReadChanges(...)` runs status/diff/model analysis.
3. JSON payload returns branch + filtered file changes + grouped model deltas.
4. Refresh does not trigger overview module-list loading; overview requests are user-initiated.

### Export

1. UI calls `POST ?action=export` with persistence toggles.
2. Route validates output selection and repository state.
3. If `persistRawChanges=true`, raw-change export JSON is written.
4. If `persistDumps=true`, per-file `working/head` dump artefacts are persisted during analysis.
5. If overview output flags are enabled, app overview artefacts are generated.
6. Response returns success, output paths, and folders.

### Overview module list and generation

1. UI loads module list via `?action=list-overview-modules` when the overview view needs it.
2. Service reconstructs committed `.mpr` snapshots, dumps with `mx.exe`, and extracts module references.
3. User selects modules and requests `?action=generate-overview-modules&modules=A,B,...`.
4. Service creates run folder and writes JSON/pseudocode artefacts plus manifest.

### Commit-message storage

1. Client submits `POST ?action=store-commit-message` with JSON body `{ "message": "..." }`.
2. Store service sanitises file token from first line and writes UTF-8 text atomically.
3. Response returns output file and folder path.

## Data root resolution and storage

`ExtensionDataPaths.ResolveDataRoot(projectPath, dataRootBasePath)` resolves in this order:

1. Explicit `dataRootBasePath` query (normalised to `<base>/mendix-data` if needed).
2. Build-configured root from environment variable `MENDIX_GIT_DATA_ROOT`.
3. Build-configured root from assembly metadata key `MendixDataRoot`.
4. Fallback `<projectPath>/mendix-data`.

Primary runtime folders:

- `raw-changes` (raw change exports)
- `processed` (reserved downstream)
- `errors` (reserved downstream)
- `app-overview` (overview artefacts)
- `dumps` (persisted dump artefacts)

Commit-message storage folder:

- `<commitMessagesBasePath or resolved base>/Commit messages`

## Error handling strategy

- Non-Git projects return `IsGitRepo=false` with non-crashing payloads.
- `.mpr` model-analysis failures degrade to synthetic ?Model Analysis unavailable? rows instead of failing all changes.
- Known `mx.exe` environment issues (`mprcontents`, workspace mismatch) are treated as recoverable for individual files.
- Export/overview/store routes return structured JSON error responses with status `400` or `500`.
- File writes use temporary files plus atomic move where applicable.

## Security and trust boundaries

- All operations run locally in Studio Pro extension context.
- No outbound network calls are made by this extension runtime.
- Export responses include local filesystem paths; treat as sensitive in shared environments.
- `store-commit-message` writes user-provided text to disk; caller controls path through configured base folder.

## Performance notes

- Status and diff scans are filtered to Mendix-relevant extensions.
- `.mpr` diffing requires two dumps per changed model file.
- Overview generation parses committed model dumps and can be expensive for large models.
- `mx.exe` execution is timeout-guarded.

## Known limitations

- No cancellation propagation into deep diff/overview parsing loops.
- Limited telemetry for timing and artefact size analysis.
- Some resources still rely on generic detail summaries rather than dedicated semantic parsers.
- Commit-message storage endpoint exists server-side; current embedded UI primarily supports copy-to-clipboard composition.

## CLI test harness (`model-overview-cli`)

A separate .NET 8.0 console project provides a standalone test harness for the model overview pipeline. It exists purely for development iteration — the extension remains the production entry point.

### Architecture

- **Project:** `model-overview-cli/ModelOverviewCli.csproj`
- **References:** `AutoCommitMessage.csproj` via `<ProjectReference>`
- **Access:** Extension exposes internals via `InternalsVisibleTo("ModelOverviewCli")`
- **No code duplication:** The CLI calls `MendixModelOverviewParser.ParseDump()` and `.BuildModulePseudocode()` directly from the extension project

### What it does

- Reads a pre-existing dump JSON file (from `mendix-data/dumps/`)
- Lists available modules (`--list-modules`)
- Generates app and module overview artefacts (JSON + pseudocode) identical to extension output
- Writes to `mendix-data/app-overview/`

### Launcher

`KnowledgeBase-Creator/run-dump-parser.ps1` is the current launcher for dump + parser export + KB scaffold seeding.

### Visibility changes to the extension

- `InternalsVisibleTo("ModelOverviewCli")` added to `AutoCommitMessage.csproj`
- `ModuleOverviewExport` record changed from `private` to `internal` in `AutoCommitMessageModelOverviewService.cs`

These changes have no effect on extension runtime behaviour.

## Related documents

- `PROCESSING_PIPELINE.md`
- `EXPORT_CONTRACT.md`
- `MODEL_OVERVIEW_EXPORT_CONTRACT.md`
- `REPOSITORY_WORKFLOWS.md`
- `OPEN_QUESTIONS.md`
