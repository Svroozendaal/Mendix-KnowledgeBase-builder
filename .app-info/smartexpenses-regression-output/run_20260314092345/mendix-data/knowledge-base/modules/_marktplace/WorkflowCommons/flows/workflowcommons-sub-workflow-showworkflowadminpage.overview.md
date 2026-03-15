---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_Workflow_ShowWorkflowAdminPage
stableId: 46a524c8-8790-4f2a-a16d-025651432492
slug: workflowcommons-sub-workflow-showworkflowadminpage
layer: L1
l0: workflowcommons-sub-workflow-showworkflowadminpage.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflow-showworkflowadminpage.json
l2Logical: flow:WorkflowCommons.SUB_Workflow_ShowWorkflowAdminPage
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_Workflow_ShowWorkflowAdminPage

## Summary

- Likely acts as a UI entry or navigation handler because it shows WorkflowCommons.DefaultWorkflowAdmin.
- L0: [abstract](workflowcommons-sub-workflow-showworkflowadminpage.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflow-showworkflowadminpage.json)

## Main Steps

- ShowPageAction: show page WorkflowCommons.DefaultWorkflowAdmin show page WorkflowCommons.DefaultWorkflowAdmin

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.ACT_Workflow_OpenParentWorkflow, WorkflowCommons.SUB_WorkflowView_ShowWorkflowAdminPage.
- Output/UI context: Shows WorkflowCommons.DefaultWorkflowAdmin.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: WorkflowCommons.ACT_Workflow_OpenParentWorkflow, WorkflowCommons.SUB_WorkflowView_ShowWorkflowAdminPage

## Shown Pages

- WorkflowCommons.DefaultWorkflowAdmin

## Important Retrieves/Decisions/Mutations

- No retrieve, decision, or mutation metadata was exported for this flow; inspect L2 JSON if node-level evidence matters.

## Warnings/Unknowns

- Rollback hint detected in node detail.
- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflow-showworkflowadminpage.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
