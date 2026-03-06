# knowledgebase-creator-artifact
## Purpose

Define and maintain a portable `KnowledgeBase-Creator/` drop-in package that can be used on another laptop to generate Mendix KB inputs and seeded KB markdown structure.

## Product direction

This package is now a primary product output of this repository.
It is designed for KB creation only.

## Included in artifact

- Minimal `.agents/` subset for KB creation workflow
- `agents.md` AI launcher entry point
- `run-dump-parser.ps1` central command
- `Mendix-model-overview-parser/` source and prebuilt parser binaries
- `artifacts/` markdown templates copied into generated KB folders
- `.env` for local path configuration

## Central flow

1. Run `KnowledgeBase-Creator/run-dump-parser.ps1`.
2. Script runs `mx dump-mpr` and parser export.
3. Script scaffolds KB structure and seeds required markdown templates.
4. AI agent uses `agents.md` + included agents/skills to complete KB content.

## Automation

`workflow_dispatch` GitHub Action builds and publishes `KnowledgeBase-Creator` as downloadable artifact.
