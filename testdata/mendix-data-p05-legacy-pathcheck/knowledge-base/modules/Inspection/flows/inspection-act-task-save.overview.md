---
objectType: flow
module: Inspection
qualifiedName: Inspection.ACT_Task_Save
stableId: 9f1526a5-afb7-4a20-905c-0a1efd8b8218
slug: inspection-act-task-save
layer: L1
l0: inspection-act-task-save.abstract.md
l2Path: ../../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-act-task-save.json
l2Logical: flow:Inspection.ACT_Task_Save
sourceRun: cli_2026-03-18T20-44-56.522Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Inspection.ACT_Task_Save

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](inspection-act-task-save.abstract.md)
- L2: [json](../../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-act-task-save.json)

## Main Steps

- $Task/Status = Inspection.Enum_TaskStatus.Done task set to 'done'? expression=$Task/Status = Inspection.Enum_TaskStatus.Done
- $IsValid IsValid? expression=$IsValid
- CommitAction: commit Task (refreshInClient=true, withEvents=true) commit Task (refreshInClient=true, withEvents=true)

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

- nodeId=2d7a77fa-c91c-421a-963d-dd2a9ac4ec1d; caption=task set to 'done'?; expression=$Task/Status = Inspection.Enum_TaskStatus.Done task set to 'done'? expression=$Task/Status = Inspection.Enum_TaskStatus.Done
- nodeId=439e480d-20ab-46e6-a5fe-d99443145321; caption=IsValid?; expression=$IsValid IsValid? expression=$IsValid
- nodeId=d95b605d-cd20-4b90-9f2b-2b3734a70be0; caption=status is set to 'to do'?; expression=$Task/Status = Inspection.Enum_TaskStatus.To_do status is set to 'to do'? expression=$Task/Status = Inspection.Enum_TaskStatus.To_do
- nodeId=3e4b8309-cb40-4b11-86ab-a454fdeff32d; actionKind=Commit; members=refreshInClient=true, withEvents=true; summary=CommitAction: commit Task (refreshInClient=true, withEvents=true) commit Task (refreshInClient=true, withEvents=true)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-act-task-save.json)
- Aggregate export: [flows.json](../../../../../mendix-data-p05-legacy/app-overview/cli_2026-03-18T20-44-56.522Z/modules/Inspection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../mendix-data-p05-legacy/app-overview/cli_2026-03-18T20-44-56.522Z/modules/Inspection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-44-56.522Z
