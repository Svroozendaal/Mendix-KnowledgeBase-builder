# Processing Pipeline

## Objective

The processing layer converts raw repository state into structured change data suitable for:

- In-pane review by developers.
- Deterministic export into downstream commit-message tooling.

## Pipeline overview

1. Discover Git repository from current project path.
2. Retrieve filtered file status (`*.mpr`, `*.mprops`).
3. Retrieve filtered patch data.
4. Build file-level change entries with status, staged flag, and diff text.
5. For each changed `*.mpr` file:
   1. Dump working model to JSON.
   2. Reconstruct `HEAD` model snapshot and dump to JSON.
   3. Compare dumps semantically and produce `MendixModelChange` entries.
   4. Group model changes by module and category.
   5. Optionally persist working/head dump artefacts.
6. Return `AutoCommitMessagePayload` to UI or export layer.

## Service responsibilities

## `AutoCommitMessageChangeService`

- Entry point: `ReadChanges(string projectPath, bool persistModelDumps = false)`.
- Handles repository detection and payload creation.
- Applies status/diff filtering and model analysis orchestration.
- Converts failures in model analysis into informative fallback model-change rows.

### Status and diff handling

- File status is normalised into `Added`, `Modified`, `Deleted`, or `Renamed`.
- Staged detection is derived from index-related `LibGit2Sharp` status flags.
- `.mpr` diff text is intentionally shown as binary/unavailable while model-level details carry semantics.

### Model dump reconstruction details

- Working dump:
  - Uses current working `*.mpr` when present.
  - Uses empty dump JSON for deleted/missing working model.
- `HEAD` dump:
  - Reads `HEAD` blob for `*.mpr`.
  - Reconstructs `mprcontents` from `HEAD` tree when available.
  - Falls back to copying working `mprcontents` if needed.

This approach reduces false failures where dump execution expects `mprcontents` alignment.

## `MxToolService`

- Finds compatible `mx.exe` in this order:
  - `PATH` candidates.
  - Registry install locations.
  - Program Files fallbacks.
- Verifies `dump-mpr` support (`mx dump-mpr --help`) before selecting candidate.
- Executes `dump-mpr` with controlled working directory and timeout.

## `MendixModelDiffService`

- Compares working/head dump JSONs semantically.
- Tracks resources by IDs and ownership to detect added, modified, deleted resources.
- Applies resource-specific detail builders for:
  - Domain entities and associations.
  - Enumerations.
  - Microflows and nanoflows.
  - Pages (roles, layout metadata, action bindings).
- Suppresses noisy layout-only properties for microflow-related models.

Output is a list of `MendixModelChange` records ordered by type/name/change type.

## `MendixModelChangeStructurer`

- Groups model changes into modules based on `Module.Element` naming.
- Maps element types into categories:
  - `DomainModel`
  - `Microflows`
  - `Pages`
  - `Nanoflows`
  - `Resources`
- Promotes association summaries into related domain entity details where possible.

## `MendixModelChangeDisplayTextFormatter`

- Produces deterministic `displayText` for UI and export payloads.
- Applies abbreviation and marker rules (`NEW`, `DEL`, `MF`, `NF`, etc.).
- Compacts verbose flow details into stable summary sections.

See `info_model-change-display-text-formatter.md` for converter-style rule details.

## Export handoff

`AutoCommitMessageExportService` consumes payloads from `ReadChanges(...)` and:

- Resolves project metadata (`projectName`, `branchName`, `user.name`, `user.email`).
- Re-computes grouped model changes if missing.
- Serialises a stable schema (`schemaVersion = 1.0`).
- Writes to temp file and atomically moves to final destination.

Full JSON contract: `EXPORT_CONTRACT.md`.

## Failure modes and fallbacks

| Failure case | Handling |
|---|---|
| Project path empty | Returns payload with error |
| Not a Git repository | Returns `IsGitRepo = false` |
| `mx.exe` not found/compatible | Per-file model-analysis fallback entry |
| Temporary dump workspace inconsistency | Returns empty model changes for affected file |
| Export requested with no changes | Returns explicit user-facing error |

## Improvement opportunities

- Add benchmark traces for large dump comparison sessions.
- Add dedicated parser for model-specific detail payloads to reduce regex-heavy logic.
- Add cancellation support deep in dump comparison to improve responsiveness.
- Add structured diagnostics output for support workflows.
