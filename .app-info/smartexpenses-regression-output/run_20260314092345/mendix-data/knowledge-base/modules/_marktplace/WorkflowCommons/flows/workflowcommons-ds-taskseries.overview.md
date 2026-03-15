---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.DS_TaskSeries
stableId: b310ceb8-8e2d-4a20-8266-6d095e435221
slug: workflowcommons-ds-taskseries
layer: L1
l0: workflowcommons-ds-taskseries.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ds-taskseries.json
l2Logical: flow:WorkflowCommons.DS_TaskSeries
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.DS_TaskSeries

## Summary

- Likely supplies data to callers or pages rather than driving user navigation directly.
- L0: [abstract](workflowcommons-ds-taskseries.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ds-taskseries.json)

## Main Steps

- retrieve TaskSeriesList over association TaskSeries_DashboardContext from DashboardContext

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; check L2 JSON if the exact user-facing effect matters.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it may serve validation, background processing, or delegate work to other flows.

## Important Retrieves/Decisions/Mutations

- nodeId=c31b2ab3-b5c8-45be-9091-bd006003ebfc; sourceKind=Association; association=TaskSeries_DashboardContext; summary=retrieve TaskSeriesList over association TaskSeries_DashboardContext from DashboardContext

## Warnings/Unknowns

- Rollback hint detected in node detail.
- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ds-taskseries.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
