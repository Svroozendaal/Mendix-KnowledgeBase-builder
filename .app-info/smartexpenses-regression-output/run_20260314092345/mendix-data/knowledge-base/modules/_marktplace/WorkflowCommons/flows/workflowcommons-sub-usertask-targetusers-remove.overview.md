---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_UserTask_TargetUsers_Remove
stableId: 1e7a9ef7-7910-48df-b3fc-9230b272c5bb
slug: workflowcommons-sub-usertask-targetusers-remove
layer: L1
l0: workflowcommons-sub-usertask-targetusers-remove.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertask-targetusers-remove.json
l2Logical: flow:WorkflowCommons.SUB_UserTask_TargetUsers_Remove
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_UserTask_TargetUsers_Remove

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](workflowcommons-sub-usertask-targetusers-remove.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertask-targetusers-remove.json)

## Main Steps

- retrieve UserTaskViewList over association UserTaskView_WorkflowUserTask from WorkflowUserTask
- retrieve Workflow over association WorkflowUserTask_Workflow from WorkflowUserTask
- $UserTaskView != empty Available? expression=$UserTaskView != empty
- ChangeObjectAction: change UserTaskView (UserTaskView_TargetUsers=$UserList; refreshInClient=true) change UserTaskView (UserTaskView_TargetUsers=$UserList; refreshInClient=true)
- ChangeObjectAction: change Workflow (refreshInClient=true) change Workflow (refreshInClient=true)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.ACT_WorkflowUserTask_TargetUsers_Remove, WorkflowCommons.SUB_UserTask_TargetUser_Remove.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: WorkflowCommons.ACT_WorkflowUserTask_TargetUsers_Remove, WorkflowCommons.SUB_UserTask_TargetUser_Remove

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=88893d8c-db2c-4d57-90ad-ce3dd77a8d35; sourceKind=Association; association=UserTaskView_WorkflowUserTask; summary=retrieve UserTaskViewList over association UserTaskView_WorkflowUserTask from WorkflowUserTask
- nodeId=822a8073-2ff9-4599-8ed2-c143d90794cf; sourceKind=Association; association=WorkflowUserTask_Workflow; summary=retrieve Workflow over association WorkflowUserTask_Workflow from WorkflowUserTask
- nodeId=c8a799fd-50d0-411f-986e-da57f407375c; caption=Available?; expression=$UserTaskView != empty Available? expression=$UserTaskView != empty
- nodeId=48632d63-6d9d-45e6-a020-1a8e6dbba248; actionKind=Change; members=UserTaskView_TargetUsers=$UserList; refreshInClient=true; summary=ChangeObjectAction: change UserTaskView (UserTaskView_TargetUsers=$UserList; refreshInClient=true) change UserTaskView (UserTaskView_TargetUsers=$UserList; refreshInClient=true)
- nodeId=f1448940-d91d-4866-973f-499ae8fc7300; actionKind=Change; members=refreshInClient=true; summary=ChangeObjectAction: change Workflow (refreshInClient=true) change Workflow (refreshInClient=true)
- nodeId=d5d30ee1-825b-4338-bd52-cfe56907a0fc; actionKind=Change; members=WorkflowUserTask_TargetUsers=$UserList; refreshInClient=true; summary=ChangeObjectAction: change WorkflowUserTask (WorkflowUserTask_TargetUsers=$UserList; refreshInClient=true) change WorkflowUserTask (WorkflowUserTask_TargetUsers=$UserList; refreshInClient=true)

## Warnings/Unknowns

- Rollback hint detected in node detail.
- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertask-targetusers-remove.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
