# Structured Export Pipeline

## Status

- `DONE`

## Goal

Export deterministic JSON payloads representing uncommitted Mendix changes so downstream tooling can generate structured commit intelligence.

## Current behaviour

1. Export route validates repository state and current payload.
2. Export metadata includes:
   - schema version
   - UTC timestamp
   - project and branch names
   - Git user name and email
3. File-level changes include status, stage flag, diff text, grouped model changes, and optional dump artefact paths.
4. Export writes to temporary file and atomically moves to final `.json`.
5. Required data folders are ensured (`exports`, `processed`, `errors`, `structured`, `dumps`).

## Implementation references

- `studio-pro-extension-csharp/Processing/Services/AutoCommitMessageExportService.cs`
- `studio-pro-extension-csharp/Processing/Core/ExtensionDataPaths.cs`
- `studio-pro-extension-csharp/UI/Web/AutoCommitMessageWebServerExtension.cs`
- `studio-pro-extension-csharp/Docs/EXPORT_CONTRACT.md`

## Contract notes

- Current schema version is `1.0`.
- `displayText` is included for readability; consumers should also use structured fields.
- `processed/errors/structured` folders are currently reserved for downstream stages.

## Improvement opportunities

1. Publish explicit JSON Schema in the repository.
2. Add export correlation ID for cross-stage tracing.
3. Add configuration switch for dump artefact persistence.
