---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_WorkflowSummary_RetrieveOrCreate
stableId: 3cae5e60-f95a-434e-97c9-75a0cc9b36fd
slug: workflowcommons-sub-workflowsummary-retrieveorcreate
layer: L1
l0: workflowcommons-sub-workflowsummary-retrieveorcreate.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowsummary-retrieveorcreate.json
l2Logical: flow:WorkflowCommons.SUB_WorkflowSummary_RetrieveOrCreate
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_WorkflowSummary_RetrieveOrCreate

## Summary

- Likely acts as a save, process, or background step for WorkflowCommons.WorkflowSummary because it mutates data without showing a page.
- L0: [abstract](workflowcommons-sub-workflowsummary-retrieveorcreate.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowsummary-retrieveorcreate.json)

## Main Steps

- retrieve WorkflowSummary over association DashboardContext_WorkflowSummary from DashboardContext
- $DashboardContext != empty != empty expression=$DashboardContext != empty
- $WorkflowSummary != empty != empty expression=$WorkflowSummary != empty
- CreateObjectAction: create WorkflowCommons.WorkflowSummary as EmptyWorkflowSummary create WorkflowCommons.WorkflowSummary as EmptyWorkflowSummary
- CreateObjectAction: create WorkflowCommons.WorkflowSummary as NewWorkflowSummary (DashboardContext_WorkflowSummary=$DashboardContext) create WorkflowCommons.WorkflowSummary as NewWorkflowSummary (DashboardContext_WorkflowSummary=$DashboardContext)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.SUB_WorkflowSummary_CreateOrUpdate.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- WorkflowCommons.WorkflowSummary

## Called / Called By

- Calls: none
- Called by: WorkflowCommons.SUB_WorkflowSummary_CreateOrUpdate

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=dfc9141f-e0a5-4627-8985-57f40a911208; sourceKind=Association; association=DashboardContext_WorkflowSummary; summary=retrieve WorkflowSummary over association DashboardContext_WorkflowSummary from DashboardContext
- nodeId=13525c58-124e-403f-81d5-77be4c54596d; caption=!= empty; expression=$DashboardContext != empty != empty expression=$DashboardContext != empty
- nodeId=5c1969eb-e9e0-4277-a4ca-cd378df0ab2e; caption=!= empty; expression=$WorkflowSummary != empty != empty expression=$WorkflowSummary != empty
- nodeId=68a9efcb-c112-4502-9c48-4fa42fc68a50; actionKind=Create; entity=WorkflowCommons.WorkflowSummary; summary=CreateObjectAction: create WorkflowCommons.WorkflowSummary as EmptyWorkflowSummary create WorkflowCommons.WorkflowSummary as EmptyWorkflowSummary
- nodeId=e35aa7bf-9e1f-48b1-a5a6-e7ced9119d26; actionKind=Create; entity=WorkflowCommons.WorkflowSummary; members=DashboardContext_WorkflowSummary=$DashboardContext; summary=CreateObjectAction: create WorkflowCommons.WorkflowSummary as NewWorkflowSummary (DashboardContext_WorkflowSummary=$DashboardContext) create WorkflowCommons.WorkflowSummary as NewWorkflowSummary (DashboardContext_WorkflowSummary=$DashboardContext)

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowsummary-retrieveorcreate.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
