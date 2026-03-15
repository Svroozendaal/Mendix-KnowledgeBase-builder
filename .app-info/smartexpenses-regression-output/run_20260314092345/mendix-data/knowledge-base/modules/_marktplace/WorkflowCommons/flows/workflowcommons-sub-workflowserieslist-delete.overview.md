---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_WorkflowSeriesList_Delete
stableId: d3bf6b76-0f9a-4b20-bd7d-04b5680d9419
slug: workflowcommons-sub-workflowserieslist-delete
layer: L1
l0: workflowcommons-sub-workflowserieslist-delete.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowserieslist-delete.json
l2Logical: flow:WorkflowCommons.SUB_WorkflowSeriesList_Delete
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_WorkflowSeriesList_Delete

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](workflowcommons-sub-workflowserieslist-delete.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowserieslist-delete.json)

## Main Steps

- retrieve WorkflowSeriesList over association WorkflowSeries_DashboardContext from DashboardContext
- DeleteAction: delete WorkflowSeriesList (refreshInClient=false) delete WorkflowSeriesList (refreshInClient=false)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.SUB_WorkflowSeries_CreateOrUpdate.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: WorkflowCommons.SUB_WorkflowSeries_CreateOrUpdate

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=5c138921-1406-408b-a123-dbdeeba939c7; sourceKind=Association; association=WorkflowSeries_DashboardContext; summary=retrieve WorkflowSeriesList over association WorkflowSeries_DashboardContext from DashboardContext
- nodeId=e110ce17-1d63-44ba-bc43-2a4453ee692d; actionKind=Delete; members=refreshInClient=false; summary=DeleteAction: delete WorkflowSeriesList (refreshInClient=false) delete WorkflowSeriesList (refreshInClient=false)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowserieslist-delete.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
