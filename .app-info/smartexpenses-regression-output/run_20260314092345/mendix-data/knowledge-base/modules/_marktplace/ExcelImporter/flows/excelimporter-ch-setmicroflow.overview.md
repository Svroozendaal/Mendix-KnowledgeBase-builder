---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.Ch_SetMicroflow
stableId: 60fbe072-f03f-451e-bde2-f8026531be62
slug: excelimporter-ch-setmicroflow
layer: L1
l0: excelimporter-ch-setmicroflow.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ch-setmicroflow.json
l2Logical: flow:ExcelImporter.Ch_SetMicroflow
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.Ch_SetMicroflow

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](excelimporter-ch-setmicroflow.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ch-setmicroflow.json)

## Main Steps

- retrieve Microflow over association Column_Microflows from column
- $column/ExcelImporter.Column_Microflows != empty has microflow selected expression=$column/ExcelImporter.Column_Microflows != empty
- ChangeObjectAction: change column (FindMicroflow=$Microflow/CompleteName; refreshInClient=true) change column (FindMicroflow=$Microflow/CompleteName; refreshInClient=true)
- ChangeObjectAction: change column (FindMicroflow=empty; refreshInClient=true) change column (FindMicroflow=empty; refreshInClient=true)

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

- nodeId=ceb157bc-b7c2-4db6-baa4-0e2028dd7eee; sourceKind=Association; association=Column_Microflows; summary=retrieve Microflow over association Column_Microflows from column
- nodeId=11a362ca-c4d7-4a48-a343-a75d6f33225b; caption=has microflow selected; expression=$column/ExcelImporter.Column_Microflows != empty has microflow selected expression=$column/ExcelImporter.Column_Microflows != empty
- nodeId=abd41eb1-0059-4333-a6c9-78f9c8561209; actionKind=Change; members=FindMicroflow=$Microflow/CompleteName; refreshInClient=true; summary=ChangeObjectAction: change column (FindMicroflow=$Microflow/CompleteName; refreshInClient=true) change column (FindMicroflow=$Microflow/CompleteName; refreshInClient=true)
- nodeId=1dbc406a-92d3-4e6c-bc3f-c7ee94765af5; actionKind=Change; members=FindMicroflow=empty; refreshInClient=true; summary=ChangeObjectAction: change column (FindMicroflow=empty; refreshInClient=true) change column (FindMicroflow=empty; refreshInClient=true)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ch-setmicroflow.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
