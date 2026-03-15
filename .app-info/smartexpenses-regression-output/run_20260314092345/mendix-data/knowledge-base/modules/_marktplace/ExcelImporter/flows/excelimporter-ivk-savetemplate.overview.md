---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.IVK_SaveTemplate
stableId: 9c9efeb4-fd56-4c10-971f-4ee32c9a7424
slug: excelimporter-ivk-savetemplate
layer: L1
l0: excelimporter-ivk-savetemplate.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ivk-savetemplate.json
l2Logical: flow:ExcelImporter.IVK_SaveTemplate
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.IVK_SaveTemplate

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](excelimporter-ivk-savetemplate.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ivk-savetemplate.json)

## Main Steps

- $valid valid? expression=$valid
- ChangeObjectAction: change AddProperties (refreshInClient=true) change AddProperties (refreshInClient=true)
- ChangeObjectAction: change Template (Status=ExcelImporter.Status.INVALID; refreshInClient=true) change Template (Status=ExcelImporter.Status.INVALID; refreshInClient=true)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by ExcelImporter.IVK_SaveNewTemplate.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: ExcelImporter.CleanupOldRefHandling, ExcelImporter.GetAddProperties, ExcelImporter.ValidateTemplate
- Called by: ExcelImporter.IVK_SaveNewTemplate

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=aff0b3b1-b8a0-4226-ad3c-39a0cdec3844; caption=valid?; expression=$valid valid? expression=$valid
- nodeId=d0c35fc3-5142-4fa7-9cfd-0507b907d382; actionKind=Change; members=refreshInClient=true; summary=ChangeObjectAction: change AddProperties (refreshInClient=true) change AddProperties (refreshInClient=true)
- nodeId=a80b577a-dd93-42fa-9f35-4468bf77f6bc; actionKind=Change; entity=ExcelImporter.Status; members=Status=ExcelImporter.Status.INVALID; refreshInClient=true; summary=ChangeObjectAction: change Template (Status=ExcelImporter.Status.INVALID; refreshInClient=true) change Template (Status=ExcelImporter.Status.INVALID; refreshInClient=true)
- nodeId=0b449952-ecf3-4c1c-9180-e7b49f449125; actionKind=Change; entity=ExcelImporter.Status; members=Status=ExcelImporter.Status.VALID; refreshInClient=true; summary=ChangeObjectAction: change Template (Status=ExcelImporter.Status.VALID; refreshInClient=true) change Template (Status=ExcelImporter.Status.VALID; refreshInClient=true)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ivk-savetemplate.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
