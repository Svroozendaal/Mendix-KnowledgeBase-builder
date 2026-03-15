---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_Workflow_CountCompleted
stableId: c492d964-dff0-4d88-ad0d-f98b1f5b904a
slug: workflowcommons-sub-workflow-countcompleted
layer: L1
l0: workflowcommons-sub-workflow-countcompleted.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflow-countcompleted.json
l2Logical: flow:WorkflowCommons.SUB_Workflow_CountCompleted
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_Workflow_CountCompleted

## Summary

- Likely acts as a save, process, or background step for WorkflowCommons.WorkflowView because it mutates data without showing a page.
- L0: [abstract](workflowcommons-sub-workflow-countcompleted.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflow-countcompleted.json)

## Main Steps

- retrieve WorkflowView_Completed from WorkflowCommons.WorkflowView
- CreateVariableAction: create variable IgnoreStartedAfter=$StartedAfter = empty create variable IgnoreStartedAfter=$StartedAfter = empty
- CreateVariableAction: create variable IgnoreStartedBefore=$StartedBefore = empty create variable IgnoreStartedBefore=$StartedBefore = empty

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.SUB_WorkflowSummary_CreateOrUpdate.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- WorkflowCommons.WorkflowView

## Called / Called By

- Calls: none
- Called by: WorkflowCommons.SUB_WorkflowSummary_CreateOrUpdate

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=9ff195ef-21af-49a9-a9b6-0d7a4d868b98; sourceKind=Database; entity=WorkflowCommons.WorkflowView; summary=retrieve WorkflowView_Completed from WorkflowCommons.WorkflowView
- nodeId=2d509cfa-ef24-4ff5-8a40-f2b8687702c0; actionKind=Create; summary=CreateVariableAction: create variable IgnoreStartedAfter=$StartedAfter = empty create variable IgnoreStartedAfter=$StartedAfter = empty
- nodeId=248ce926-bfbc-44da-aef3-ff844b2a16b2; actionKind=Create; summary=CreateVariableAction: create variable IgnoreStartedBefore=$StartedBefore = empty create variable IgnoreStartedBefore=$StartedBefore = empty

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflow-countcompleted.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
