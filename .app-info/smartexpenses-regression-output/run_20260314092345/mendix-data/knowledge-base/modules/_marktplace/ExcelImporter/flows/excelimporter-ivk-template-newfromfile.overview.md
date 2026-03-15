---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.IVK_Template_NewFromFile
stableId: dd7ce598-1fc7-4adc-a813-3dc6fdd90076
slug: excelimporter-ivk-template-newfromfile
layer: L1
l0: excelimporter-ivk-template-newfromfile.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ivk-template-newfromfile.json
l2Logical: flow:ExcelImporter.IVK_Template_NewFromFile
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.IVK_Template_NewFromFile

## Summary

- Likely acts as a UI entry or navigation handler because it shows ExcelImporter.Template_New_FromDocument.
- L0: [abstract](excelimporter-ivk-template-newfromfile.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ivk-template-newfromfile.json)

## Main Steps

- ShowPageAction: show page ExcelImporter.Template_New_FromDocument show page ExcelImporter.Template_New_FromDocument
- ChangeObjectAction: change NewTemplateDocument (TemplateDocument_Template=$NewTemplate; refreshInClient=false) change NewTemplateDocument (TemplateDocument_Template=$NewTemplate; refreshInClient=false)
- CreateObjectAction: create ExcelImporter.Template as NewTemplate create ExcelImporter.Template as NewTemplate

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: Shows ExcelImporter.Template_New_FromDocument.

## Key Entities Touched

- ExcelImporter.Template, ExcelImporter.TemplateDocument

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- ExcelImporter.Template_New_FromDocument

## Important Retrieves/Decisions/Mutations

- nodeId=0df7791e-7415-40c4-bee9-1125e2b2b29c; actionKind=Change; members=TemplateDocument_Template=$NewTemplate; refreshInClient=false; summary=ChangeObjectAction: change NewTemplateDocument (TemplateDocument_Template=$NewTemplate; refreshInClient=false) change NewTemplateDocument (TemplateDocument_Template=$NewTemplate; refreshInClient=false)
- nodeId=860e71e8-13c7-4a2f-b41d-95550e1053d3; actionKind=Create; entity=ExcelImporter.Template; summary=CreateObjectAction: create ExcelImporter.Template as NewTemplate create ExcelImporter.Template as NewTemplate
- nodeId=ac12a00e-7b80-4287-a4de-2db481a0ef38; actionKind=Create; entity=ExcelImporter.TemplateDocument; summary=CreateObjectAction: create ExcelImporter.TemplateDocument as NewTemplateDocument create ExcelImporter.TemplateDocument as NewTemplateDocument

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ivk-template-newfromfile.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
