---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_WorkflowSeries_CreateOrUpdate
stableId: d9c5d54c-2337-4cae-99f2-d91badb293f7
slug: workflowcommons-sub-workflowseries-createorupdate
layer: L1
l0: workflowcommons-sub-workflowseries-createorupdate.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowseries-createorupdate.json
l2Logical: flow:WorkflowCommons.SUB_WorkflowSeries_CreateOrUpdate
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_WorkflowSeries_CreateOrUpdate

## Summary

- Likely acts as a save, process, or background step for WorkflowCommons.WorkflowSeries because it mutates data without showing a page.
- L0: [abstract](workflowcommons-sub-workflowseries-createorupdate.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowseries-createorupdate.json)

## Main Steps

- $BeginOfStep_InTimeFrame <= $DashboardContext/TimeFrameStart First day of time frame reached? expression=$BeginOfStep_InTimeFrame <= $DashboardContext/TimeFrameStart
- ChangeVariableAction: change variable BeginOfStep_InTimeFrame=if $DashboardContext/TimeFrameStepUnit = WorkflowCommons.Enum_TimeFrameStepUnit.Day then addDays($BeginOfStep_InTimeFrame,-1) else if $DashboardContext/TimeFrameStepUnit = WorkflowCommons.Enum_TimeFrameStepUnit.Week then... change variable BeginOfStep_InTimeFrame=if $DashboardContext/TimeFrameStepUnit = WorkflowCommons.Enum_TimeFrameStepUnit.Day then addDays($BeginOfStep_InTimeFrame,-1) else if $DashboardContext/TimeFrameStepUnit = WorkflowCommons.Enum_TimeFrameStepUnit.Week then...
- ChangeVariableAction: change variable EndOfStep_InTimeFrame=if $DashboardContext/TimeFrameStepUnit = WorkflowCommons.Enum_TimeFrameStepUnit.Day then addDays($EndOfStep_InTimeFrame,-1) else if $DashboardContext/TimeFrameStepUnit = WorkflowCommons.Enum_TimeFrameStepUnit.Week then a... change variable EndOfStep_InTimeFrame=if $DashboardContext/TimeFrameStepUnit = WorkflowCommons.Enum_TimeFrameStepUnit.Day then addDays($EndOfStep_InTimeFrame,-1) else if $DashboardContext/TimeFrameStepUnit = WorkflowCommons.Enum_TimeFrameStepUnit.Week then a...

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.SUB_WorkflowDashboard_Update.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- WorkflowCommons.WorkflowSeries

## Called / Called By

- Calls: WorkflowCommons.SUB_Workflow_AverageHandlingTime, WorkflowCommons.SUB_Workflow_CountCompletedOnTime, WorkflowCommons.SUB_Workflow_CountCompletedOverdue, WorkflowCommons.SUB_WorkflowSeriesList_Delete
- Called by: WorkflowCommons.SUB_WorkflowDashboard_Update

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=12c0b7c7-99bc-4a98-b0f9-93c818889b99; caption=First day of time frame reached?; expression=$BeginOfStep_InTimeFrame <= $DashboardContext/TimeFrameStart First day of time frame reached? expression=$BeginOfStep_InTimeFrame <= $DashboardContext/TimeFrameStart
- nodeId=76eab299-80d8-40bb-ad4b-681cfae37645; actionKind=Change; entity=WorkflowCommons.Enum_TimeFrameStepUnit; members=$BeginOfStep_InTimeFrame,-1; summary=ChangeVariableAction: change variable BeginOfStep_InTimeFrame=if $DashboardContext/TimeFrameStepUnit = WorkflowCommons.Enum_TimeFrameStepUnit.Day then addDays($BeginOfStep_InTimeFrame,-1) else if $DashboardContext/TimeFrameStepUnit = WorkflowCommons.Enum_TimeFrameStepUnit.Week then... change variable BeginOfStep_InTimeFrame=if $DashboardContext/TimeFrameStepUnit = WorkflowCommons.Enum_TimeFrameStepUnit.Day then addDays($BeginOfStep_InTimeFrame,-1) else if $DashboardContext/TimeFrameStepUnit = WorkflowCommons.Enum_TimeFrameStepUnit.Week then...
- nodeId=ac593f72-6dcd-455b-969f-c520550f583f; actionKind=Change; entity=WorkflowCommons.Enum_TimeFrameStepUnit; members=$EndOfStep_InTimeFrame,-1; summary=ChangeVariableAction: change variable EndOfStep_InTimeFrame=if $DashboardContext/TimeFrameStepUnit = WorkflowCommons.Enum_TimeFrameStepUnit.Day then addDays($EndOfStep_InTimeFrame,-1) else if $DashboardContext/TimeFrameStepUnit = WorkflowCommons.Enum_TimeFrameStepUnit.Week then a... change variable EndOfStep_InTimeFrame=if $DashboardContext/TimeFrameStepUnit = WorkflowCommons.Enum_TimeFrameStepUnit.Day then addDays($EndOfStep_InTimeFrame,-1) else if $DashboardContext/TimeFrameStepUnit = WorkflowCommons.Enum_TimeFrameStepUnit.Week then a...
- nodeId=9ee7235a-f636-4d9a-a861-ee1311dd3cea; actionKind=Create; entity=WorkflowCommons.WorkflowSeries; members=DateDisplay=if $DashboardContext/TimeFrameStepUnit = WorkflowCommons.Enum_TimeFrameStepUnit.Day then if $BeginOfStep_InTimeFrame = [%BeginOfCurrentDay%] then 'Today' else formatDateTime($Begin..., NumberofWorkflowsCompleted=$Workflow_CountCompletedOnTime + $Workflow_CountCompletedOverDue, AverageWorkflowHandlingTime=$Workflow_AverageHandlingTime, NumberofWorkflowsCompletedOverdue=$Workflow_CountCompletedOverDue, Date=$BeginOfStep_InTimeFrame, WorkflowSeries_DashboardContext=$DashboardContext; summary=CreateObjectAction: create WorkflowCommons.WorkflowSeries as NewWorkflowSeries (DateDisplay=if $DashboardContext/TimeFrameStepUnit = WorkflowCommons.Enum_TimeFrameStepUnit.Day then if $BeginOfStep_InTimeFrame = [%BeginOfCurrentDay%] then 'Today' else formatDateTime($Begin..., NumberofWorkflowsCompleted=$Workflow_CountCompletedOnTime + $Workflow_CountCompletedOverDue, AverageWorkflowHandlingTime=$Workflow_AverageHandlingTime, NumberofWorkflowsCompletedOverdue=$Workflow_CountCompletedOverDue, Date=$BeginOfStep_InTimeFrame, WorkflowSeries_DashboardContext=$DashboardContext) create WorkflowCommons.WorkflowSeries as NewWorkflowSeries (DateDisplay=if $DashboardContext/TimeFrameStepUnit = WorkflowCommons.Enum_TimeFrameStepUnit.Day then if $BeginOfStep_InTimeFrame = [%BeginOfCurrentDay%] then 'Today' else formatDateTime($Begin..., NumberofWorkflowsCompleted=$Workflow_CountCompletedOnTime + $Workflow_CountCompletedOverDue, AverageWorkflowHandlingTime=$Workflow_AverageHandlingTime, NumberofWorkflowsCompletedOverdue=$Workflow_CountCompletedOverDue, Date=$BeginOfStep_InTimeFrame, WorkflowSeries_DashboardContext=$DashboardContext)
- nodeId=302eb8f0-8d30-4c2e-b861-3a33ab731b5d; actionKind=Create; entity=WorkflowCommons.Enum_TimeFrameStepUnit; summary=CreateVariableAction: create variable BeginOfStep_InTimeFrame=if $DashboardContext/TimeFrameStepUnit = WorkflowCommons.Enum_TimeFrameStepUnit.Day then [%BeginOfCurrentDay%] else if $DashboardContext/TimeFrameStepUnit = WorkflowCommons.Enum_TimeFrameStepUnit.Week then [%BeginOfCurre... create variable BeginOfStep_InTimeFrame=if $DashboardContext/TimeFrameStepUnit = WorkflowCommons.Enum_TimeFrameStepUnit.Day then [%BeginOfCurrentDay%] else if $DashboardContext/TimeFrameStepUnit = WorkflowCommons.Enum_TimeFrameStepUnit.Week then [%BeginOfCurre...
- nodeId=f5dec38d-b49a-4d98-96eb-3537d5181a55; actionKind=Create; entity=WorkflowCommons.Enum_TimeFrameStepUnit; summary=CreateVariableAction: create variable EndOfStep_InTimeFrame=if $DashboardContext/TimeFrameStepUnit = WorkflowCommons.Enum_TimeFrameStepUnit.Day then [%EndOfCurrentDay%] else if $DashboardContext/TimeFrameStepUnit = WorkflowCommons.Enum_TimeFrameStepUnit.Week then [%EndOfCurrentWe... create variable EndOfStep_InTimeFrame=if $DashboardContext/TimeFrameStepUnit = WorkflowCommons.Enum_TimeFrameStepUnit.Day then [%EndOfCurrentDay%] else if $DashboardContext/TimeFrameStepUnit = WorkflowCommons.Enum_TimeFrameStepUnit.Week then [%EndOfCurrentWe...

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowseries-createorupdate.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
