---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_UserTask_CountInProgress
stableId: 9056e27f-12f6-4269-a462-bfa6692fae18
slug: workflowcommons-sub-usertask-countinprogress
layer: L1
l0: workflowcommons-sub-usertask-countinprogress.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertask-countinprogress.json
l2Logical: flow:WorkflowCommons.SUB_UserTask_CountInProgress
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_UserTask_CountInProgress

## Summary

- Likely serves as a helper flow invoked from WorkflowCommons.SUB_TaskSummary_CreateOrUpdate.
- L0: [abstract](workflowcommons-sub-usertask-countinprogress.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertask-countinprogress.json)

## Main Steps

- retrieve UserTask_InProgress from System.WorkflowUserTask

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.SUB_TaskSummary_CreateOrUpdate.
- Output/UI context: No page output was exported; check L2 JSON if the exact user-facing effect matters.

## Key Entities Touched

- System.WorkflowUserTask

## Called / Called By

- Calls: none
- Called by: WorkflowCommons.SUB_TaskSummary_CreateOrUpdate

## Shown Pages

- No ShowPageAction was exported for this flow; it may serve validation, background processing, or delegate work to other flows.

## Important Retrieves/Decisions/Mutations

- nodeId=b1ef6cb0-4bcd-444d-8d11-720a1f5399f7; sourceKind=Database; entity=System.WorkflowUserTask; summary=retrieve UserTask_InProgress from System.WorkflowUserTask

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertask-countinprogress.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
