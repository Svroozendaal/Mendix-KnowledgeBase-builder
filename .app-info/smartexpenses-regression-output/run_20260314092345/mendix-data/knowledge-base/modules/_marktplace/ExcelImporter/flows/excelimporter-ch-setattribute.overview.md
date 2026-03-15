---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.Ch_SetAttribute
stableId: 45b17ae2-3011-49cd-adec-75c4e01dc7e0
slug: excelimporter-ch-setattribute
layer: L1
l0: excelimporter-ch-setattribute.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ch-setattribute.json
l2Logical: flow:ExcelImporter.Ch_SetAttribute
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.Ch_SetAttribute

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](excelimporter-ch-setattribute.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ch-setattribute.json)

## Main Steps

- retrieve Member over association Column_MxObjectMember from column
- $column/ExcelImporter.Column_MxObjectMember != empty has member selected expression=$column/ExcelImporter.Column_MxObjectMember != empty
- ChangeObjectAction: change column (FindAttribute=$Member/AttributeName, Column_ValueType=$Member/MxModelReflection.MxObjectMember_Type, AttributeTypeEnum=$Member/AttributeTypeEnum; refreshInClient=true) change column (FindAttribute=$Member/AttributeName, Column_ValueType=$Member/MxModelReflection.MxObjectMember_Type, AttributeTypeEnum=$Member/AttributeTypeEnum; refreshInClient=true)
- ChangeObjectAction: change column (FindAttribute=empty, Column_ValueType=empty, AttributeTypeEnum=empty; refreshInClient=true) change column (FindAttribute=empty, Column_ValueType=empty, AttributeTypeEnum=empty; refreshInClient=true)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=8e8cc7cc-4a79-4a6f-86c4-a15965db271c; sourceKind=Association; association=Column_MxObjectMember; summary=retrieve Member over association Column_MxObjectMember from column
- nodeId=9770192c-bf6d-4fec-98bc-92b8a9725cbf; caption=has member selected; expression=$column/ExcelImporter.Column_MxObjectMember != empty has member selected expression=$column/ExcelImporter.Column_MxObjectMember != empty
- nodeId=93d370cd-72ef-47cd-a5fc-52ff992a3385; actionKind=Change; entity=MxModelReflection.MxObjectMember_Type; members=FindAttribute=$Member/AttributeName, Column_ValueType=$Member/MxModelReflection.MxObjectMember_Type, AttributeTypeEnum=$Member/AttributeTypeEnum; refreshInClient=true; summary=ChangeObjectAction: change column (FindAttribute=$Member/AttributeName, Column_ValueType=$Member/MxModelReflection.MxObjectMember_Type, AttributeTypeEnum=$Member/AttributeTypeEnum; refreshInClient=true) change column (FindAttribute=$Member/AttributeName, Column_ValueType=$Member/MxModelReflection.MxObjectMember_Type, AttributeTypeEnum=$Member/AttributeTypeEnum; refreshInClient=true)
- nodeId=47a39b3c-5de0-43ea-a426-872f885f6d10; actionKind=Change; members=FindAttribute=empty, Column_ValueType=empty, AttributeTypeEnum=empty; refreshInClient=true; summary=ChangeObjectAction: change column (FindAttribute=empty, Column_ValueType=empty, AttributeTypeEnum=empty; refreshInClient=true) change column (FindAttribute=empty, Column_ValueType=empty, AttributeTypeEnum=empty; refreshInClient=true)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ch-setattribute.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
