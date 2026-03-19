---
objectType: flow
module: Inspection
qualifiedName: Inspection.ACT_Task_SetToDone
stableId: 03114587-dc6f-4348-a516-efcf027a6b7a
slug: inspection-act-task-settodone
layer: L1
l0: inspection-act-task-settodone.abstract.md
l2Path: ../../../../app-overview/current/modules/Inspection/flows/inspection-act-task-settodone.json
l2Logical: flow:Inspection.ACT_Task_SetToDone
sourceRun: cli_2026-03-18T20-52-48.461Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Inspection.ACT_Task_SetToDone

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](inspection-act-task-settodone.abstract.md)
- L2: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-act-task-settodone.json)

## Main Steps

- $IsValid IsValid? expression=$IsValid
- ChangeObjectAction: change Task (Status=Inspection.Enum_TaskStatus.Done; refreshInClient=true) change Task (Status=Inspection.Enum_TaskStatus.Done; refreshInClient=true)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: Inspection.VAL_Task_Validate, Notification.SUB_Notification_SendToManager
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=a427846d-29e8-4aae-8f08-985a0ef0c340; caption=IsValid?; expression=$IsValid IsValid? expression=$IsValid
- nodeId=035f507d-7893-4953-97c9-9bce1f821563; actionKind=Change; entity=Inspection.Enum_TaskStatus; members=Status=Inspection.Enum_TaskStatus.Done; refreshInClient=true; summary=ChangeObjectAction: change Task (Status=Inspection.Enum_TaskStatus.Done; refreshInClient=true) change Task (Status=Inspection.Enum_TaskStatus.Done; refreshInClient=true)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-act-task-settodone.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/Inspection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/Inspection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-52-48.461Z
