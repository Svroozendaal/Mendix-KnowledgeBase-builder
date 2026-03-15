---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.Ch_FindAttribute_Reference
stableId: 1f7c9cce-9a66-474b-beb8-300c52053f52
slug: excelimporter-ch-findattribute-reference
layer: L1
l0: excelimporter-ch-findattribute-reference.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ch-findattribute-reference.json
l2Logical: flow:ExcelImporter.Ch_FindAttribute_Reference
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.Ch_FindAttribute_Reference

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](excelimporter-ch-findattribute-reference.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ch-findattribute-reference.json)

## Main Steps

- retrieve MxObjectType over association Column_MxObjectType_Reference from Column
- $Member != empty found? expression=$Member != empty
- $MxObjectType != empty found? expression=$MxObjectType != empty
- ChangeObjectAction: change Column (Column_MxObjectMember=empty, AttributeTypeEnum=empty; refreshInClient=true) change Column (Column_MxObjectMember=empty, AttributeTypeEnum=empty; refreshInClient=true)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: MxModelReflection.FindMember
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=d8127e28-cf5b-47cb-bcd6-901671e1566f; sourceKind=Association; association=Column_MxObjectType_Reference; summary=retrieve MxObjectType over association Column_MxObjectType_Reference from Column
- nodeId=d152a7a7-d856-4bab-9b8a-4f5d00e016f4; caption=found?; expression=$Member != empty found? expression=$Member != empty
- nodeId=59114b51-7e3f-4e5e-bd3a-74300f3b3a83; caption=found?; expression=$MxObjectType != empty found? expression=$MxObjectType != empty
- nodeId=49a4c6f8-37d1-46c5-8ac1-afd33a0092d1; caption=has attr search string; expression=$Column/FindAttribute != empty and $Column/FindAttribute != '' has attr search string expression=$Column/FindAttribute != empty and $Column/FindAttribute != ''
- nodeId=45ca721c-8d62-42ef-b397-a3b6da5b2a07; actionKind=Change; members=Column_MxObjectMember=empty, AttributeTypeEnum=empty; refreshInClient=true; summary=ChangeObjectAction: change Column (Column_MxObjectMember=empty, AttributeTypeEnum=empty; refreshInClient=true) change Column (Column_MxObjectMember=empty, AttributeTypeEnum=empty; refreshInClient=true)
- nodeId=d0a49e14-4ffd-42b4-8d35-35f07a0b4659; actionKind=Change; members=Column_MxObjectMember=empty, AttributeTypeEnum=empty; refreshInClient=true; summary=ChangeObjectAction: change Column (Column_MxObjectMember=empty, AttributeTypeEnum=empty; refreshInClient=true) change Column (Column_MxObjectMember=empty, AttributeTypeEnum=empty; refreshInClient=true)
- nodeId=7829631a-60ac-41b3-b530-f999008f5daf; actionKind=Change; members=FindAttribute=$Member/AttributeName, Column_MxObjectMember_Reference=$Member, AttributeTypeEnum=$Member/AttributeTypeEnum; refreshInClient=true; summary=ChangeObjectAction: change Column (FindAttribute=$Member/AttributeName, Column_MxObjectMember_Reference=$Member, AttributeTypeEnum=$Member/AttributeTypeEnum; refreshInClient=true) change Column (FindAttribute=$Member/AttributeName, Column_MxObjectMember_Reference=$Member, AttributeTypeEnum=$Member/AttributeTypeEnum; refreshInClient=true)

## Warnings/Unknowns

- Rollback hint detected in node detail.
- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ch-findattribute-reference.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
