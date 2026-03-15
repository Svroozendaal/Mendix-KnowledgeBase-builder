---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.Ch_FindObjectType_Reference
stableId: 401d8324-d413-40e1-88b2-4c8c49879973
slug: excelimporter-ch-findobjecttype-reference
layer: L1
l0: excelimporter-ch-findobjecttype-reference.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ch-findobjecttype-reference.json
l2Logical: flow:ExcelImporter.Ch_FindObjectType_Reference
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.Ch_FindObjectType_Reference

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](excelimporter-ch-findobjecttype-reference.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ch-findobjecttype-reference.json)

## Main Steps

- retrieve Reference over association Column_MxObjectReference from Column
- $ObjectType != empty found? expression=$ObjectType != empty
- $Column/FindReference != empty and $Column/FindReference != '' has object search string expression=$Column/FindReference != empty and $Column/FindReference != ''
- ChangeObjectAction: change Column (Column_MxObjectType_Reference=empty; refreshInClient=true) change Column (Column_MxObjectType_Reference=empty; refreshInClient=true)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: MxModelReflection.FindObjectType
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=8e6b3a64-f369-415f-9de8-81fdb534b615; sourceKind=Association; association=Column_MxObjectReference; summary=retrieve Reference over association Column_MxObjectReference from Column
- nodeId=0a2b9e91-cd29-4b8e-8a91-73f405c5fc8b; caption=found?; expression=$ObjectType != empty found? expression=$ObjectType != empty
- nodeId=ed4551e3-60c8-4e9e-93ac-62912cdc56c3; caption=has object search string; expression=$Column/FindReference != empty and $Column/FindReference != '' has object search string expression=$Column/FindReference != empty and $Column/FindReference != ''
- nodeId=a61e3322-61b5-4403-b73b-301c0530fc73; actionKind=Change; members=Column_MxObjectType_Reference=empty; refreshInClient=true; summary=ChangeObjectAction: change Column (Column_MxObjectType_Reference=empty; refreshInClient=true) change Column (Column_MxObjectType_Reference=empty; refreshInClient=true)
- nodeId=dca44423-f37f-4e09-93a1-99e49474482f; actionKind=Change; members=Column_MxObjectType_Reference=empty; refreshInClient=true; summary=ChangeObjectAction: change Column (Column_MxObjectType_Reference=empty; refreshInClient=true) change Column (Column_MxObjectType_Reference=empty; refreshInClient=true)
- nodeId=77e2b2db-913c-4259-91c0-9891bb25fcf7; actionKind=Change; members=FindObjectType=$ObjectType/CompleteName, Column_MxObjectType_Reference=$ObjectType; refreshInClient=true; summary=ChangeObjectAction: change Column (FindObjectType=$ObjectType/CompleteName, Column_MxObjectType_Reference=$ObjectType; refreshInClient=true) change Column (FindObjectType=$ObjectType/CompleteName, Column_MxObjectType_Reference=$ObjectType; refreshInClient=true)

## Warnings/Unknowns

- Rollback hint detected in node detail.
- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ch-findobjecttype-reference.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
