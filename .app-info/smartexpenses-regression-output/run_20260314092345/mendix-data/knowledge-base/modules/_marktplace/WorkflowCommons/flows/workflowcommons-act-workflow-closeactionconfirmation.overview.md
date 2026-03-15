---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.ACT_Workflow_CloseActionConfirmation
stableId: 2931dabd-85ef-4c90-a9ca-29cc1b7ad1f3
slug: workflowcommons-act-workflow-closeactionconfirmation
layer: L1
l0: workflowcommons-act-workflow-closeactionconfirmation.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-workflow-closeactionconfirmation.json
l2Logical: flow:WorkflowCommons.ACT_Workflow_CloseActionConfirmation
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.ACT_Workflow_CloseActionConfirmation

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](workflowcommons-act-workflow-closeactionconfirmation.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-workflow-closeactionconfirmation.json)

## Main Steps

- retrieve WorkflowUserTaskList over association WorkflowUserTask_Workflow from Workflow
- ChangeObjectAction: change IteratorWorkflowUserTask (refreshInClient=true) change IteratorWorkflowUserTask (refreshInClient=true)
- ChangeObjectAction: change Workflow (refreshInClient=true) change Workflow (refreshInClient=true)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=3701200b-6820-4bac-9e0c-e65614e3055e; sourceKind=Association; association=WorkflowUserTask_Workflow; summary=retrieve WorkflowUserTaskList over association WorkflowUserTask_Workflow from Workflow
- nodeId=9c56566c-a722-434f-88f6-d054e36dbc71; actionKind=Change; members=refreshInClient=true; summary=ChangeObjectAction: change IteratorWorkflowUserTask (refreshInClient=true) change IteratorWorkflowUserTask (refreshInClient=true)
- nodeId=f6d35722-547a-4fc4-bc1e-40ab916a27f3; actionKind=Change; members=refreshInClient=true; summary=ChangeObjectAction: change Workflow (refreshInClient=true) change Workflow (refreshInClient=true)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-workflow-closeactionconfirmation.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
