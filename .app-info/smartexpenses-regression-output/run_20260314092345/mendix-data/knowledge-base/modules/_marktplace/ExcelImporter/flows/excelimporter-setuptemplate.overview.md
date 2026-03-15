---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.SetupTemplate
stableId: d007e03e-9e42-49f2-adee-08dc085cb6cd
slug: excelimporter-setuptemplate
layer: L1
l0: excelimporter-setuptemplate.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-setuptemplate.json
l2Logical: flow:ExcelImporter.SetupTemplate
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.SetupTemplate

## Summary

- Likely acts as a save, process, or background step for ExcelImporter.Template because it mutates data without showing a page.
- L0: [abstract](excelimporter-setuptemplate.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-setuptemplate.json)

## Main Steps

- retrieve Template from ExcelImporter.Template
- $Template != empty found? expression=$Template != empty
- ChangeObjectAction: change Template (SheetIndex=1, HeaderRowNumber=if $DataRowNr > 0 then $DataRowNr - 1 else 0, FirstDataRowNumber=$DataRowNr, ImportAction=$ImportActions, TemplateType=ExcelImporter.TemplateType.Normal, Template_MxObjectType=$MxObjectType, Template_MxObjectReference_ParentAssociation=$MxObjectReference; refreshInClient=false) change Template (SheetIndex=1, HeaderRowNumber=if $DataRowNr > 0 then $DataRowNr - 1 else 0, FirstDataRowNumber=$DataRowNr, ImportAction=$ImportActions, TemplateType=ExcelImporter.TemplateType.Normal, Template_MxObjectType=$MxObjectType, Template_MxObjectReference_ParentAssociation=$MxObjectReference; refreshInClient=false)
- CommitAction: commit AdditionalProperties (refreshInClient=false, withEvents=true) commit AdditionalProperties (refreshInClient=false, withEvents=true)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by ExcelImporter.Example_SetupImportTemplate.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- ExcelImporter.Template

## Called / Called By

- Calls: ExcelImporter.GetAddProperties, MxModelReflection.FindObjectType, MxModelReflection.FindReference
- Called by: ExcelImporter.Example_SetupImportTemplate

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=fa3c7548-c950-4e9c-8a36-dd232b46be52; sourceKind=Database; entity=ExcelImporter.Template; summary=retrieve Template from ExcelImporter.Template
- nodeId=9bba46dc-311b-4d4d-a21f-cc397772b0f7; caption=found?; expression=$Template != empty found? expression=$Template != empty
- nodeId=14c10e00-abc7-4703-93a5-757a4b94ff68; actionKind=Change; entity=ExcelImporter.TemplateType; members=SheetIndex=1, HeaderRowNumber=if $DataRowNr > 0 then $DataRowNr - 1 else 0, FirstDataRowNumber=$DataRowNr, ImportAction=$ImportActions, TemplateType=ExcelImporter.TemplateType.Normal, Template_MxObjectType=$MxObjectType, Template_MxObjectReference_ParentAssociation=$MxObjectReference; refreshInClient=false; summary=ChangeObjectAction: change Template (SheetIndex=1, HeaderRowNumber=if $DataRowNr > 0 then $DataRowNr - 1 else 0, FirstDataRowNumber=$DataRowNr, ImportAction=$ImportActions, TemplateType=ExcelImporter.TemplateType.Normal, Template_MxObjectType=$MxObjectType, Template_MxObjectReference_ParentAssociation=$MxObjectReference; refreshInClient=false) change Template (SheetIndex=1, HeaderRowNumber=if $DataRowNr > 0 then $DataRowNr - 1 else 0, FirstDataRowNumber=$DataRowNr, ImportAction=$ImportActions, TemplateType=ExcelImporter.TemplateType.Normal, Template_MxObjectType=$MxObjectType, Template_MxObjectReference_ParentAssociation=$MxObjectReference; refreshInClient=false)
- nodeId=3d7c701c-c829-4f0b-8292-90f94c3e0eca; actionKind=Commit; members=refreshInClient=false, withEvents=true; summary=CommitAction: commit AdditionalProperties (refreshInClient=false, withEvents=true) commit AdditionalProperties (refreshInClient=false, withEvents=true)
- nodeId=9b2de957-3927-4479-9327-312b29cbfda7; actionKind=Create; entity=ExcelImporter.Template; members=Title=$TemplateName; summary=CreateObjectAction: create ExcelImporter.Template as NewTemplate (Title=$TemplateName) create ExcelImporter.Template as NewTemplate (Title=$TemplateName)

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-setuptemplate.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
