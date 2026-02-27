# Export Contract

## Purpose

This document defines the current export payload and folder contract produced by:

- `Processing/Services/AutoCommitMessageExportService.cs`

It is intended for maintainers of downstream processors (for example parsing, structuring, and commit-message generation).

## Output location

Export JSON files are written to:

- `<DataRoot>/exports`

`DataRoot` resolution is documented in `ARCHITECTURE.md`.

## File naming

Pattern:

`<UTC timestamp>_<project token>.json`

Example:

`2026-02-27T17-05-12.304Z_Smart Expenses app-main.json`

Collision handling:

- If target file already exists, a suffix timestamp token is appended.

Write safety:

- Export is written to a temporary file first and then moved to destination.

## Schema version

Current value:

- `schemaVersion: "1.0"`

Version changes should be treated as explicit compatibility events for downstream consumers.

## JSON structure

Top-level fields:

| Field | Type | Description |
|---|---|---|
| `schemaVersion` | `string` | Export schema version |
| `timestamp` | `string` (ISO-8601 UTC) | Export creation time |
| `projectName` | `string` | Project folder name |
| `branchName` | `string` | Current Git branch |
| `userName` | `string` | `git config user.name` fallback `Unknown` |
| `userEmail` | `string` | `git config user.email` fallback `unknown@example.com` |
| `changes` | `array` | File-level change entries |

`changes[]` fields:

| Field | Type | Description |
|---|---|---|
| `filePath` | `string` | Repository-relative path |
| `status` | `string` | Normalised Git status |
| `isStaged` | `boolean` | Index staging flag |
| `diffText` | `string` | Patch text or fallback message |
| `modelChangesByModule` | `array?` | Module-grouped model changes (for `*.mpr`) |
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
| `changeType` | `string` | Added/Modified/Deleted |
| `elementType` | `string` | Mendix element category |
| `elementName` | `string` | Element name |
| `details` | `string?` | Optional details |
| `displayText` | `string` | Deterministic formatted row text |

`modelDumpArtifact` fields:

| Field | Type | Description |
|---|---|---|
| `folderPath` | `string` | Dump artefact folder |
| `workingDumpPath` | `string` | Working-copy dump JSON |
| `headDumpPath` | `string` | HEAD dump JSON |

## Example payload (abridged)

```json
{
  "schemaVersion": "1.0",
  "timestamp": "2026-02-27T17:05:12.3040000+00:00",
  "projectName": "Smart Expenses app-main",
  "branchName": "feature/model-ui",
  "userName": "Dev User",
  "userEmail": "dev@example.com",
  "changes": [
    {
      "filePath": "MyProject.mpr",
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
              "displayText": "- Order : attributes added (1): totalAmount"
            }
          ],
          "microflows": [],
          "pages": [],
          "nanoflows": [],
          "resources": []
        }
      ],
      "modelDumpArtifact": {
        "folderPath": "C:\\Repo\\mendix-data\\dumps\\2026-02-27T17-05-11.900Z_MyProject_mpr_...",
        "workingDumpPath": "C:\\Repo\\mendix-data\\dumps\\...\\working-dump.json",
        "headDumpPath": "C:\\Repo\\mendix-data\\dumps\\...\\head-dump.json"
      }
    }
  ]
}
```

## Folder contract around export

At export time the extension ensures these folders exist:

- `exports`
- `processed`
- `errors`
- `structured`
- `dumps`

Only `exports` and `dumps` are currently written by the extension. The other folders are reserved for downstream pipeline stages.

## Consumer guidance

- Treat unknown fields as forward-compatible additions.
- Read `displayText` as presentation-friendly, not as the only semantic source.
- Prefer structured fields (`changeType`, `elementType`, `details`) for deterministic processing.
- Respect schema version gates before making strict parsing assumptions.

## Improvement opportunities

- Publish machine-readable JSON Schema in-repo.
- Add explicit export ID for easier cross-stage traceability.
- Add optional source metadata for tool version diagnostics.
