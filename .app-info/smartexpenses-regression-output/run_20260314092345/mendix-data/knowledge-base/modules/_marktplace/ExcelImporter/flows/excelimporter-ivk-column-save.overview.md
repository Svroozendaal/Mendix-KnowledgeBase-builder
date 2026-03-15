---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.IVK_Column_Save
stableId: 99ee71b4-5312-49a8-b7a6-b4e29ad263ef
slug: excelimporter-ivk-column-save
layer: L1
l0: excelimporter-ivk-column-save.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ivk-column-save.json
l2Logical: flow:ExcelImporter.IVK_Column_Save
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.IVK_Column_Save

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](excelimporter-ivk-column-save.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ivk-column-save.json)

## Main Steps

- $Column/DataSource Datasource expression=$Column/DataSource
- $Column/ExcelImporter.Column_MxObjectMember != empty has attribute? expression=$Column/ExcelImporter.Column_MxObjectMember != empty
- ChangeObjectAction: change Column (IsKey=ExcelImporter.YesNo.No, IsReferenceKey=ExcelImporter.ReferenceKeyType.NoKey, ColNumber=999; refreshInClient=false) change Column (IsKey=ExcelImporter.YesNo.No, IsReferenceKey=ExcelImporter.ReferenceKeyType.NoKey, ColNumber=999; refreshInClient=false)
- ChangeObjectAction: change Column (refreshInClient=true) change Column (refreshInClient=true)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: ExcelImporter.BCo_Column
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=3b920a83-c014-4bf0-9c39-a59d7aa1e266; caption=Datasource; expression=$Column/DataSource Datasource expression=$Column/DataSource
- nodeId=ed249808-9700-477f-b911-e1cd72d14e07; caption=has attribute?; expression=$Column/ExcelImporter.Column_MxObjectMember != empty has attribute? expression=$Column/ExcelImporter.Column_MxObjectMember != empty
- nodeId=435d6ea5-3684-42f4-a8f4-013db9940f97; caption=has col number?; expression=$Column/ColNumber != empty has col number? expression=$Column/ColNumber != empty
- nodeId=15a06fc5-8a4b-4cd8-acbd-40c300dfb8ba; caption=has key?; expression=$Column/IsKey != empty has key? expression=$Column/IsKey != empty
- nodeId=2e0ed2d5-ff67-477b-9e56-163cb2127b49; caption=has ref attribute?; expression=$Column/ExcelImporter.Column_MxObjectMember_Reference != empty has ref attribute? expression=$Column/ExcelImporter.Column_MxObjectMember_Reference != empty
- nodeId=4df3b0dd-4ea5-406f-bcba-390dddbe9ebe; caption=has ref key?; expression=$Column/IsReferenceKey != empty has ref key? expression=$Column/IsReferenceKey != empty
- nodeId=e0a33971-2c2b-452f-9985-99d22ed5b90f; caption=has ref object?; expression=$Column/ExcelImporter.Column_MxObjectType_Reference != empty has ref object? expression=$Column/ExcelImporter.Column_MxObjectType_Reference != empty
- nodeId=2eddea1f-1198-42b7-804f-cf25d2af405e; caption=has reference?; expression=$Column/ExcelImporter.Column_MxObjectReference != empty has reference? expression=$Column/ExcelImporter.Column_MxObjectReference != empty

## Warnings/Unknowns

- Rollback hint detected in node detail.
- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ivk-column-save.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
