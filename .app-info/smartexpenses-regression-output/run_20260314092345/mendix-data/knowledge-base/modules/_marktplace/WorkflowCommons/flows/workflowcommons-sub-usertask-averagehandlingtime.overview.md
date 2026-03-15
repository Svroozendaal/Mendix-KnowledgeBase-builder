---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_UserTask_AverageHandlingTime
stableId: 7c50b7f7-cd22-4fad-9133-6237635c4dda
slug: workflowcommons-sub-usertask-averagehandlingtime
layer: L1
l0: workflowcommons-sub-usertask-averagehandlingtime.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertask-averagehandlingtime.json
l2Logical: flow:WorkflowCommons.SUB_UserTask_AverageHandlingTime
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_UserTask_AverageHandlingTime

## Summary

- Likely acts as a save, process, or background step for WorkflowCommons.UserTaskView because it mutates data without showing a page.
- L0: [abstract](workflowcommons-sub-usertask-averagehandlingtime.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertask-averagehandlingtime.json)

## Main Steps

- retrieve UserTaskView_Completed from WorkflowCommons.UserTaskView
- ChangeVariableAction: change variable TotalHandlingTimeInDays=$TotalHandlingTimeInDays + daysBetween($IteratorUserTask/StartTime, $IteratorUserTask/EndTime) change variable TotalHandlingTimeInDays=$TotalHandlingTimeInDays + daysBetween($IteratorUserTask/StartTime, $IteratorUserTask/EndTime)
- CreateVariableAction: create variable TotalHandlingTimeInDays=0 create variable TotalHandlingTimeInDays=0

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.SUB_TaskSeries_CreateOrUpdate, WorkflowCommons.SUB_TaskSummary_CreateOrUpdate.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- WorkflowCommons.UserTaskView

## Called / Called By

- Calls: none
- Called by: WorkflowCommons.SUB_TaskSeries_CreateOrUpdate, WorkflowCommons.SUB_TaskSummary_CreateOrUpdate

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=a45481a3-099c-4149-aa64-c4b1f3ab65c2; sourceKind=Database; entity=WorkflowCommons.UserTaskView; summary=retrieve UserTaskView_Completed from WorkflowCommons.UserTaskView
- nodeId=b6879873-339e-4624-ab0f-f7a55ff1f225; actionKind=Change; members=$IteratorUserTask/StartTime, $IteratorUserTask/EndTime; summary=ChangeVariableAction: change variable TotalHandlingTimeInDays=$TotalHandlingTimeInDays + daysBetween($IteratorUserTask/StartTime, $IteratorUserTask/EndTime) change variable TotalHandlingTimeInDays=$TotalHandlingTimeInDays + daysBetween($IteratorUserTask/StartTime, $IteratorUserTask/EndTime)
- nodeId=50c778e5-6afb-4752-9091-00740cc1bd50; actionKind=Create; summary=CreateVariableAction: create variable TotalHandlingTimeInDays=0 create variable TotalHandlingTimeInDays=0

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertask-averagehandlingtime.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
