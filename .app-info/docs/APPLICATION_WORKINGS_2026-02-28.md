# Application Workings (28 February 2026)

## Scope

This document describes the current end-to-end behaviour of the `AutoCommitMessage` extension based on:

- `.agents/AGENTS.md`
- `.app-info/*`
- `studio-pro-extension-csharp/*` source code and technical docs

The goal is to provide a complete technical map of how the application currently works at runtime.

## Product role

`AutoCommitMessage` is a Mendix Studio Pro 10 extension that turns local model changes into deterministic, structured outputs for downstream commit intelligence.

Primary jobs:

1. Detect local uncommitted Mendix changes (`.mpr`, `.mprops`).
2. Convert binary `.mpr` diffs into semantic model-change records.
3. Present grouped model changes in an in-IDE dockable pane.
4. Export raw-change JSON and model-overview artefacts for external processing.

## Runtime architecture

## UI layer

- Dockable pane registration: `UI/DockablePane/AutoCommitMessageDockablePaneExtension.cs`
- Pane view model: `UI/DockablePane/AutoCommitMessageDockablePaneViewModel.cs`
- Open/close menu integration: `UI/Menu/AutoCommitMessageMenuExtension.cs`
- Embedded web UI (HTML/CSS/JS in C# string): `UI/Web/AutoCommitMessagePanelHtml.cs`

## Route layer

- Web route host: `UI/Web/AutoCommitMessageWebServerExtension.cs`
- Route prefix: `autocommitmessage/`
- Supported actions:
  - `refresh`
  - `export`
  - `list-overview-modules`
  - `generate-overview-app`
  - `generate-overview-modules`
  - `generate-overview-module`
  - `generate-overview-both` / `generate-overview`
  - `store-commit-message`

## Processing layer

- Change analysis orchestrator: `Processing/Services/AutoCommitMessageChangeService.cs`
- Raw-change export writer: `Processing/Services/AutoCommitMessageExportService.cs`
- Overview export orchestrator: `Processing/Services/AutoCommitMessageModelOverviewService.cs`
- Commit-message file writer: `Processing/Services/AutoCommitMessageCommitMessageStoreService.cs`
- Mendix CLI integration: `Processing/Services/MxToolService.cs`
- Diff engine: `Processing/ModelDiff/MendixModelDiffService.cs`
- Module/category grouping: `Processing/ModelDiff/MendixModelChangeStructurer.cs`
- Full inventory parser: `Processing/ModelDiff/MendixModelOverviewParser.cs`
- Deterministic display formatting: `Processing/Formatting/MendixModelChangeDisplayTextFormatter.cs`

## Data model and storage

## Data root resolution

Runtime paths resolve from `ExtensionDataPaths` using:

1. request query `dataRootBasePath` (normalised to `<base>/mendix-data`)
2. environment variable `MENDIX_GIT_DATA_ROOT`
3. assembly metadata `MendixDataRoot`
4. fallback `<projectPath>/mendix-data`

## Runtime folders

Under resolved `mendix-data`:

- `raw-changes`
- `processed`
- `errors`
- `app-overview`
- `dumps`

Commit-message text folder:

- `<commitMessagesBasePath or resolved base>/Commit messages`

## Important note

Deployment scripts still pre-create legacy `exports` / `structured` folders for compatibility, while current runtime services write to `raw-changes` / `app-overview`.

## End-to-end behaviour

## 1) Pane open and initial load

1. Dockable pane URL includes `projectPath` and cache-buster `_v`.
2. Default route returns HTML shell.
3. UI starts with ?Press Refresh to load change analysis.?

## 2) Refresh flow (`action=refresh`)

1. UI calls route with current settings-derived query values.
2. `ReadChanges(...)` discovers repository and filters status/patch to `*.mpr` and `*.mprops`.
3. Each changed `.mpr` is analysed via working and committed dumps.
4. UI receives `AutoCommitMessagePayload` with grouped model changes.
5. UI renders:
   - model-change groups by module/category
   - changed-file table
   - diff text pane
6. Refresh no longer auto-loads overview modules; overview requests are on demand from the overview view.

## 3) `.mpr` semantic diff flow

For each changed `.mpr`:

1. Dump working model to temporary JSON.
2. Reconstruct committed (`HEAD`) `.mpr` into temporary workspace.
3. Dump committed model to temporary JSON.
4. Compare dumps in `MendixModelDiffService`.
5. Produce `MendixModelChange` rows with resource-specific details.
6. Group rows via `MendixModelChangeStructurer`.

Details include:

- entity attributes and system-member flags
- associations and cardinality summaries
- flow action/loop/decision deltas
- page roles/layout/action bindings/widget summaries
- generic property diffs for uncovered types

## 4) Export flow (`action=export`)

The export route supports output toggles:

- `persistRawChanges`
- `persistDumps`
- `persistOverviewStructured`
- `persistOverviewPseudocode`

Behaviour:

1. Validates at least one output is enabled.
2. Reads latest payload (optionally persisting dumps).
3. Writes raw-change JSON when requested.
4. Generates app overview artefacts when overview output is requested.
5. Returns paths and folder metadata in JSON response.

## 5) Model overview flow

### Via extension (production)

Module list:

1. UI calls `list-overview-modules`.
2. Service scans committed `.mpr` files and extracts `Projects$Module` references.
3. Modules are classified as `System`, `Marketplace`, or `Custom`.

Generation:

1. User selects modules in UI.
2. UI calls `generate-overview-modules&modules=A,B,...`.
3. Service generates selected module overviews from committed dump state.
4. Output includes JSON, pseudocode, module index, and manifest.

### Via CLI test harness (development)

1. Developer runs `.\run-model-overview.ps1` or invokes `model-overview-cli` directly.
2. CLI reads a pre-existing dump JSON file (from `mendix-data/dumps/`).
3. CLI calls `MendixModelOverviewParser.ParseDump()` from the extension project (same code, no duplication).
4. Output is identical: JSON, pseudocode, module index, and manifest in `mendix-data/app-overview/`.

This enables rapid parser iteration without opening Studio Pro.

## 6) Commit-message composition

Current UI flow:

1. User clicks `Create message`.
2. UI opens compose modal with story ID, signature, comments, and generated change block.
3. UI copies composed text to clipboard.

Server capability:

- `store-commit-message` endpoint can persist provided message text, but current embedded UI does not yet invoke this endpoint by default.

## UI features and state

The embedded UI has three views:

1. `Model changes`
2. `Model overview`
3. `Settings`

Persisted client settings (localStorage):

- theme (`dark`/`light`)
- data-root base path
- signature
- output toggles (dumps/raw/overview structured/overview pseudocode)
- commit-message base path and store flag

## Contracts and core records

## Change payload

`AutoCommitMessagePayload`:

- `IsGitRepo`
- `BranchName`
- `Changes[]`
- `Error`

`Changes[]` includes:

- `FilePath`
- `Status`
- `IsStaged`
- `DiffText`
- `ModelChanges`
- `ModelChangesByModule`
- `ModelDumpArtifact`

## Raw-change export

- schema version: `1.0`
- output folder: `raw-changes`
- module-grouped model changes and deterministic `displayText`

## Overview export

- inventory-based, committed-model scope
- output root: `app-overview/overviews/<run-folder>`
- app-level and/or module-level JSON + pseudocode

## Dependencies and prerequisites

- `LibGit2Sharp` for repository interrogation.
- `Mendix.StudioPro.ExtensionsAPI` for extension integration.
- `mx.exe` with `dump-mpr` support.
- .NET target framework `net8.0-windows`.

## Current constraints and hotspots

1. Large-model diff and overview runs can be slow.
2. Cancellation is limited in deep parsing loops.
3. Parser coverage for some Mendix resource types is still generic.
4. Folder naming drift exists between runtime services and deployment script pre-created folders.
5. Commit-message storage endpoint exists, but UI integration is partial.

## CLI test harness layer

- CLI project: `model-overview-cli/ModelOverviewCli.csproj`
- CLI entry point: `model-overview-cli/Program.cs`
- Interactive launcher: `run-model-overview.ps1`
- Reuses extension's `MendixModelOverviewParser` via `InternalsVisibleTo` — same code, no duplication
- Output contracts identical to extension overview pipeline

## Operational workflow summary

### Extension workflow (production)

1. Build and deploy extension to target Mendix app.
2. Start Studio Pro with extension development enabled.
3. Open pane and run refresh.
4. Review grouped model changes.
5. Export selected artefacts.
6. Downstream tooling consumes raw changes and/or overview outputs.

### CLI workflow (development iteration)

1. Edit parser/formatter in `studio-pro-extension-csharp/`.
2. Run `.\run-model-overview.ps1` (auto-builds and generates from pre-existing dumps).
3. Inspect output in `mendix-data/app-overview/`.
4. Repeat without opening Studio Pro.

## Technical references

- `studio-pro-extension-csharp/Docs/ARCHITECTURE.md`
- `studio-pro-extension-csharp/Docs/PROCESSING_PIPELINE.md`
- `studio-pro-extension-csharp/Docs/EXPORT_CONTRACT.md`
- `studio-pro-extension-csharp/Docs/MODEL_OVERVIEW_EXPORT_CONTRACT.md`
- `studio-pro-extension-csharp/Docs/REPOSITORY_WORKFLOWS.md`

