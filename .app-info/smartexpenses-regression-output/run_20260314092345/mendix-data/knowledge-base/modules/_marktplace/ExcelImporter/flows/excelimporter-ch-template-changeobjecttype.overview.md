---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.Ch_Template_ChangeObjectType
stableId: d2b8a870-21ad-428b-857a-466cb91d9ea2
slug: excelimporter-ch-template-changeobjecttype
layer: L1
l0: excelimporter-ch-template-changeobjecttype.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ch-template-changeobjecttype.json
l2Logical: flow:ExcelImporter.Ch_Template_ChangeObjectType
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.Ch_Template_ChangeObjectType

## Summary

- Likely acts as a save, process, or background step for ExcelImporter.Column because it mutates data without showing a page.
- L0: [abstract](excelimporter-ch-template-changeobjecttype.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ch-template-changeobjecttype.json)

## Main Steps

- retrieve Columns from ExcelImporter.Column
- ChangeObjectAction: change Iterator (Column_MxObjectType=$Template/ExcelImporter.Template_MxObjectType; refreshInClient=false) change Iterator (Column_MxObjectType=$Template/ExcelImporter.Template_MxObjectType; refreshInClient=false)
- ChangeObjectAction: change Iterator (refreshInClient=true) change Iterator (refreshInClient=true)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- ExcelImporter.Column

## Called / Called By

- Calls: ExcelImporter.SetColumnStatus
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=fdf70ba1-ce18-41b3-bbf7-dd35768a45fe; sourceKind=Database; entity=ExcelImporter.Column; summary=retrieve Columns from ExcelImporter.Column
- nodeId=a9715a0d-8b2e-4009-83a9-f89ee519e463; actionKind=Change; entity=ExcelImporter.Template_MxObjectType; members=Column_MxObjectType=$Template/ExcelImporter.Template_MxObjectType; refreshInClient=false; summary=ChangeObjectAction: change Iterator (Column_MxObjectType=$Template/ExcelImporter.Template_MxObjectType; refreshInClient=false) change Iterator (Column_MxObjectType=$Template/ExcelImporter.Template_MxObjectType; refreshInClient=false)
- nodeId=e738b0fd-8f92-4b8f-aac0-00ae233b9dcf; actionKind=Change; members=refreshInClient=true; summary=ChangeObjectAction: change Iterator (refreshInClient=true) change Iterator (refreshInClient=true)

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ch-template-changeobjecttype.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
