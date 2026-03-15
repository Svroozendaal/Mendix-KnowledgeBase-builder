---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.ParseStringToEnum_StatisticsLevel
stableId: b067e1a3-f187-41a2-8e20-c661a3089c7a
slug: excelimporter-parsestringtoenum-statisticslevel
layer: L1
l0: excelimporter-parsestringtoenum-statisticslevel.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-parsestringtoenum-statisticslevel.json
l2Logical: flow:ExcelImporter.ParseStringToEnum_StatisticsLevel
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.ParseStringToEnum_StatisticsLevel

## Summary

- Deterministic overview derived from exported flow structure.
- L0: [abstract](excelimporter-parsestringtoenum-statisticslevel.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-parsestringtoenum-statisticslevel.json)

## Main Steps

- $PrintStatisticsMessages = empty empty? expression=$PrintStatisticsMessages = empty
- $PrintStatisticsMessages = 'AllStatistics' expression=$PrintStatisticsMessages = 'AllStatistics'

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

- nodeId=557ad00a-f540-43f7-b408-9edd37b1f531; caption=empty?; expression=$PrintStatisticsMessages = empty empty? expression=$PrintStatisticsMessages = empty
- nodeId=6d54995e-9857-4a75-8da7-9cc73293bfad; caption=none; expression=$PrintStatisticsMessages = 'AllStatistics' expression=$PrintStatisticsMessages = 'AllStatistics'
- nodeId=6b4ea034-8f8e-45c3-a78c-2ec81a002986; caption=none; expression=$PrintStatisticsMessages = 'NoStatistics' expression=$PrintStatisticsMessages = 'NoStatistics'
- nodeId=e15be779-fe57-4074-a711-c1ae476c8812; caption=none; expression=$PrintStatisticsMessages = 'OnlyFinalStatistics' expression=$PrintStatisticsMessages = 'OnlyFinalStatistics'

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-parsestringtoenum-statisticslevel.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
