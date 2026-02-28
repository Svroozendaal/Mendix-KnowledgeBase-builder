# Export Contract

## Purpose

Defines the raw-change export payload produced by:

- `Processing/Services/AutoCommitMessageExportService.cs`

This contract is consumed by downstream parsing and commit-message tooling.

## Output location

Raw-change JSON files are written to:

- `<DataRoot>/raw-changes`

`DataRoot` is resolved by `ExtensionDataPaths` (see `ARCHITECTURE.md`).

## Trigger path

Raw-change export is triggered through web route action:

- `POST autocommitmessage/?action=export`

Raw-change export only runs when `persistRawChanges=true`.

## File naming

Pattern:

`<UTC timestamp>_<project token>.json`

Example:

`2026-02-28T13-20-11.204Z_Smart Expenses app-main.json`

Collision handling:

- If file exists, a timestamp suffix is appended.

Write safety:

- JSON is written to temp file first, then atomically moved.

## Schema version

Current value:

- `schemaVersion: "1.0"`

Any change must be treated as a compatibility event for downstream consumers.

## JSON structure

Top-level fields:

| Field | Type | Description |
|---|---|---|
| `schemaVersion` | `string` | Export schema version |
| `timestamp` | `string` (ISO-8601 UTC) | Export creation timestamp |
| `projectName` | `string` | Project folder name |
| `branchName` | `string` | Current Git branch |
| `userName` | `string` | `git config user.name` or fallback |
| `userEmail` | `string` | `git config user.email` or fallback |
| `changes` | `array` | File-level changes |

`changes[]` fields:

| Field | Type | Description |
|---|---|---|
| `filePath` | `string` | Repository-relative file path |
| `status` | `string` | Normalised Git status |
| `isStaged` | `boolean` | Index staging flag |
| `diffText` | `string` | Patch text or fallback message |
| `modelChangesByModule` | `array?` | Module-grouped model changes (for `.mpr`) |
| `modelDumpArtifact` | `object?` | Persisted dump artefact paths |

`modelChangesByModule[]` fields:

| Field | Type |
|---|---|
| `module` | `string` |
| `domainModel` | `array<ExportModelChange>` |
| `microflows` | `array<ExportModelChange>` |
| `pages` | `array<ExportModelChange>` |
| `nanoflows` | `array<ExportModelChange>` |
| `resources` | `array<ExportModelChange>` |

`ExportModelChange` fields:

| Field | Type | Description |
|---|---|---|
| `changeType` | `string` | Added / Modified / Deleted |
| `elementType` | `string` | Element category |
| `elementName` | `string` | Element name |
| `details` | `string?` | Optional detail text |
| `displayText` | `string` | Deterministic formatted display line |

`modelDumpArtifact` fields:

| Field | Type | Description |
|---|---|---|
| `folderPath` | `string` | Dump artefact folder |
| `workingDumpPath` | `string` | Working dump JSON path |
| `headDumpPath` | `string` | HEAD dump JSON path |

## Example payload (abridged)

```json
{
  "schemaVersion": "1.0",
  "timestamp": "2026-02-28T13:20:11.2040000+00:00",
  "projectName": "Smart Expenses app-main",
  "branchName": "feature/model-overview",
  "userName": "Dev User",
  "userEmail": "dev@example.com",
  "changes": [
    {
      "filePath": "App.mpr",
      "status": "Modified",
      "isStaged": false,
      "diffText": "Binary file changed - diff not available",
      "modelChangesByModule": [
        {
          "module": "MyFirstModule",
          "domainModel": [
            {
              "changeType": "Modified",
              "elementType": "Entity",
              "elementName": "MyFirstModule.Order",
              "details": "attributes added (1): totalAmount",
              "displayText": "Order : attributes added (1): totalAmount"
            }
          ],
          "microflows": [],
          "pages": [],
          "nanoflows": [],
          "resources": []
        }
      ],
      "modelDumpArtifact": {
        "folderPath": "C:\\Repo\\mendix-data\\dumps\\...",
        "workingDumpPath": "C:\\Repo\\mendix-data\\dumps\\...\\working-dump.json",
        "headDumpPath": "C:\\Repo\\mendix-data\\dumps\\...\\head-dump.json"
      }
    }
  ]
}
```

## Folder contract around export

When export runs, these folders are ensured:

- `raw-changes`
- `processed`
- `errors`
- `app-overview`
- `dumps`

Current writer responsibilities:

- Raw-change export writer: `raw-changes`
- Overview writer: `app-overview`
- Dump artefact writer: `dumps`

## Consumer guidance

- Treat unknown fields as forward-compatible additions.
- Use structured fields as canonical semantics.
- Treat `displayText` as deterministic presentation-friendly text.
- Gate strict parsing by `schemaVersion`.

## Improvement opportunities

- Publish machine-readable JSON Schema in-repo.
- Add explicit export correlation ID for cross-stage traceability.
- Add compatibility test fixtures shared with downstream parser.

