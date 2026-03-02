# Processing Pipeline

## Objective

The processing layer converts local repository state into deterministic, machine-readable artefacts for:

- In-pane model-change review.
- Raw-change export consumed by parser/commit-message automation.
- Full committed-model overview exports (app + modules).
- Optional commit-message text storage.

## Pipeline families

## 1) Change analysis pipeline (`ReadChanges`)

Entry point: `AutoCommitMessageChangeService.ReadChanges(projectPath, persistModelDumps, dataRootBasePath, headDumpCacheEnabled, selectedModules)`

1. Discover Git repository from `projectPath`.
2. Retrieve filtered status for `*.mpr` and `*.mprops`.
3. Retrieve filtered patch data.
4. Build file-change records (`filePath`, `status`, `isStaged`, `diffText`).
5. For each changed `.mpr`:
   - (v2 only) Check if module is in `selectedModules` filter; skip analysis if not
   - dump working model (`mx dump-mpr`)
   - reconstruct and dump committed (`HEAD`) snapshot
   - (if `headDumpCacheEnabled=true`) attempt cached HEAD dump lookup; skip mx.exe if cache hit
   - (on cache miss) execute dump and cache result for future use
   - diff dumps semantically via `MendixModelDiffService`
   - group by module/category via `MendixModelChangeStructurer`
   - optionally persist dump artefacts (`persistModelDumps=true`)
6. (if `headDumpCacheEnabled=true`) prune stale cache entries
7. Return `AutoCommitMessagePayload`.

Fallback behaviour:

- Per-file model-analysis failures become synthetic `Model Analysis` changes.
- Known dump environment mismatches return empty model changes for affected file rather than failing full payload.
- Cache read failures fall back to live dump execution.
- Cache write failures are non-critical and do not block refresh.

### HEAD Dump Caching Details

When enabled, `AutoCommitMessageHeadDumpCacheService`:
- Stores dumps at: `<DataRoot>/dumps/head-cache/<commit-hash>/<mpr-filename>.json`
- Cache key: `<mpr-path> + <HEAD-commit-SHA>`
- Prunes entries older than 30 days (configurable)
- Prune failures are non-critical and logged but not thrown
- Setting: Query parameter `headDumpCacheEnabled` (default: true), localStorage key: `autocommitmessage.headDumpCacheEnabled`

### Module Filtering Details

For **MPR v2** projects (detected via `mprcontents/` directory):
- If `selectedModules` provided and non-empty, skip analysis for modules not in list
- Optimization: unselected modules avoid dump/diff work entirely
- For **MPR v1** projects, filter is ignored; full analysis always performed (client-side filtering in UI)

Format detection via `MendixMprFormatDetector.IsMprV2(mprPath)`. See `Docs/MPR_FORMAT_SUPPORT.md` for full details.

## 2) Raw-change export pipeline

Entry point: `AutoCommitMessageExportService.ExportChanges(payload, projectPath, dataRootBasePath)`

1. Validate payload (`IsGitRepo`, no payload error, non-empty changes).
2. Resolve metadata (`projectName`, `branchName`, `user.name`, `user.email`, timestamp).
3. Ensure output folders exist (`raw-changes`, `processed`, `errors`, `app-overview`, `dumps`).
4. Convert grouped model changes to export records including deterministic `displayText`.
5. Write JSON (`schemaVersion: 1.0`) via temp file + atomic move.

## 3) Model overview export pipeline

Entry points:

- `AutoCommitMessageModelOverviewService.ListOverviewModules(projectPath)`
- `AutoCommitMessageModelOverviewService.GenerateOverview(projectPath, mode, ...)`

`ListOverviewModules`:

1. Validate Git/HEAD state.
2. Resolve committed `.mpr` files from repository tree.
3. Reconstruct each committed `.mpr` in temporary workspace.
4. Run `mx dump-mpr` on committed snapshot.
5. Parse `Projects$Module` entries and classify as `System`, `Marketplace`, or `Custom`.

`GenerateOverview`:

1. Validate requested outputs and repository state.
2. Resolve committed `.mpr` files.
3. Dump committed model snapshot(s) with `mx.exe`.
4. Parse full inventory with `MendixModelOverviewParser`.
5. Generate app and/or module artefacts depending on mode and module selection.
6. Write run manifest.

Output path pattern:

- `<DataRoot>/app-overview/overviews/<timestamp>_<repo>_<guid>/...`

## 4) Changed module detection pipeline (`ListChangeModules`)

Entry point: HTTP GET `/list-change-modules` (routed via `AutoCommitMessageWebServerExtension.HandleListChangeModulesRequestAsync`)

1. Validate Git repository at `projectPath`.
2. Find first `.mpr` file in project.
3. Detect MPR format via `MendixMprFormatDetector.IsMprV2(mprPath)`.
4. For **v2 projects**: extract changed modules via `MendixV2ChangedModuleDetector.DetectChangedModules(repository, mprContentsPath)`.
5. For **v1 projects**: return empty module list.
6. Return JSON response with format version, module list, and `supportsPreFilter` flag.

Response shape:

```json
{
  "success": true,
  "mprVersion": "v2",
  "modules": ["ModuleA", "ModuleB"],
  "supportsPreFilter": true
}
```

Used by UI to populate module selection before Refresh action.

## 5) Commit-message storage pipeline

Entry point: `AutoCommitMessageCommitMessageStoreService.StoreCommitMessage(...)`

1. Validate non-empty commit text.
2. Resolve folder `<base>/Commit messages`.
3. Derive file token from first line (sanitised, length-limited).
4. Write UTF-8 text via temp file + atomic move.

## Service responsibilities

| Service | Responsibility |
|---|---|
| `AutoCommitMessageChangeService` | Git status/diff collection and `.mpr` model analysis orchestration |
| `AutoCommitMessageHeadDumpCacheService` | HEAD dump caching (lookup, storage, pruning) |
| `MendixMprFormatDetector` | MPR v1 vs v2 format detection |
| `MendixV2ChangedModuleDetector` | Changed module extraction from mprcontents/ structure |
| `MxToolService` | `mx.exe` discovery, compatibility probing, and dump execution |
| `MendixModelDiffService` | Semantic diffing and resource-specific detail enrichment |
| `MendixModelChangeStructurer` | Module/category grouping and association-to-domain detail promotion |
| `MendixModelChangeDisplayTextFormatter` | Stable `displayText` generation for UI/export |
| `AutoCommitMessageExportService` | Raw-change payload serialisation and persistence |
| `MendixModelOverviewParser` | Full-model inventory and flow-graph/pseudocode extraction |
| `AutoCommitMessageModelOverviewService` | Overview run orchestration, module listing, and artefact writing |
| `AutoCommitMessageCommitMessageStoreService` | Commit-message text storage |

## Failure modes and handling

| Failure case | Handling |
|---|---|
| Empty project path | Returns payload error |
| Not a Git repository | Returns `IsGitRepo=false` |
| `mx.exe` unavailable/incompatible | Per-file model-analysis fallback entry |
| Dump workspace mismatch | Per-file empty model-change fallback |
| Export with no enabled outputs | HTTP 400 in web route |
| Export raw-changes with zero changes | HTTP 400 in web route |
| Overview requested with missing modules | Failure result with explicit message |
| Store commit message with empty body | HTTP 400 in web route |

## Improvement opportunities

- Add structured telemetry for step timing and artefact sizes.
- Add cancellation propagation in deep parse loops.
- Extend specialised detail builders for uncovered high-volume model types.
- Add contract tests for web-route output toggles and module-filter selection.

