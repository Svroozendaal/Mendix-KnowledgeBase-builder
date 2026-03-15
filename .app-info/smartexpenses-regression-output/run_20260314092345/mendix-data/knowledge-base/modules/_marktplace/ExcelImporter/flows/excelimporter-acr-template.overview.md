---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.ACr_Template
stableId: 1acf6021-8f88-4729-b8da-3b6a3282bddb
slug: excelimporter-acr-template
layer: L1
l0: excelimporter-acr-template.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-acr-template.json
l2Logical: flow:ExcelImporter.ACr_Template
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.ACr_Template

## Summary

- Likely acts as a save, process, or background step for ExcelImporter.AdditionalProperties because it mutates data without showing a page.
- L0: [abstract](excelimporter-acr-template.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-acr-template.json)

## Main Steps

- ChangeObjectAction: change NewAdditionalProperties (Template_AdditionalProperties=$Template; refreshInClient=false) change NewAdditionalProperties (Template_AdditionalProperties=$Template; refreshInClient=false)
- ChangeObjectAction: change Template (Template_AdditionalProperties=$NewAdditionalProperties; refreshInClient=false) change Template (Template_AdditionalProperties=$NewAdditionalProperties; refreshInClient=false)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- ExcelImporter.AdditionalProperties

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=9cda61a7-04d8-4570-a79b-c6243431c1a5; actionKind=Change; members=Template_AdditionalProperties=$Template; refreshInClient=false; summary=ChangeObjectAction: change NewAdditionalProperties (Template_AdditionalProperties=$Template; refreshInClient=false) change NewAdditionalProperties (Template_AdditionalProperties=$Template; refreshInClient=false)
- nodeId=8e057afe-9afa-4624-a16d-3795d2f20fbf; actionKind=Change; members=Template_AdditionalProperties=$NewAdditionalProperties; refreshInClient=false; summary=ChangeObjectAction: change Template (Template_AdditionalProperties=$NewAdditionalProperties; refreshInClient=false) change Template (Template_AdditionalProperties=$NewAdditionalProperties; refreshInClient=false)
- nodeId=588e700a-7647-4a41-879e-e439491caf03; actionKind=Create; entity=ExcelImporter.AdditionalProperties; summary=CreateObjectAction: create ExcelImporter.AdditionalProperties as NewAdditionalProperties create ExcelImporter.AdditionalProperties as NewAdditionalProperties

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-acr-template.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
