---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.Sub_CreateColumnsFromTemplate
stableId: a6ae33cc-553c-4c24-9775-3764c39b4b7e
slug: excelimporter-sub-createcolumnsfromtemplate
layer: L1
l0: excelimporter-sub-createcolumnsfromtemplate.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-sub-createcolumnsfromtemplate.json
l2Logical: flow:ExcelImporter.Sub_CreateColumnsFromTemplate
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.Sub_CreateColumnsFromTemplate

## Summary

- Likely acts as a save, process, or background step for ExcelImporter.Column, MxModelReflection.MxObjectMember because it mutates data without showing a page.
- L0: [abstract](excelimporter-sub-createcolumnsfromtemplate.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-sub-createcolumnsfromtemplate.json)

## Main Steps

- retrieve ColumnList over association Column_Template from Template
- retrieve MemberList from MxModelReflection.MxObjectMember
- $Column != empty found? expression=$Column != empty
- ChangeListAction: change ColumnList (type=Add, value=$NewColumn) change ColumnList (type=Add, value=$NewColumn)
- ChangeObjectAction: change Column (MappingType=ExcelImporter.MappingType.Attribute, FindAttribute=$Member/AttributeName, Column_MxObjectMember=$Member, Column_MxObjectType=$MxObjectType; refreshInClient=false) change Column (MappingType=ExcelImporter.MappingType.Attribute, FindAttribute=$Member/AttributeName, Column_MxObjectMember=$Member, Column_MxObjectType=$MxObjectType; refreshInClient=false)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by ExcelImporter.IVK_SaveNewTemplate_CreateColumns.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- ExcelImporter.Column, MxModelReflection.MxObjectMember

## Called / Called By

- Calls: none
- Called by: ExcelImporter.IVK_SaveNewTemplate_CreateColumns

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=b48700e8-0391-4a1d-bea8-87db0e17754d; sourceKind=Association; association=Column_Template; summary=retrieve ColumnList over association Column_Template from Template
- nodeId=a5e8fbf3-18b2-4c6e-af84-cd0c2e35abeb; sourceKind=Database; entity=MxModelReflection.MxObjectMember; summary=retrieve MemberList from MxModelReflection.MxObjectMember
- nodeId=e39904a8-a535-452f-a21b-dbeca2b43670; sourceKind=Association; association=Template_MxObjectType; summary=retrieve MxObjectType over association Template_MxObjectType from Template
- nodeId=bd872bc9-9881-451a-ba8c-d6edac23c65f; caption=found?; expression=$Column != empty found? expression=$Column != empty
- nodeId=6efea842-cebd-4055-916b-82655bfb36c6; actionKind=Change; members=type=Add, value=$NewColumn; summary=ChangeListAction: change ColumnList (type=Add, value=$NewColumn) change ColumnList (type=Add, value=$NewColumn)
- nodeId=282e5e94-7b0d-4aa2-a64d-3621e101a356; actionKind=Change; entity=ExcelImporter.MappingType; members=MappingType=ExcelImporter.MappingType.Attribute, FindAttribute=$Member/AttributeName, Column_MxObjectMember=$Member, Column_MxObjectType=$MxObjectType; refreshInClient=false; summary=ChangeObjectAction: change Column (MappingType=ExcelImporter.MappingType.Attribute, FindAttribute=$Member/AttributeName, Column_MxObjectMember=$Member, Column_MxObjectType=$MxObjectType; refreshInClient=false) change Column (MappingType=ExcelImporter.MappingType.Attribute, FindAttribute=$Member/AttributeName, Column_MxObjectMember=$Member, Column_MxObjectType=$MxObjectType; refreshInClient=false)
- nodeId=e8a5f547-c177-4287-85d9-cd68cae0ddd8; actionKind=Change; summary=ChangeVariableAction: change variable NextColNumber=if $NextColNumber = empty then 0 else $NextColNumber + 1 change variable NextColNumber=if $NextColNumber = empty then 0 else $NextColNumber + 1
- nodeId=b6072fbd-904c-49e6-9745-ef27afcbb280; actionKind=Commit; members=refreshInClient=true, withEvents=true; summary=CommitAction: commit ColumnList (refreshInClient=true, withEvents=true) commit ColumnList (refreshInClient=true, withEvents=true)

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-sub-createcolumnsfromtemplate.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
