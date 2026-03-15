---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.DS_WorkflowTaskDetail
stableId: 7af956a3-f247-4de8-859f-a7b9147b2cb1
slug: workflowcommons-ds-workflowtaskdetail
layer: L1
l0: workflowcommons-ds-workflowtaskdetail.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ds-workflowtaskdetail.json
l2Logical: flow:WorkflowCommons.DS_WorkflowTaskDetail
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.DS_WorkflowTaskDetail

## Summary

- Likely supplies data to callers or pages rather than driving user navigation directly.
- L0: [abstract](workflowcommons-ds-workflowtaskdetail.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ds-workflowtaskdetail.json)

## Main Steps

- retrieve WorkflowTaskDetail over association WorkflowTaskDetail_DashboardContext from DashboardContext

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

- nodeId=de582de6-621d-4f03-8257-2e46487a922a; sourceKind=Association; association=WorkflowTaskDetail_DashboardContext; summary=retrieve WorkflowTaskDetail over association WorkflowTaskDetail_DashboardContext from DashboardContext

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ds-workflowtaskdetail.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
