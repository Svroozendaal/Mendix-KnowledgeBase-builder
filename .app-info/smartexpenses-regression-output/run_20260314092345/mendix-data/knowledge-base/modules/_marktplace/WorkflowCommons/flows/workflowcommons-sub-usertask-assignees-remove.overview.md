---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_UserTask_Assignees_Remove
stableId: 245310b4-78e0-42cd-9262-1e37bb707c71
slug: workflowcommons-sub-usertask-assignees-remove
layer: L1
l0: workflowcommons-sub-usertask-assignees-remove.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertask-assignees-remove.json
l2Logical: flow:WorkflowCommons.SUB_UserTask_Assignees_Remove
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_UserTask_Assignees_Remove

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](workflowcommons-sub-usertask-assignees-remove.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertask-assignees-remove.json)

## Main Steps

- retrieve UserTaskViewList over association UserTaskView_WorkflowUserTask from WorkflowUserTask
- retrieve Workflow over association WorkflowUserTask_Workflow from WorkflowUserTask
- $UserTaskView != empty Available? expression=$UserTaskView != empty
- ChangeObjectAction: change UserTaskView (UserTaskView_Assignees=$UserList; refreshInClient=true) change UserTaskView (UserTaskView_Assignees=$UserList; refreshInClient=true)
- ChangeObjectAction: change Workflow (refreshInClient=true) change Workflow (refreshInClient=true)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.ACT_WorkflowUserTask_Assignees_Remove, WorkflowCommons.ACT_WorkflowUserTask_Unassign, WorkflowCommons.SUB_UserTask_Assignee_Remove.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: WorkflowCommons.ACT_WorkflowUserTask_Assignees_Remove, WorkflowCommons.ACT_WorkflowUserTask_Unassign, WorkflowCommons.SUB_UserTask_Assignee_Remove

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=660e5f05-9a8c-472a-bafe-5ab220ef2edc; sourceKind=Association; association=UserTaskView_WorkflowUserTask; summary=retrieve UserTaskViewList over association UserTaskView_WorkflowUserTask from WorkflowUserTask
- nodeId=6db68821-425c-46d5-897b-1057b19792b3; sourceKind=Association; association=WorkflowUserTask_Workflow; summary=retrieve Workflow over association WorkflowUserTask_Workflow from WorkflowUserTask
- nodeId=7a5b82f5-0305-4253-8648-fbf520789d22; caption=Available?; expression=$UserTaskView != empty Available? expression=$UserTaskView != empty
- nodeId=bde68573-6dcc-4fc2-8fcc-9a34e36d039d; actionKind=Change; members=UserTaskView_Assignees=$UserList; refreshInClient=true; summary=ChangeObjectAction: change UserTaskView (UserTaskView_Assignees=$UserList; refreshInClient=true) change UserTaskView (UserTaskView_Assignees=$UserList; refreshInClient=true)
- nodeId=1d5d684e-9c90-4bc5-9232-a56f440bf159; actionKind=Change; members=refreshInClient=true; summary=ChangeObjectAction: change Workflow (refreshInClient=true) change Workflow (refreshInClient=true)
- nodeId=87d7148b-4ea7-4896-95cc-acfa06ca03eb; actionKind=Change; members=WorkflowUserTask_Assignees=$UserList; refreshInClient=true; summary=ChangeObjectAction: change WorkflowUserTask (WorkflowUserTask_Assignees=$UserList; refreshInClient=true) change WorkflowUserTask (WorkflowUserTask_Assignees=$UserList; refreshInClient=true)

## Warnings/Unknowns

- Rollback hint detected in node detail.
- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertask-assignees-remove.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
