---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.BCo_Column
stableId: d24c1194-6877-430a-a049-2704d54ca335
slug: excelimporter-bco-column
layer: L1
l0: excelimporter-bco-column.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-bco-column.json
l2Logical: flow:ExcelImporter.BCo_Column
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.BCo_Column

## Summary

- Likely acts as a save, process, or background step for ExcelImporter.Column because it mutates data without showing a page.
- L0: [abstract](excelimporter-bco-column.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-bco-column.json)

## Main Steps

- retrieve DuplicateMapping from ExcelImporter.Column
- retrieve Template over association Column_Template from pColumn
- decision decision
- $DuplicateMapping != empty found? expression=$DuplicateMapping != empty
- ChangeObjectAction: change pColumn (FindAttribute=empty, FindReference=empty, FindObjectType=empty, FindMicroflow=empty, Column_MxObjectType_Reference=empty, Column_MxObjectMember=empty, Column_MxObjectMember_Reference=empty, Column_MxObjectReference=empty, +4 more; refreshInClient=false) change pColumn (FindAttribute=empty, FindReference=empty, FindObjectType=empty, FindMicroflow=empty, Column_MxObjectType_Reference=empty, Column_MxObjectMember=empty, Column_MxObjectMember_Reference=empty, Column_MxObjectReference=empty, +4 more; refreshInClient=false)
- ChangeObjectAction: change pColumn (IsReferenceKey=if( $pColumn/MappingType = ExcelImporter.MappingType.Attribute ) then if( $pColumn/IsKey = ExcelImporter.YesNo.Yes ) then ExcelImporter.ReferenceKeyType.YesOnlyMainObject else Exce...; refreshInClient=false) change pColumn (IsReferenceKey=if( $pColumn/MappingType = ExcelImporter.MappingType.Attribute ) then if( $pColumn/IsKey = ExcelImporter.YesNo.Yes ) then ExcelImporter.ReferenceKeyType.YesOnlyMainObject else Exce...; refreshInClient=false)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by ExcelImporter.IVK_Column_Save.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- ExcelImporter.Column

## Called / Called By

- Calls: ExcelImporter.Column_SetDetails, ExcelImporter.prepareReferenceHandling
- Called by: ExcelImporter.IVK_Column_Save

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=0cc87de0-9346-4662-b9ae-55ebafecbfdb; sourceKind=Database; entity=ExcelImporter.Column; summary=retrieve DuplicateMapping from ExcelImporter.Column
- nodeId=eac0132a-6344-41a8-bc57-1907ec43312f; sourceKind=Association; association=Column_Template; summary=retrieve Template over association Column_Template from pColumn
- nodeId=d3549ade-123f-4593-bc4a-b226d0122e53; caption=found?; expression=$DuplicateMapping != empty found? expression=$DuplicateMapping != empty
- nodeId=a37e50fb-d53a-40ea-bc58-66885adab6d2; actionKind=Change; members=FindAttribute=empty, FindReference=empty, FindObjectType=empty, FindMicroflow=empty, Column_MxObjectType_Reference=empty, Column_MxObjectMember=empty, Column_MxObjectMember_Reference=empty, Column_MxObjectReference=empty, +4 more; refreshInClient=false; summary=ChangeObjectAction: change pColumn (FindAttribute=empty, FindReference=empty, FindObjectType=empty, FindMicroflow=empty, Column_MxObjectType_Reference=empty, Column_MxObjectMember=empty, Column_MxObjectMember_Reference=empty, Column_MxObjectReference=empty, +4 more; refreshInClient=false) change pColumn (FindAttribute=empty, FindReference=empty, FindObjectType=empty, FindMicroflow=empty, Column_MxObjectType_Reference=empty, Column_MxObjectMember=empty, Column_MxObjectMember_Reference=empty, Column_MxObjectReference=empty, +4 more; refreshInClient=false)
- nodeId=7f3c040d-14e2-47af-9fb2-9963f685c89e; actionKind=Change; entity=ExcelImporter.MappingType; members=IsReferenceKey=if( $pColumn/MappingType = ExcelImporter.MappingType.Attribute; summary=ChangeObjectAction: change pColumn (IsReferenceKey=if( $pColumn/MappingType = ExcelImporter.MappingType.Attribute ) then if( $pColumn/IsKey = ExcelImporter.YesNo.Yes ) then ExcelImporter.ReferenceKeyType.YesOnlyMainObject else Exce...; refreshInClient=false) change pColumn (IsReferenceKey=if( $pColumn/MappingType = ExcelImporter.MappingType.Attribute ) then if( $pColumn/IsKey = ExcelImporter.YesNo.Yes ) then ExcelImporter.ReferenceKeyType.YesOnlyMainObject else Exce...; refreshInClient=false)
- nodeId=82091648-410b-4547-9429-a95e7149ae5b; actionKind=Change; entity=ExcelImporter.Status; members=Status=ExcelImporter.Status.INFO; refreshInClient=false; summary=ChangeObjectAction: change pColumn (Status=ExcelImporter.Status.INFO; refreshInClient=false) change pColumn (Status=ExcelImporter.Status.INFO; refreshInClient=false)
- nodeId=1d9f73f9-137a-451b-90e3-2dec0bb8b067; actionKind=Change; entity=ExcelImporter.Status; members=Status=ExcelImporter.Status.VALID; refreshInClient=false; summary=ChangeObjectAction: change pColumn (Status=ExcelImporter.Status.VALID; refreshInClient=false) change pColumn (Status=ExcelImporter.Status.VALID; refreshInClient=false)

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-bco-column.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
