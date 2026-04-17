# KnowledgeBase Creator - AI Start

Use this file as the AI entry point for the standalone creator package.

This package now has two public functions only:

1. Create or rebuild a Mendix knowledge base end to end.
2. Interpret or route an already-created knowledge base by handing off to that KB's own `READER.md` and `.agents/` framework.

## Mandatory Start Sequence

1. Read `.agents/AGENTS.md`.
2. Read `.agents/AI_WORKFLOW.md`.
3. Choose one agent:
   - `.agents/agents/KNOWLEDGEBASE_CREATOR.md` for end-to-end KB creation.
   - `.agents/agents/KNOWLEDGEBASE_INTERPRETER.md` for KB reading and routing.

## Scope

`KnowledgeBase-Creator/` is a self-contained CLI tool package.

- Deterministic extraction and KB composition live under `cli/`.
- Internal creator skills live under `.agents/`.
- Generated KBs still ship their own rich `.agents/` framework and `READER.md`.
- Public repo-level entry skills live under `../tool-usage/`.

## Key Paths

- `.env` - creator defaults and environment overrides.
- `cli/run-initkb.ps1` - preferred end-to-end creator runner.
- `cli/run-dump-parser.ps1` - deterministic pipeline primitive.
- `cli/run-enrichkb.ps1` - AI enrichment-only runner.
- `mendix-data/app-overview/<run-folder>/` - parsed source data.
- `mendix-data/knowledge-base/` - generated KB output.

## Validation Rule

Do not report completion for KB creation unless both pass:

```powershell
.\cli\run-kb-scaffold.ps1 -Validate -OutputRoot mendix-data/knowledge-base -AppName <app-name>
.\cli\run-kb-quality-gate.ps1 -OutputRoot mendix-data/knowledge-base -AppName <app-name>
```
