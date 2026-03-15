---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_UserTask_CountOverdue
stableId: 9a43c5f3-c04c-412d-9a75-1972eab19c3b
slug: workflowcommons-sub-usertask-countoverdue
layer: L1
l0: workflowcommons-sub-usertask-countoverdue.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertask-countoverdue.json
l2Logical: flow:WorkflowCommons.SUB_UserTask_CountOverdue
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_UserTask_CountOverdue

## Summary

- Likely acts as a save, process, or background step for System.WorkflowUserTask, WorkflowCommons.UserTaskView because it mutates data without showing a page.
- L0: [abstract](workflowcommons-sub-usertask-countoverdue.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertask-countoverdue.json)

## Main Steps

- retrieve UserTaskView_Overdue from WorkflowCommons.UserTaskView
- retrieve UserTask_InProgress_Overdue from System.WorkflowUserTask
- CreateVariableAction: create variable CountOverdueTotal=$CountOverdue + $CountInProgressOverdue create variable CountOverdueTotal=$CountOverdue + $CountInProgressOverdue

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.SUB_TaskSummary_CreateOrUpdate.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- System.WorkflowUserTask, WorkflowCommons.UserTaskView

## Called / Called By

- Calls: none
- Called by: WorkflowCommons.SUB_TaskSummary_CreateOrUpdate

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=2292f884-e497-49d8-8f54-ae29c809782b; sourceKind=Database; entity=WorkflowCommons.UserTaskView; summary=retrieve UserTaskView_Overdue from WorkflowCommons.UserTaskView
- nodeId=75a6902a-ae2d-4289-be45-b64cb42bd85a; sourceKind=Database; entity=System.WorkflowUserTask; summary=retrieve UserTask_InProgress_Overdue from System.WorkflowUserTask
- nodeId=10976107-06bd-4e3f-98bd-680b7ddebef6; actionKind=Create; summary=CreateVariableAction: create variable CountOverdueTotal=$CountOverdue + $CountInProgressOverdue create variable CountOverdueTotal=$CountOverdue + $CountInProgressOverdue

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertask-countoverdue.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
