# KnowledgeBase Creator - AI Start

Use this file as the AI starting point for KB creation and enrichment.

Prefer `/initkb` when the user wants the full creator workflow from this package. It is backed by `.\wizard\run-initkb.ps1`, which rebuilds the target workspace, writes creator-link and handoff artifacts, and then guides the AI through the existing enrichment flow.

Prefer `/enrichkb` when `mendix-data/app-overview/<run-folder>` and `mendix-data/knowledge-base/` already exist and the user only wants the AI enrichment phase.

## Mandatory Start Sequence

1. Read `.agents/AGENTS.md` - scope, agents, and orchestration.
2. Read `.agents/AI_WORKFLOW.md` - step-by-step creation flow.
3. Execute `.agents/agents/KNOWLEDGEBASE_CREATOR.md` - top-level orchestrator.

## Scope

This package creates and enriches a Mendix knowledge base. The process has two phases:

1. **Pipeline phase** (PowerShell) - deterministic data extraction from `.mpr` export.
2. **Enrichment phase** (AI) - semantic narratives, business logic explanations, and gap resolution.

## Input and Output

- `.env` - pipeline configuration (app name, paths, options).
- `mendix-data/app-overview/<run-folder>/` - parsed model data (JSON + pseudo.txt).
- `mendix-data/knowledge-base/` - the generated and enriched KB.
- `mendix-data/knowledge-base/.agents/` - read-only interpretation agents (shipped with the KB).

## Two-Phase Flow

### Phase 1: Pipeline (deterministic)

```powershell
.\wizard\run-initkb.ps1 -OpenVsCode
```

This runs the deterministic pipeline (dump -> parse -> scaffold -> seed templates -> compose -> validate -> quality gate -> benchmark), writes `creator-link.json` and `INITKB_HANDOFF.md`, and can open the target `mendix-data` workspace for manual phase-2 enrichment.

### Phase 2: AI Enrichment

After the pipeline completes, the AI reads the composed KB files alongside the source pseudo.txt files and adds:

- Module purpose narratives (what does each module do in business terms?)
- Flow business logic explanations (why does each flow exist?)
- Entity relationship stories (what does the domain model mean?)
- Resolution of Unknown items from `_reports/UNKNOWN_TODO.md`

See `.agents/agents/OVERVIEW_KB_BUILDER.md` for enrichment instructions.

## Required Validation Before Completion

After enrichment, re-run validation:

```powershell
.\wizard\run-kb-scaffold.ps1 -Validate -OutputRoot mendix-data/knowledge-base -AppName <app-name>
.\wizard\run-kb-quality-gate.ps1 -OutputRoot mendix-data/knowledge-base -AppName <app-name>
```

Only report success when both validations pass.
