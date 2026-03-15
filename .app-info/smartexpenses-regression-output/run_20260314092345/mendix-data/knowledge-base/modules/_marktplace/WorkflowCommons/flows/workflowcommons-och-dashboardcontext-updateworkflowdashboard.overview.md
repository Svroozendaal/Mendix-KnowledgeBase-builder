---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.OCh_DashboardContext_UpdateWorkflowDashboard
stableId: e7713c6c-9c91-4d7c-aa45-98fb395d950e
slug: workflowcommons-och-dashboardcontext-updateworkflowdashboard
layer: L1
l0: workflowcommons-och-dashboardcontext-updateworkflowdashboard.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-och-dashboardcontext-updateworkflowdashboard.json
l2Logical: flow:WorkflowCommons.OCh_DashboardContext_UpdateWorkflowDashboard
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.OCh_DashboardContext_UpdateWorkflowDashboard

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](workflowcommons-och-dashboardcontext-updateworkflowdashboard.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-och-dashboardcontext-updateworkflowdashboard.json)

## Main Steps

- ChangeObjectAction: change DashboardContext (refreshInClient=true) change DashboardContext (refreshInClient=true)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: WorkflowCommons.SUB_WorkflowDashboard_Update
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=86a3c235-da1d-4958-b586-3301be739f0f; actionKind=Change; members=refreshInClient=true; summary=ChangeObjectAction: change DashboardContext (refreshInClient=true) change DashboardContext (refreshInClient=true)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-och-dashboardcontext-updateworkflowdashboard.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
