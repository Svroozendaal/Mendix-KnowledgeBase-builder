---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.Ch_FindMicroflow
stableId: caf8ed1c-4344-409c-90e7-53ce3a1d0ed5
slug: excelimporter-ch-findmicroflow
layer: L1
l0: excelimporter-ch-findmicroflow.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ch-findmicroflow.json
l2Logical: flow:ExcelImporter.Ch_FindMicroflow
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.Ch_FindMicroflow

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](excelimporter-ch-findmicroflow.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ch-findmicroflow.json)

## Main Steps

- $Microflow != empty found? expression=$Microflow != empty
- $Column/FindMicroflow != empty and $Column/FindMicroflow != '' has mf search string expression=$Column/FindMicroflow != empty and $Column/FindMicroflow != ''
- ChangeObjectAction: change Column (Column_Microflows=$Microflow, FindMicroflow=$Microflow/CompleteName; refreshInClient=true) change Column (Column_Microflows=$Microflow, FindMicroflow=$Microflow/CompleteName; refreshInClient=true)
- ChangeObjectAction: change Column (Column_Microflows=empty; refreshInClient=true) change Column (Column_Microflows=empty; refreshInClient=true)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: MxModelReflection.FindMicroflow
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=245ee5e1-fe45-4d8b-8734-151aba9ffb1f; caption=found?; expression=$Microflow != empty found? expression=$Microflow != empty
- nodeId=a6222e0e-4280-4ca4-81eb-0556ef7b2a2f; caption=has mf search string; expression=$Column/FindMicroflow != empty and $Column/FindMicroflow != '' has mf search string expression=$Column/FindMicroflow != empty and $Column/FindMicroflow != ''
- nodeId=4570cb19-1ef6-4611-bf76-e32f4947458a; actionKind=Change; members=Column_Microflows=$Microflow, FindMicroflow=$Microflow/CompleteName; refreshInClient=true; summary=ChangeObjectAction: change Column (Column_Microflows=$Microflow, FindMicroflow=$Microflow/CompleteName; refreshInClient=true) change Column (Column_Microflows=$Microflow, FindMicroflow=$Microflow/CompleteName; refreshInClient=true)
- nodeId=3f1e34cb-2f9b-404c-b12c-9ffcacd0200c; actionKind=Change; members=Column_Microflows=empty; refreshInClient=true; summary=ChangeObjectAction: change Column (Column_Microflows=empty; refreshInClient=true) change Column (Column_Microflows=empty; refreshInClient=true)
- nodeId=63461386-7b6a-48b7-8329-b9229b3d325f; actionKind=Change; members=Column_Microflows=empty; refreshInClient=true; summary=ChangeObjectAction: change Column (Column_Microflows=empty; refreshInClient=true) change Column (Column_Microflows=empty; refreshInClient=true)

## Warnings/Unknowns

- Rollback hint detected in node detail.
- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ch-findmicroflow.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
