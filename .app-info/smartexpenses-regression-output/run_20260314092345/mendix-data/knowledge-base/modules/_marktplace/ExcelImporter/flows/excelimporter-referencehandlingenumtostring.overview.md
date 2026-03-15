---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.ReferenceHandlingEnumToString
stableId: 74299b46-024a-45fe-b000-2c57e63ac89d
slug: excelimporter-referencehandlingenumtostring
layer: L1
l0: excelimporter-referencehandlingenumtostring.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-referencehandlingenumtostring.json
l2Logical: flow:ExcelImporter.ReferenceHandlingEnumToString
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.ReferenceHandlingEnumToString

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](excelimporter-referencehandlingenumtostring.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-referencehandlingenumtostring.json)

## Main Steps

- CreateVariableAction: create variable ReferenceHandlingEnumString=getKey($ReferenceHandlingEnum) create variable ReferenceHandlingEnumString=getKey($ReferenceHandlingEnum)

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

- nodeId=918f3f0b-5cdf-49b5-9b93-8a43b0a61d19; actionKind=Create; members=$ReferenceHandlingEnum; summary=CreateVariableAction: create variable ReferenceHandlingEnumString=getKey($ReferenceHandlingEnum) create variable ReferenceHandlingEnumString=getKey($ReferenceHandlingEnum)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-referencehandlingenumtostring.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
