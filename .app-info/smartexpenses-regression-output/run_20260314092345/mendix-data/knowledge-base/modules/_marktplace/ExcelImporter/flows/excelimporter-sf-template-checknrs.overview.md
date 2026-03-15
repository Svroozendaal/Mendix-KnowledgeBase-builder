---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.SF_Template_CheckNrs
stableId: a79d2479-ed24-4c71-bc46-3a7a427f2ec4
slug: excelimporter-sf-template-checknrs
layer: L1
l0: excelimporter-sf-template-checknrs.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-sf-template-checknrs.json
l2Logical: flow:ExcelImporter.SF_Template_CheckNrs
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.SF_Template_CheckNrs

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](excelimporter-sf-template-checknrs.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-sf-template-checknrs.json)

## Main Steps

- $Template/HeaderRowNumber < 1 HeaderRownr < 1 expression=$Template/HeaderRowNumber < 1
- $Template/HeaderRowNumber = empty HeaderRownr = empty expression=$Template/HeaderRowNumber = empty
- ChangeVariableAction: change variable IsValid=false change variable IsValid=false

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by ExcelImporter.Ch_Template_CheckNrs, ExcelImporter.IVK_SaveContinue_CreateTemplateFromDoc, ExcelImporter.ValidateTemplate.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: ExcelImporter.Ch_Template_CheckNrs, ExcelImporter.IVK_SaveContinue_CreateTemplateFromDoc, ExcelImporter.ValidateTemplate

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=3b494e7e-1eb0-4857-b35f-7eed9aab1114; caption=HeaderRownr < 1; expression=$Template/HeaderRowNumber < 1 HeaderRownr < 1 expression=$Template/HeaderRowNumber < 1
- nodeId=cd0aa3b8-8d7e-4e81-9128-d68731b07881; caption=HeaderRownr = empty; expression=$Template/HeaderRowNumber = empty HeaderRownr = empty expression=$Template/HeaderRowNumber = empty
- nodeId=aa8d2384-f0cb-4eb9-a6e6-1362cac2170b; caption=ImportRowNr < 1; expression=$Template/FirstDataRowNumber < 1 ImportRowNr < 1 expression=$Template/FirstDataRowNumber < 1
- nodeId=6f9e3f17-735c-48cc-b4b5-318ece4e2d7b; caption=ImportRowNr = empty; expression=$Template/FirstDataRowNumber = empty ImportRowNr = empty expression=$Template/FirstDataRowNumber = empty
- nodeId=dd148b67-abcc-46cd-8de6-fdec37a1b462; caption=SheetIndex < 1; expression=$Template/SheetIndex < 1 SheetIndex < 1 expression=$Template/SheetIndex < 1
- nodeId=3815f58d-3ae1-4097-bb3b-294dc602ad84; caption=SheetIndex = empty; expression=$Template/SheetIndex = empty SheetIndex = empty expression=$Template/SheetIndex = empty
- nodeId=3437fc32-0d05-421f-816d-d9207769a315; caption=Show messages; expression=$ShowWarningPopup Show messages expression=$ShowWarningPopup
- nodeId=3bb23c14-95fb-4ea2-8e9d-fb2d7ca2d426; caption=Show messages; expression=$ShowWarningPopup Show messages expression=$ShowWarningPopup

## Warnings/Unknowns

- Rollback hint detected in node detail.
- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-sf-template-checknrs.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
