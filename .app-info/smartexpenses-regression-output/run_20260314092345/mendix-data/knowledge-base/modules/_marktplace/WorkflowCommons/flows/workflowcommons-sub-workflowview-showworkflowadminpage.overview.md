---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_WorkflowView_ShowWorkflowAdminPage
stableId: 8b6ed958-09f6-4050-a7b2-1675f966ee05
slug: workflowcommons-sub-workflowview-showworkflowadminpage
layer: L1
l0: workflowcommons-sub-workflowview-showworkflowadminpage.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowview-showworkflowadminpage.json
l2Logical: flow:WorkflowCommons.SUB_WorkflowView_ShowWorkflowAdminPage
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_WorkflowView_ShowWorkflowAdminPage

## Summary

- Likely acts as a UI entry or navigation handler because it shows WorkflowCommons.CompletedWorkflowView.
- L0: [abstract](workflowcommons-sub-workflowview-showworkflowadminpage.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowview-showworkflowadminpage.json)

## Main Steps

- retrieve Workflow over association WorkflowView_Workflow from WorkflowView
- $WorkflowView/State != System.WorkflowState.Completed Not completed? expression=$WorkflowView/State != System.WorkflowState.Completed
- ShowPageAction: show page WorkflowCommons.CompletedWorkflowView show page WorkflowCommons.CompletedWorkflowView

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.ACT_UserTaskView_ShowWorkflowAdminPage, WorkflowCommons.ACT_WorkflowView_ShowWorkflowAdminPage.
- Output/UI context: Shows WorkflowCommons.CompletedWorkflowView.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: WorkflowCommons.SUB_Workflow_ShowWorkflowAdminPage
- Called by: WorkflowCommons.ACT_UserTaskView_ShowWorkflowAdminPage, WorkflowCommons.ACT_WorkflowView_ShowWorkflowAdminPage

## Shown Pages

- WorkflowCommons.CompletedWorkflowView

## Important Retrieves/Decisions/Mutations

- nodeId=a7b59ea8-0560-46a5-8f4e-582f9b1d6d7d; sourceKind=Association; association=WorkflowView_Workflow; summary=retrieve Workflow over association WorkflowView_Workflow from WorkflowView
- nodeId=be6b4e94-455f-4c19-93ac-d0055570d673; caption=Not completed?; expression=$WorkflowView/State != System.WorkflowState.Completed Not completed? expression=$WorkflowView/State != System.WorkflowState.Completed

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowview-showworkflowadminpage.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
