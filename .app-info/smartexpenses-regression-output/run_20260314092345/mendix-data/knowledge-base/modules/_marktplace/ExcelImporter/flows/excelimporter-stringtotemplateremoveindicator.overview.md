---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.StringToTemplateRemoveIndicator
stableId: 69004dbf-2c2d-4cf7-a556-bc776aa8cf6f
slug: excelimporter-stringtotemplateremoveindicator
layer: L1
l0: excelimporter-stringtotemplateremoveindicator.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-stringtotemplateremoveindicator.json
l2Logical: flow:ExcelImporter.StringToTemplateRemoveIndicator
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.StringToTemplateRemoveIndicator

## Summary

- Deterministic overview derived from exported flow structure.
- L0: [abstract](excelimporter-stringtotemplateremoveindicator.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-stringtotemplateremoveindicator.json)

## Main Steps

- $RemoveUnsyncedObjects = empty or toString( ExcelImporter.RemoveIndicator.Nothing ) = $RemoveUnsyncedObjects expression=$RemoveUnsyncedObjects = empty or toString( ExcelImporter.RemoveIndicator.Nothing ) = $RemoveUnsyncedObjects
- toString( ExcelImporter.RemoveIndicator.RemoveUnchangedObjects ) = $RemoveUnsyncedObjects expression=toString( ExcelImporter.RemoveIndicator.RemoveUnchangedObjects ) = $RemoveUnsyncedObjects

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; check L2 JSON if the exact user-facing effect matters.

## Key Entities Touched

- No entity evidence was exported for this flow.

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it may serve validation, background processing, or delegate work to other flows.

## Important Retrieves/Decisions/Mutations

- nodeId=0cf817d7-cb1c-4e13-823a-a3d3939654c8; caption=none; expression=$RemoveUnsyncedObjects = empty or toString( ExcelImporter.RemoveIndicator.Nothing ) = $RemoveUnsyncedObjects expression=$RemoveUnsyncedObjects = empty or toString( ExcelImporter.RemoveIndicator.Nothing ) = $RemoveUnsyncedObjects
- nodeId=58dd0db9-0e6b-4fe6-a64a-f1e7694d308e; caption=none; expression=toString( ExcelImporter.RemoveIndicator.RemoveUnchangedObjects ) = $RemoveUnsyncedObjects expression=toString( ExcelImporter.RemoveIndicator.RemoveUnchangedObjects ) = $RemoveUnsyncedObjects
- nodeId=bdb68574-df70-4980-b1b0-514e8d002aaf; caption=none; expression=toString( ExcelImporter.RemoveIndicator.TrackChanges ) = $RemoveUnsyncedObjects expression=toString( ExcelImporter.RemoveIndicator.TrackChanges ) = $RemoveUnsyncedObjects

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-stringtotemplateremoveindicator.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
