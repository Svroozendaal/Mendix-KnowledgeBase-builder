---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.prepareReferenceHandling
stableId: 7fc6b071-b6d7-48cb-8b1c-755fbd68ab25
slug: excelimporter-preparereferencehandling
layer: L1
l0: excelimporter-preparereferencehandling.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-preparereferencehandling.json
l2Logical: flow:ExcelImporter.prepareReferenceHandling
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.prepareReferenceHandling

## Summary

- Likely acts as a save, process, or background step for ExcelImporter.Column, ExcelImporter.ReferenceHandling because it mutates data without showing a page.
- L0: [abstract](excelimporter-preparereferencehandling.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-preparereferencehandling.json)

## Main Steps

- retrieve vMxReference over association Column_MxObjectReference from pColumn
- retrieve vOriColumn from ExcelImporter.Column
- $Count > 0 > 0 expression=$Count > 0
- $vReferenceHandling != empty found? expression=$vReferenceHandling != empty
- ChangeObjectAction: change vNewReferenceHandling (ReferenceHandling_Template=$pColumn/ExcelImporter.Column_Template, ReferenceHandling_MxObjectReference=$vMxReference; refreshInClient=true) change vNewReferenceHandling (ReferenceHandling_Template=$pColumn/ExcelImporter.Column_Template, ReferenceHandling_MxObjectReference=$vMxReference; refreshInClient=true)
- CreateObjectAction: create ExcelImporter.ReferenceHandling as vNewReferenceHandling create ExcelImporter.ReferenceHandling as vNewReferenceHandling

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by ExcelImporter.BCo_Column, ExcelImporter.BDe_Column.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- ExcelImporter.Column, ExcelImporter.ReferenceHandling

## Called / Called By

- Calls: none
- Called by: ExcelImporter.BCo_Column, ExcelImporter.BDe_Column

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=43496cbe-b9e3-40af-9aa2-b4a7d81e5a92; sourceKind=Association; association=Column_MxObjectReference; summary=retrieve vMxReference over association Column_MxObjectReference from pColumn
- nodeId=afd86f46-88ac-4527-ba2c-445cd6e5479d; sourceKind=Database; entity=ExcelImporter.Column; summary=retrieve vOriColumn from ExcelImporter.Column
- nodeId=d168ec99-50af-4491-a2eb-d86f5cc614fa; sourceKind=Database; entity=ExcelImporter.Column; summary=retrieve vOtherColumnWithThisRef from ExcelImporter.Column
- nodeId=fa482da1-56c5-4065-b4dd-f9653943c0cd; sourceKind=Database; entity=ExcelImporter.ReferenceHandling; summary=retrieve vReferenceHandling from ExcelImporter.ReferenceHandling
- nodeId=cd888d8b-fdec-43de-b79b-094207c862a3; sourceKind=Database; entity=ExcelImporter.ReferenceHandling; summary=retrieve vReferenceHandlingToRemove from ExcelImporter.ReferenceHandling
- nodeId=c835aa02-5961-49e3-9288-5a41be3af8ec; caption=> 0; expression=$Count > 0 > 0 expression=$Count > 0
- nodeId=4d7277dd-10f5-4e89-8412-6215ba9a631f; caption=found?; expression=$vReferenceHandling != empty found? expression=$vReferenceHandling != empty
- nodeId=1f55663c-fa34-447a-ba3a-5d2d5c042544; caption=found?; expression=$vReferenceHandlingToRemove != empty found? expression=$vReferenceHandlingToRemove != empty

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-preparereferencehandling.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
