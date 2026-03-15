---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.Ch_FindAttribute
stableId: 29763fb6-72a8-4880-9e41-6f9913b71e09
slug: excelimporter-ch-findattribute
layer: L1
l0: excelimporter-ch-findattribute.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ch-findattribute.json
l2Logical: flow:ExcelImporter.Ch_FindAttribute
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.Ch_FindAttribute

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](excelimporter-ch-findattribute.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ch-findattribute.json)

## Main Steps

- retrieve MxObjectType over association Column_MxObjectType from Column
- $Member != empty found? expression=$Member != empty
- $Column/FindAttribute != empty and $Column/FindAttribute != '' has attr search string expression=$Column/FindAttribute != empty and $Column/FindAttribute != ''
- ChangeObjectAction: change Column (Column_MxObjectMember=$Member, FindAttribute=$Member/AttributeName, AttributeTypeEnum=$Member/AttributeTypeEnum; refreshInClient=true) change Column (Column_MxObjectMember=$Member, FindAttribute=$Member/AttributeName, AttributeTypeEnum=$Member/AttributeTypeEnum; refreshInClient=true)
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

- nodeId=dc2b2c93-fce5-4ee9-9043-6efae9462a0a; sourceKind=Association; association=Column_MxObjectType; summary=retrieve MxObjectType over association Column_MxObjectType from Column
- nodeId=c6456168-addb-4d31-a4d9-9eaa2787db82; caption=found?; expression=$Member != empty found? expression=$Member != empty
- nodeId=99390835-c0b3-4c53-a25f-8bdfe04cdcb3; caption=has attr search string; expression=$Column/FindAttribute != empty and $Column/FindAttribute != '' has attr search string expression=$Column/FindAttribute != empty and $Column/FindAttribute != ''
- nodeId=e8768d99-bc21-4825-82ba-5dd68b655305; actionKind=Change; members=Column_MxObjectMember=$Member, FindAttribute=$Member/AttributeName, AttributeTypeEnum=$Member/AttributeTypeEnum; refreshInClient=true; summary=ChangeObjectAction: change Column (Column_MxObjectMember=$Member, FindAttribute=$Member/AttributeName, AttributeTypeEnum=$Member/AttributeTypeEnum; refreshInClient=true) change Column (Column_MxObjectMember=$Member, FindAttribute=$Member/AttributeName, AttributeTypeEnum=$Member/AttributeTypeEnum; refreshInClient=true)
- nodeId=4cfda083-2aee-46a3-9601-fd8e01038441; actionKind=Change; members=Column_MxObjectMember=empty, AttributeTypeEnum=empty; refreshInClient=true; summary=ChangeObjectAction: change Column (Column_MxObjectMember=empty, AttributeTypeEnum=empty; refreshInClient=true) change Column (Column_MxObjectMember=empty, AttributeTypeEnum=empty; refreshInClient=true)
- nodeId=752ceccd-e241-428d-a4e9-00da5aece2c7; actionKind=Change; members=Column_MxObjectMember=empty, AttributeTypeEnum=empty; refreshInClient=true; summary=ChangeObjectAction: change Column (Column_MxObjectMember=empty, AttributeTypeEnum=empty; refreshInClient=true) change Column (Column_MxObjectMember=empty, AttributeTypeEnum=empty; refreshInClient=true)

## Warnings/Unknowns

- Rollback hint detected in node detail.
- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ch-findattribute.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
