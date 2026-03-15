---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.IVK_ImportXML_Upload
stableId: 6ec65397-7f34-4916-a013-04fccdcb973e
slug: excelimporter-ivk-importxml-upload
layer: L1
l0: excelimporter-ivk-importxml-upload.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ivk-importxml-upload.json
l2Logical: flow:ExcelImporter.IVK_ImportXML_Upload
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.IVK_ImportXML_Upload

## Summary

- Likely acts as a UI entry or navigation handler because it shows ExcelImporter.ImportXML_Upload.
- L0: [abstract](excelimporter-ivk-importxml-upload.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ivk-importxml-upload.json)

## Main Steps

- ShowPageAction: show page ExcelImporter.ImportXML_Upload show page ExcelImporter.ImportXML_Upload
- ChangeObjectAction: change NewXMLDocumentTemplate (refreshInClient=false) change NewXMLDocumentTemplate (refreshInClient=false)
- CreateObjectAction: create ExcelImporter.XMLDocumentTemplate as NewXMLDocumentTemplate create ExcelImporter.XMLDocumentTemplate as NewXMLDocumentTemplate

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: Shows ExcelImporter.ImportXML_Upload.

## Key Entities Touched

- ExcelImporter.XMLDocumentTemplate

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- ExcelImporter.ImportXML_Upload

## Important Retrieves/Decisions/Mutations

- nodeId=96cf9041-7e22-4217-ac3f-5b67dc8f6c93; actionKind=Change; members=refreshInClient=false; summary=ChangeObjectAction: change NewXMLDocumentTemplate (refreshInClient=false) change NewXMLDocumentTemplate (refreshInClient=false)
- nodeId=f55d1d39-2be4-45fb-9dd5-6b78e121bc31; actionKind=Create; entity=ExcelImporter.XMLDocumentTemplate; summary=CreateObjectAction: create ExcelImporter.XMLDocumentTemplate as NewXMLDocumentTemplate create ExcelImporter.XMLDocumentTemplate as NewXMLDocumentTemplate

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ivk-importxml-upload.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
