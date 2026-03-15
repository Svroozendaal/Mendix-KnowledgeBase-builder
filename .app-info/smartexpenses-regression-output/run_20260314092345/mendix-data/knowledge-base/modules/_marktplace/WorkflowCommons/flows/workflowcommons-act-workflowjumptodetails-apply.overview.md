---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.ACT_WorkflowJumpToDetails_Apply
stableId: ad1d41dc-e25d-45fe-b782-f44eab2aca25
slug: workflowcommons-act-workflowjumptodetails-apply
layer: L1
l0: workflowcommons-act-workflowjumptodetails-apply.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-workflowjumptodetails-apply.json
l2Logical: flow:WorkflowCommons.ACT_WorkflowJumpToDetails_Apply
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.ACT_WorkflowJumpToDetails_Apply

## Summary

- Likely acts as a UI entry or navigation handler because it shows WorkflowCommons.Workflow_ActionConfirmation.
- L0: [abstract](workflowcommons-act-workflowjumptodetails-apply.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-workflowjumptodetails-apply.json)

## Main Steps

- retrieve Workflow over association WorkflowJumpToDetails_Workflow from WorkflowJumpToDetails
- $Valid Valid? expression=$Valid
- ShowPageAction: show page WorkflowCommons.Workflow_ActionConfirmation show page WorkflowCommons.Workflow_ActionConfirmation

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: Shows WorkflowCommons.Workflow_ActionConfirmation.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: WorkflowCommons.SUB_WorkflowJumpToDetails_Validate
- Called by: none

## Shown Pages

- WorkflowCommons.Workflow_ActionConfirmation

## Important Retrieves/Decisions/Mutations

- nodeId=704be36c-6428-4b7e-95a7-a7c5bf8ec03d; sourceKind=Association; association=WorkflowJumpToDetails_Workflow; summary=retrieve Workflow over association WorkflowJumpToDetails_Workflow from WorkflowJumpToDetails
- nodeId=3cbb7b6d-df16-4e45-bc67-0cf6230cd703; caption=Valid?; expression=$Valid Valid? expression=$Valid

## Warnings/Unknowns

- Rollback hint detected in node detail.
- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-workflowjumptodetails-apply.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
