---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_WorkflowTask_AverageHandlingTime
stableId: c782815e-613b-471e-95c1-ea9e6e8fc585
slug: workflowcommons-sub-workflowtask-averagehandlingtime
layer: L1
l0: workflowcommons-sub-workflowtask-averagehandlingtime.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowtask-averagehandlingtime.json
l2Logical: flow:WorkflowCommons.SUB_WorkflowTask_AverageHandlingTime
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_WorkflowTask_AverageHandlingTime

## Summary

- Likely acts as a save, process, or background step for WorkflowCommons.UserTaskView because it mutates data without showing a page.
- L0: [abstract](workflowcommons-sub-workflowtask-averagehandlingtime.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowtask-averagehandlingtime.json)

## Main Steps

- retrieve UserTaskViewList from WorkflowCommons.UserTaskView
- ChangeVariableAction: change variable TotalHandlingTimeInDays=$TotalHandlingTimeInDays + daysBetween($IteratorUserTask/StartTime,$IteratorUserTask/EndTime) change variable TotalHandlingTimeInDays=$TotalHandlingTimeInDays + daysBetween($IteratorUserTask/StartTime,$IteratorUserTask/EndTime)
- CreateVariableAction: create variable TotalHandlingTimeInDays=0 create variable TotalHandlingTimeInDays=0

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.SUB_WorkflowTaskDetail_CreateOrUpdate.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- WorkflowCommons.UserTaskView

## Called / Called By

- Calls: none
- Called by: WorkflowCommons.SUB_WorkflowTaskDetail_CreateOrUpdate

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=572a9f93-e3f5-4e76-a725-0aa8af52aca2; sourceKind=Database; entity=WorkflowCommons.UserTaskView; summary=retrieve UserTaskViewList from WorkflowCommons.UserTaskView
- nodeId=f90d0109-0f87-4b07-9604-19d6da3b939f; actionKind=Change; members=$IteratorUserTask/StartTime,$IteratorUserTask/EndTime; summary=ChangeVariableAction: change variable TotalHandlingTimeInDays=$TotalHandlingTimeInDays + daysBetween($IteratorUserTask/StartTime,$IteratorUserTask/EndTime) change variable TotalHandlingTimeInDays=$TotalHandlingTimeInDays + daysBetween($IteratorUserTask/StartTime,$IteratorUserTask/EndTime)
- nodeId=7071fcc3-e38c-49fc-9fd1-d3f589bec955; actionKind=Create; summary=CreateVariableAction: create variable TotalHandlingTimeInDays=0 create variable TotalHandlingTimeInDays=0

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowtask-averagehandlingtime.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
