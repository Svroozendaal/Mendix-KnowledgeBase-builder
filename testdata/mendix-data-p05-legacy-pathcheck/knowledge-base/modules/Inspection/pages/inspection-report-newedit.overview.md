---
objectType: page
module: Inspection
qualifiedName: Inspection.Report_NewEdit
stableId: Inspection.Report_NewEdit
slug: inspection-report-newedit
layer: L1
l0: inspection-report-newedit.abstract.md
l2Path: ../../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/pages/inspection-report-newedit.json
l2Logical: page:Inspection.Report_NewEdit
sourceRun: cli_2026-03-18T20-44-56.522Z
collectionL0: INDEX.abstract.md
collectionL1: ../PAGES.md
---
# Page Overview: Inspection.Report_NewEdit

## Summary

- Generate report. Likely supports create/edit interactions for report helper because it accepts page parameters.
- L0: [abstract](inspection-report-newedit.abstract.md)
- L2: [json](../../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/pages/inspection-report-newedit.json)

## Roles and Entry Provenance

- Roles: Inspection.Administrator, Inspection.Manager
- Entry provenance: ShowPageAction

## Parameters

- ReportHelper:Inspection.ReportHelper

## Datasource Summary

- No datasource metadata was exported for this page; it may rely on parameter-driven context rather than a standalone datasource. Check L2 JSON if exact binding matters.

## Client Actions

- actionId=0c705b2f-8f83-4aba-bca4-b2913c148a50; actionType=CancelChangesClientAction; summary=CancelChangesClientAction
- actionId=3ad719e1-08e1-44ff-b6b9-4dbfc12fe1b2; actionType=MicroflowClientAction; flow=Inspection.ACT_Report_Generate; summary=MicroflowClientAction, flow=Inspection.ACT_Report_Generate
- actionId=83cbf178-285b-4889-a6a7-e92721ed746c; actionType=MicroflowClientAction; flow=Inspection.ACT_Report_ApplyFilters; summary=MicroflowClientAction, flow=Inspection.ACT_Report_ApplyFilters
- actionId=02d4e8c5-d0eb-4084-97fb-1be159976b83; actionType=NoClientAction; summary=NoClientAction
- actionId=1ab03b4c-176c-4695-848e-c9fa6430aa0e; actionType=NoClientAction; summary=NoClientAction

## Shown by Flows

- Inspection.ACT_ReportHelper_Create

## Navigation/Homepage Provenance

- No navigation or homepage provenance was exported; the clearest exported evidence is the flow link shown above.

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/pages/inspection-report-newedit.json)
- Aggregate export: [pages.json](../../../../../mendix-data-p05-legacy/app-overview/cli_2026-03-18T20-44-56.522Z/modules/Inspection/pages.json)
- Aggregate pseudo: [pages.pseudo.txt](../../../../../mendix-data-p05-legacy/app-overview/cli_2026-03-18T20-44-56.522Z/modules/Inspection/pages.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-44-56.522Z
