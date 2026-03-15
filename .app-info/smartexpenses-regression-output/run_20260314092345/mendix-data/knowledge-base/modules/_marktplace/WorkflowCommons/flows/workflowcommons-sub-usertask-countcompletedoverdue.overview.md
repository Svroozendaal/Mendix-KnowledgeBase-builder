---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_UserTask_CountCompletedOverdue
stableId: 09b2f734-238b-4e1a-884e-6a7ae6559a39
slug: workflowcommons-sub-usertask-countcompletedoverdue
layer: L1
l0: workflowcommons-sub-usertask-countcompletedoverdue.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertask-countcompletedoverdue.json
l2Logical: flow:WorkflowCommons.SUB_UserTask_CountCompletedOverdue
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_UserTask_CountCompletedOverdue

## Summary

- Likely serves as a helper flow invoked from WorkflowCommons.SUB_TaskSeries_CreateOrUpdate.
- L0: [abstract](workflowcommons-sub-usertask-countcompletedoverdue.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertask-countcompletedoverdue.json)

## Main Steps

- retrieve UserTaskView_CompletedOverdue from WorkflowCommons.UserTaskView

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.SUB_TaskSeries_CreateOrUpdate.
- Output/UI context: No page output was exported; check L2 JSON if the exact user-facing effect matters.

## Key Entities Touched

- WorkflowCommons.UserTaskView

## Called / Called By

- Calls: none
- Called by: WorkflowCommons.SUB_TaskSeries_CreateOrUpdate

## Shown Pages

- No ShowPageAction was exported for this flow; it may serve validation, background processing, or delegate work to other flows.

## Important Retrieves/Decisions/Mutations

- nodeId=c51530d6-6041-4a64-9d8a-fd4a4615c0a8; sourceKind=Database; entity=WorkflowCommons.UserTaskView; summary=retrieve UserTaskView_CompletedOverdue from WorkflowCommons.UserTaskView

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertask-countcompletedoverdue.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
