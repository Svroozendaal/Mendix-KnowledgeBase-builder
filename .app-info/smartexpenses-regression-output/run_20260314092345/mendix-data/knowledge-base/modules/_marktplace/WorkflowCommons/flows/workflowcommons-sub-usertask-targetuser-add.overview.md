---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_UserTask_TargetUser_Add
stableId: 7ffee5c4-bafd-44ee-879e-ce81a216d10b
slug: workflowcommons-sub-usertask-targetuser-add
layer: L1
l0: workflowcommons-sub-usertask-targetuser-add.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertask-targetuser-add.json
l2Logical: flow:WorkflowCommons.SUB_UserTask_TargetUser_Add
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_UserTask_TargetUser_Add

## Summary

- Likely acts as a save, process, or background step for System.User because it mutates data without showing a page.
- L0: [abstract](workflowcommons-sub-usertask-targetuser-add.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertask-targetuser-add.json)

## Main Steps

- ChangeListAction: change UserList (type=Add, value=$User) change UserList (type=Add, value=$User)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.SUB_TaskAssignmentHelper_Retarget.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- System.User

## Called / Called By

- Calls: WorkflowCommons.SUB_UserTask_TargetUsers_Add
- Called by: WorkflowCommons.SUB_TaskAssignmentHelper_Retarget

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=22595288-9222-4c48-bd2a-8b301dfffc25; actionKind=Change; members=type=Add, value=$User; summary=ChangeListAction: change UserList (type=Add, value=$User) change UserList (type=Add, value=$User)

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertask-targetuser-add.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
