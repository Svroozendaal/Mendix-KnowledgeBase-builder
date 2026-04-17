# AI_WORKFLOW
## KB Creation and Interpretation Workflow

## Overview

This package supports two workflows:

1. End-to-end KB creation from a Mendix application source.
2. KB interpretation by routing into an already-generated knowledge base.

Use `.\cli\run-initkb.ps1` or the public `tool-usage/knowledgebase` skill for full creation.
Use `.\cli\run-enrichkb.ps1` or the internal `enrichkb` skill when the deterministic pipeline already ran.

## Workflow A: Create a Knowledge Base

### Phase 1: Deterministic pipeline

1. Confirm the source `.mpr`, target output root, and Mendix tooling path or version context.
2. Run:

```powershell
.\cli\run-initkb.ps1 -OpenVsCode
```

3. Confirm:
   - quality gate status is `pass`
   - the KB root was produced
   - the app-overview run folder was produced
   - `creator-link.json` and `INITKB_HANDOFF.md` were written

### Phase 2: Enrichment

1. Use the internal `enrichkb` skill plus the supporting Mendix interpretation skills.
2. Read the source pseudo exports from `mendix-data/app-overview/<run-folder>/`.
3. Read the composed KB from `mendix-data/knowledge-base/`.
4. Enrich app-level docs, custom-module `INTERPRETATION.md` files, and resolvable unknowns only.

### Phase 3: Revalidation

```powershell
.\cli\run-kb-scaffold.ps1 -Validate -OutputRoot mendix-data/knowledge-base -AppName <app-name>
.\cli\run-kb-quality-gate.ps1 -OutputRoot mendix-data/knowledge-base -AppName <app-name>
```

## Workflow B: Interpret a Knowledge Base

1. Resolve the KB root.
2. Read that KB's `READER.md`.
3. Read that KB's `ROUTING.md`.
4. Use the KB's shipped `.agents/` framework for detailed routing and interpretation.
5. Do not rerun creator pipeline commands during interpretation.

## Enrichment Rules

1. Never remove export-backed data.
2. Never change required headings, anchors, link targets, pointer blocks, or evidence tables.
3. Write module narrative only to `INTERPRETATION.md`.
4. Mark AI-added narrative as `Confidence: Inferred`.
5. Keep all relative links valid.
6. Prefer targeted reads over large raw-file loads.
