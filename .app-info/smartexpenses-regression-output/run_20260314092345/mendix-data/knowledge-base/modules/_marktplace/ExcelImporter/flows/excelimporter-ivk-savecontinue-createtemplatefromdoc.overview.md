---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.IVK_SaveContinue_CreateTemplateFromDoc
stableId: f1571e32-b013-44f7-8eab-50b552393ff8
slug: excelimporter-ivk-savecontinue-createtemplatefromdoc
layer: L1
l0: excelimporter-ivk-savecontinue-createtemplatefromdoc.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ivk-savecontinue-createtemplatefromdoc.json
l2Logical: flow:ExcelImporter.IVK_SaveContinue_CreateTemplateFromDoc
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.IVK_SaveContinue_CreateTemplateFromDoc

## Summary

- Likely acts as a UI entry or navigation handler because it shows ExcelImporter.Template_Edit.
- L0: [abstract](excelimporter-ivk-savecontinue-createtemplatefromdoc.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ivk-savecontinue-createtemplatefromdoc.json)

## Main Steps

- retrieve Template over association TemplateDocument_Template from TemplateDocument
- $IsValid Is valid template? expression=$IsValid
- $isValid validate template document expression=$isValid
- ShowPageAction: show page ExcelImporter.Template_Edit show page ExcelImporter.Template_Edit
- ChangeObjectAction: change Template (refreshInClient=true) change Template (refreshInClient=true)
- DeleteAction: delete TemplateDocument (refreshInClient=false) delete TemplateDocument (refreshInClient=false)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: Shows ExcelImporter.Template_Edit.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: ExcelImporter.SF_Template_CheckNrs, ExcelImporter.Validate_TemplateDocument
- Called by: none

## Shown Pages

- ExcelImporter.Template_Edit

## Important Retrieves/Decisions/Mutations

- nodeId=22df8bcf-3630-4970-b8eb-288beeb6df2a; sourceKind=Association; association=TemplateDocument_Template; summary=retrieve Template over association TemplateDocument_Template from TemplateDocument
- nodeId=848254b8-40e6-438f-9e49-a145b2769d9e; caption=Is valid template?; expression=$IsValid Is valid template? expression=$IsValid
- nodeId=b942c0d7-66f2-44ba-aa1b-5c3c93dd81a2; caption=validate template document; expression=$isValid validate template document expression=$isValid
- nodeId=e3bc1757-039d-4f73-a987-fef2dfaa0731; actionKind=Change; members=refreshInClient=true; summary=ChangeObjectAction: change Template (refreshInClient=true) change Template (refreshInClient=true)
- nodeId=446c578a-cc63-4479-9d33-d7bdbecc4279; actionKind=Delete; members=refreshInClient=false; summary=DeleteAction: delete TemplateDocument (refreshInClient=false) delete TemplateDocument (refreshInClient=false)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ivk-savecontinue-createtemplatefromdoc.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
