---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.IVK_ColumnNew
stableId: f7975ba6-f871-43e7-b01d-234e29c13fe0
slug: excelimporter-ivk-columnnew
layer: L1
l0: excelimporter-ivk-columnnew.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ivk-columnnew.json
l2Logical: flow:ExcelImporter.IVK_ColumnNew
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.IVK_ColumnNew

## Summary

- Likely acts as a UI entry or navigation handler because it shows ExcelImporter.Column_NewEdit.
- L0: [abstract](excelimporter-ivk-columnnew.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ivk-columnnew.json)

## Main Steps

- $EnclosingContext/ExcelImporter.Template_MxObjectType != empty Has object type? expression=$EnclosingContext/ExcelImporter.Template_MxObjectType != empty
- ShowPageAction: show page ExcelImporter.Column_NewEdit show page ExcelImporter.Column_NewEdit
- ChangeObjectAction: change NewColAttributeRelation (Column_MxObjectType=$EnclosingContext/ExcelImporter.Template_MxObjectType, Column_Template=$EnclosingContext; refreshInClient=false) change NewColAttributeRelation (Column_MxObjectType=$EnclosingContext/ExcelImporter.Template_MxObjectType, Column_Template=$EnclosingContext; refreshInClient=false)
- CreateObjectAction: create ExcelImporter.Column as NewColAttributeRelation create ExcelImporter.Column as NewColAttributeRelation

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: Shows ExcelImporter.Column_NewEdit.

## Key Entities Touched

- ExcelImporter.Column

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- ExcelImporter.Column_NewEdit

## Important Retrieves/Decisions/Mutations

- nodeId=573e5bb7-f148-498d-86c1-7ec7e5b4b043; caption=Has object type?; expression=$EnclosingContext/ExcelImporter.Template_MxObjectType != empty Has object type? expression=$EnclosingContext/ExcelImporter.Template_MxObjectType != empty
- nodeId=82c70fc0-f913-4ceb-804a-2ee3b0804bf3; actionKind=Change; entity=ExcelImporter.Template_MxObjectType; members=Column_MxObjectType=$EnclosingContext/ExcelImporter.Template_MxObjectType, Column_Template=$EnclosingContext; refreshInClient=false; summary=ChangeObjectAction: change NewColAttributeRelation (Column_MxObjectType=$EnclosingContext/ExcelImporter.Template_MxObjectType, Column_Template=$EnclosingContext; refreshInClient=false) change NewColAttributeRelation (Column_MxObjectType=$EnclosingContext/ExcelImporter.Template_MxObjectType, Column_Template=$EnclosingContext; refreshInClient=false)
- nodeId=16612b9b-8171-4689-99bd-e3bb33bd87c8; actionKind=Create; entity=ExcelImporter.Column; summary=CreateObjectAction: create ExcelImporter.Column as NewColAttributeRelation create ExcelImporter.Column as NewColAttributeRelation

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ivk-columnnew.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
