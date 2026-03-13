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
4. Read the target KB files:
   - `ROUTING.md`
   - `_reports/UNKNOWN_TODO.md`
5. Read source pseudo files from `lastRunFolder`:
   - `general/app-info.pseudo.txt`
   - `general/user-roles.pseudo.txt`
   - for each custom module:
     - `modules/<Name>/domain-model.pseudo.txt`
     - `modules/<Name>/flows.pseudo.txt`
     - `modules/<Name>/pages.pseudo.txt`
6. Enrich the KB in place:
   - `app/APP_OVERVIEW.md`
   - `app/MODULE_LANDSCAPE.md`
   - `app/SECURITY.md`
   - `app/CALL_GRAPH.md`
   - `modules/<Name>/README.md`
   - `modules/<Name>/DOMAIN.md`
   - `modules/<Name>/FLOWS.md`
   - `modules/<Name>/PAGES.md`
7. Resolve items in `_reports/UNKNOWN_TODO.md` when the source run folder provides enough evidence.
8. Re-run scaffold validation and quality gate from the creator package.

## Guardrails

- Never rerun dump, parser, scaffold, or compose in this command.
- Never remove export-backed data.
- For module docs, write only inside the reserved interpretation headings:
  - `README.md` -> `## Interpretation`
  - `DOMAIN.md` -> `## Domain Interpretation`
  - `FLOWS.md` -> `## Flow Interpretation`
  - `PAGES.md` -> `## Page Interpretation`
- Never change pointer/evidence blocks, required headings, table structures, anchors, or link targets.
- Mark AI-added narratives as `Confidence: Inferred`.
- Prioritise custom modules over marketplace and system modules.

## Completion report

Report:

- app name
- KB root
- source run folder
- enriched files
- resolved Unknown items
- remaining gaps
- post-enrichment validation results
