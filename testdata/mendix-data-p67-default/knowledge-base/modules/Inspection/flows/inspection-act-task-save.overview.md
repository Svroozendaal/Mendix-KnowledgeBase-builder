---
objectType: flow
module: Inspection
qualifiedName: Inspection.ACT_Task_Save
stableId: 9f1526a5-afb7-4a20-905c-0a1efd8b8218
slug: inspection-act-task-save
layer: L1
l0: inspection-act-task-save.abstract.md
l2Path: ../../../../app-overview/current/modules/Inspection/flows/inspection-act-task-save.json
l2Logical: flow:Inspection.ACT_Task_Save
sourceRun: cli_2026-03-18T21-10-02.160Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Inspection.ACT_Task_Save

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](inspection-act-task-save.abstract.md)
- L2: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-act-task-save.json)

## Main Steps

- $IsValid
- $Task/Status = Inspection.Enum_TaskStatus.To_do
- commit $Task WITH EVENTS REFRESH ON ERROR ROLLBACK

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: Inspection.VAL_Task_Validate, Notification.SUB_Notification_SendToInspector, Notification.SUB_Notification_SendToManager
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=n003-decision; caption=IF; expression=$IsValid
- nodeId=n004-decision; caption=IF; expression=$Task/Status = Inspection.Enum_TaskStatus.To_do
- nodeId=n006-decision; caption=IF; expression=$Task/Status = Inspection.Enum_TaskStatus.Done
- nodeId=n008-commit; actionKind=Commit; entity=Inspection.Task; summary=commit $Task WITH EVENTS REFRESH ON ERROR ROLLBACK

## Warnings/Unknowns

- Rollback hint detected in node detail.
- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-act-task-save.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-18T21-10-02.160Z/modules/Inspection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-18T21-10-02.160Z/modules/Inspection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T21-10-02.160Z
