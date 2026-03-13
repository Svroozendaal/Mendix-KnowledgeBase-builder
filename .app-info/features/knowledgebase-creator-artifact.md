# knowledgebase-creator-artifact
## Purpose

Define and maintain a portable `KnowledgeBase-Creator/` drop-in package that can be used on another laptop to generate Mendix KB inputs and seeded KB markdown structure.

## Product direction

This package is now a primary product output of this repository.
It is designed for KB creation only.

## Included in artifact

- Minimal `.agents/` subset for KB creation workflow
- `agents.md` AI launcher entry point
- `KnowledgeBaseCreator.exe` main launcher
- `wizard/run-dump-parser.ps1` advanced script bootstrap
- `Mendix-model-overview-parser/` source and prebuilt parser binaries
- `artifacts/` markdown templates copied into generated KB folders
- `.env` for local path configuration

## Central flow

1. Run `KnowledgeBase-Creator/KnowledgeBaseCreator.exe`.
2. The wizard collects the `.mpr` path and Mendix installation details.
3. The wizard runs `wizard/run-dump-parser.ps1`, which performs dump, parser export, scaffold, composition, and validation.
4. AI agent uses `agents.md` + included agents/skills to complete KB content.

## Automation

`workflow_dispatch` GitHub Action builds and publishes `KnowledgeBase-Creator` as downloadable artifact.
