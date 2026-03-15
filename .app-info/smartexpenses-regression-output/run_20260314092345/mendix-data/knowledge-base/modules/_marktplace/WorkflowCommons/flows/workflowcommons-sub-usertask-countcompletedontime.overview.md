---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_UserTask_CountCompletedOnTime
stableId: 5956734b-8220-44e0-8da8-c028df353932
slug: workflowcommons-sub-usertask-countcompletedontime
layer: L1
l0: workflowcommons-sub-usertask-countcompletedontime.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertask-countcompletedontime.json
l2Logical: flow:WorkflowCommons.SUB_UserTask_CountCompletedOnTime
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_UserTask_CountCompletedOnTime

## Summary

- Likely serves as a helper flow invoked from WorkflowCommons.SUB_TaskSeries_CreateOrUpdate, WorkflowCommons.SUB_TaskSummary_CreateOrUpdate.
- L0: [abstract](workflowcommons-sub-usertask-countcompletedontime.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertask-countcompletedontime.json)

## Main Steps

- retrieve UserTaskView_CompletedOnTime from WorkflowCommons.UserTaskView

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.SUB_TaskSeries_CreateOrUpdate, WorkflowCommons.SUB_TaskSummary_CreateOrUpdate.
- Output/UI context: No page output was exported; check L2 JSON if the exact user-facing effect matters.

## Key Entities Touched

- WorkflowCommons.UserTaskView

## Called / Called By

- Calls: none
- Called by: WorkflowCommons.SUB_TaskSeries_CreateOrUpdate, WorkflowCommons.SUB_TaskSummary_CreateOrUpdate

## Shown Pages

- No ShowPageAction was exported for this flow; it may serve validation, background processing, or delegate work to other flows.

## Important Retrieves/Decisions/Mutations

- nodeId=9e63efe7-8193-4e28-916e-5576a74b5a0e; sourceKind=Database; entity=WorkflowCommons.UserTaskView; summary=retrieve UserTaskView_CompletedOnTime from WorkflowCommons.UserTaskView

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertask-countcompletedontime.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
