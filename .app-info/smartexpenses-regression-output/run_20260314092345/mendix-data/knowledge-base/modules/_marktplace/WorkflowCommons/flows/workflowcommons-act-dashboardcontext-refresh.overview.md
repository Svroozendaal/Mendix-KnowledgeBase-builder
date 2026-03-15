---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.ACT_DashboardContext_Refresh
stableId: 704eb989-b776-471c-8a78-24e0de854943
slug: workflowcommons-act-dashboardcontext-refresh
layer: L1
l0: workflowcommons-act-dashboardcontext-refresh.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-dashboardcontext-refresh.json
l2Logical: flow:WorkflowCommons.ACT_DashboardContext_Refresh
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.ACT_DashboardContext_Refresh

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](workflowcommons-act-dashboardcontext-refresh.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-dashboardcontext-refresh.json)

## Main Steps

- ChangeObjectAction: change DashboardContext (refreshInClient=true) change DashboardContext (refreshInClient=true)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=e4376f73-bedd-4819-b657-80a3e2310aad; actionKind=Change; members=refreshInClient=true; summary=ChangeObjectAction: change DashboardContext (refreshInClient=true) change DashboardContext (refreshInClient=true)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-dashboardcontext-refresh.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
