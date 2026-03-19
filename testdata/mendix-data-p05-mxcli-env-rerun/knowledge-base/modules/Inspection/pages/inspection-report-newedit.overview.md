---
objectType: page
module: Inspection
qualifiedName: Inspection.Report_NewEdit
stableId: Inspection.Report_NewEdit
slug: inspection-report-newedit
layer: L1
l0: inspection-report-newedit.abstract.md
l2Path: ../../../../app-overview/current/modules/Inspection/pages/inspection-report-newedit.json
l2Logical: page:Inspection.Report_NewEdit
sourceRun: cli_2026-03-18T20-54-38.903Z
collectionL0: INDEX.abstract.md
collectionL1: ../PAGES.md
---
# Page Overview: Inspection.Report_NewEdit

## Summary

- Generate report. Likely supports create/edit interactions for report helper because it accepts page parameters.
- L0: [abstract](inspection-report-newedit.abstract.md)
- L2: [json](../../../../app-overview/current/modules/Inspection/pages/inspection-report-newedit.json)

## Roles and Entry Provenance

- Roles: Inspection.Administrator, Inspection.Manager
- Entry provenance: ShowPageAction

## Parameters

- ReportHelper:Inspection.ReportHelper

## Datasource Summary

- sourceId=dataView5; sourceType=Parameter; entity=Inspection.ReportHelper; summary=Parameter datasource: $ReportHelper

## Client Actions

- actionId=actionButton3; actionType=MicroflowClientAction; flow=Inspection.ACT_Report_Generate; summary=MicroflowClientAction, flow=Inspection.ACT_Report_Generate
- actionId=actionButton1; actionType=MicroflowClientAction; flow=Inspection.ACT_Report_ApplyFilters; summary=MicroflowClientAction, flow=Inspection.ACT_Report_ApplyFilters

## Shown by Flows

- Inspection.ACT_ReportHelper_Create

## Navigation/Homepage Provenance

- No navigation or homepage provenance was exported; the clearest exported evidence is the flow link shown above.

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/Inspection/pages/inspection-report-newedit.json)
- Aggregate export: [pages.json](../../../../app-overview/cli_2026-03-18T20-54-38.903Z/modules/Inspection/pages.json)
- Aggregate pseudo: [pages.pseudo.txt](../../../../app-overview/cli_2026-03-18T20-54-38.903Z/modules/Inspection/pages.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-54-38.903Z
