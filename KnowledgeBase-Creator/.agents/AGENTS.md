# AGENTS
## KnowledgeBase Creator Agent System

This package contains the agents and skills required to create and enrich a Mendix knowledge base.

## Purpose

Convert a Mendix `.mpr` model into an AI-navigable knowledge base in two phases:

1. **Pipeline phase** - PowerShell scripts extract data deterministically into structured markdown.
2. **Enrichment phase** - AI reads the composed KB + source data and adds semantic narratives.

## How It Works

The PowerShell pipeline (`wizard/run-dump-parser.ps1`) handles:
- Dumping the `.mpr` file via `mx.exe`
- Parsing the dump into structured JSON + pseudo.txt exports
- Scaffolding the KB folder structure
- Seeding templates and `.agents/` framework
- Composing all markdown files with export-backed data
- Running validation, quality gate, and benchmark

After the pipeline completes, the **enrichment phase** is where the AI adds value. The compose script fills ~90% of the content deterministically. The AI adds the remaining ~10%: business narratives, flow explanations, domain stories, and Unknown resolution.

## Allowed Workflow

1. Prefer `/initkb` or `.\wizard\run-initkb.ps1` for the full creator workflow when the user wants to build or rebuild a KB from this package.
2. Prefer `/enrichkb` when the deterministic pipeline already ran and only the AI phase should execute.
3. Read this file first.
4. Read `.agents/AI_WORKFLOW.md`.
5. Execute `.agents/agents/KNOWLEDGEBASE_CREATOR.md` (orchestrator).
6. Delegate enrichment to `.agents/agents/OVERVIEW_KB_BUILDER.md`.
7. Use skills from `.agents/skills/` for enrichment guidance.

## Included Agents

| Agent | File | Role |
|---|---|---|
| KnowledgeBase Creator | `.agents/agents/KNOWLEDGEBASE_CREATOR.md` | Pipeline orchestrator + enrichment trigger |
| Overview KB Builder | `.agents/agents/OVERVIEW_KB_BUILDER.md` | Semantic enrichment of composed KB files |

## Included Skills

| Skill | File | Purpose |
|---|---|---|
| Init KB | `.agents/skills/initkb/SKILL.md` | Slash-command workflow backed by `wizard/run-initkb.ps1` for rebuilding and handing off KB enrichment from the creator package |
| Enrich KB | `.agents/skills/enrichkb/SKILL.md` | Slash-command workflow for running only the AI enrichment phase against an existing KB and run folder |
| General Enrichment | `.agents/skills/mendix-overview-general-interpretation/SKILL.md` | Enrich app-level docs with business narratives |
| Module Enrichment | `.agents/skills/mendix-overview-module-interpretation/SKILL.md` | Enrich per-module docs with domain stories |
| Routing Enrichment | `.agents/skills/mendix-overview-routing-synthesis/SKILL.md` | Validate and enrich cross-reference indexes |

## Key Paths

| Path | Purpose |
|---|---|
| `.env` | Pipeline configuration |
| `wizard/run-dump-parser.ps1` | Main pipeline script |
| `mendix-data/app-overview/<run>/` | Parsed source data (JSON + pseudo.txt) |
| `mendix-data/knowledge-base/` | Generated KB output |
| `mendix-data/knowledge-base/.agents/` | Read-only interpretation agents (shipped with KB) |
| `mendix-data/knowledge-base/_reports/UNKNOWN_TODO.md` | Unresolved items for AI to address |

## Validation Rule

Do not report completion unless both pass:

```powershell
.\wizard\run-kb-scaffold.ps1 -Validate -OutputRoot mendix-data/knowledge-base -AppName <app-name>
.\wizard\run-kb-quality-gate.ps1 -OutputRoot mendix-data/knowledge-base -AppName <app-name>
```
