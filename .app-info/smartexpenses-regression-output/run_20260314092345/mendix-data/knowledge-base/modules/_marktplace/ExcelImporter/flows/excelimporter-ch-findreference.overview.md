---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.Ch_FindReference
stableId: dbe5fcfd-5671-44f0-9895-465034f1046e
slug: excelimporter-ch-findreference
layer: L1
l0: excelimporter-ch-findreference.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ch-findreference.json
l2Logical: flow:ExcelImporter.Ch_FindReference
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.Ch_FindReference

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](excelimporter-ch-findreference.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ch-findreference.json)

## Main Steps

- retrieve MxObjectType over association Column_MxObjectType from Column
- $Reference != empty found? expression=$Reference != empty
- $Column/FindReference != empty and $Column/FindReference != '' has ref search string expression=$Column/FindReference != empty and $Column/FindReference != ''
- ChangeObjectAction: change Column (Column_MxObjectReference=$Reference, FindReference=$Reference/CompleteName; refreshInClient=true) change Column (Column_MxObjectReference=$Reference, FindReference=$Reference/CompleteName; refreshInClient=true)
- ChangeObjectAction: change Column (Column_MxObjectReference=empty; refreshInClient=true) change Column (Column_MxObjectReference=empty; refreshInClient=true)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: ExcelImporter.Column_SetCorrectRefObjectType, MxModelReflection.FindReference
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=d7ba52ab-20ff-4b21-adbe-1141b305c8b9; sourceKind=Association; association=Column_MxObjectType; summary=retrieve MxObjectType over association Column_MxObjectType from Column
- nodeId=3b0f2da4-4554-4a2b-82ec-4cd32205975f; caption=found?; expression=$Reference != empty found? expression=$Reference != empty
- nodeId=4cdb958b-173d-4c3e-8c5e-df87766e45d3; caption=has ref search string; expression=$Column/FindReference != empty and $Column/FindReference != '' has ref search string expression=$Column/FindReference != empty and $Column/FindReference != ''
- nodeId=b9cb6d7b-7743-40f6-95ac-ae4b0dd6a42f; actionKind=Change; members=Column_MxObjectReference=$Reference, FindReference=$Reference/CompleteName; refreshInClient=true; summary=ChangeObjectAction: change Column (Column_MxObjectReference=$Reference, FindReference=$Reference/CompleteName; refreshInClient=true) change Column (Column_MxObjectReference=$Reference, FindReference=$Reference/CompleteName; refreshInClient=true)
- nodeId=ad7b4fbe-056b-4505-b5c3-cc763b203a2c; actionKind=Change; members=Column_MxObjectReference=empty; refreshInClient=true; summary=ChangeObjectAction: change Column (Column_MxObjectReference=empty; refreshInClient=true) change Column (Column_MxObjectReference=empty; refreshInClient=true)
- nodeId=b5a0f40e-d2b7-472b-98a5-ab7af2180da4; actionKind=Change; members=Column_MxObjectReference=empty; refreshInClient=true; summary=ChangeObjectAction: change Column (Column_MxObjectReference=empty; refreshInClient=true) change Column (Column_MxObjectReference=empty; refreshInClient=true)

## Warnings/Unknowns

- Rollback hint detected in node detail.
- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ch-findreference.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
