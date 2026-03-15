---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.StringToMxObjectReferenceReferenceType
stableId: abd5eb26-38b5-43a8-8df8-876782a33c7a
slug: excelimporter-stringtomxobjectreferencereferencetype
layer: L1
l0: excelimporter-stringtomxobjectreferencereferencetype.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-stringtomxobjectreferencereferencetype.json
l2Logical: flow:ExcelImporter.StringToMxObjectReferenceReferenceType
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.StringToMxObjectReferenceReferenceType

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](excelimporter-stringtomxobjectreferencereferencetype.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-stringtomxobjectreferencereferencetype.json)

## Main Steps

- CreateVariableAction: create variable Enum=if $Input = 'Reference' then MxModelReflection.ReferenceType.Reference else if $Input = 'ReferenceSet' then MxModelReflection.ReferenceType.ReferenceSet else empty create variable Enum=if $Input = 'Reference' then MxModelReflection.ReferenceType.Reference else if $Input = 'ReferenceSet' then MxModelReflection.ReferenceType.ReferenceSet else empty

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

- nodeId=025501e3-507c-441b-8c9d-06ae9670c373; actionKind=Create; entity=MxModelReflection.ReferenceType; summary=CreateVariableAction: create variable Enum=if $Input = 'Reference' then MxModelReflection.ReferenceType.Reference else if $Input = 'ReferenceSet' then MxModelReflection.ReferenceType.ReferenceSet else empty create variable Enum=if $Input = 'Reference' then MxModelReflection.ReferenceType.Reference else if $Input = 'ReferenceSet' then MxModelReflection.ReferenceType.ReferenceSet else empty

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-stringtomxobjectreferencereferencetype.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
