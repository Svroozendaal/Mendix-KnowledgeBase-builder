---
objectType: flow
module: Inspection
qualifiedName: Inspection.ACT_Task_SetToInProgress
stableId: 1877708d-aebb-453e-8027-255a485774c6
slug: inspection-act-task-settoinprogress
layer: L1
l0: inspection-act-task-settoinprogress.abstract.md
l2Path: ../../../../app-overview/current/modules/Inspection/flows/inspection-act-task-settoinprogress.json
l2Logical: flow:Inspection.ACT_Task_SetToInProgress
sourceRun: cli_2026-03-18T21-10-02.160Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Inspection.ACT_Task_SetToInProgress

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](inspection-act-task-settoinprogress.abstract.md)
- L2: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-act-task-settoinprogress.json)

## Main Steps

- change $Task (Status = Inspection.Enum_TaskStatus.Running)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=n002-change; actionKind=Change; entity=Inspection.Task; members=Status = Inspection.Enum_TaskStatus.Running; summary=change $Task (Status = Inspection.Enum_TaskStatus.Running)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-act-task-settoinprogress.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-18T21-10-02.160Z/modules/Inspection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-18T21-10-02.160Z/modules/Inspection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T21-10-02.160Z
