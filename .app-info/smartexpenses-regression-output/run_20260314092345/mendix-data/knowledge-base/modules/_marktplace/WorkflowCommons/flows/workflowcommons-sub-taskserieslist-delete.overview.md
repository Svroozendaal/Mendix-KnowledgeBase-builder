---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_TaskSeriesList_Delete
stableId: 626f631e-27d4-4349-9d53-b09ef1f6953a
slug: workflowcommons-sub-taskserieslist-delete
layer: L1
l0: workflowcommons-sub-taskserieslist-delete.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-taskserieslist-delete.json
l2Logical: flow:WorkflowCommons.SUB_TaskSeriesList_Delete
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_TaskSeriesList_Delete

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](workflowcommons-sub-taskserieslist-delete.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-taskserieslist-delete.json)

## Main Steps

- retrieve TaskSeriesList over association TaskSeries_DashboardContext from DashboardContext
- DeleteAction: delete TaskSeriesList (refreshInClient=false) delete TaskSeriesList (refreshInClient=false)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.SUB_TaskSeries_CreateOrUpdate.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: WorkflowCommons.SUB_TaskSeries_CreateOrUpdate

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=8a661aab-e6d4-4a88-be82-610d0ead9a69; sourceKind=Association; association=TaskSeries_DashboardContext; summary=retrieve TaskSeriesList over association TaskSeries_DashboardContext from DashboardContext
- nodeId=a34cb5ad-b258-441f-b08f-44d63608030c; actionKind=Delete; members=refreshInClient=false; summary=DeleteAction: delete TaskSeriesList (refreshInClient=false) delete TaskSeriesList (refreshInClient=false)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-taskserieslist-delete.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
