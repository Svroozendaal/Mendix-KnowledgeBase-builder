---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.Ch_Column_SetDefaultObject
stableId: 5c8774ed-1423-4d50-acbb-8d7aa30892c9
slug: excelimporter-ch-column-setdefaultobject
layer: L1
l0: excelimporter-ch-column-setdefaultobject.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ch-column-setdefaultobject.json
l2Logical: flow:ExcelImporter.Ch_Column_SetDefaultObject
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.Ch_Column_SetDefaultObject

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](excelimporter-ch-column-setdefaultobject.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ch-column-setdefaultobject.json)

## Main Steps

- retrieve MxObjectType over association Column_MxObjectType from Columns
- retrieve Reference over association Column_MxObjectReference from Columns
- $Reference != empty found? expression=$Reference != empty
- ChangeObjectAction: change Columns (Column_MxObjectType_Reference=empty, Column_MxObjectMember_Reference=empty; refreshInClient=true) change Columns (Column_MxObjectType_Reference=empty, Column_MxObjectMember_Reference=empty; refreshInClient=true)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: ExcelImporter.Ch_SetReference, ExcelImporter.Column_SetCorrectRefObjectType
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=aec5dac4-ee2d-4db5-8a9a-0b79feb83509; sourceKind=Association; association=Column_MxObjectType; summary=retrieve MxObjectType over association Column_MxObjectType from Columns
- nodeId=14d4c270-4012-4814-9ca5-2ebcd2941a6b; sourceKind=Association; association=Column_MxObjectReference; summary=retrieve Reference over association Column_MxObjectReference from Columns
- nodeId=d144fafa-c023-45cd-9e82-3be1a20e0cad; caption=found?; expression=$Reference != empty found? expression=$Reference != empty
- nodeId=2bfcc5c4-4d62-409c-813a-3d8242455dd5; actionKind=Change; members=Column_MxObjectType_Reference=empty, Column_MxObjectMember_Reference=empty; refreshInClient=true; summary=ChangeObjectAction: change Columns (Column_MxObjectType_Reference=empty, Column_MxObjectMember_Reference=empty; refreshInClient=true) change Columns (Column_MxObjectType_Reference=empty, Column_MxObjectMember_Reference=empty; refreshInClient=true)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ch-column-setdefaultobject.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
