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
sourceRun: cli_2026-03-18T20-44-56.522Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Inspection.CAL_Inspector_TasksOverdue

## Summary

- Deterministic overview derived from exported flow structure.
- L0: [abstract](inspection-cal-inspector-tasksoverdue.abstract.md)
- L2: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-cal-inspector-tasksoverdue.json)

## Main Steps

- RetrieveAction: retrieve TaskList_OverDue from Inspection.Task retrieve TaskList_OverDue from Inspection.Task

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

- nodeId=f7ed0822-adfb-421b-a152-12af874f858c; sourceKind=Database; entity=Inspection.Task; summary=RetrieveAction: retrieve TaskList_OverDue from Inspection.Task retrieve TaskList_OverDue from Inspection.Task

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-cal-inspector-tasksoverdue.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-18T20-44-56.522Z/modules/Inspection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-18T20-44-56.522Z/modules/Inspection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-44-56.522Z
