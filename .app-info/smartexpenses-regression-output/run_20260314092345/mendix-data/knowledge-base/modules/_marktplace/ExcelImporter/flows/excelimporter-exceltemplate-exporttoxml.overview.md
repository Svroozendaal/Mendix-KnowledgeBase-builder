---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.ExcelTemplate_ExportToXML
stableId: aa1c8812-4ba4-4563-9ffe-276fd2ad392b
slug: excelimporter-exceltemplate-exporttoxml
layer: L1
l0: excelimporter-exceltemplate-exporttoxml.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-exceltemplate-exporttoxml.json
l2Logical: flow:ExcelImporter.ExcelTemplate_ExportToXML
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.ExcelTemplate_ExportToXML

## Summary

- Likely acts as a save, process, or background step for ExcelImporter.XMLDocumentTemplate because it mutates data without showing a page.
- L0: [abstract](excelimporter-exceltemplate-exporttoxml.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-exceltemplate-exporttoxml.json)

## Main Steps

- ChangeObjectAction: change NewXMLDocumentTemplate (Name='ExcelTemplate_' + $Template/Title + '_' + formatDateTime([%CurrentDateTime%], 'yyyy-MM-dd_HHmm') + '.xml'; refreshInClient=false) change NewXMLDocumentTemplate (Name='ExcelTemplate_' + $Template/Title + '_' + formatDateTime([%CurrentDateTime%], 'yyyy-MM-dd_HHmm') + '.xml'; refreshInClient=false)
- ChangeObjectAction: change NewXMLDocumentTemplate (XMLDocumentTemplate_Template=$Template; refreshInClient=false) change NewXMLDocumentTemplate (XMLDocumentTemplate_Template=$Template; refreshInClient=false)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- ExcelImporter.XMLDocumentTemplate

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=6805c751-614e-4727-90de-015a46aeeedb; actionKind=Change; members=Name='ExcelTemplate_' + $Template/Title + '_' + formatDateTime([%CurrentDateTime%], 'yyyy-MM-dd_HHmm'; summary=ChangeObjectAction: change NewXMLDocumentTemplate (Name='ExcelTemplate_' + $Template/Title + '_' + formatDateTime([%CurrentDateTime%], 'yyyy-MM-dd_HHmm') + '.xml'; refreshInClient=false) change NewXMLDocumentTemplate (Name='ExcelTemplate_' + $Template/Title + '_' + formatDateTime([%CurrentDateTime%], 'yyyy-MM-dd_HHmm') + '.xml'; refreshInClient=false)
- nodeId=d3e3ea0b-3f0a-422b-bdf7-3cb0bcea4e6a; actionKind=Change; members=XMLDocumentTemplate_Template=$Template; refreshInClient=false; summary=ChangeObjectAction: change NewXMLDocumentTemplate (XMLDocumentTemplate_Template=$Template; refreshInClient=false) change NewXMLDocumentTemplate (XMLDocumentTemplate_Template=$Template; refreshInClient=false)
- nodeId=309481bf-bf55-497f-aa07-cb532b2ee838; actionKind=Create; entity=ExcelImporter.XMLDocumentTemplate; summary=CreateObjectAction: create ExcelImporter.XMLDocumentTemplate as NewXMLDocumentTemplate create ExcelImporter.XMLDocumentTemplate as NewXMLDocumentTemplate

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-exceltemplate-exporttoxml.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
