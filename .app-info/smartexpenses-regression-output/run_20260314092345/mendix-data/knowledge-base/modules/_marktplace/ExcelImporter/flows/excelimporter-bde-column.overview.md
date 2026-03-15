---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.BDe_Column
stableId: 5f023a9b-6bb1-48cb-b178-6054dd9b884b
slug: excelimporter-bde-column
layer: L1
l0: excelimporter-bde-column.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-bde-column.json
l2Logical: flow:ExcelImporter.BDe_Column
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.BDe_Column

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](excelimporter-bde-column.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-bde-column.json)

## Main Steps

- ChangeObjectAction: change Column (Column_MxObjectType_Reference=empty, Column_MxObjectType=empty, Column_MxObjectMember=empty, Column_MxObjectMember_Reference=empty, Column_MxObjectReference=empty, MappingType=ExcelImporter.MappingType.DoNotUse; refreshInClient=false) change Column (Column_MxObjectType_Reference=empty, Column_MxObjectType=empty, Column_MxObjectMember=empty, Column_MxObjectMember_Reference=empty, Column_MxObjectReference=empty, MappingType=ExcelImporter.MappingType.DoNotUse; refreshInClient=false)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: ExcelImporter.prepareReferenceHandling
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=28dd6c2f-8394-4b9b-b84a-f759e76a0157; actionKind=Change; entity=ExcelImporter.MappingType; members=Column_MxObjectType_Reference=empty, Column_MxObjectType=empty, Column_MxObjectMember=empty, Column_MxObjectMember_Reference=empty, Column_MxObjectReference=empty, MappingType=ExcelImporter.MappingType.DoNotUse; refreshInClient=false; summary=ChangeObjectAction: change Column (Column_MxObjectType_Reference=empty, Column_MxObjectType=empty, Column_MxObjectMember=empty, Column_MxObjectMember_Reference=empty, Column_MxObjectReference=empty, MappingType=ExcelImporter.MappingType.DoNotUse; refreshInClient=false) change Column (Column_MxObjectType_Reference=empty, Column_MxObjectType=empty, Column_MxObjectMember=empty, Column_MxObjectMember_Reference=empty, Column_MxObjectReference=empty, MappingType=ExcelImporter.MappingType.DoNotUse; refreshInClient=false)

## Warnings/Unknowns

- Rollback hint detected in node detail.
- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-bde-column.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
