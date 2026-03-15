---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.IVK_SaveNewTemplate
stableId: 2ae721b0-b8c9-4899-a9b3-10bbf1ef17f0
slug: excelimporter-ivk-savenewtemplate
layer: L1
l0: excelimporter-ivk-savenewtemplate.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ivk-savenewtemplate.json
l2Logical: flow:ExcelImporter.IVK_SaveNewTemplate
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.IVK_SaveNewTemplate

## Summary

- Likely acts as a UI entry or navigation handler because it shows ExcelImporter.Template_Edit.
- L0: [abstract](excelimporter-ivk-savenewtemplate.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ivk-savenewtemplate.json)

## Main Steps

- $Valid valid? expression=$Valid
- ShowPageAction: show page ExcelImporter.Template_Edit show page ExcelImporter.Template_Edit

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by ExcelImporter.IVK_SaveNewTemplate_CreateColumns.
- Output/UI context: Shows ExcelImporter.Template_Edit.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: ExcelImporter.IVK_SaveTemplate
- Called by: ExcelImporter.IVK_SaveNewTemplate_CreateColumns

## Shown Pages

- ExcelImporter.Template_Edit

## Important Retrieves/Decisions/Mutations

- nodeId=01d437d4-1b67-4fb5-b9a5-8d5482ca5a24; caption=valid?; expression=$Valid valid? expression=$Valid

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ivk-savenewtemplate.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
