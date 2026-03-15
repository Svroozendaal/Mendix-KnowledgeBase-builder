---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_Workflow_Retry
stableId: d6d2c01b-b7f4-4d50-9ef5-27963966edf5
slug: workflowcommons-sub-workflow-retry
layer: L1
l0: workflowcommons-sub-workflow-retry.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflow-retry.json
l2Logical: flow:WorkflowCommons.SUB_Workflow_Retry
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_Workflow_Retry

## Summary

- Likely acts as a UI entry or navigation handler because it shows WorkflowCommons.Workflow_ActionConfirmation.
- L0: [abstract](workflowcommons-sub-workflow-retry.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflow-retry.json)

## Main Steps

- ShowPageAction: show page WorkflowCommons.Workflow_ActionConfirmation show page WorkflowCommons.Workflow_ActionConfirmation

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.ACT_Workflow_Retry, WorkflowCommons.ACT_Workflow_Retry_KeepTargetedUsers, WorkflowCommons.ACT_Workflow_Retry_RerunUserTargeting.
- Output/UI context: Shows WorkflowCommons.Workflow_ActionConfirmation.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: WorkflowCommons.ACT_Workflow_Retry, WorkflowCommons.ACT_Workflow_Retry_KeepTargetedUsers, WorkflowCommons.ACT_Workflow_Retry_RerunUserTargeting

## Shown Pages

- WorkflowCommons.Workflow_ActionConfirmation

## Important Retrieves/Decisions/Mutations

- No retrieve, decision, or mutation metadata was exported for this flow; inspect L2 JSON if node-level evidence matters.

## Warnings/Unknowns

- Rollback hint detected in node detail.
- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflow-retry.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
