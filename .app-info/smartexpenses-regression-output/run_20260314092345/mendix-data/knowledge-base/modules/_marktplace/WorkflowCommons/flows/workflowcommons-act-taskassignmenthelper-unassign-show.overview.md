---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.ACT_TaskAssignmentHelper_Unassign_Show
stableId: 83208356-3258-4bad-b413-c2298f68a0c4
slug: workflowcommons-act-taskassignmenthelper-unassign-show
layer: L1
l0: workflowcommons-act-taskassignmenthelper-unassign-show.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-taskassignmenthelper-unassign-show.json
l2Logical: flow:WorkflowCommons.ACT_TaskAssignmentHelper_Unassign_Show
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.ACT_TaskAssignmentHelper_Unassign_Show

## Summary

- Likely acts as a UI entry or navigation handler because it shows WorkflowCommons.TaskAssignmentHelper_UserTask_Unassign_TargetUserOptions.
- L0: [abstract](workflowcommons-act-taskassignmenthelper-unassign-show.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-taskassignmenthelper-unassign-show.json)

## Main Steps

- $WorkflowUserTaskList != empty Task selected? expression=$WorkflowUserTaskList != empty
- ShowPageAction: show page WorkflowCommons.TaskAssignmentHelper_UserTask_Unassign_TargetUserOptions show page WorkflowCommons.TaskAssignmentHelper_UserTask_Unassign_TargetUserOptions
- ChangeObjectAction: change TaskAssignmentHelper (TaskAssignmentHelper_WorkflowUserTask=$WorkflowUserTaskList; refreshInClient=false) change TaskAssignmentHelper (TaskAssignmentHelper_WorkflowUserTask=$WorkflowUserTaskList; refreshInClient=false)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: Shows WorkflowCommons.TaskAssignmentHelper_UserTask_Unassign_TargetUserOptions.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- WorkflowCommons.TaskAssignmentHelper_UserTask_Unassign_TargetUserOptions

## Important Retrieves/Decisions/Mutations

- nodeId=5041c4fd-be6b-4a66-9049-aa1572a3d493; caption=Task selected?; expression=$WorkflowUserTaskList != empty Task selected? expression=$WorkflowUserTaskList != empty
- nodeId=bcc8ffca-ae0b-45a0-85b9-33532aafc47d; actionKind=Change; members=TaskAssignmentHelper_WorkflowUserTask=$WorkflowUserTaskList; refreshInClient=false; summary=ChangeObjectAction: change TaskAssignmentHelper (TaskAssignmentHelper_WorkflowUserTask=$WorkflowUserTaskList; refreshInClient=false) change TaskAssignmentHelper (TaskAssignmentHelper_WorkflowUserTask=$WorkflowUserTaskList; refreshInClient=false)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-taskassignmenthelper-unassign-show.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
