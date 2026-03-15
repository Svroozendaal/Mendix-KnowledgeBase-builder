---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_Workflow_CountCompletedOverdue
stableId: 30455940-df0f-4519-b690-1e4bbe69f10f
slug: workflowcommons-sub-workflow-countcompletedoverdue
layer: L1
l0: workflowcommons-sub-workflow-countcompletedoverdue.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflow-countcompletedoverdue.json
l2Logical: flow:WorkflowCommons.SUB_Workflow_CountCompletedOverdue
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_Workflow_CountCompletedOverdue

## Summary

- Likely acts as a save, process, or background step for WorkflowCommons.WorkflowView because it mutates data without showing a page.
- L0: [abstract](workflowcommons-sub-workflow-countcompletedoverdue.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflow-countcompletedoverdue.json)

## Main Steps

- retrieve WorkflowView_CompletedOverdue from WorkflowCommons.WorkflowView
- CreateVariableAction: create variable IgnoreCompletedAfter=$CompletedAfter = empty create variable IgnoreCompletedAfter=$CompletedAfter = empty
- CreateVariableAction: create variable IgnoreCompletedBefore=$CompletedBefore = empty create variable IgnoreCompletedBefore=$CompletedBefore = empty

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.SUB_WorkflowSeries_CreateOrUpdate.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- WorkflowCommons.WorkflowView

## Called / Called By

- Calls: none
- Called by: WorkflowCommons.SUB_WorkflowSeries_CreateOrUpdate

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=325ab9fd-6a5f-451b-846c-b5d4b2690672; sourceKind=Database; entity=WorkflowCommons.WorkflowView; summary=retrieve WorkflowView_CompletedOverdue from WorkflowCommons.WorkflowView
- nodeId=264872fa-5d4f-469d-a400-82e14181f8cb; actionKind=Create; summary=CreateVariableAction: create variable IgnoreCompletedAfter=$CompletedAfter = empty create variable IgnoreCompletedAfter=$CompletedAfter = empty
- nodeId=bf3e66c6-7bf3-47bc-95e1-aa65ad20194c; actionKind=Create; summary=CreateVariableAction: create variable IgnoreCompletedBefore=$CompletedBefore = empty create variable IgnoreCompletedBefore=$CompletedBefore = empty

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflow-countcompletedoverdue.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
