---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_UserTask_Assignees_Add
stableId: 2db711a4-11c7-45cb-a0fe-c9963a40bf59
slug: workflowcommons-sub-usertask-assignees-add
layer: L1
l0: workflowcommons-sub-usertask-assignees-add.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertask-assignees-add.json
l2Logical: flow:WorkflowCommons.SUB_UserTask_Assignees_Add
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_UserTask_Assignees_Add

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](workflowcommons-sub-usertask-assignees-add.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertask-assignees-add.json)

## Main Steps

- retrieve UserTaskViewList over association UserTaskView_WorkflowUserTask from WorkflowUserTask
- retrieve Workflow over association WorkflowUserTask_Workflow from WorkflowUserTask
- $UserTaskView != empty Available? expression=$UserTaskView != empty
- ChangeObjectAction: change UserTaskView (UserTaskView_Assignees=$UserList, UserTaskView_TargetUsers=$UserList; refreshInClient=true) change UserTaskView (UserTaskView_Assignees=$UserList, UserTaskView_TargetUsers=$UserList; refreshInClient=true)
- ChangeObjectAction: change Workflow (refreshInClient=true) change Workflow (refreshInClient=true)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.ACT_UserTask_AssignToUsers, WorkflowCommons.ACT_WorkflowUserTask_Assignees_Add, WorkflowCommons.SUB_UserTask_Assignee_Add.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: WorkflowCommons.ACT_UserTask_AssignToUsers, WorkflowCommons.ACT_WorkflowUserTask_Assignees_Add, WorkflowCommons.SUB_UserTask_Assignee_Add

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=2eebf0c4-35bd-4ad4-a297-6c707c410dd5; sourceKind=Association; association=UserTaskView_WorkflowUserTask; summary=retrieve UserTaskViewList over association UserTaskView_WorkflowUserTask from WorkflowUserTask
- nodeId=dc47d1ed-3798-46ee-80e8-474fed9bfe70; sourceKind=Association; association=WorkflowUserTask_Workflow; summary=retrieve Workflow over association WorkflowUserTask_Workflow from WorkflowUserTask
- nodeId=6e3f72e5-5a92-4310-91cf-5b414ba6d21e; caption=Available?; expression=$UserTaskView != empty Available? expression=$UserTaskView != empty
- nodeId=87470131-8e97-4443-ab84-ee78e2a0dc3c; actionKind=Change; members=UserTaskView_Assignees=$UserList, UserTaskView_TargetUsers=$UserList; refreshInClient=true; summary=ChangeObjectAction: change UserTaskView (UserTaskView_Assignees=$UserList, UserTaskView_TargetUsers=$UserList; refreshInClient=true) change UserTaskView (UserTaskView_Assignees=$UserList, UserTaskView_TargetUsers=$UserList; refreshInClient=true)
- nodeId=357eb014-3a1a-453f-85b4-f4abc50760e2; actionKind=Change; members=refreshInClient=true; summary=ChangeObjectAction: change Workflow (refreshInClient=true) change Workflow (refreshInClient=true)
- nodeId=dedee6b7-3080-4ce1-becf-fd84652b8fd7; actionKind=Change; members=WorkflowUserTask_Assignees=$UserList, WorkflowUserTask_TargetUsers=$UserList; refreshInClient=true; summary=ChangeObjectAction: change WorkflowUserTask (WorkflowUserTask_Assignees=$UserList, WorkflowUserTask_TargetUsers=$UserList; refreshInClient=true) change WorkflowUserTask (WorkflowUserTask_Assignees=$UserList, WorkflowUserTask_TargetUsers=$UserList; refreshInClient=true)

## Warnings/Unknowns

- Rollback hint detected in node detail.
- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertask-assignees-add.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
