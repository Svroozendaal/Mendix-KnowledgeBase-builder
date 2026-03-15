---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.ACT_TaskAssignmentHelper_Retarget_Show
stableId: 6574b420-d9cb-46a5-b488-7afdd79598d7
slug: workflowcommons-act-taskassignmenthelper-retarget-show
layer: L1
l0: workflowcommons-act-taskassignmenthelper-retarget-show.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-taskassignmenthelper-retarget-show.json
l2Logical: flow:WorkflowCommons.ACT_TaskAssignmentHelper_Retarget_Show
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.ACT_TaskAssignmentHelper_Retarget_Show

## Summary

- Likely acts as a UI entry or navigation handler because it shows WorkflowCommons.TaskAssignmentHelper_UserTask_Retarget.
- L0: [abstract](workflowcommons-act-taskassignmenthelper-retarget-show.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-taskassignmenthelper-retarget-show.json)

## Main Steps

- $WorkflowUserTaskList != empty Task selected? expression=$WorkflowUserTaskList != empty
- ShowPageAction: show page WorkflowCommons.TaskAssignmentHelper_UserTask_Retarget show page WorkflowCommons.TaskAssignmentHelper_UserTask_Retarget
- ChangeObjectAction: change TaskAssignmentHelper (TaskAssignmentHelper_WorkflowUserTask=$WorkflowUserTaskList; refreshInClient=false) change TaskAssignmentHelper (TaskAssignmentHelper_WorkflowUserTask=$WorkflowUserTaskList; refreshInClient=false)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: Shows WorkflowCommons.TaskAssignmentHelper_UserTask_Retarget.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- WorkflowCommons.TaskAssignmentHelper_UserTask_Retarget

## Important Retrieves/Decisions/Mutations

- nodeId=ac5f3bd3-a1a6-4cc6-ad2b-a9ef053ec70d; caption=Task selected?; expression=$WorkflowUserTaskList != empty Task selected? expression=$WorkflowUserTaskList != empty
- nodeId=fded7f88-8241-49a6-8ba1-6b5e546eb0f0; actionKind=Change; members=TaskAssignmentHelper_WorkflowUserTask=$WorkflowUserTaskList; refreshInClient=false; summary=ChangeObjectAction: change TaskAssignmentHelper (TaskAssignmentHelper_WorkflowUserTask=$WorkflowUserTaskList; refreshInClient=false) change TaskAssignmentHelper (TaskAssignmentHelper_WorkflowUserTask=$WorkflowUserTaskList; refreshInClient=false)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-taskassignmenthelper-retarget-show.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
