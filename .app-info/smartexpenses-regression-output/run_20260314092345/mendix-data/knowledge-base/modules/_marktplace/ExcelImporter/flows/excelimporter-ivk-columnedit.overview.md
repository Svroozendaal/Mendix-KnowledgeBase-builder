---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.IVK_ColumnEdit
stableId: 46aafb28-57ad-48d3-ac91-551220f8c340
slug: excelimporter-ivk-columnedit
layer: L1
l0: excelimporter-ivk-columnedit.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ivk-columnedit.json
l2Logical: flow:ExcelImporter.IVK_ColumnEdit
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.IVK_ColumnEdit

## Summary

- Likely acts as a UI entry or navigation handler because it shows ExcelImporter.Column_NewEdit.
- L0: [abstract](excelimporter-ivk-columnedit.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ivk-columnedit.json)

## Main Steps

- $EnclosingContext/ExcelImporter.Template_MxObjectType != empty has object type expression=$EnclosingContext/ExcelImporter.Template_MxObjectType != empty
- ShowPageAction: show page ExcelImporter.Column_NewEdit show page ExcelImporter.Column_NewEdit

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: Shows ExcelImporter.Column_NewEdit.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- ExcelImporter.Column_NewEdit

## Important Retrieves/Decisions/Mutations

- nodeId=9f81b446-7892-47ab-9b93-2be9b3931d69; caption=has object type; expression=$EnclosingContext/ExcelImporter.Template_MxObjectType != empty has object type expression=$EnclosingContext/ExcelImporter.Template_MxObjectType != empty

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ivk-columnedit.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
