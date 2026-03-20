---
name: enrichkb
description: Kick off phase-2 AI enrichment for an existing knowledge base without rerunning dump, parser, scaffold, or compose. Use when `mendix-data/app-overview/<run-folder>` and `mendix-data/knowledge-base/` already exist and you only want the AI narrative layer.
---

# ENRICHKB

## Purpose

Use `/enrichkb` from the `KnowledgeBase-Creator` package when the deterministic pipeline has already completed and only the AI enrichment phase should run.

## Input resolution

Resolve the target KB in this order:

1. `mendix-data/knowledge-base/_sources/creator-link.json` in the current creator workspace
2. A KB path explicitly provided by the user, then its `_sources/creator-link.json`

Require:

- `knowledgeBaseRoot`
- `lastRunFolder`
- `appName`

If `_sources/INITKB_HANDOFF.md` exists, read it immediately after `creator-link.json` and use it as the source of truth for paths and validation commands.

If `lastRunFolder` is missing or does not exist, stop and tell the user to run `/initkb` instead because the deterministic pipeline outputs are missing.

## Procedure

1. Bootstrap once per session — read only these KB files for orientation:
   - `ROUTING.md` (in the knowledge base root)
   - `_reports/UNKNOWN_TODO.md`
   Do NOT read AGENTS.md, KNOWLEDGEBASE_CREATOR.md, OVERVIEW_KB_BUILDER.md,
   or AI_WORKFLOW.md — the caller already provides enrichment guidance via the
   general-interpretation and module-interpretation skill files.
2. Read app-level source pseudo files:
   - `general/app-info.pseudo.txt`
   - `general/user-roles.pseudo.txt`
3. Enrich the app-level KB files conservatively:
   - `app/APP_OVERVIEW.md`
   - `app/MODULE_LANDSCAPE.md`
   - `app/SECURITY.md`
   - `app/CALL_GRAPH.md`
4. Enrich custom modules one at a time. For each module, load:
   - `modules/<Name>/README.md` — module hub and navigation
   - `modules/<Name>/DOMAIN.md` — entity shape and lifecycle
   - `modules/<Name>/FLOWS.md` — flow catalogue with L0/L1/L2 links
   - `modules/<Name>/flows/INDEX.abstract.md` — collection L0 for flow triage
   - Individual L1 flow overviews (`flows/<slug>.overview.md`) for Tier 1 flows
   - `modules/<Name>/PAGES.md` — page inventory with L0/L1/L2 links
   - `modules/<Name>/pages/INDEX.abstract.md` — collection L0 for page triage
   - Individual L1 page overviews (`pages/<slug>.overview.md`) as needed
   - `modules/<Name>/INTERPRETATION.md` — writable module narrative file
   - `lastRunFolder/modules/<Name>/domain-model.pseudo.txt` — prefer targeted reads for large files
   - `lastRunFolder/modules/<Name>/flows.pseudo.txt` — prefer targeted reads for large files
   - `lastRunFolder/modules/<Name>/pages.pseudo.txt` — prefer targeted reads for large files
   - `lastRunFolder/modules/<Name>/resources.pseudo.txt`
5. Write module narrative only to `modules/<Name>/INTERPRETATION.md` (app-level narrative writes are handled in step 3).
6. Resolve items in `_reports/UNKNOWN_TODO.md` when the source run folder provides enough evidence.
7. Re-run scaffold validation and quality gate from the creator package.

## Guardrails

- Never rerun dump, parser, scaffold, or compose in this command.
- `/enrichkb` is an explicitly authorised write workflow:
  - app-level narrative writes are allowed in:
    - `app/APP_OVERVIEW.md`
    - `app/MODULE_LANDSCAPE.md`
    - `app/SECURITY.md`
    - `app/CALL_GRAPH.md`
  - module-level narrative writes are allowed in:
    - `modules/<Name>/INTERPRETATION.md`
  - `_reports/UNKNOWN_TODO.md` may be updated when resolving items.
- Generic KB "read-only" rules apply to normal interpretation only; they do not block `/enrichkb`.
- Reading source data in `lastRunFolder` is allowed for this workflow.
- Never remove export-backed data.
- For module docs, write only inside `INTERPRETATION.md`:
  - `## Module Purpose`
  - `## Domain Narrative`
  - `## Flow Narrative`
  - `## Page Narrative`
- Never change pointer/evidence blocks, required headings, table structures, anchors, or link targets.
- Never edit L0 abstract or L1 overview files — these are pipeline-owned.
- Mark AI-added narratives as `Confidence: Inferred`.
- Prioritise custom modules over marketplace and system modules.
- Use collection abstracts (`INDEX.abstract.md`) and L0 files for triage before reading full L1 overviews.
- Do not preload all custom-module pseudo exports in one pass.
- Prefer heading-targeted reads/searches for large files instead of full raw-file loads.
- Do not parse wizard/terminal run logs for enrichment content.
- Do not read `CURRENT_RUN.md`, console transcripts, or validation reports (`quality-gate-latest.*`, `l2-contract-debt.*`, scaffold output) during normal enrichment.
- Read validation reports only when diagnosing a specific failed post-enrichment validation.

## Completion report

Report:

- app name
- KB root
- source run folder
- enriched files
- resolved Unknown items
- remaining gaps
- post-enrichment validation results
