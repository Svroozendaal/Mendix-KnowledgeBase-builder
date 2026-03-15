---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_Workflow_AverageHandlingTime
stableId: 26c32472-d75a-4bed-885e-dbee42a2a8fb
slug: workflowcommons-sub-workflow-averagehandlingtime
layer: L1
l0: workflowcommons-sub-workflow-averagehandlingtime.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflow-averagehandlingtime.json
l2Logical: flow:WorkflowCommons.SUB_Workflow_AverageHandlingTime
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_Workflow_AverageHandlingTime

## Summary

- Likely acts as a save, process, or background step for WorkflowCommons.WorkflowView because it mutates data without showing a page.
- L0: [abstract](workflowcommons-sub-workflow-averagehandlingtime.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflow-averagehandlingtime.json)

## Main Steps

- retrieve WorkflowView_Completed from WorkflowCommons.WorkflowView
- ChangeVariableAction: change variable TotalHandlingTimeInDays=$TotalHandlingTimeInDays + daysBetween($IteratorWorkflow/StartTime,$IteratorWorkflow/EndTime) change variable TotalHandlingTimeInDays=$TotalHandlingTimeInDays + daysBetween($IteratorWorkflow/StartTime,$IteratorWorkflow/EndTime)
- CreateVariableAction: create variable IgnoreCompletedAfter=$CompletedAfter = empty create variable IgnoreCompletedAfter=$CompletedAfter = empty

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

- nodeId=545bfebb-77e5-4efb-a913-2c9f361befee; sourceKind=Database; entity=WorkflowCommons.WorkflowView; summary=retrieve WorkflowView_Completed from WorkflowCommons.WorkflowView
- nodeId=5c7df3b9-7df3-440b-a2d6-74384a47c8fb; actionKind=Change; members=$IteratorWorkflow/StartTime,$IteratorWorkflow/EndTime; summary=ChangeVariableAction: change variable TotalHandlingTimeInDays=$TotalHandlingTimeInDays + daysBetween($IteratorWorkflow/StartTime,$IteratorWorkflow/EndTime) change variable TotalHandlingTimeInDays=$TotalHandlingTimeInDays + daysBetween($IteratorWorkflow/StartTime,$IteratorWorkflow/EndTime)
- nodeId=aff67c8b-7a5d-4e2d-95b3-8be614b56df0; actionKind=Create; summary=CreateVariableAction: create variable IgnoreCompletedAfter=$CompletedAfter = empty create variable IgnoreCompletedAfter=$CompletedAfter = empty
- nodeId=9e9573be-2518-45ac-8705-6b1936d22b08; actionKind=Create; summary=CreateVariableAction: create variable IgnoreCompletedBefore=$CompletedBefore = empty create variable IgnoreCompletedBefore=$CompletedBefore = empty
- nodeId=6ef85094-99b7-4a21-a1b6-22160b0b371e; actionKind=Create; summary=CreateVariableAction: create variable TotalHandlingTimeInDays=0 create variable TotalHandlingTimeInDays=0

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflow-averagehandlingtime.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
