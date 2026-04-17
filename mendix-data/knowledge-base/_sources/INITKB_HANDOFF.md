# Init KB Handoff

## Resolved paths

- Creator root: C:\Workspaces\Mendix-KnowledgeBase-builder-mendix-cli-implementation\KnowledgeBase-Creator
- Creator runner: C:\Workspaces\Mendix-KnowledgeBase-builder-mendix-cli-implementation\KnowledgeBase-Creator\cli\run-initkb.ps1
- Data root: C:\Workspaces\Mendix\Emixa_InspectionApp\mendix-data
- Knowledge base root: C:\Workspaces\Mendix\Emixa_InspectionApp\mendix-data\knowledge-base
- Source run folder: C:\Workspaces\Mendix\Emixa_InspectionApp\mendix-data\app-overview\cli_2026-03-19T15-48-55.594Z
- Extraction mode: MxCli
- Creator link: C:\Workspaces\Mendix\Emixa_InspectionApp\mendix-data\knowledge-base\_sources\creator-link.json

## Purpose

- Use /enrichkb inside this KB to add the AI narrative layer in place.
- /initkb remains available as a compatibility entry point and rebuild handoff.
- Do not rerun dump, parser, scaffold, or compose from this KB.
- Rebuild from source only through the creator package.

## Enrichment focus

- Read ROUTING.md and _reports/UNKNOWN_TODO.md first.
- Prioritise custom modules over marketplace and system modules.
- Use pseudo source files from the run folder as evidence for inferred narratives.
- Never remove export-backed data or change required headings, tables, or links.

## Revalidation

Run from the creator package after enrichment:

```powershell
.\cli\run-kb-scaffold.ps1 -Validate -OutputRoot "C:\Workspaces\Mendix\Emixa_InspectionApp\mendix-data\knowledge-base" -AppName "Mastering Advanced XPaths - Starting point"
.\cli\run-kb-quality-gate.ps1 -OutputRoot "C:\Workspaces\Mendix\Emixa_InspectionApp\mendix-data\knowledge-base" -AppName "Mastering Advanced XPaths - Starting point"
```
