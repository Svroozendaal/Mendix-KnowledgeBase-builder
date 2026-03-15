---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_WorkflowSummary_CreateOrUpdate
stableId: 5a08ca95-1329-4418-89b8-d58a4ec39a30
slug: workflowcommons-sub-workflowsummary-createorupdate
layer: L1
l0: workflowcommons-sub-workflowsummary-createorupdate.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowsummary-createorupdate.json
l2Logical: flow:WorkflowCommons.SUB_WorkflowSummary_CreateOrUpdate
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_WorkflowSummary_CreateOrUpdate

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](workflowcommons-sub-workflowsummary-createorupdate.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowsummary-createorupdate.json)

## Main Steps

- ChangeObjectAction: change WorkflowSummary (NumberOfWorkflowsInProgress=$Workflow_CountInProgress, NumberOfWorkflowOverdue=$Workflow_CountOverdue, NumberOfWorkflowAlmostDue=$Workflow_CountAlmostDue, NumberOfWorkflowsCompleted=$Workflow_CountCompleted, DashboardContext_WorkflowSummary=$DashboardContext, WorkflowSummary_WorkflowDefinition=$WorkflowDefinition_Selected, IsLocked=if ($WorkflowDefinition_Selected != empty) then $WorkflowDefinition_Selected/IsLocked else false, IsObsolete=if ($WorkflowDefinition_Selected != empty) then $WorkflowDefinition_Selected/IsObsolete else false; refreshInClient=false) change WorkflowSummary (NumberOfWorkflowsInProgress=$Workflow_CountInProgress, NumberOfWorkflowOverdue=$Workflow_CountOverdue, NumberOfWorkflowAlmostDue=$Workflow_CountAlmostDue, NumberOfWorkflowsCompleted=$Workflow_CountCompleted, DashboardContext_WorkflowSummary=$DashboardContext, WorkflowSummary_WorkflowDefinition=$WorkflowDefinition_Selected, IsLocked=if ($WorkflowDefinition_Selected != empty) then $WorkflowDefinition_Selected/IsLocked else false, IsObsolete=if ($WorkflowDefinition_Selected != empty) then $WorkflowDefinition_Selected/IsObsolete else false; refreshInClient=false)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.DS_WorkflowDefinition_Overview, WorkflowCommons.SUB_WorkflowDashboard_Update.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: WorkflowCommons.SUB_Workflow_CountAlmostDue, WorkflowCommons.SUB_Workflow_CountCompleted, WorkflowCommons.SUB_Workflow_CountInProgress, WorkflowCommons.SUB_Workflow_CountOverdue, WorkflowCommons.SUB_WorkflowSummary_RetrieveOrCreate
- Called by: WorkflowCommons.DS_WorkflowDefinition_Overview, WorkflowCommons.SUB_WorkflowDashboard_Update

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=cf03e5ab-37d6-4162-8608-dcc05e17ac18; actionKind=Change; members=NumberOfWorkflowsInProgress=$Workflow_CountInProgress, NumberOfWorkflowOverdue=$Workflow_CountOverdue, NumberOfWorkflowAlmostDue=$Workflow_CountAlmostDue, NumberOfWorkflowsCompleted=$Workflow_CountCompleted, DashboardContext_WorkflowSummary=$DashboardContext, WorkflowSummary_WorkflowDefinition=$WorkflowDefinition_Selected, IsLocked=if ($WorkflowDefinition_Selected != empty; summary=ChangeObjectAction: change WorkflowSummary (NumberOfWorkflowsInProgress=$Workflow_CountInProgress, NumberOfWorkflowOverdue=$Workflow_CountOverdue, NumberOfWorkflowAlmostDue=$Workflow_CountAlmostDue, NumberOfWorkflowsCompleted=$Workflow_CountCompleted, DashboardContext_WorkflowSummary=$DashboardContext, WorkflowSummary_WorkflowDefinition=$WorkflowDefinition_Selected, IsLocked=if ($WorkflowDefinition_Selected != empty) then $WorkflowDefinition_Selected/IsLocked else false, IsObsolete=if ($WorkflowDefinition_Selected != empty) then $WorkflowDefinition_Selected/IsObsolete else false; refreshInClient=false) change WorkflowSummary (NumberOfWorkflowsInProgress=$Workflow_CountInProgress, NumberOfWorkflowOverdue=$Workflow_CountOverdue, NumberOfWorkflowAlmostDue=$Workflow_CountAlmostDue, NumberOfWorkflowsCompleted=$Workflow_CountCompleted, DashboardContext_WorkflowSummary=$DashboardContext, WorkflowSummary_WorkflowDefinition=$WorkflowDefinition_Selected, IsLocked=if ($WorkflowDefinition_Selected != empty) then $WorkflowDefinition_Selected/IsLocked else false, IsObsolete=if ($WorkflowDefinition_Selected != empty) then $WorkflowDefinition_Selected/IsObsolete else false; refreshInClient=false)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowsummary-createorupdate.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
