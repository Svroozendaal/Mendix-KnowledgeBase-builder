---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.MxObjectAttributeTypesEnumToString
stableId: 5832521b-ffb7-4a1c-9ec2-6a51ce7dcbff
slug: excelimporter-mxobjectattributetypesenumtostring
layer: L1
l0: excelimporter-mxobjectattributetypesenumtostring.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-mxobjectattributetypesenumtostring.json
l2Logical: flow:ExcelImporter.MxObjectAttributeTypesEnumToString
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.MxObjectAttributeTypesEnumToString

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](excelimporter-mxobjectattributetypesenumtostring.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-mxobjectattributetypesenumtostring.json)

## Main Steps

- CreateVariableAction: create variable AttributeTypeString=getKey($AttributeTypes) create variable AttributeTypeString=getKey($AttributeTypes)

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

- nodeId=9ee500ae-bad3-42f8-abc4-1673929d7c43; actionKind=Create; members=$AttributeTypes; summary=CreateVariableAction: create variable AttributeTypeString=getKey($AttributeTypes) create variable AttributeTypeString=getKey($AttributeTypes)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-mxobjectattributetypesenumtostring.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
