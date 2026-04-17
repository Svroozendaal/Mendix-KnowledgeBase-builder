---
name: enrichkb
description: Kick off creator-side AI enrichment for an existing knowledge base without rerunning dump, parser, scaffold, or compose. Use when `mendix-data/app-overview/<run-folder>` and `mendix-data/knowledge-base/` already exist and you only want the AI narrative layer.
---

# ENRICHKB

## Purpose

Use `/enrichkb` from the `KnowledgeBase-Creator` package when the deterministic pipeline has already completed and only the creator-side AI enrichment phase should run.

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

1. Bootstrap once per session - read only these KB files for orientation:
   - `ROUTING.md` in the knowledge base root
   - `_reports/UNKNOWN_TODO.md`
   Do NOT read `AGENTS.md`, `KNOWLEDGEBASE_CREATOR.md`, `KNOWLEDGEBASE_INTERPRETER.md`, or `AI_WORKFLOW.md` - the caller already provides enrichment guidance via the supporting skill files.
2. Read app-level source pseudo files:
   - `general/app-info.pseudo.txt`
   - `general/user-roles.pseudo.txt`
3. Enrich the app-level KB files conservatively:
   - `app/APP_OVERVIEW.md`
   - `app/MODULE_LANDSCAPE.md`
   - `app/SECURITY.md`
   - `app/CALL_GRAPH.md`
4. Enrich custom modules one at a time. For each module, load:
   - `modules/<Name>/README.md`
   - `modules/<Name>/DOMAIN.md`
   - `modules/<Name>/FLOWS.md`
   - `modules/<Name>/flows/INDEX.abstract.md`
   - individual L1 flow overviews as needed
   - `modules/<Name>/PAGES.md`
   - `modules/<Name>/pages/INDEX.abstract.md`
   - individual L1 page overviews as needed
   - `modules/<Name>/INTERPRETATION.md`
   - `lastRunFolder/modules/<Name>/domain-model.pseudo.txt`
   - `lastRunFolder/modules/<Name>/flows.pseudo.txt`
   - `lastRunFolder/modules/<Name>/pages.pseudo.txt`
   - `lastRunFolder/modules/<Name>/resources.pseudo.txt`
5. Write module narrative only to `modules/<Name>/INTERPRETATION.md`.
6. Resolve items in `_reports/UNKNOWN_TODO.md` when the source run folder provides enough evidence.
7. Re-run scaffold validation and the quality gate from the creator package.

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
- Generic KB read-only rules apply to normal interpretation only; they do not block `/enrichkb`.
- Reading source data in `lastRunFolder` is allowed for this workflow.
- Never remove export-backed data.
- For module docs, write only inside `INTERPRETATION.md`:
  - `## Module Purpose`
  - `## Domain Narrative`
  - `## Flow Narrative`
  - `## Page Narrative`
- Never change pointer blocks, evidence blocks, required headings, table structures, anchors, or link targets.
- Never edit L0 abstract or L1 overview files - these are pipeline-owned.
- Mark AI-added narratives as `Confidence: Inferred`.
- Prioritise custom modules over marketplace and system modules.
- Use collection abstracts for triage before reading full L1 overviews.
- Do not preload all custom-module pseudo exports in one pass.
- Prefer heading-targeted reads or searches for large files instead of full raw-file loads.
- Do not parse CLI or terminal run logs for enrichment content.
- Do not read `CURRENT_RUN.md`, console transcripts, or validation reports during normal enrichment unless diagnosing a failed post-enrichment validation.

## Completion report

Report:

- app name
- KB root
- source run folder
- enriched files
- resolved Unknown items
- remaining gaps
- post-enrichment validation results
