---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.ACT_TaskAssignmentHelper_Reassign_Show
stableId: 153f8d01-aeba-48e4-9803-99d89ebd93c2
slug: workflowcommons-act-taskassignmenthelper-reassign-show
layer: L1
l0: workflowcommons-act-taskassignmenthelper-reassign-show.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-taskassignmenthelper-reassign-show.json
l2Logical: flow:WorkflowCommons.ACT_TaskAssignmentHelper_Reassign_Show
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.ACT_TaskAssignmentHelper_Reassign_Show

## Summary

- Likely acts as a UI entry or navigation handler because it shows WorkflowCommons.TaskAssignmentHelper_UserTask_Reassign.
- L0: [abstract](workflowcommons-act-taskassignmenthelper-reassign-show.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-taskassignmenthelper-reassign-show.json)

## Main Steps

- $WorkflowUserTaskList != empty Task selected? expression=$WorkflowUserTaskList != empty
- ShowPageAction: show page WorkflowCommons.TaskAssignmentHelper_UserTask_Reassign show page WorkflowCommons.TaskAssignmentHelper_UserTask_Reassign
- ChangeObjectAction: change TaskAssignmentHelper (TaskAssignmentHelper_WorkflowUserTask=$WorkflowUserTaskList; refreshInClient=false) change TaskAssignmentHelper (TaskAssignmentHelper_WorkflowUserTask=$WorkflowUserTaskList; refreshInClient=false)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: Shows WorkflowCommons.TaskAssignmentHelper_UserTask_Reassign.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- WorkflowCommons.TaskAssignmentHelper_UserTask_Reassign

## Important Retrieves/Decisions/Mutations

- nodeId=7dc4e70b-5144-45c3-a4d0-fb7ae8f40985; caption=Task selected?; expression=$WorkflowUserTaskList != empty Task selected? expression=$WorkflowUserTaskList != empty
- nodeId=6333ef51-ca51-4486-b690-f4b83e6e42c3; actionKind=Change; members=TaskAssignmentHelper_WorkflowUserTask=$WorkflowUserTaskList; refreshInClient=false; summary=ChangeObjectAction: change TaskAssignmentHelper (TaskAssignmentHelper_WorkflowUserTask=$WorkflowUserTaskList; refreshInClient=false) change TaskAssignmentHelper (TaskAssignmentHelper_WorkflowUserTask=$WorkflowUserTaskList; refreshInClient=false)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-taskassignmenthelper-reassign-show.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
