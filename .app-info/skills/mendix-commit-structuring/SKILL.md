---
name: mendix-commit-structuring
description: Build or update the Phase 7 parser structuring pipeline that converts raw Mendix export JSON into commit-ready structured output (`schemaVersion: 2.0`). Use when changing parser schema, model aggregations, commit message context generation, or export-to-structured process flow.
---

# MENDIX_COMMIT_STRUCTURING

## TASKS

1. Treat extension export files as the source contract (`schemaVersion: 1.0` in `exports`).
2. Keep the parser output contract explicit (`schemaVersion: 2.0` in `structured`).
3. Build and maintain these sections:
   - `files` (normalised file-level summaries and tags)
   - `modelChanges` (flattened model rows)
   - `modelSummary` (aggregates and highlights)
   - `commitMessageContext` (drafting hints and risks)
4. Preserve coupling with model detail text emitted by extension diff logic (`actions used`, `action details`, `attributes added` anchors).
5. Keep processing restart-safe by draining existing `exports` files on startup before watcher events.

## IMPLEMENTATION MAP

- `MendixCommitParser/Services/CommitParserService.cs`: primary transformation logic.
- `MendixCommitParser/Models/StructuredCommitData.cs`: structured output schema.
- `MendixCommitParser/Services/FileWatcherService.cs`: queue, watch, move success/error files.
- `MendixCommitParser/Storage/JsonStorage.cs`: final structured JSON persistence.
- `MendixCommitParser/Program.cs`: runtime logging and process lifecycle.

## VALIDATION CHECKLIST

1. Run `dotnet build .\MendixCommitParser\MendixCommitParser.csproj -c Debug`.
2. Replay at least one realistic export file through `mendix-data/exports`.
3. Confirm raw file is moved to `processed` (or `errors` on failure).
4. Confirm generated structured file includes `schemaVersion: "2.0"` and all required sections.
5. Confirm `commitMessageContext` and `modelSummary` are populated when model changes exist.
