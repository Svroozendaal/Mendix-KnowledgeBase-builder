---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.StringToMxObjectAttributeTypesEnum
stableId: 6bfa582b-e7a1-4d6d-9731-b41dbc2d6477
slug: excelimporter-stringtomxobjectattributetypesenum
layer: L1
l0: excelimporter-stringtomxobjectattributetypesenum.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-stringtomxobjectattributetypesenum.json
l2Logical: flow:ExcelImporter.StringToMxObjectAttributeTypesEnum
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.StringToMxObjectAttributeTypesEnum

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](excelimporter-stringtomxobjectattributetypesenum.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-stringtomxobjectattributetypesenum.json)

## Main Steps

- CreateVariableAction: create variable Enum=if $Input = 'AutoNumber' then MxModelReflection.PrimitiveTypes.AutoNumber else if $Input = 'BooleanType' then MxModelReflection.PrimitiveTypes.BooleanType else if $Input = 'DateTime' then MxModelReflection.PrimitiveTypes... create variable Enum=if $Input = 'AutoNumber' then MxModelReflection.PrimitiveTypes.AutoNumber else if $Input = 'BooleanType' then MxModelReflection.PrimitiveTypes.BooleanType else if $Input = 'DateTime' then MxModelReflection.PrimitiveTypes...

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

- nodeId=31a576f1-1b98-412c-be93-344bad074e2b; actionKind=Create; entity=MxModelReflection.PrimitiveTypes; summary=CreateVariableAction: create variable Enum=if $Input = 'AutoNumber' then MxModelReflection.PrimitiveTypes.AutoNumber else if $Input = 'BooleanType' then MxModelReflection.PrimitiveTypes.BooleanType else if $Input = 'DateTime' then MxModelReflection.PrimitiveTypes... create variable Enum=if $Input = 'AutoNumber' then MxModelReflection.PrimitiveTypes.AutoNumber else if $Input = 'BooleanType' then MxModelReflection.PrimitiveTypes.BooleanType else if $Input = 'DateTime' then MxModelReflection.PrimitiveTypes...

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-stringtomxobjectattributetypesenum.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
