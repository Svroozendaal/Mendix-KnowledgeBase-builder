---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.SetColumnStatus
stableId: b37d2b7d-e899-4147-a7fe-72535094fec0
slug: excelimporter-setcolumnstatus
layer: L1
l0: excelimporter-setcolumnstatus.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-setcolumnstatus.json
l2Logical: flow:ExcelImporter.SetColumnStatus
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.SetColumnStatus

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](excelimporter-setcolumnstatus.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-setcolumnstatus.json)

## Main Steps

- decision decision
- Validate the column Validate the column
- ChangeObjectAction: change Column (Status=ExcelImporter.Status.INFO; refreshInClient=false) change Column (Status=ExcelImporter.Status.INFO; refreshInClient=false)
- ChangeObjectAction: change Column (Status=ExcelImporter.Status.INVALID; refreshInClient=false) change Column (Status=ExcelImporter.Status.INVALID; refreshInClient=false)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by ExcelImporter.Ch_Template_ChangeObjectType, ExcelImporter.ValidateTemplate.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: ExcelImporter.Ch_Template_ChangeObjectType, ExcelImporter.ValidateTemplate

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=d247baa2-acf5-4f58-979e-56d8adb06550; actionKind=Change; entity=ExcelImporter.Status; members=Status=ExcelImporter.Status.INFO; refreshInClient=false; summary=ChangeObjectAction: change Column (Status=ExcelImporter.Status.INFO; refreshInClient=false) change Column (Status=ExcelImporter.Status.INFO; refreshInClient=false)
- nodeId=5f781036-186f-40fa-9985-a7b2d40a6d81; actionKind=Change; entity=ExcelImporter.Status; members=Status=ExcelImporter.Status.INVALID; refreshInClient=false; summary=ChangeObjectAction: change Column (Status=ExcelImporter.Status.INVALID; refreshInClient=false) change Column (Status=ExcelImporter.Status.INVALID; refreshInClient=false)
- nodeId=3893d5dc-e01f-4cc1-8398-33eee1379f0c; actionKind=Change; entity=ExcelImporter.Status; members=Status=ExcelImporter.Status.VALID; refreshInClient=false; summary=ChangeObjectAction: change Column (Status=ExcelImporter.Status.VALID; refreshInClient=false) change Column (Status=ExcelImporter.Status.VALID; refreshInClient=false)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-setcolumnstatus.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
