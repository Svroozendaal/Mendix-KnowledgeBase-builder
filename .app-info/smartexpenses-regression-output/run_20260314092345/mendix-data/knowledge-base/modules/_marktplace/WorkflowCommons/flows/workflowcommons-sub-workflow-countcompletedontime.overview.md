---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_Workflow_CountCompletedOnTime
stableId: ba393c62-77c8-4ec8-bff0-62d9ef312160
slug: workflowcommons-sub-workflow-countcompletedontime
layer: L1
l0: workflowcommons-sub-workflow-countcompletedontime.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflow-countcompletedontime.json
l2Logical: flow:WorkflowCommons.SUB_Workflow_CountCompletedOnTime
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_Workflow_CountCompletedOnTime

## Summary

- Likely acts as a save, process, or background step for WorkflowCommons.WorkflowView because it mutates data without showing a page.
- L0: [abstract](workflowcommons-sub-workflow-countcompletedontime.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflow-countcompletedontime.json)

## Main Steps

- retrieve WorkflowView_CompletedOnTime from WorkflowCommons.WorkflowView
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

- nodeId=ac2b6f3b-c825-4db6-84cd-0926d33f8740; sourceKind=Database; entity=WorkflowCommons.WorkflowView; summary=retrieve WorkflowView_CompletedOnTime from WorkflowCommons.WorkflowView
- nodeId=c7aacd1f-50e7-4e8d-9933-85c2daad8035; actionKind=Create; summary=CreateVariableAction: create variable IgnoreCompletedAfter=$CompletedAfter = empty create variable IgnoreCompletedAfter=$CompletedAfter = empty
- nodeId=95928433-9010-4ab3-a812-fb10a9a49d10; actionKind=Create; summary=CreateVariableAction: create variable IgnoreCompletedBefore=$CompletedBefore = empty create variable IgnoreCompletedBefore=$CompletedBefore = empty

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflow-countcompletedontime.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
