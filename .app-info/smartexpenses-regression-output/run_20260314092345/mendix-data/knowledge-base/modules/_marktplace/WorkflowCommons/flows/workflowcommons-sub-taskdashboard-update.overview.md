---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_TaskDashboard_Update
stableId: 5e949125-595f-428b-af6b-2283b9fd5c28
slug: workflowcommons-sub-taskdashboard-update
layer: L1
l0: workflowcommons-sub-taskdashboard-update.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-taskdashboard-update.json
l2Logical: flow:WorkflowCommons.SUB_TaskDashboard_Update
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_TaskDashboard_Update

## Summary

- Likely orchestrates downstream flow calls without direct UI output.
- L0: [abstract](workflowcommons-sub-taskdashboard-update.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-taskdashboard-update.json)

## Main Steps

- No compact step summary was derivable from the exported flow actions.

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.DS_TaskDashboard, WorkflowCommons.OCh_DashboardContext_UpdateTaskDashboard.
- Output/UI context: No page output was exported; this likely delegates work to downstream flows.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: WorkflowCommons.DashboardContext_GetSelectedWorkflowDefinition, WorkflowCommons.DashboardContext_GetSelectedWorkflowTaskDefinition, WorkflowCommons.SUB_DashboardContext_UpdateSettings, WorkflowCommons.SUB_TaskSeries_CreateOrUpdate, WorkflowCommons.SUB_TaskSummary_CreateOrUpdate
- Called by: WorkflowCommons.DS_TaskDashboard, WorkflowCommons.OCh_DashboardContext_UpdateTaskDashboard

## Shown Pages

- No ShowPageAction was exported for this flow; it may serve validation, background processing, or delegate work to other flows.

## Important Retrieves/Decisions/Mutations

- No retrieve, decision, or mutation metadata was exported for this flow; inspect L2 JSON if node-level evidence matters.

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-taskdashboard-update.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
