---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.GetAddProperties
stableId: 64ce4e8d-bcb3-44b2-92b9-bc746d08e39c
slug: excelimporter-getaddproperties
layer: L1
l0: excelimporter-getaddproperties.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-getaddproperties.json
l2Logical: flow:ExcelImporter.GetAddProperties
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.GetAddProperties

## Summary

- Likely acts as a save, process, or background step for ExcelImporter.AdditionalProperties because it mutates data without showing a page.
- L0: [abstract](excelimporter-getaddproperties.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-getaddproperties.json)

## Main Steps

- retrieve AddProperties over association Template_AdditionalProperties from Template
- $AddProperties != empty found? expression=$AddProperties != empty
- ChangeObjectAction: change NewAdditionalProperties (Template_AdditionalProperties=$Template; refreshInClient=false) change NewAdditionalProperties (Template_AdditionalProperties=$Template; refreshInClient=false)
- ChangeObjectAction: change Template (Template_AdditionalProperties=$NewAdditionalProperties; refreshInClient=false) change Template (Template_AdditionalProperties=$NewAdditionalProperties; refreshInClient=false)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by ExcelImporter.IVK_SaveTemplate, ExcelImporter.SetupTemplate, ExcelImporter.ValidateTemplate.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- ExcelImporter.AdditionalProperties

## Called / Called By

- Calls: none
- Called by: ExcelImporter.IVK_SaveTemplate, ExcelImporter.SetupTemplate, ExcelImporter.ValidateTemplate

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=f0e52773-6a1f-45ca-bade-7169d2952848; sourceKind=Association; association=Template_AdditionalProperties; summary=retrieve AddProperties over association Template_AdditionalProperties from Template
- nodeId=b7dff1de-7c0f-412e-9182-eadd4360bcdf; caption=found?; expression=$AddProperties != empty found? expression=$AddProperties != empty
- nodeId=3723d89a-2c73-4869-9f3b-b086e5467ef8; actionKind=Change; members=Template_AdditionalProperties=$Template; refreshInClient=false; summary=ChangeObjectAction: change NewAdditionalProperties (Template_AdditionalProperties=$Template; refreshInClient=false) change NewAdditionalProperties (Template_AdditionalProperties=$Template; refreshInClient=false)
- nodeId=ac17cfbf-ab1d-462b-aee1-7eea98a32307; actionKind=Change; members=Template_AdditionalProperties=$NewAdditionalProperties; refreshInClient=false; summary=ChangeObjectAction: change Template (Template_AdditionalProperties=$NewAdditionalProperties; refreshInClient=false) change Template (Template_AdditionalProperties=$NewAdditionalProperties; refreshInClient=false)
- nodeId=4925ae28-d427-424c-8703-3c3a64891490; actionKind=Create; entity=ExcelImporter.AdditionalProperties; summary=CreateObjectAction: create ExcelImporter.AdditionalProperties as NewAdditionalProperties create ExcelImporter.AdditionalProperties as NewAdditionalProperties

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-getaddproperties.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
