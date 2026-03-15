---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.Ch_SetObjectType_Reference
stableId: c408ed32-e684-426b-b414-60ccfc94f431
slug: excelimporter-ch-setobjecttype-reference
layer: L1
l0: excelimporter-ch-setobjecttype-reference.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ch-setobjecttype-reference.json
l2Logical: flow:ExcelImporter.Ch_SetObjectType_Reference
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.Ch_SetObjectType_Reference

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](excelimporter-ch-setobjecttype-reference.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ch-setobjecttype-reference.json)

## Main Steps

- retrieve MxObjectType over association Column_MxObjectType_Reference from column
- $column/ExcelImporter.Column_MxObjectType_Reference != empty has objecttype selected expression=$column/ExcelImporter.Column_MxObjectType_Reference != empty
- ChangeObjectAction: change column (FindObjectType=$MxObjectType/CompleteName; refreshInClient=true) change column (FindObjectType=$MxObjectType/CompleteName; refreshInClient=true)
- ChangeObjectAction: change column (FindObjectType=empty; refreshInClient=true) change column (FindObjectType=empty; refreshInClient=true)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by ExcelImporter.Column_SetCorrectRefObjectType.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: ExcelImporter.Column_SetCorrectRefObjectType

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=170d4705-14d0-422e-a551-e93571733bc9; sourceKind=Association; association=Column_MxObjectType_Reference; summary=retrieve MxObjectType over association Column_MxObjectType_Reference from column
- nodeId=4070b55a-2f55-471c-af4a-1510fdfdbf2b; caption=has objecttype selected; expression=$column/ExcelImporter.Column_MxObjectType_Reference != empty has objecttype selected expression=$column/ExcelImporter.Column_MxObjectType_Reference != empty
- nodeId=563e607e-171b-4aba-b6ad-29ea793c2d87; actionKind=Change; members=FindObjectType=$MxObjectType/CompleteName; refreshInClient=true; summary=ChangeObjectAction: change column (FindObjectType=$MxObjectType/CompleteName; refreshInClient=true) change column (FindObjectType=$MxObjectType/CompleteName; refreshInClient=true)
- nodeId=c696d122-2f1b-4df8-a35c-9a824047e9e7; actionKind=Change; members=FindObjectType=empty; refreshInClient=true; summary=ChangeObjectAction: change column (FindObjectType=empty; refreshInClient=true) change column (FindObjectType=empty; refreshInClient=true)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ch-setobjecttype-reference.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
