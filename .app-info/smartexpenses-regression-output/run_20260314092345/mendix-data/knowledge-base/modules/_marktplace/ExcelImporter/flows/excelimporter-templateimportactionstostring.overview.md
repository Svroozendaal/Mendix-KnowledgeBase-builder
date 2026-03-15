---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.TemplateImportActionsToString
stableId: 65f59e2d-8bb6-42ac-8f4e-32dc11bab7cc
slug: excelimporter-templateimportactionstostring
layer: L1
l0: excelimporter-templateimportactionstostring.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-templateimportactionstostring.json
l2Logical: flow:ExcelImporter.TemplateImportActionsToString
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.TemplateImportActionsToString

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](excelimporter-templateimportactionstostring.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-templateimportactionstostring.json)

## Main Steps

- CreateVariableAction: create variable ImportActionString=getKey($ImportActions) create variable ImportActionString=getKey($ImportActions)

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

- nodeId=c9f6251b-8b1b-45d9-81ab-5a6c59f05740; actionKind=Create; members=$ImportActions; summary=CreateVariableAction: create variable ImportActionString=getKey($ImportActions) create variable ImportActionString=getKey($ImportActions)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-templateimportactionstostring.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
