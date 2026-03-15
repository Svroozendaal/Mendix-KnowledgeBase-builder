---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_TaskSeries_CreateOrUpdate
stableId: 4a1af0ae-1070-4ec3-89e5-a360caf88300
slug: workflowcommons-sub-taskseries-createorupdate
layer: L1
l0: workflowcommons-sub-taskseries-createorupdate.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-taskseries-createorupdate.json
l2Logical: flow:WorkflowCommons.SUB_TaskSeries_CreateOrUpdate
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_TaskSeries_CreateOrUpdate

## Summary

- Likely acts as a save, process, or background step for WorkflowCommons.TaskSeries because it mutates data without showing a page.
- L0: [abstract](workflowcommons-sub-taskseries-createorupdate.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-taskseries-createorupdate.json)

## Main Steps

- $BeginOfStep_InTimeFrame <= $DashboardContext/TimeFrameStart First day of time frame reached? expression=$BeginOfStep_InTimeFrame <= $DashboardContext/TimeFrameStart
- ChangeVariableAction: change variable BeginOfStep_InTimeFrame=if $DashboardContext/TimeFrameStepUnit = WorkflowCommons.Enum_TimeFrameStepUnit.Day then addDays($BeginOfStep_InTimeFrame,-1) else if $DashboardContext/TimeFrameStepUnit = WorkflowCommons.Enum_TimeFrameStepUnit.Week then... change variable BeginOfStep_InTimeFrame=if $DashboardContext/TimeFrameStepUnit = WorkflowCommons.Enum_TimeFrameStepUnit.Day then addDays($BeginOfStep_InTimeFrame,-1) else if $DashboardContext/TimeFrameStepUnit = WorkflowCommons.Enum_TimeFrameStepUnit.Week then...
- ChangeVariableAction: change variable EndOfStep_InTimeFrame=if $DashboardContext/TimeFrameStepUnit = WorkflowCommons.Enum_TimeFrameStepUnit.Day then addDays($EndOfStep_InTimeFrame,-1) else if $DashboardContext/TimeFrameStepUnit = WorkflowCommons.Enum_TimeFrameStepUnit.Week then a... change variable EndOfStep_InTimeFrame=if $DashboardContext/TimeFrameStepUnit = WorkflowCommons.Enum_TimeFrameStepUnit.Day then addDays($EndOfStep_InTimeFrame,-1) else if $DashboardContext/TimeFrameStepUnit = WorkflowCommons.Enum_TimeFrameStepUnit.Week then a...

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.SUB_TaskDashboard_Update, WorkflowCommons.SUB_WorkflowDashboard_Update.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- WorkflowCommons.TaskSeries

## Called / Called By

- Calls: WorkflowCommons.SUB_TaskSeriesList_Delete, WorkflowCommons.SUB_UserTask_AverageHandlingTime, WorkflowCommons.SUB_UserTask_CountCompletedOnTime, WorkflowCommons.SUB_UserTask_CountCompletedOverdue
- Called by: WorkflowCommons.SUB_TaskDashboard_Update, WorkflowCommons.SUB_WorkflowDashboard_Update

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=492adfd1-32e5-4c7a-9d28-fb709d5f6411; caption=First day of time frame reached?; expression=$BeginOfStep_InTimeFrame <= $DashboardContext/TimeFrameStart First day of time frame reached? expression=$BeginOfStep_InTimeFrame <= $DashboardContext/TimeFrameStart
- nodeId=9f4044d4-b024-4504-a33d-1925f746a485; actionKind=Change; entity=WorkflowCommons.Enum_TimeFrameStepUnit; members=$BeginOfStep_InTimeFrame,-1; summary=ChangeVariableAction: change variable BeginOfStep_InTimeFrame=if $DashboardContext/TimeFrameStepUnit = WorkflowCommons.Enum_TimeFrameStepUnit.Day then addDays($BeginOfStep_InTimeFrame,-1) else if $DashboardContext/TimeFrameStepUnit = WorkflowCommons.Enum_TimeFrameStepUnit.Week then... change variable BeginOfStep_InTimeFrame=if $DashboardContext/TimeFrameStepUnit = WorkflowCommons.Enum_TimeFrameStepUnit.Day then addDays($BeginOfStep_InTimeFrame,-1) else if $DashboardContext/TimeFrameStepUnit = WorkflowCommons.Enum_TimeFrameStepUnit.Week then...
- nodeId=cc62794c-a96f-4fbb-81bf-dc0125662070; actionKind=Change; entity=WorkflowCommons.Enum_TimeFrameStepUnit; members=$EndOfStep_InTimeFrame,-1; summary=ChangeVariableAction: change variable EndOfStep_InTimeFrame=if $DashboardContext/TimeFrameStepUnit = WorkflowCommons.Enum_TimeFrameStepUnit.Day then addDays($EndOfStep_InTimeFrame,-1) else if $DashboardContext/TimeFrameStepUnit = WorkflowCommons.Enum_TimeFrameStepUnit.Week then a... change variable EndOfStep_InTimeFrame=if $DashboardContext/TimeFrameStepUnit = WorkflowCommons.Enum_TimeFrameStepUnit.Day then addDays($EndOfStep_InTimeFrame,-1) else if $DashboardContext/TimeFrameStepUnit = WorkflowCommons.Enum_TimeFrameStepUnit.Week then a...
- nodeId=04144bcc-44fd-4fa1-b2ed-f27129142167; actionKind=Create; entity=WorkflowCommons.TaskSeries; members=DateDisplay=if $DashboardContext/TimeFrameStepUnit = WorkflowCommons.Enum_TimeFrameStepUnit.Day then if $BeginOfStep_InTimeFrame = [%BeginOfCurrentDay%] then 'Today' else formatDateTime($Begin..., NumberofTasksCompletedOnTime=$UserTask_CountCompletedOnTime, AverageTaskHandlingTime=$UserTask_AverageHandlingTime, TasksHandledOnTime=if $UserTask_CountCompleted = 0 then 0 else round($UserTask_CountCompletedOnTime:$UserTask_CountCompleted*100,2; summary=CreateObjectAction: create WorkflowCommons.TaskSeries as NewTaskSeries (DateDisplay=if $DashboardContext/TimeFrameStepUnit = WorkflowCommons.Enum_TimeFrameStepUnit.Day then if $BeginOfStep_InTimeFrame = [%BeginOfCurrentDay%] then 'Today' else formatDateTime($Begin..., NumberofTasksCompletedOnTime=$UserTask_CountCompletedOnTime, AverageTaskHandlingTime=$UserTask_AverageHandlingTime, TasksHandledOnTime=if $UserTask_CountCompleted = 0 then 0 else round($UserTask_CountCompletedOnTime:$UserTask_CountCompleted*100,2), NumberOfTasksCompletedOverdue=$UserTask_CountCompletedOverdue, Date=$BeginOfStep_InTimeFrame, TaskSeries_DashboardContext=$DashboardContext) create WorkflowCommons.TaskSeries as NewTaskSeries (DateDisplay=if $DashboardContext/TimeFrameStepUnit = WorkflowCommons.Enum_TimeFrameStepUnit.Day then if $BeginOfStep_InTimeFrame = [%BeginOfCurrentDay%] then 'Today' else formatDateTime($Begin..., NumberofTasksCompletedOnTime=$UserTask_CountCompletedOnTime, AverageTaskHandlingTime=$UserTask_AverageHandlingTime, TasksHandledOnTime=if $UserTask_CountCompleted = 0 then 0 else round($UserTask_CountCompletedOnTime:$UserTask_CountCompleted*100,2), NumberOfTasksCompletedOverdue=$UserTask_CountCompletedOverdue, Date=$BeginOfStep_InTimeFrame, TaskSeries_DashboardContext=$DashboardContext)
- nodeId=82acba11-990e-407e-90e1-f48300d3aabb; actionKind=Create; entity=WorkflowCommons.Enum_TimeFrameStepUnit; summary=CreateVariableAction: create variable BeginOfStep_InTimeFrame=if $DashboardContext/TimeFrameStepUnit = WorkflowCommons.Enum_TimeFrameStepUnit.Day then [%BeginOfCurrentDay%] else if $DashboardContext/TimeFrameStepUnit = WorkflowCommons.Enum_TimeFrameStepUnit.Week then [%BeginOfCurre... create variable BeginOfStep_InTimeFrame=if $DashboardContext/TimeFrameStepUnit = WorkflowCommons.Enum_TimeFrameStepUnit.Day then [%BeginOfCurrentDay%] else if $DashboardContext/TimeFrameStepUnit = WorkflowCommons.Enum_TimeFrameStepUnit.Week then [%BeginOfCurre...
- nodeId=8106addb-f7f6-4e37-aefa-dc650f2a1b33; actionKind=Create; entity=WorkflowCommons.Enum_TimeFrameStepUnit; summary=CreateVariableAction: create variable EndOfStep_InTimeFrame=if $DashboardContext/TimeFrameStepUnit = WorkflowCommons.Enum_TimeFrameStepUnit.Day then [%EndOfCurrentDay%] else if $DashboardContext/TimeFrameStepUnit = WorkflowCommons.Enum_TimeFrameStepUnit.Week then [%EndOfCurrentWe... create variable EndOfStep_InTimeFrame=if $DashboardContext/TimeFrameStepUnit = WorkflowCommons.Enum_TimeFrameStepUnit.Day then [%EndOfCurrentDay%] else if $DashboardContext/TimeFrameStepUnit = WorkflowCommons.Enum_TimeFrameStepUnit.Week then [%EndOfCurrentWe...
- nodeId=558d03da-2366-4672-887a-696da2e6b3de; actionKind=Create; summary=CreateVariableAction: create variable UserTask_CountCompleted=$UserTask_CountCompletedOnTime + $UserTask_CountCompletedOverdue create variable UserTask_CountCompleted=$UserTask_CountCompletedOnTime + $UserTask_CountCompletedOverdue

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-taskseries-createorupdate.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
