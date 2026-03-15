---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_WorkflowDashboard_Update
stableId: 850bc31f-ce4e-4d15-9b74-420deb65dba0
slug: workflowcommons-sub-workflowdashboard-update
layer: L1
l0: workflowcommons-sub-workflowdashboard-update.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowdashboard-update.json
l2Logical: flow:WorkflowCommons.SUB_WorkflowDashboard_Update
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_WorkflowDashboard_Update

## Summary

- Likely orchestrates downstream flow calls without direct UI output.
- L0: [abstract](workflowcommons-sub-workflowdashboard-update.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowdashboard-update.json)

## Main Steps

- No compact step summary was derivable from the exported flow actions.

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.DS_WorkflowDashboard, WorkflowCommons.OCh_DashboardContext_UpdateWorkflowDashboard.
- Output/UI context: No page output was exported; this likely delegates work to downstream flows.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: WorkflowCommons.DashboardContext_GetSelectedWorkflowDefinition, WorkflowCommons.DashboardContext_GetSelectedWorkflowTaskDefinition, WorkflowCommons.SUB_DashboardContext_UpdateSettings, WorkflowCommons.SUB_TaskSeries_CreateOrUpdate, WorkflowCommons.SUB_TaskSummary_CreateOrUpdate, WorkflowCommons.SUB_WorkflowSeries_CreateOrUpdate, WorkflowCommons.SUB_WorkflowSummary_CreateOrUpdate, WorkflowCommons.SUB_WorkflowTaskDetail_CreateOrUpdate
- Called by: WorkflowCommons.DS_WorkflowDashboard, WorkflowCommons.OCh_DashboardContext_UpdateWorkflowDashboard

## Shown Pages

- No ShowPageAction was exported for this flow; it may serve validation, background processing, or delegate work to other flows.

## Important Retrieves/Decisions/Mutations

- No retrieve, decision, or mutation metadata was exported for this flow; inspect L2 JSON if node-level evidence matters.

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowdashboard-update.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
