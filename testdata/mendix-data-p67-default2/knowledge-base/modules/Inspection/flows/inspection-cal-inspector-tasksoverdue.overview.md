---
objectType: flow
module: Inspection
qualifiedName: Inspection.CAL_Inspector_TasksOverdue
stableId: 7209dc67-aa43-4278-8400-21cf36a6ba76
slug: inspection-cal-inspector-tasksoverdue
layer: L1
l0: inspection-cal-inspector-tasksoverdue.abstract.md
l2Path: ../../../../app-overview/current/modules/Inspection/flows/inspection-cal-inspector-tasksoverdue.json
l2Logical: flow:Inspection.CAL_Inspector_TasksOverdue
sourceRun: cli_2026-03-18T21-15-38.461Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Inspection.CAL_Inspector_TasksOverdue

## Summary

- Deterministic overview derived from exported flow structure.
- L0: [abstract](inspection-cal-inspector-tasksoverdue.abstract.md)
- L2: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-cal-inspector-tasksoverdue.json)

## Main Steps

- retrieve from Inspection.Task WHERE Inspection.Task_Inspector = $Inspector] [DueDate < '[%BeginOfCurrentDay%]'

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

- nodeId=n002-retrieve; sourceKind=Database; entity=Inspection.Task; xPath=Inspection.Task_Inspector = $Inspector] [DueDate < '[%BeginOfCurrentDay%]'; summary=retrieve from Inspection.Task WHERE Inspection.Task_Inspector = $Inspector] [DueDate < '[%BeginOfCurrentDay%]'

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-cal-inspector-tasksoverdue.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-18T21-15-38.461Z/modules/Inspection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-18T21-15-38.461Z/modules/Inspection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T21-15-38.461Z
