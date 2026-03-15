---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.Validate_TemplateDocument
stableId: 80917079-4b43-40c4-bcdd-267c4c1047a1
slug: excelimporter-validate-templatedocument
layer: L1
l0: excelimporter-validate-templatedocument.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-validate-templatedocument.json
l2Logical: flow:ExcelImporter.Validate_TemplateDocument
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.Validate_TemplateDocument

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](excelimporter-validate-templatedocument.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-validate-templatedocument.json)

## Main Steps

- endsWith($documentName,'.xls') or (endsWith($documentName,'.xlsx')) or endsWith($documentName,'.xlsm') Ends with '.xls', '.xlsx' or '.xlsm' expression=endsWith($documentName,'.xls') or (endsWith($documentName,'.xlsx')) or endsWith($documentName,'.xlsm')
- $TemplateDocument != empty found? expression=$TemplateDocument != empty
- CreateVariableAction: create variable documentName=toLowerCase($TemplateDocument/Name) create variable documentName=toLowerCase($TemplateDocument/Name)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by ExcelImporter.IVK_SaveContinue_CreateTemplateFromDoc.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: ExcelImporter.IVK_SaveContinue_CreateTemplateFromDoc

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=e41f6fa2-de0e-41f4-bd79-da4534afcd27; caption=Ends with '.xls', '.xlsx' or '.xlsm'; expression=endsWith($documentName,'.xls') or (endsWith($documentName,'.xlsx')) or endsWith($documentName,'.xlsm') Ends with '.xls', '.xlsx' or '.xlsm' expression=endsWith($documentName,'.xls') or (endsWith($documentName,'.xlsx')) or endsWith($documentName,'.xlsm')
- nodeId=01339081-0efe-4ec4-9c8a-a4ec28686cb2; caption=found?; expression=$TemplateDocument != empty found? expression=$TemplateDocument != empty
- nodeId=d78320d0-f5ab-4af6-b1b8-dafc052da550; caption=has file?; expression=$TemplateDocument/Name != empty and $TemplateDocument/Name != '' has file? expression=$TemplateDocument/Name != empty and $TemplateDocument/Name != ''
- nodeId=89c3ff2b-86d1-42ba-a453-5f24f1fbba31; actionKind=Create; members=$TemplateDocument/Name; summary=CreateVariableAction: create variable documentName=toLowerCase($TemplateDocument/Name) create variable documentName=toLowerCase($TemplateDocument/Name)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-validate-templatedocument.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
