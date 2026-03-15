---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_UserTask_Assignee_Remove
stableId: f565b01a-eee9-42b0-b2be-3e73767ba66c
slug: workflowcommons-sub-usertask-assignee-remove
layer: L1
l0: workflowcommons-sub-usertask-assignee-remove.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertask-assignee-remove.json
l2Logical: flow:WorkflowCommons.SUB_UserTask_Assignee_Remove
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_UserTask_Assignee_Remove

## Summary

- Likely acts as a save, process, or background step for System.User because it mutates data without showing a page.
- L0: [abstract](workflowcommons-sub-usertask-assignee-remove.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertask-assignee-remove.json)

## Main Steps

- ChangeListAction: change UserList (type=Add, value=$User) change UserList (type=Add, value=$User)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.ACT_UserTask_Unassign, WorkflowCommons.SUB_TaskAssignmentHelper_Reassign, WorkflowCommons.SUB_TaskAssignmentHelper_Unassign.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- System.User

## Called / Called By

- Calls: WorkflowCommons.SUB_UserTask_Assignees_Remove
- Called by: WorkflowCommons.ACT_UserTask_Unassign, WorkflowCommons.SUB_TaskAssignmentHelper_Reassign, WorkflowCommons.SUB_TaskAssignmentHelper_Unassign

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=7beaabb2-0bcb-4a4c-953b-b87f723743da; actionKind=Change; members=type=Add, value=$User; summary=ChangeListAction: change UserList (type=Add, value=$User) change UserList (type=Add, value=$User)

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertask-assignee-remove.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
