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

1. Read `AGENTS.md`.
2. Read `.agents/agents/KNOWLEDGEBASE_CREATOR.md`.
3. Read `.agents/agents/OVERVIEW_KB_BUILDER.md`.
4. Bootstrap once per session:
   - `ROUTING.md`
   - `_reports/UNKNOWN_TODO.md`
5. Read app-level source pseudo files:
   - `general/app-info.pseudo.txt`
   - `general/user-roles.pseudo.txt`
6. Enrich the app-level KB files conservatively:
   - `app/APP_OVERVIEW.md`
   - `app/MODULE_LANDSCAPE.md`
   - `app/SECURITY.md`
   - `app/CALL_GRAPH.md`
7. Enrich custom modules one at a time. For each module, load:
   - `modules/<Name>/README.md` — module hub and navigation
   - `modules/<Name>/DOMAIN.md` — entity shape and lifecycle
   - `modules/<Name>/FLOWS.md` — flow catalogue with L0/L1/L2 links
   - `modules/<Name>/flows/INDEX.abstract.md` — collection L0 for flow triage
   - Individual L1 flow overviews (`flows/<slug>.overview.md`) for Tier 1 flows
   - `modules/<Name>/PAGES.md` — page inventory with L0/L1/L2 links
   - `modules/<Name>/pages/INDEX.abstract.md` — collection L0 for page triage
   - Individual L1 page overviews (`pages/<slug>.overview.md`) as needed
   - `modules/<Name>/INTERPRETATION.md` — the only writable file
   - `lastRunFolder/modules/<Name>/domain-model.pseudo.txt`
   - `lastRunFolder/modules/<Name>/flows.pseudo.txt`
   - `lastRunFolder/modules/<Name>/pages.pseudo.txt`
   - `lastRunFolder/modules/<Name>/resources.pseudo.txt`
8. Write module narrative only to `modules/<Name>/INTERPRETATION.md`.
9. Resolve items in `_reports/UNKNOWN_TODO.md` when the source run folder provides enough evidence.
10. Re-run scaffold validation and quality gate from the creator package.

## Guardrails

- Never rerun dump, parser, scaffold, or compose in this command.
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
- Inspect detailed quality-gate issues from `_reports/quality-gate-latest.md` or by rerunning with `-ShowAllIssues`.

## Completion report

Report:

- app name
- KB root
- source run folder
- enriched files
- resolved Unknown items
- remaining gaps
- post-enrichment validation results
