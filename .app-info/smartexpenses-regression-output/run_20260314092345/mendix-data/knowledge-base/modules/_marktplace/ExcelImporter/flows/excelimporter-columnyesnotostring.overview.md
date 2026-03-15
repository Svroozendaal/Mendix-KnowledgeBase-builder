---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.ColumnYesNoToString
stableId: 439f5d1e-0d9e-42e2-a964-71d819f52f16
slug: excelimporter-columnyesnotostring
layer: L1
l0: excelimporter-columnyesnotostring.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-columnyesnotostring.json
l2Logical: flow:ExcelImporter.ColumnYesNoToString
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.ColumnYesNoToString

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](excelimporter-columnyesnotostring.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-columnyesnotostring.json)

## Main Steps

- CreateVariableAction: create variable YesNoString=getKey($YesNo) create variable YesNoString=getKey($YesNo)

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

- nodeId=d9aacbb4-984c-4d21-8b97-19d2186e0b96; actionKind=Create; members=$YesNo; summary=CreateVariableAction: create variable YesNoString=getKey($YesNo) create variable YesNoString=getKey($YesNo)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-columnyesnotostring.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
