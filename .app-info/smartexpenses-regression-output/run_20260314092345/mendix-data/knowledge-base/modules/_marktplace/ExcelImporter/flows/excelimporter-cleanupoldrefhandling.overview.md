---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.CleanupOldRefHandling
stableId: 2940ff7e-55d5-4ac6-a09e-505f280a821c
slug: excelimporter-cleanupoldrefhandling
layer: L1
l0: excelimporter-cleanupoldrefhandling.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-cleanupoldrefhandling.json
l2Logical: flow:ExcelImporter.CleanupOldRefHandling
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.CleanupOldRefHandling

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](excelimporter-cleanupoldrefhandling.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-cleanupoldrefhandling.json)

## Main Steps

- retrieve ReferenceHandlingList over association ReferenceHandling_Template from Template
- $IteratorReferenceHandling/ExcelImporter.ReferenceHandling_MxObjectReference != empty Still Has reference? expression=$IteratorReferenceHandling/ExcelImporter.ReferenceHandling_MxObjectReference != empty
- DeleteAction: delete IteratorReferenceHandling (refreshInClient=false) delete IteratorReferenceHandling (refreshInClient=false)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by ExcelImporter.IVK_SaveTemplate.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: ExcelImporter.IVK_SaveTemplate

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=15c0ccee-4ec5-423a-9a0a-f0f8fa68888b; sourceKind=Association; association=ReferenceHandling_Template; summary=retrieve ReferenceHandlingList over association ReferenceHandling_Template from Template
- nodeId=b07803d9-151a-484b-93ff-46fd8957e436; caption=Still Has reference?; expression=$IteratorReferenceHandling/ExcelImporter.ReferenceHandling_MxObjectReference != empty Still Has reference? expression=$IteratorReferenceHandling/ExcelImporter.ReferenceHandling_MxObjectReference != empty
- nodeId=90066945-3b67-4f9f-86aa-d89bde87c0e9; actionKind=Delete; members=refreshInClient=false; summary=DeleteAction: delete IteratorReferenceHandling (refreshInClient=false) delete IteratorReferenceHandling (refreshInClient=false)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-cleanupoldrefhandling.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
