---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.ExcelTemplate_ImportFromXml
stableId: a08fa6b9-d979-4b42-afb5-835bbc72edac
slug: excelimporter-exceltemplate-importfromxml
layer: L1
l0: excelimporter-exceltemplate-importfromxml.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-exceltemplate-importfromxml.json
l2Logical: flow:ExcelImporter.ExcelTemplate_ImportFromXml
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.ExcelTemplate_ImportFromXml

## Summary

- Likely acts as a save, process, or background step for ExcelImporter.Log because it mutates data without showing a page.
- L0: [abstract](excelimporter-exceltemplate-importfromxml.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-exceltemplate-importfromxml.json)

## Main Steps

- ChangeObjectAction: change NewLogXMLToDom (Log_XMLDocumentTemplate=$XMLDocumentTemplate, Logline='The mapping from XML to Domain throwed an error. Be sure the MxModelReflection and selected DB is synchronized. ' + 'LastErrorMessage: ' + $latestError/Message + '. ' + '' + 'Last...; refreshInClient=false) change NewLogXMLToDom (Log_XMLDocumentTemplate=$XMLDocumentTemplate, Logline='The mapping from XML to Domain throwed an error. Be sure the MxModelReflection and selected DB is synchronized. ' + 'LastErrorMessage: ' + $latestError/Message + '. ' + '' + 'Last...; refreshInClient=false)
- CreateObjectAction: create ExcelImporter.Log as NewLogXMLToDom create ExcelImporter.Log as NewLogXMLToDom

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- ExcelImporter.Log

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=0ce4f5c4-4603-44b9-be3f-3f6e1c0f7d6b; actionKind=Change; members=Log_XMLDocumentTemplate=$XMLDocumentTemplate, Logline='The mapping from XML to Domain throwed an error. Be sure the MxModelReflection and selected DB is synchronized. ' + 'LastErrorMessage: ' + $latestError/Message + '. ' + '' + 'Last...; refreshInClient=false; summary=ChangeObjectAction: change NewLogXMLToDom (Log_XMLDocumentTemplate=$XMLDocumentTemplate, Logline='The mapping from XML to Domain throwed an error. Be sure the MxModelReflection and selected DB is synchronized. ' + 'LastErrorMessage: ' + $latestError/Message + '. ' + '' + 'Last...; refreshInClient=false) change NewLogXMLToDom (Log_XMLDocumentTemplate=$XMLDocumentTemplate, Logline='The mapping from XML to Domain throwed an error. Be sure the MxModelReflection and selected DB is synchronized. ' + 'LastErrorMessage: ' + $latestError/Message + '. ' + '' + 'Last...; refreshInClient=false)
- nodeId=e8a818fe-64d3-4a9e-a62d-37556e2ad126; actionKind=Create; entity=ExcelImporter.Log; summary=CreateObjectAction: create ExcelImporter.Log as NewLogXMLToDom create ExcelImporter.Log as NewLogXMLToDom

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-exceltemplate-importfromxml.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
