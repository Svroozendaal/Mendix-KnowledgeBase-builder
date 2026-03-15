---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.ACT_UserTask_AssignToMe_UpdateTaskCount
stableId: 0b1c515e-22a7-4ae2-a525-4d2dde062c8d
slug: workflowcommons-act-usertask-assigntome-updatetaskcount
layer: L1
l0: workflowcommons-act-usertask-assigntome-updatetaskcount.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-usertask-assigntome-updatetaskcount.json
l2Logical: flow:WorkflowCommons.ACT_UserTask_AssignToMe_UpdateTaskCount
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.ACT_UserTask_AssignToMe_UpdateTaskCount

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](workflowcommons-act-usertask-assigntome-updatetaskcount.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-usertask-assigntome-updatetaskcount.json)

## Main Steps

- $IsAssigned Is Assigned? expression=$IsAssigned
- ChangeObjectAction: change TaskCount (refreshInClient=true) change TaskCount (refreshInClient=true)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: WorkflowCommons.SUB_TaskCount_Update, WorkflowCommons.SUB_UserTask_Assign
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=ac4a044d-12da-4de6-8dc5-6002c1968346; caption=Is Assigned?; expression=$IsAssigned Is Assigned? expression=$IsAssigned
- nodeId=c033084b-883d-45b3-94ac-0b3932bfa244; actionKind=Change; members=refreshInClient=true; summary=ChangeObjectAction: change TaskCount (refreshInClient=true) change TaskCount (refreshInClient=true)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-usertask-assigntome-updatetaskcount.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
