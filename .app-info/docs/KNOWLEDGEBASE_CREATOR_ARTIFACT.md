# KNOWLEDGEBASE_CREATOR_ARTIFACT
## Product Intent

The repository now ships a portable `KnowledgeBase-Creator/` folder as an explicit product output.

## Why it exists

Enable users to move one package to another laptop and run one command to:
1. dump a Mendix model,
2. build model-overview export files,
3. scaffold and seed KB markdown files,
4. start AI-driven KB completion from a single `agents.md` entry point.

## Ownership

- CI packaging workflow: `.github/workflows/build-knowledgebase-creator-artifact.yml`
- Runtime entry command: `KnowledgeBase-Creator/KnowledgeBaseCreator.exe`
- Advanced script bootstrap: `KnowledgeBase-Creator/wizard/run-dump-parser.ps1`
- Package source of truth: `KnowledgeBase-Creator/`

## Scope boundary

The portable package is for KB creation only.
It is intentionally limited to the minimum agents and skills required for KB generation.
