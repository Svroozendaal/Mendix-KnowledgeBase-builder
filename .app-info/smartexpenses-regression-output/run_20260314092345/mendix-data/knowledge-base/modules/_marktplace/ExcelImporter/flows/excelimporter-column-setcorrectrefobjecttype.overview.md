---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.Column_SetCorrectRefObjectType
stableId: a69ce0bb-f6d7-4270-9f53-a77700eaa470
slug: excelimporter-column-setcorrectrefobjecttype
layer: L1
l0: excelimporter-column-setcorrectrefobjecttype.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-column-setcorrectrefobjecttype.json
l2Logical: flow:ExcelImporter.Column_SetCorrectRefObjectType
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.Column_SetCorrectRefObjectType

## Summary

- Likely acts as a save, process, or background step for MxModelReflection.MxObjectType because it mutates data without showing a page.
- L0: [abstract](excelimporter-column-setcorrectrefobjecttype.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-column-setcorrectrefobjecttype.json)

## Main Steps

- retrieve MxObjects from MxModelReflection.MxObjectType
- retrieve MxObject_Ref over association Column_MxObjectType_Reference from Column
- $NrOfObjects > 2 > 2 expression=$NrOfObjects > 2
- $MxObject_Ref != empty already has objecttype? expression=$MxObject_Ref != empty
- ChangeObjectAction: change Column (Column_MxObjectType_Reference=$Iterator; refreshInClient=true) change Column (Column_MxObjectType_Reference=$Iterator; refreshInClient=true)
- ChangeObjectAction: change Column (Column_MxObjectType_Reference=empty; refreshInClient=true) change Column (Column_MxObjectType_Reference=empty; refreshInClient=true)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by ExcelImporter.Ch_Column_SetDefaultObject, ExcelImporter.Ch_FindReference.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- MxModelReflection.MxObjectType

## Called / Called By

- Calls: ExcelImporter.Ch_SetObjectType_Reference
- Called by: ExcelImporter.Ch_Column_SetDefaultObject, ExcelImporter.Ch_FindReference

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=d1c1228a-77ec-4790-b3aa-410308d131cd; sourceKind=Database; entity=MxModelReflection.MxObjectType; summary=retrieve MxObjects from MxModelReflection.MxObjectType
- nodeId=0325ea93-d672-4161-8238-ba3c98ebdfa0; sourceKind=Association; association=Column_MxObjectType_Reference; summary=retrieve MxObject_Ref over association Column_MxObjectType_Reference from Column
- nodeId=ac78b7f8-0602-4c76-a9e6-49141f0dfccf; caption=> 2; expression=$NrOfObjects > 2 > 2 expression=$NrOfObjects > 2
- nodeId=db7d2bee-ae69-45ff-8419-400c676faff8; caption=already has objecttype?; expression=$MxObject_Ref != empty already has objecttype? expression=$MxObject_Ref != empty
- nodeId=c4fe81c5-b558-4474-8c15-5fef3c2e0c7a; caption=none; expression=$Iterator != $StartMxObjectType expression=$Iterator != $StartMxObjectType
- nodeId=fc5ec24c-dd6c-4bb5-84eb-2da2d8d86e31; caption=valid?; expression=$SelectionIsValid valid? expression=$SelectionIsValid
- nodeId=8d87e0bb-71bd-44f3-9cf7-010002931dbe; actionKind=Change; members=Column_MxObjectType_Reference=$Iterator; refreshInClient=true; summary=ChangeObjectAction: change Column (Column_MxObjectType_Reference=$Iterator; refreshInClient=true) change Column (Column_MxObjectType_Reference=$Iterator; refreshInClient=true)
- nodeId=3aa1daf2-99be-40b3-9fe1-bebc4c7d51c0; actionKind=Change; members=Column_MxObjectType_Reference=empty; refreshInClient=true; summary=ChangeObjectAction: change Column (Column_MxObjectType_Reference=empty; refreshInClient=true) change Column (Column_MxObjectType_Reference=empty; refreshInClient=true)

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-column-setcorrectrefobjecttype.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
