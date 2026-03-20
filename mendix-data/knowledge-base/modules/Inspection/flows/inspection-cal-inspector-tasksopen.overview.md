---
objectType: flow
module: Inspection
qualifiedName: Inspection.CAL_Inspector_TasksOpen
stableId: 862134f9-de13-44d3-a001-6902d40a1e68
slug: inspection-cal-inspector-tasksopen
layer: L1
l0: inspection-cal-inspector-tasksopen.abstract.md
l2Path: ../../../../app-overview/current/modules/Inspection/flows/inspection-cal-inspector-tasksopen.json
l2Logical: flow:Inspection.CAL_Inspector_TasksOpen
sourceRun: cli_2026-03-19T15-48-55.594Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Inspection.CAL_Inspector_TasksOpen

## Summary

- Deterministic overview derived from exported flow structure.
- L0: [abstract](inspection-cal-inspector-tasksopen.abstract.md)
- L2: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-cal-inspector-tasksopen.json)

## Main Steps

- retrieve from Inspection.Task WHERE Inspection.Task_Inspector = $Inspector] [Status = 'To_do' or Status = 'Running'

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; check L2 JSON if the exact user-facing effect matters.

## Key Entities Touched

- Inspection.Task

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it may serve validation, background processing, or delegate work to other flows.

## Important Retrieves/Decisions/Mutations

- nodeId=n002-retrieve; sourceKind=Database; entity=Inspection.Task; xPath=Inspection.Task_Inspector = $Inspector] [Status = 'To_do' or Status = 'Running'; summary=retrieve from Inspection.Task WHERE Inspection.Task_Inspector = $Inspector] [Status = 'To_do' or Status = 'Running'

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-cal-inspector-tasksopen.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-19T15-48-55.594Z/modules/Inspection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-19T15-48-55.594Z/modules/Inspection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-19T15-48-55.594Z
