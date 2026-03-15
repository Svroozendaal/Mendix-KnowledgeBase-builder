---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_TaskSummary_CreateOrUpdate
stableId: f0762162-3def-4013-b1f1-6fb3e2d21e9a
slug: workflowcommons-sub-tasksummary-createorupdate
layer: L1
l0: workflowcommons-sub-tasksummary-createorupdate.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-tasksummary-createorupdate.json
l2Logical: flow:WorkflowCommons.SUB_TaskSummary_CreateOrUpdate
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_TaskSummary_CreateOrUpdate

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](workflowcommons-sub-tasksummary-createorupdate.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-tasksummary-createorupdate.json)

## Main Steps

- $Admin Admin? expression=$Admin
- ChangeObjectAction: change TaskSummary (NumberOfTasksCompleted=$UserTask_CountCompleted, NumberOfTasksInProgress=$UserTask_CountInProgress, NumberOfTasksAlmostDue=$UserTask_CountAlmostDue, NumberOfTasksOverdue=$UserTask_CountOverdue, NumberOfTasksFailed=$UserTask_CountFailed, DashboardContext_TaskSummary=$DashboardContext; refreshInClient=false) change TaskSummary (NumberOfTasksCompleted=$UserTask_CountCompleted, NumberOfTasksInProgress=$UserTask_CountInProgress, NumberOfTasksAlmostDue=$UserTask_CountAlmostDue, NumberOfTasksOverdue=$UserTask_CountOverdue, NumberOfTasksFailed=$UserTask_CountFailed, DashboardContext_TaskSummary=$DashboardContext; refreshInClient=false)
- ChangeObjectAction: change TaskSummary (NumberOfTasksCompleted=$UserTask_CountCompleted, TaskAverageHandlingTime=$UserTask_AverageHandlingTime, TasksHandledInTime=if $UserTask_CountCompleted = 0 then 0 else round($UserTask_CountCompletedOnTime:$UserTask_CountCompleted*100,2), DashboardContext_TaskSummary=$DashboardContext; refreshInClient=false) change TaskSummary (NumberOfTasksCompleted=$UserTask_CountCompleted, TaskAverageHandlingTime=$UserTask_AverageHandlingTime, TasksHandledInTime=if $UserTask_CountCompleted = 0 then 0 else round($UserTask_CountCompletedOnTime:$UserTask_CountCompleted*100,2), DashboardContext_TaskSummary=$DashboardContext; refreshInClient=false)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.SUB_TaskDashboard_Update, WorkflowCommons.SUB_WorkflowDashboard_Update.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: WorkflowCommons.SUB_TaskSummary_RetrieveOrCreate, WorkflowCommons.SUB_UserTask_AverageHandlingTime, WorkflowCommons.SUB_UserTask_CountAlmostDue, WorkflowCommons.SUB_UserTask_CountCompleted, WorkflowCommons.SUB_UserTask_CountCompletedOnTime, WorkflowCommons.SUB_UserTask_CountFailed, WorkflowCommons.SUB_UserTask_CountInProgress, WorkflowCommons.SUB_UserTask_CountOverdue
- Called by: WorkflowCommons.SUB_TaskDashboard_Update, WorkflowCommons.SUB_WorkflowDashboard_Update

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=9ee7ab2e-c217-4bcb-86f2-4da8b1336067; caption=Admin?; expression=$Admin Admin? expression=$Admin
- nodeId=a61d46aa-929a-4cc9-abce-3f7b0812a4d0; actionKind=Change; members=NumberOfTasksCompleted=$UserTask_CountCompleted, NumberOfTasksInProgress=$UserTask_CountInProgress, NumberOfTasksAlmostDue=$UserTask_CountAlmostDue, NumberOfTasksOverdue=$UserTask_CountOverdue, NumberOfTasksFailed=$UserTask_CountFailed, DashboardContext_TaskSummary=$DashboardContext; refreshInClient=false; summary=ChangeObjectAction: change TaskSummary (NumberOfTasksCompleted=$UserTask_CountCompleted, NumberOfTasksInProgress=$UserTask_CountInProgress, NumberOfTasksAlmostDue=$UserTask_CountAlmostDue, NumberOfTasksOverdue=$UserTask_CountOverdue, NumberOfTasksFailed=$UserTask_CountFailed, DashboardContext_TaskSummary=$DashboardContext; refreshInClient=false) change TaskSummary (NumberOfTasksCompleted=$UserTask_CountCompleted, NumberOfTasksInProgress=$UserTask_CountInProgress, NumberOfTasksAlmostDue=$UserTask_CountAlmostDue, NumberOfTasksOverdue=$UserTask_CountOverdue, NumberOfTasksFailed=$UserTask_CountFailed, DashboardContext_TaskSummary=$DashboardContext; refreshInClient=false)
- nodeId=b967d14b-2ab5-4884-bda6-42bc3d30da60; actionKind=Change; members=NumberOfTasksCompleted=$UserTask_CountCompleted, TaskAverageHandlingTime=$UserTask_AverageHandlingTime, TasksHandledInTime=if $UserTask_CountCompleted = 0 then 0 else round($UserTask_CountCompletedOnTime:$UserTask_CountCompleted*100,2; summary=ChangeObjectAction: change TaskSummary (NumberOfTasksCompleted=$UserTask_CountCompleted, TaskAverageHandlingTime=$UserTask_AverageHandlingTime, TasksHandledInTime=if $UserTask_CountCompleted = 0 then 0 else round($UserTask_CountCompletedOnTime:$UserTask_CountCompleted*100,2), DashboardContext_TaskSummary=$DashboardContext; refreshInClient=false) change TaskSummary (NumberOfTasksCompleted=$UserTask_CountCompleted, TaskAverageHandlingTime=$UserTask_AverageHandlingTime, TasksHandledInTime=if $UserTask_CountCompleted = 0 then 0 else round($UserTask_CountCompletedOnTime:$UserTask_CountCompleted*100,2), DashboardContext_TaskSummary=$DashboardContext; refreshInClient=false)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-tasksummary-createorupdate.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
