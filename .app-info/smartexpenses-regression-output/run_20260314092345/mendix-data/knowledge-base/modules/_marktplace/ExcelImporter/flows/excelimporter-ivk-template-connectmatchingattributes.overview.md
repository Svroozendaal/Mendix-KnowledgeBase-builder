---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.IVK_Template_ConnectMatchingAttributes
stableId: c8823650-2b64-4335-8e9d-1fed67fe0712
slug: excelimporter-ivk-template-connectmatchingattributes
layer: L1
l0: excelimporter-ivk-template-connectmatchingattributes.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ivk-template-connectmatchingattributes.json
l2Logical: flow:ExcelImporter.IVK_Template_ConnectMatchingAttributes
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.IVK_Template_ConnectMatchingAttributes

## Summary

- Likely acts as a save, process, or background step for ExcelImporter.Column, MxModelReflection.MxObjectMember because it mutates data without showing a page.
- L0: [abstract](excelimporter-ivk-template-connectmatchingattributes.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ivk-template-connectmatchingattributes.json)

## Main Steps

- retrieve ColumnList from ExcelImporter.Column
- retrieve MxObjectMemberList from MxModelReflection.MxObjectMember
- $count > 1 > 1 expression=$count > 1
- $Template/ExcelImporter.Template_MxObjectType != empty expression=$Template/ExcelImporter.Template_MxObjectType != empty
- ChangeObjectAction: change Column (MappingType=ExcelImporter.MappingType.Attribute, FindAttribute=$MxObjectMember/AttributeName, Column_MxObjectMember=$MxObjectMember; refreshInClient=true) change Column (MappingType=ExcelImporter.MappingType.Attribute, FindAttribute=$MxObjectMember/AttributeName, Column_MxObjectMember=$MxObjectMember; refreshInClient=true)
- ChangeObjectAction: change Column (MappingType=ExcelImporter.MappingType.Attribute, FindAttribute=$MxObjectMember_1/AttributeName, Column_MxObjectMember=$MxObjectMember_1; refreshInClient=true) change Column (MappingType=ExcelImporter.MappingType.Attribute, FindAttribute=$MxObjectMember_1/AttributeName, Column_MxObjectMember=$MxObjectMember_1; refreshInClient=true)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- ExcelImporter.Column, MxModelReflection.MxObjectMember

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=84e79b48-7d2e-4285-9322-863155cbb236; sourceKind=Database; entity=ExcelImporter.Column; summary=retrieve ColumnList from ExcelImporter.Column
- nodeId=b1a1ea96-266c-4953-8cd9-e8e3cf0af1fd; sourceKind=Database; entity=MxModelReflection.MxObjectMember; summary=retrieve MxObjectMemberList from MxModelReflection.MxObjectMember
- nodeId=880df351-4c57-47ae-a014-3f8de1639fd4; sourceKind=Association; association=Template_MxObjectType; summary=retrieve MxObjectType over association Template_MxObjectType from Template
- nodeId=5d58892c-7bdf-4baa-81cc-51def60ec46e; caption=> 1; expression=$count > 1 > 1 expression=$count > 1
- nodeId=be8d57be-8bba-4ea7-a595-865d2b47773a; caption=none; expression=$Template/ExcelImporter.Template_MxObjectType != empty expression=$Template/ExcelImporter.Template_MxObjectType != empty
- nodeId=4be1b644-050f-443e-ab00-cd2490dc75b9; caption=Matched?; expression=$MemberMatched Matched? expression=$MemberMatched
- nodeId=d5e5d77d-6b91-4670-b865-1861fe475e7a; caption=Names identical; expression=trim( toLowerCase( $MxObjectMember/AttributeName ) ) = trim( toLowerCase( $ColumnTitle ) ) Names identical expression=trim( toLowerCase( $MxObjectMember/AttributeName ) ) = trim( toLowerCase( $ColumnTitle ) )
- nodeId=3527fd8d-be08-4db3-88b3-69b8f56f9b74; actionKind=Change; entity=ExcelImporter.MappingType; members=MappingType=ExcelImporter.MappingType.Attribute, FindAttribute=$MxObjectMember/AttributeName, Column_MxObjectMember=$MxObjectMember; refreshInClient=true; summary=ChangeObjectAction: change Column (MappingType=ExcelImporter.MappingType.Attribute, FindAttribute=$MxObjectMember/AttributeName, Column_MxObjectMember=$MxObjectMember; refreshInClient=true) change Column (MappingType=ExcelImporter.MappingType.Attribute, FindAttribute=$MxObjectMember/AttributeName, Column_MxObjectMember=$MxObjectMember; refreshInClient=true)

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ivk-template-connectmatchingattributes.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
