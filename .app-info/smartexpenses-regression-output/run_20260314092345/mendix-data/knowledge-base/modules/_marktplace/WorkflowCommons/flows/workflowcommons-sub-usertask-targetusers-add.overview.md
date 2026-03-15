---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_UserTask_TargetUsers_Add
stableId: c4a1a55c-7c13-4975-97ab-ebf84357f8e8
slug: workflowcommons-sub-usertask-targetusers-add
layer: L1
l0: workflowcommons-sub-usertask-targetusers-add.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertask-targetusers-add.json
l2Logical: flow:WorkflowCommons.SUB_UserTask_TargetUsers_Add
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_UserTask_TargetUsers_Add

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](workflowcommons-sub-usertask-targetusers-add.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertask-targetusers-add.json)

## Main Steps

- retrieve UserTaskViewList over association UserTaskView_WorkflowUserTask from WorkflowUserTask
- retrieve Workflow over association WorkflowUserTask_Workflow from WorkflowUserTask
- $UserTaskView != empty Available? expression=$UserTaskView != empty
- ChangeObjectAction: change UserTaskView (UserTaskView_TargetUsers=$UserList; refreshInClient=true) change UserTaskView (UserTaskView_TargetUsers=$UserList; refreshInClient=true)
- ChangeObjectAction: change Workflow (refreshInClient=true) change Workflow (refreshInClient=true)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.ACT_WorkflowUserTask_TargetUsers_Add, WorkflowCommons.SUB_UserTask_TargetUser_Add.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: WorkflowCommons.ACT_WorkflowUserTask_TargetUsers_Add, WorkflowCommons.SUB_UserTask_TargetUser_Add

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=7b9c9bc2-7305-4203-b518-ce1586eee1ae; sourceKind=Association; association=UserTaskView_WorkflowUserTask; summary=retrieve UserTaskViewList over association UserTaskView_WorkflowUserTask from WorkflowUserTask
- nodeId=2ad6cfcd-71cb-49b5-bf58-8f90685c92b1; sourceKind=Association; association=WorkflowUserTask_Workflow; summary=retrieve Workflow over association WorkflowUserTask_Workflow from WorkflowUserTask
- nodeId=ade80be6-fdec-43cf-a276-638d8e591180; caption=Available?; expression=$UserTaskView != empty Available? expression=$UserTaskView != empty
- nodeId=7e11b804-0b74-4ab5-bbbe-11aa77b48952; actionKind=Change; members=UserTaskView_TargetUsers=$UserList; refreshInClient=true; summary=ChangeObjectAction: change UserTaskView (UserTaskView_TargetUsers=$UserList; refreshInClient=true) change UserTaskView (UserTaskView_TargetUsers=$UserList; refreshInClient=true)
- nodeId=ad7516da-cfcd-4af2-a16e-8aff3af39379; actionKind=Change; members=refreshInClient=true; summary=ChangeObjectAction: change Workflow (refreshInClient=true) change Workflow (refreshInClient=true)
- nodeId=5ce2e6c8-4950-49e2-9a17-b7e8ca77f6bb; actionKind=Change; members=WorkflowUserTask_TargetUsers=$UserList; refreshInClient=true; summary=ChangeObjectAction: change WorkflowUserTask (WorkflowUserTask_TargetUsers=$UserList; refreshInClient=true) change WorkflowUserTask (WorkflowUserTask_TargetUsers=$UserList; refreshInClient=true)

## Warnings/Unknowns

- Rollback hint detected in node detail.
- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertask-targetusers-add.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
