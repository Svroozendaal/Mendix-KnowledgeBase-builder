---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.TemplateReferenceHandlingEnumToString
stableId: 6ea0b225-da30-4811-a607-72f09e9826c0
slug: excelimporter-templatereferencehandlingenumtostring
layer: L1
l0: excelimporter-templatereferencehandlingenumtostring.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-templatereferencehandlingenumtostring.json
l2Logical: flow:ExcelImporter.TemplateReferenceHandlingEnumToString
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.TemplateReferenceHandlingEnumToString

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](excelimporter-templatereferencehandlingenumtostring.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-templatereferencehandlingenumtostring.json)

## Main Steps

- CreateVariableAction: create variable RefString=getKey($ReferenceHandling) create variable RefString=getKey($ReferenceHandling)

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

- nodeId=ee1062f7-066f-42a0-9b64-3b458d0da5a2; actionKind=Create; members=$ReferenceHandling; summary=CreateVariableAction: create variable RefString=getKey($ReferenceHandling) create variable RefString=getKey($ReferenceHandling)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-templatereferencehandlingenumtostring.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
