# Commit Parser Handoff Contract

## Status

- `DONE`

## Goal

Provide predictable exported input for the downstream commit parser and commit-message generation workflow managed through app-specific skills.

## Current behaviour

1. Extension export payloads are written to the shared data root (`mendix-data/exports` by default).
2. Payload includes grouped model changes and deterministic `displayText` values.
3. Folder contract reserves `processed`, `errors`, and `structured` for parser pipeline stages.
4. Feature and workflow documentation links parser owners to the extension export contract.

## Integration references

- `studio-pro-extension-csharp/Docs/EXPORT_CONTRACT.md`
- `.app-info/skills/mendix-commit-structuring/SKILL.md`
- `.app-info/skills/mendix-technical-commit-message/SKILL.md`
- `.app-info/features/data-export-pipeline.md`

## Constraints

- Parser compatibility depends on schema stability and coordinated version changes.
- No strict schema-validation tool is currently enforced in CI.

## Improvement opportunities

1. Add schema-version compatibility matrix for parser consumers.
2. Add validation step that fails fast on contract-breaking export changes.
3. Document end-to-end sample from export to final commit message output.
