---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.MxObjectReferenceReferenceTypeToString
stableId: 76166651-cf10-4a76-a429-abf12a2ef511
slug: excelimporter-mxobjectreferencereferencetypetostring
layer: L1
l0: excelimporter-mxobjectreferencereferencetypetostring.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-mxobjectreferencereferencetypetostring.json
l2Logical: flow:ExcelImporter.MxObjectReferenceReferenceTypeToString
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.MxObjectReferenceReferenceTypeToString

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](excelimporter-mxobjectreferencereferencetypetostring.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-mxobjectreferencereferencetypetostring.json)

## Main Steps

- CreateVariableAction: create variable ReferenceTypeString=getKey($ReferenceTypeEnum) create variable ReferenceTypeString=getKey($ReferenceTypeEnum)

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

- nodeId=6618193e-4281-4c5b-a476-4b97336e1cad; actionKind=Create; members=$ReferenceTypeEnum; summary=CreateVariableAction: create variable ReferenceTypeString=getKey($ReferenceTypeEnum) create variable ReferenceTypeString=getKey($ReferenceTypeEnum)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-mxobjectreferencereferencetypetostring.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
