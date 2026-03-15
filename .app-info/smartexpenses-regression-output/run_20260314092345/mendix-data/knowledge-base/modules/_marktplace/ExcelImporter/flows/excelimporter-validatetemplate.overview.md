---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.ValidateTemplate
stableId: cca92234-473a-4ba8-8afb-fd3d351d7c3e
slug: excelimporter-validatetemplate
layer: L1
l0: excelimporter-validatetemplate.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-validatetemplate.json
l2Logical: flow:ExcelImporter.ValidateTemplate
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.ValidateTemplate

## Summary

- Likely acts as a save, process, or background step for ExcelImporter.Column, ExcelImporter.ReferenceHandling because it mutates data without showing a page.
- L0: [abstract](excelimporter-validatetemplate.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-validatetemplate.json)

## Main Steps

- retrieve AllKeyColumns from ExcelImporter.Column
- retrieve AllReferences from ExcelImporter.ReferenceHandling
- $Count_1 > 0 > 0 expression=$Count_1 > 0
- $AnyColumnUsed Any column used? expression=$AnyColumnUsed
- ChangeObjectAction: change ColumnIter (refreshInClient=true) change ColumnIter (refreshInClient=true)
- ChangeVariableAction: change variable AnyColumnUsed=true change variable AnyColumnUsed=true

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by ExcelImporter.ASu_CheckModelAndTemplates, ExcelImporter.IVK_CancelTemplate, ExcelImporter.IVK_SaveTemplate.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- ExcelImporter.Column, ExcelImporter.ReferenceHandling

## Called / Called By

- Calls: ExcelImporter.GetAddProperties, ExcelImporter.GetCorrectString, ExcelImporter.SetColumnStatus, ExcelImporter.SF_Template_CheckNrs
- Called by: ExcelImporter.ASu_CheckModelAndTemplates, ExcelImporter.IVK_CancelTemplate, ExcelImporter.IVK_SaveTemplate

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=b7499d0f-74d9-4a5e-9c56-0b8f85a7dbf0; sourceKind=Database; entity=ExcelImporter.Column; summary=retrieve AllKeyColumns from ExcelImporter.Column
- nodeId=61714782-8b0c-4797-b406-e3d44f2072c5; sourceKind=Database; entity=ExcelImporter.ReferenceHandling; summary=retrieve AllReferences from ExcelImporter.ReferenceHandling
- nodeId=95ea72ad-0b0a-4366-a9e5-10ba981c41f4; sourceKind=Database; entity=ExcelImporter.Column; summary=retrieve Columns from ExcelImporter.Column
- nodeId=98752e3c-99ec-446f-bb36-a4b839d6a652; sourceKind=Database; entity=ExcelImporter.Column; summary=retrieve KeyColumnsForReference from ExcelImporter.Column
- nodeId=8fa2ce4f-28f7-4d64-8656-33b29b8aac48; sourceKind=Association; association=ReferenceHandling_MxObjectReference; summary=retrieve MxReference over association ReferenceHandling_MxObjectReference from Reference
- nodeId=cbdbc2d8-a1f7-43b7-a217-cd7db64a872a; sourceKind=Association; association=User_Language; summary=retrieve UserLanguage over association User_Language from currentUser
- nodeId=41ba27a2-5aa8-48c3-80a2-dd50e9b19761; caption=> 0; expression=$Count_1 > 0 > 0 expression=$Count_1 > 0
- nodeId=5d87fc78-0e55-4c6b-a21a-01f153b2417d; caption=> 0; expression=$Count_1 > 0 > 0 expression=$Count_1 > 0

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-validatetemplate.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
