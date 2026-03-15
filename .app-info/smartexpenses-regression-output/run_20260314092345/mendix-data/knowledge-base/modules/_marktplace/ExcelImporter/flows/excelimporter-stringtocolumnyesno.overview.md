---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.StringToColumnYesNo
stableId: 4184aafd-754a-4d11-98f6-1316e7a924cb
slug: excelimporter-stringtocolumnyesno
layer: L1
l0: excelimporter-stringtocolumnyesno.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-stringtocolumnyesno.json
l2Logical: flow:ExcelImporter.StringToColumnYesNo
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.StringToColumnYesNo

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](excelimporter-stringtocolumnyesno.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-stringtocolumnyesno.json)

## Main Steps

- CreateVariableAction: create variable Enum=if $Input = 'No' then ExcelImporter.YesNo.No else if $Input = 'Yes' then ExcelImporter.YesNo.Yes else empty create variable Enum=if $Input = 'No' then ExcelImporter.YesNo.No else if $Input = 'Yes' then ExcelImporter.YesNo.Yes else empty

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

- nodeId=71c4e7a6-296c-43ee-bcb9-f680ced43901; actionKind=Create; entity=ExcelImporter.YesNo; summary=CreateVariableAction: create variable Enum=if $Input = 'No' then ExcelImporter.YesNo.No else if $Input = 'Yes' then ExcelImporter.YesNo.Yes else empty create variable Enum=if $Input = 'No' then ExcelImporter.YesNo.No else if $Input = 'Yes' then ExcelImporter.YesNo.Yes else empty

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-stringtocolumnyesno.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
