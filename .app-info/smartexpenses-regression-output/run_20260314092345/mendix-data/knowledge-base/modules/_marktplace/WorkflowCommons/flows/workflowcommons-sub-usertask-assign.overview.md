---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_UserTask_Assign
stableId: 2736dd66-ca43-4a85-8d7e-b64eb0987313
slug: workflowcommons-sub-usertask-assign
layer: L1
l0: workflowcommons-sub-usertask-assign.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertask-assign.json
l2Logical: flow:WorkflowCommons.SUB_UserTask_Assign
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_UserTask_Assign

## Summary

- Likely acts as a save, process, or background step for System.User because it mutates data without showing a page.
- L0: [abstract](workflowcommons-sub-usertask-assign.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertask-assign.json)

## Main Steps

- retrieve AssignedUserList from System.User
- $WorkflowUserTask/CompletionType = System.WorkflowUserTaskCompletionType.Single Is Single? expression=$WorkflowUserTask/CompletionType = System.WorkflowUserTaskCompletionType.Single
- $AssigneeCount = 0 Not Assigned? expression=$AssigneeCount = 0
- ChangeObjectAction: change WorkflowUserTask (refreshInClient=true) change WorkflowUserTask (refreshInClient=true)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.ACT_UserTask_AssignToMe, WorkflowCommons.ACT_UserTask_AssignToMe_UpdateTaskCount, WorkflowCommons.ACT_UserTask_AssignToUser.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- System.User

## Called / Called By

- Calls: WorkflowCommons.SUB_UserTask_Assignee_Add
- Called by: WorkflowCommons.ACT_UserTask_AssignToMe, WorkflowCommons.ACT_UserTask_AssignToMe_UpdateTaskCount, WorkflowCommons.ACT_UserTask_AssignToUser

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=b59f00ae-b8cd-429a-8ed8-52784b7b77b0; sourceKind=Database; entity=System.User; summary=retrieve AssignedUserList from System.User
- nodeId=a47a3727-4deb-49ef-b24a-2228c54b69d8; caption=Is Single?; expression=$WorkflowUserTask/CompletionType = System.WorkflowUserTaskCompletionType.Single Is Single? expression=$WorkflowUserTask/CompletionType = System.WorkflowUserTaskCompletionType.Single
- nodeId=0f4eaca7-c823-4d58-a254-774730be565b; caption=Not Assigned?; expression=$AssigneeCount = 0 Not Assigned? expression=$AssigneeCount = 0
- nodeId=450ee9cd-3387-4b75-b669-4993f0c31469; actionKind=Change; members=refreshInClient=true; summary=ChangeObjectAction: change WorkflowUserTask (refreshInClient=true) change WorkflowUserTask (refreshInClient=true)

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertask-assign.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
