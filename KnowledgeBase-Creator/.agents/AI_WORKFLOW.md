# AI_WORKFLOW
## KB Creation and Enrichment Workflow

## Overview

The knowledge base creation is a two-phase process. Phase 1 (pipeline) is deterministic PowerShell. Phase 2 (enrichment) is where the AI adds semantic value.

Use `/initkb` or `.\wizard\run-initkb.ps1` as the preferred shortcut for the full workflow. Use `/enrichkb` when the deterministic pipeline already ran and you only want phase 2.

## Phase 1: Run the Pipeline

1. Read `.env` to confirm `APP_NAME`, `MPR_FILE_PATH`, and `STUDIO_PRO_PATH` are set.
2. Run the creator backend:

```powershell
.\wizard\run-initkb.ps1 -OpenVsCode
```

3. Confirm the pipeline completed successfully. Check the output for:
   - Quality gate status: should be `pass`
   - All expected files present
   - Note the KB folder path, run folder path, and generated handoff file path

If the pipeline fails, diagnose the error before proceeding. Common issues:
- `mendix-data` already exists: remove it or use `-SkipDump -SkipParser` flags.
- Missing `mx.exe`: check `STUDIO_PRO_PATH` in `.env`.
- Missing `.mpr`: check `MPR_FILE_PATH` in `.env`.

## Phase 2: AI Enrichment

After the pipeline completes, the KB files contain export-backed data but lack business narratives. The enrichment phase adds human-readable explanations.

If the pipeline already completed earlier, start here with `/enrichkb`.

### Step 1: Understand the source data

Read the source pseudo.txt files from `mendix-data/app-overview/<run-folder>/`:
- `general/app-info.pseudo.txt` - app metadata and summary counts
- `general/user-roles.pseudo.txt` - security roles
- `general/all-modules.pseudo.txt` - module inventory
- Per-module: `modules/<Name>/domain-model.pseudo.txt`, `flows.pseudo.txt`, `pages.pseudo.txt`

### Step 2: Read the composed KB

Read the key composed files to understand what the pipeline already generated:
- `mendix-data/knowledge-base/ROUTING.md` - module index and completeness stats
- `mendix-data/knowledge-base/app/APP_OVERVIEW.md` - app-level summary
- `mendix-data/knowledge-base/_reports/UNKNOWN_TODO.md` - unresolved items

### Step 3: Enrich app-level docs

Use skill `mendix-overview-general-interpretation`. Focus on:
- `app/APP_OVERVIEW.md`: Add a meaningful mission summary. The compose script writes a generic one. Rewrite it to describe what the app actually does in business terms.
- `app/MODULE_LANDSCAPE.md`: Add narrative explaining why each custom module exists and how they relate.
- `app/SECURITY.md`: Add plain-language explanation of the security model.
- `app/CALL_GRAPH.md`: Add architecture narrative if cross-module dependencies exist.

### Step 4: Enrich per-module docs (custom modules only)

Use skill `mendix-overview-module-interpretation`. For each custom module:
- `modules/<Name>/README.md`: add module purpose interpretation under `## Interpretation`.
- `modules/<Name>/DOMAIN.md`: add entity relationship narrative under `## Domain Interpretation`.
- `modules/<Name>/FLOWS.md`: add business logic explanations under `## Flow Interpretation`.
- `modules/<Name>/PAGES.md`: add user journey context under `## Page Interpretation`.

Skip marketplace and system modules unless they have significant custom behaviour.

### Step 5: Resolve Unknown items

Read `_reports/UNKNOWN_TODO.md` and attempt to resolve items by cross-referencing source data.

### Step 6: Validate and enrich routes

Use skill `mendix-overview-routing-synthesis`. Verify all links resolve. Add completeness notes.

### Step 7: Re-validate

```powershell
.\wizard\run-kb-scaffold.ps1 -Validate -OutputRoot mendix-data/knowledge-base -AppName <app-name>
.\wizard\run-kb-quality-gate.ps1 -OutputRoot mendix-data/knowledge-base -AppName <app-name>
```

## Enrichment Rules

1. **Never remove export-backed data.** Only add to it.
2. **Never change module pointer/evidence blocks, table structures, required headings, anchors, or links.** The quality gate checks these.
3. **Mark AI-added content as `Confidence: Inferred`** to distinguish it from export-backed data.
4. **Keep all relative links valid.** Do not break existing navigation.
5. **Be specific, not generic.** "This module manages training course registrations" is better than "This module handles business logic."
6. **Cite source data.** When inferring purpose from entity names or flow patterns, say so.

## Completion Report

When done, report:
- App name
- Module count (custom / marketplace / system)
- Pipeline status (quality gate, benchmark)
- Enrichment summary (which files were enriched, what was added)
- Remaining gaps (items that could not be resolved)
