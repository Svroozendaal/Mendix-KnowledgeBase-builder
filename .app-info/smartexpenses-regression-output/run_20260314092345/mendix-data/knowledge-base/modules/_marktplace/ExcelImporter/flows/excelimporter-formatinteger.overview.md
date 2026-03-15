---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.FormatInteger
stableId: 770943ac-4f30-4e4a-a5ff-8fedc75d39ed
slug: excelimporter-formatinteger
layer: L1
l0: excelimporter-formatinteger.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-formatinteger.json
l2Logical: flow:ExcelImporter.FormatInteger
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.FormatInteger

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](excelimporter-formatinteger.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-formatinteger.json)

## Main Steps

- CreateVariableAction: create variable FormattedInt=if( contains( $Unformatted, '.') ) then substring($Unformatted, 0, find($Unformatted,'.')) else $Unformatted create variable FormattedInt=if( contains( $Unformatted, '.') ) then substring($Unformatted, 0, find($Unformatted,'.')) else $Unformatted

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

- nodeId=911b2f51-e504-44c2-94b2-1bfafb91f8d8; actionKind=Create; members=contains( $Unformatted, '.'; summary=CreateVariableAction: create variable FormattedInt=if( contains( $Unformatted, '.') ) then substring($Unformatted, 0, find($Unformatted,'.')) else $Unformatted create variable FormattedInt=if( contains( $Unformatted, '.') ) then substring($Unformatted, 0, find($Unformatted,'.')) else $Unformatted

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-formatinteger.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
