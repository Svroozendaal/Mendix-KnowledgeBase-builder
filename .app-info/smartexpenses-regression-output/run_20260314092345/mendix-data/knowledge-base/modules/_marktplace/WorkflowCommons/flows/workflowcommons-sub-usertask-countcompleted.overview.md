---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_UserTask_CountCompleted
stableId: 6fd2345f-df64-470d-957d-e45ce6541a2a
slug: workflowcommons-sub-usertask-countcompleted
layer: L1
l0: workflowcommons-sub-usertask-countcompleted.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertask-countcompleted.json
l2Logical: flow:WorkflowCommons.SUB_UserTask_CountCompleted
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_UserTask_CountCompleted

## Summary

- Likely serves as a helper flow invoked from WorkflowCommons.SUB_TaskSummary_CreateOrUpdate.
- L0: [abstract](workflowcommons-sub-usertask-countcompleted.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertask-countcompleted.json)

## Main Steps

- retrieve UserTaskView_Completed from WorkflowCommons.UserTaskView

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.SUB_TaskSummary_CreateOrUpdate.
- Output/UI context: No page output was exported; check L2 JSON if the exact user-facing effect matters.

## Key Entities Touched

- WorkflowCommons.UserTaskView

## Called / Called By

- Calls: none
- Called by: WorkflowCommons.SUB_TaskSummary_CreateOrUpdate

## Shown Pages

- No ShowPageAction was exported for this flow; it may serve validation, background processing, or delegate work to other flows.

## Important Retrieves/Decisions/Mutations

- nodeId=2d7dcaa3-5b75-42bf-8a35-58c14dc0eced; sourceKind=Database; entity=WorkflowCommons.UserTaskView; summary=retrieve UserTaskView_Completed from WorkflowCommons.UserTaskView

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertask-countcompleted.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
