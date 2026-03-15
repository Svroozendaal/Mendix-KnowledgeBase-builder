---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.Ch_SetReference
stableId: aeca027b-5f1b-43da-b373-d4cea07db07e
slug: excelimporter-ch-setreference
layer: L1
l0: excelimporter-ch-setreference.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ch-setreference.json
l2Logical: flow:ExcelImporter.Ch_SetReference
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.Ch_SetReference

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](excelimporter-ch-setreference.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ch-setreference.json)

## Main Steps

- retrieve Reference over association Column_MxObjectReference from column
- $column/ExcelImporter.Column_MxObjectReference != empty has reference selected expression=$column/ExcelImporter.Column_MxObjectReference != empty
- ChangeObjectAction: change column (FindReference=$Reference/CompleteName; refreshInClient=true) change column (FindReference=$Reference/CompleteName; refreshInClient=true)
- ChangeObjectAction: change column (FindReference=empty; refreshInClient=true) change column (FindReference=empty; refreshInClient=true)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by ExcelImporter.Ch_Column_SetDefaultObject.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: ExcelImporter.Ch_Column_SetDefaultObject

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=9c3e7c4d-a06a-49ac-a2fa-00c50f3b5397; sourceKind=Association; association=Column_MxObjectReference; summary=retrieve Reference over association Column_MxObjectReference from column
- nodeId=f05e8942-a3cb-4314-8634-1ac96596f6f5; caption=has reference selected; expression=$column/ExcelImporter.Column_MxObjectReference != empty has reference selected expression=$column/ExcelImporter.Column_MxObjectReference != empty
- nodeId=f9e3e994-35a4-431a-a07c-2118ae98dd1d; actionKind=Change; members=FindReference=$Reference/CompleteName; refreshInClient=true; summary=ChangeObjectAction: change column (FindReference=$Reference/CompleteName; refreshInClient=true) change column (FindReference=$Reference/CompleteName; refreshInClient=true)
- nodeId=7c3549e7-9274-4ac2-8359-086a0e13264a; actionKind=Change; members=FindReference=empty; refreshInClient=true; summary=ChangeObjectAction: change column (FindReference=empty; refreshInClient=true) change column (FindReference=empty; refreshInClient=true)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ch-setreference.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
