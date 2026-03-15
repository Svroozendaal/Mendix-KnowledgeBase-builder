---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.StringToReferenceHandlingEnum
stableId: e8e0b9e2-8654-41e2-a4bf-a65741cdf670
slug: excelimporter-stringtoreferencehandlingenum
layer: L1
l0: excelimporter-stringtoreferencehandlingenum.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-stringtoreferencehandlingenum.json
l2Logical: flow:ExcelImporter.StringToReferenceHandlingEnum
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.StringToReferenceHandlingEnum

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](excelimporter-stringtoreferencehandlingenum.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-stringtoreferencehandlingenum.json)

## Main Steps

- CreateVariableAction: create variable Enum=if $Input = 'CreateEverything' then ExcelImporter.ReferenceHandlingEnum.CreateEverything else if $Input = 'FindCreate' then ExcelImporter.ReferenceHandlingEnum.FindCreate else if $Input = 'FindIgnore' then ExcelImporter.... create variable Enum=if $Input = 'CreateEverything' then ExcelImporter.ReferenceHandlingEnum.CreateEverything else if $Input = 'FindCreate' then ExcelImporter.ReferenceHandlingEnum.FindCreate else if $Input = 'FindIgnore' then ExcelImporter....

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

- nodeId=fa636486-36a3-4217-8e6b-52071043a2ef; actionKind=Create; entity=ExcelImporter.ReferenceHandlingEnum; summary=CreateVariableAction: create variable Enum=if $Input = 'CreateEverything' then ExcelImporter.ReferenceHandlingEnum.CreateEverything else if $Input = 'FindCreate' then ExcelImporter.ReferenceHandlingEnum.FindCreate else if $Input = 'FindIgnore' then ExcelImporter.... create variable Enum=if $Input = 'CreateEverything' then ExcelImporter.ReferenceHandlingEnum.CreateEverything else if $Input = 'FindCreate' then ExcelImporter.ReferenceHandlingEnum.FindCreate else if $Input = 'FindIgnore' then ExcelImporter....

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-stringtoreferencehandlingenum.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
