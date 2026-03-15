---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.StringToColumnMappingType
stableId: 50219c8f-d8ac-4a13-96a9-fd36e4f054da
slug: excelimporter-stringtocolumnmappingtype
layer: L1
l0: excelimporter-stringtocolumnmappingtype.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-stringtocolumnmappingtype.json
l2Logical: flow:ExcelImporter.StringToColumnMappingType
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.StringToColumnMappingType

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](excelimporter-stringtocolumnmappingtype.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-stringtocolumnmappingtype.json)

## Main Steps

- CreateVariableAction: create variable Enum=if $Input = 'Attribute' then ExcelImporter.MappingType.Attribute else if $Input = 'DoNotUse' then ExcelImporter.MappingType.DoNotUse else if $Input = 'Reference' then ExcelImporter.MappingType.Reference else empty create variable Enum=if $Input = 'Attribute' then ExcelImporter.MappingType.Attribute else if $Input = 'DoNotUse' then ExcelImporter.MappingType.DoNotUse else if $Input = 'Reference' then ExcelImporter.MappingType.Reference else empty

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

- nodeId=75e84bf1-ea79-4534-929a-008c43c827ea; actionKind=Create; entity=ExcelImporter.MappingType; summary=CreateVariableAction: create variable Enum=if $Input = 'Attribute' then ExcelImporter.MappingType.Attribute else if $Input = 'DoNotUse' then ExcelImporter.MappingType.DoNotUse else if $Input = 'Reference' then ExcelImporter.MappingType.Reference else empty create variable Enum=if $Input = 'Attribute' then ExcelImporter.MappingType.Attribute else if $Input = 'DoNotUse' then ExcelImporter.MappingType.DoNotUse else if $Input = 'Reference' then ExcelImporter.MappingType.Reference else empty

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-stringtocolumnmappingtype.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
