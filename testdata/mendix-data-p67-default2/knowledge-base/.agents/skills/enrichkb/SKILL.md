---
name: enrichkb
description: Add the AI narrative layer to this already-generated knowledge base without rerunning dump, parser, scaffold, or compose. Use the linked `lastRunFolder` from `_sources/creator-link.json` as source evidence.
---

# ENRICHKB

## Purpose

Use `/enrichkb` inside a generated KB when the deterministic pipeline has already created the KB structure and you only want the AI enrichment phase.

## Required inputs

Read `_sources/creator-link.json` first and resolve:

- `knowledgeBaseRoot`
- `lastRunFolder`
- `creatorRoot`
- `appName`

If `_sources/INITKB_HANDOFF.md` exists, read it immediately after `creator-link.json` and use it as the source of truth for paths and validation commands.

If `lastRunFolder` is missing or does not exist, stop and report that the source run folder is unavailable. In that case, a creator-side rebuild is required before enrichment can continue.

## Procedure

1. Read `ROUTING.md`.
2. Read `_reports/UNKNOWN_TODO.md`.
3. Read source pseudo files from `lastRunFolder`:
   - `general/app-info.pseudo.txt`
   - `general/user-roles.pseudo.txt`
   - for each custom module:
     - `modules/<Name>/domain-model.pseudo.txt`
     - `modules/<Name>/flows.pseudo.txt`
     - `modules/<Name>/pages.pseudo.txt`
4. If `creatorRoot` exists, also read:
   - `<creatorRoot>\.agents\agents\KNOWLEDGEBASE_CREATOR.md`
   - `<creatorRoot>\.agents\agents\OVERVIEW_KB_BUILDER.md`
5. Enrich this KB in place:
   - `app/APP_OVERVIEW.md`
   - `app/MODULE_LANDSCAPE.md`
   - `app/SECURITY.md`
   - `app/CALL_GRAPH.md`
   - `modules/<Name>/README.md`
   - `modules/<Name>/DOMAIN.md`
   - `modules/<Name>/FLOWS.md`
   - `modules/<Name>/PAGES.md`
   - for marketplace modules, use `modules/_marktplace/<Name>/...` instead of `modules/<Name>/...`
6. Resolve `_reports/UNKNOWN_TODO.md` items where the source run folder gives enough evidence.
7. Prioritise custom modules over marketplace and system modules.

## Guardrails

- Never rerun dump, parser, scaffold, or compose from this KB.
- Never remove export-backed data.
- Never change required headings, table structures, or link targets.
- Mark AI-added narrative as `Confidence: Inferred`.
- Keep all relative links valid.

## Revalidation

If `creatorRoot` exists and the validation scripts are present, tell the user or agent to re-run:

```powershell
.\wizard\run-kb-scaffold.ps1 -Validate -OutputRoot "<knowledgeBaseRoot>" -AppName "<appName>"
.\wizard\run-kb-quality-gate.ps1 -OutputRoot "<knowledgeBaseRoot>" -AppName "<appName>"
```

from the creator package after enrichment.

## Output

Report:

- app name
- KB root
- source run folder
- enriched files
- resolved Unknown items
- remaining gaps
- whether post-enrichment validation was rerun
