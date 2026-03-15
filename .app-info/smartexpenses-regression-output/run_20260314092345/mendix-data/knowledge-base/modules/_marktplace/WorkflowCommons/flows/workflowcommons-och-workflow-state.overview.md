---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.OCh_Workflow_State
stableId: 7895c6a3-0dfa-46eb-832f-27430e14b2bf
slug: workflowcommons-och-workflow-state
layer: L1
l0: workflowcommons-och-workflow-state.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-och-workflow-state.json
l2Logical: flow:WorkflowCommons.OCh_Workflow_State
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.OCh_Workflow_State

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](workflowcommons-och-workflow-state.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-och-workflow-state.json)

## Main Steps

- ChangeObjectAction: change WorkflowView (EndTime=$Workflow/EndTime, DueDate=$Workflow/DueDate, State=$Workflow/State, Reason=$Workflow/Reason; refreshInClient=true) change WorkflowView (EndTime=$Workflow/EndTime, DueDate=$Workflow/DueDate, State=$Workflow/State, Reason=$Workflow/Reason; refreshInClient=true)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: WorkflowCommons.SUB_WorkflowView_FindOrCreate
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=260673d9-0368-4591-ab3d-0a3fd59b8933; actionKind=Change; members=EndTime=$Workflow/EndTime, DueDate=$Workflow/DueDate, State=$Workflow/State, Reason=$Workflow/Reason; refreshInClient=true; summary=ChangeObjectAction: change WorkflowView (EndTime=$Workflow/EndTime, DueDate=$Workflow/DueDate, State=$Workflow/State, Reason=$Workflow/Reason; refreshInClient=true) change WorkflowView (EndTime=$Workflow/EndTime, DueDate=$Workflow/DueDate, State=$Workflow/State, Reason=$Workflow/Reason; refreshInClient=true)

## Warnings/Unknowns

- Rollback hint detected in node detail.
- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-och-workflow-state.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
