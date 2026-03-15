---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.Ch_SetAttribute_Reference
stableId: 6df2e8f6-c7b5-4d4e-988c-e3a5f2c702bf
slug: excelimporter-ch-setattribute-reference
layer: L1
l0: excelimporter-ch-setattribute-reference.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ch-setattribute-reference.json
l2Logical: flow:ExcelImporter.Ch_SetAttribute_Reference
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.Ch_SetAttribute_Reference

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](excelimporter-ch-setattribute-reference.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ch-setattribute-reference.json)

## Main Steps

- retrieve Member over association Column_MxObjectMember_Reference from column
- $column/ExcelImporter.Column_MxObjectMember_Reference != empty has member selected expression=$column/ExcelImporter.Column_MxObjectMember_Reference != empty
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

- nodeId=284ad92e-a467-4d32-9158-a2968ca30203; sourceKind=Association; association=Column_MxObjectMember_Reference; summary=retrieve Member over association Column_MxObjectMember_Reference from column
- nodeId=72661382-19f9-4eac-8f00-392d6bb93f63; caption=has member selected; expression=$column/ExcelImporter.Column_MxObjectMember_Reference != empty has member selected expression=$column/ExcelImporter.Column_MxObjectMember_Reference != empty
- nodeId=da6e91bd-2c21-40df-b038-31f205e0b0d5; actionKind=Change; entity=MxModelReflection.MxObjectMember_Type; members=FindAttribute=$Member/AttributeName, Column_ValueType=$Member/MxModelReflection.MxObjectMember_Type, AttributeTypeEnum=$Member/AttributeTypeEnum; refreshInClient=true; summary=ChangeObjectAction: change column (FindAttribute=$Member/AttributeName, Column_ValueType=$Member/MxModelReflection.MxObjectMember_Type, AttributeTypeEnum=$Member/AttributeTypeEnum; refreshInClient=true) change column (FindAttribute=$Member/AttributeName, Column_ValueType=$Member/MxModelReflection.MxObjectMember_Type, AttributeTypeEnum=$Member/AttributeTypeEnum; refreshInClient=true)
- nodeId=caa7af78-663e-46c0-ad69-49879b61f524; actionKind=Change; members=FindAttribute=empty, Column_ValueType=empty, AttributeTypeEnum=empty; refreshInClient=true; summary=ChangeObjectAction: change column (FindAttribute=empty, Column_ValueType=empty, AttributeTypeEnum=empty; refreshInClient=true) change column (FindAttribute=empty, Column_ValueType=empty, AttributeTypeEnum=empty; refreshInClient=true)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ch-setattribute-reference.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
