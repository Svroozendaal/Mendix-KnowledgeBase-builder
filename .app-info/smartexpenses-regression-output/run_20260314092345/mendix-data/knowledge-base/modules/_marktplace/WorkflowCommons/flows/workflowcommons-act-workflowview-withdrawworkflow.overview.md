---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.ACT_WorkflowView_WithdrawWorkflow
stableId: 80eb94c9-3704-4c93-bbe7-4bd6e0fca3c5
slug: workflowcommons-act-workflowview-withdrawworkflow
layer: L1
l0: workflowcommons-act-workflowview-withdrawworkflow.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-workflowview-withdrawworkflow.json
l2Logical: flow:WorkflowCommons.ACT_WorkflowView_WithdrawWorkflow
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.ACT_WorkflowView_WithdrawWorkflow

## Summary

- Likely acts as a UI entry or navigation handler because it shows WorkflowCommons.Workflow_WithdrawConfirmation.
- L0: [abstract](workflowcommons-act-workflowview-withdrawworkflow.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-workflowview-withdrawworkflow.json)

## Main Steps

- retrieve Workflow over association WorkflowView_Workflow from WorkflowView
- ShowPageAction: show page WorkflowCommons.Workflow_WithdrawConfirmation show page WorkflowCommons.Workflow_WithdrawConfirmation
- CreateObjectAction: create WorkflowCommons.WorkflowComment as NewWorkflowComment (WorkflowComment_Workflow=$Workflow, WorkflowComment_WorkflowView=$WorkflowView) create WorkflowCommons.WorkflowComment as NewWorkflowComment (WorkflowComment_Workflow=$Workflow, WorkflowComment_WorkflowView=$WorkflowView)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: Shows WorkflowCommons.Workflow_WithdrawConfirmation.

## Key Entities Touched

- WorkflowCommons.WorkflowComment

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- WorkflowCommons.Workflow_WithdrawConfirmation

## Important Retrieves/Decisions/Mutations

- nodeId=f563fb41-7aa5-4997-9343-7f8ee5fc7cee; sourceKind=Association; association=WorkflowView_Workflow; summary=retrieve Workflow over association WorkflowView_Workflow from WorkflowView
- nodeId=eeb37718-bb4b-4747-82bb-f04ecc03f62c; actionKind=Create; entity=WorkflowCommons.WorkflowComment; members=WorkflowComment_Workflow=$Workflow, WorkflowComment_WorkflowView=$WorkflowView; summary=CreateObjectAction: create WorkflowCommons.WorkflowComment as NewWorkflowComment (WorkflowComment_Workflow=$Workflow, WorkflowComment_WorkflowView=$WorkflowView) create WorkflowCommons.WorkflowComment as NewWorkflowComment (WorkflowComment_Workflow=$Workflow, WorkflowComment_WorkflowView=$WorkflowView)

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-workflowview-withdrawworkflow.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
