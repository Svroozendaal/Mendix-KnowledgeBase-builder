---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.StringToTemplateStatusEnum
stableId: e5b9014b-f7f5-4dfd-89d2-c73211d4952c
slug: excelimporter-stringtotemplatestatusenum
layer: L1
l0: excelimporter-stringtotemplatestatusenum.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-stringtotemplatestatusenum.json
l2Logical: flow:ExcelImporter.StringToTemplateStatusEnum
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.StringToTemplateStatusEnum

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](excelimporter-stringtotemplatestatusenum.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-stringtotemplatestatusenum.json)

## Main Steps

- CreateVariableAction: create variable StatusEnum=if $Input = 'INFO' then ExcelImporter.Status.INFO else if $Input = 'INVALID' then ExcelImporter.Status.INVALID else if $Input = 'VALID' then ExcelImporter.Status.VALID else empty create variable StatusEnum=if $Input = 'INFO' then ExcelImporter.Status.INFO else if $Input = 'INVALID' then ExcelImporter.Status.INVALID else if $Input = 'VALID' then ExcelImporter.Status.VALID else empty

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=700fcd40-4ab5-4296-ab11-4fa4b3f94555; actionKind=Create; entity=ExcelImporter.Status; summary=CreateVariableAction: create variable StatusEnum=if $Input = 'INFO' then ExcelImporter.Status.INFO else if $Input = 'INVALID' then ExcelImporter.Status.INVALID else if $Input = 'VALID' then ExcelImporter.Status.VALID else empty create variable StatusEnum=if $Input = 'INFO' then ExcelImporter.Status.INFO else if $Input = 'INVALID' then ExcelImporter.Status.INVALID else if $Input = 'VALID' then ExcelImporter.Status.VALID else empty

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-stringtotemplatestatusenum.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
