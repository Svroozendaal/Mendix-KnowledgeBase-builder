# AGENTS
## KnowledgeBase Creator Agent System

This package contains the internal agents and skills required to:

1. Create a Mendix knowledge base end to end.
2. Interpret an already-created knowledge base by routing into that KB's own reader surface.

## Allowed Workflow

1. Read this file first.
2. Read `.agents/AI_WORKFLOW.md`.
3. Choose one internal agent:
   - `.agents/agents/KNOWLEDGEBASE_CREATOR.md`
   - `.agents/agents/KNOWLEDGEBASE_INTERPRETER.md`
4. Use internal skills from `.agents/skills/` as needed.

## Included Agents

| Agent | File | Role |
|---|---|---|
| KnowledgeBase Creator | `.agents/agents/KNOWLEDGEBASE_CREATOR.md` | End-to-end pipeline orchestration, enrichment, and revalidation |
| KnowledgeBase Interpreter | `.agents/agents/KNOWLEDGEBASE_INTERPRETER.md` | Locate a generated KB, bootstrap from `READER.md`, and route into the KB's shipped agent framework |

## Included Internal Skills

| Skill | File | Purpose |
|---|---|---|
| Init KB | `.agents/skills/initkb/SKILL.md` | Run the deterministic pipeline and continue with creator-side enrichment |
| Enrich KB | `.agents/skills/enrichkb/SKILL.md` | Run only the creator-side enrichment phase against an existing KB |
| General Enrichment | `.agents/skills/mendix-overview-general-interpretation/SKILL.md` | Enrich app-level docs |
| Module Enrichment | `.agents/skills/mendix-overview-module-interpretation/SKILL.md` | Enrich per-module interpretation |
| Routing Enrichment | `.agents/skills/mendix-overview-routing-synthesis/SKILL.md` | Validate and enrich routing/index docs |

## Key Paths

| Path | Purpose |
|---|---|
| `.env` | Pipeline configuration |
| `cli/run-initkb.ps1` | Preferred creator runner |
| `cli/run-dump-parser.ps1` | Deterministic pipeline primitive |
| `cli/run-enrichkb.ps1` | Enrichment-only runner |
| `mendix-data/app-overview/<run>/` | Parsed source data |
| `mendix-data/knowledge-base/` | Generated KB output |
| `mendix-data/knowledge-base/.agents/` | Rich interpretation agents shipped with the KB |

## Validation Rule

Do not report KB creation complete unless both pass:

```powershell
.\cli\run-kb-scaffold.ps1 -Validate -OutputRoot mendix-data/knowledge-base -AppName <app-name>
.\cli\run-kb-quality-gate.ps1 -OutputRoot mendix-data/knowledge-base -AppName <app-name>
```
