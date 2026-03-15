---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.SetupColumn
stableId: c2bb5eaf-ca70-4e32-96ce-9ff464cbd23c
slug: excelimporter-setupcolumn
layer: L1
l0: excelimporter-setupcolumn.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-setupcolumn.json
l2Logical: flow:ExcelImporter.SetupColumn
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.SetupColumn

## Summary

- Likely acts as a save, process, or background step for ExcelImporter.Column because it mutates data without showing a page.
- L0: [abstract](excelimporter-setupcolumn.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-setupcolumn.json)

## Main Steps

- retrieve MxObjectType over association Template_MxObjectType from Template
- $Column != empty Found? expression=$Column != empty
- $MFName != empty has mf name? expression=$MFName != empty
- ChangeListAction: change ColumnList (type=Add, value=$NewColumn) change ColumnList (type=Add, value=$NewColumn)
- ChangeObjectAction: change Column (Column_Microflows=$Microflows; refreshInClient=false) change Column (Column_Microflows=$Microflows; refreshInClient=false)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by ExcelImporter.Example_SetupImportTemplate.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- ExcelImporter.Column

## Called / Called By

- Calls: MxModelReflection.FindMember, MxModelReflection.FindMicroflow
- Called by: ExcelImporter.Example_SetupImportTemplate

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=e6e80b8e-7894-4e23-9f60-f62ce9437b86; sourceKind=Association; association=Template_MxObjectType; summary=retrieve MxObjectType over association Template_MxObjectType from Template
- nodeId=9b3115f7-477a-4c35-8c62-1aa5c906c577; caption=Found?; expression=$Column != empty Found? expression=$Column != empty
- nodeId=cdc6c336-3e64-42d8-94fc-0f657c746681; caption=has mf name?; expression=$MFName != empty has mf name? expression=$MFName != empty
- nodeId=33740d20-d75e-41c5-bb33-cdbf9afeb0e8; actionKind=Change; members=type=Add, value=$NewColumn; summary=ChangeListAction: change ColumnList (type=Add, value=$NewColumn) change ColumnList (type=Add, value=$NewColumn)
- nodeId=8aa1d92d-0fa5-4ab5-851f-b6bfd6feec77; actionKind=Change; members=Column_Microflows=$Microflows; refreshInClient=false; summary=ChangeObjectAction: change Column (Column_Microflows=$Microflows; refreshInClient=false) change Column (Column_Microflows=$Microflows; refreshInClient=false)
- nodeId=f943c3ee-6715-4c66-a0a8-fa7fe38c9ac4; actionKind=Change; entity=ExcelImporter.MappingType; members=Text=$Attribute, MappingType=ExcelImporter.MappingType.Attribute, IsKey=$IsKey, CaseSensitive=ExcelImporter.YesNo.Yes, DataSource=ExcelImporter.DataSource.CellValue, Column_Template=$Template, Column_MxObjectType=$Template/ExcelImporter.Template_MxObjectType, Column_MxObjectMember=$MxObjectMember; refreshInClient=false; summary=ChangeObjectAction: change Column (Text=$Attribute, MappingType=ExcelImporter.MappingType.Attribute, IsKey=$IsKey, CaseSensitive=ExcelImporter.YesNo.Yes, DataSource=ExcelImporter.DataSource.CellValue, Column_Template=$Template, Column_MxObjectType=$Template/ExcelImporter.Template_MxObjectType, Column_MxObjectMember=$MxObjectMember; refreshInClient=false) change Column (Text=$Attribute, MappingType=ExcelImporter.MappingType.Attribute, IsKey=$IsKey, CaseSensitive=ExcelImporter.YesNo.Yes, DataSource=ExcelImporter.DataSource.CellValue, Column_Template=$Template, Column_MxObjectType=$Template/ExcelImporter.Template_MxObjectType, Column_MxObjectMember=$MxObjectMember; refreshInClient=false)
- nodeId=63971aed-5ab0-47b5-aaa4-ade004b1d4bd; actionKind=Create; entity=ExcelImporter.Column; members=ColNumber=$ColNr; summary=CreateObjectAction: create ExcelImporter.Column as NewColumn (ColNumber=$ColNr) create ExcelImporter.Column as NewColumn (ColNumber=$ColNr)

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-setupcolumn.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
