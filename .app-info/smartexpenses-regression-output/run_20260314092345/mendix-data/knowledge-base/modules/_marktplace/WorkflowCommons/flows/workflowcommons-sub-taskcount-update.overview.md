---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_TaskCount_Update
stableId: 54f6050b-3de8-4491-aa81-2e6883b75857
slug: workflowcommons-sub-taskcount-update
layer: L1
l0: workflowcommons-sub-taskcount-update.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-taskcount-update.json
l2Logical: flow:WorkflowCommons.SUB_TaskCount_Update
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_TaskCount_Update

## Summary

- Likely acts as a save, process, or background step for System.WorkflowUserTask, WorkflowCommons.UserTaskView because it mutates data without showing a page.
- L0: [abstract](workflowcommons-sub-taskcount-update.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-taskcount-update.json)

## Main Steps

- retrieve UserTaskList_AllOpen from System.WorkflowUserTask
- retrieve UserTaskList_MyOpen from System.WorkflowUserTask
- ChangeObjectAction: change TaskCount (MyOpenTaskCount=$MyOpenTaskCount, AllOpenTaskCount=$AllOpenTaskCount, UnassignedTaskCount=$UnassignedTaskCount, CompletedTaskCount=$CompletedTasksCount; refreshInClient=false) change TaskCount (MyOpenTaskCount=$MyOpenTaskCount, AllOpenTaskCount=$AllOpenTaskCount, UnassignedTaskCount=$UnassignedTaskCount, CompletedTaskCount=$CompletedTasksCount; refreshInClient=false)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.ACT_TaskCount_Update, WorkflowCommons.ACT_UserTask_AssignToMe_UpdateTaskCount, WorkflowCommons.DS_TaskCount.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- System.WorkflowUserTask, WorkflowCommons.UserTaskView

## Called / Called By

- Calls: none
- Called by: WorkflowCommons.ACT_TaskCount_Update, WorkflowCommons.ACT_UserTask_AssignToMe_UpdateTaskCount, WorkflowCommons.DS_TaskCount

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=2591758a-d910-4fc0-a51c-5768e4b7599f; sourceKind=Database; entity=System.WorkflowUserTask; summary=retrieve UserTaskList_AllOpen from System.WorkflowUserTask
- nodeId=82722d28-dc5d-45b6-9f9e-e5e84843f9ca; sourceKind=Database; entity=System.WorkflowUserTask; summary=retrieve UserTaskList_MyOpen from System.WorkflowUserTask
- nodeId=56b1cb3c-86d7-4e0d-a4f7-2a2c9876cd27; sourceKind=Database; entity=System.WorkflowUserTask; summary=retrieve UserTaskList_Unassigned from System.WorkflowUserTask
- nodeId=28638408-4bb5-4239-96ca-74eaf6f4c5f7; sourceKind=Database; entity=WorkflowCommons.UserTaskView; summary=retrieve UserTaskViewList_Completed from WorkflowCommons.UserTaskView
- nodeId=097c5782-2b35-4019-b5cd-adf286db03c6; actionKind=Change; members=MyOpenTaskCount=$MyOpenTaskCount, AllOpenTaskCount=$AllOpenTaskCount, UnassignedTaskCount=$UnassignedTaskCount, CompletedTaskCount=$CompletedTasksCount; refreshInClient=false; summary=ChangeObjectAction: change TaskCount (MyOpenTaskCount=$MyOpenTaskCount, AllOpenTaskCount=$AllOpenTaskCount, UnassignedTaskCount=$UnassignedTaskCount, CompletedTaskCount=$CompletedTasksCount; refreshInClient=false) change TaskCount (MyOpenTaskCount=$MyOpenTaskCount, AllOpenTaskCount=$AllOpenTaskCount, UnassignedTaskCount=$UnassignedTaskCount, CompletedTaskCount=$CompletedTasksCount; refreshInClient=false)

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-taskcount-update.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
