---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_Workflow_CountOverdue
stableId: ac755e1d-f19c-4f0c-a0eb-43387d44efa4
slug: workflowcommons-sub-workflow-countoverdue
layer: L1
l0: workflowcommons-sub-workflow-countoverdue.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflow-countoverdue.json
l2Logical: flow:WorkflowCommons.SUB_Workflow_CountOverdue
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_Workflow_CountOverdue

## Summary

- Likely acts as a save, process, or background step for System.Workflow, WorkflowCommons.WorkflowView because it mutates data without showing a page.
- L0: [abstract](workflowcommons-sub-workflow-countoverdue.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflow-countoverdue.json)

## Main Steps

- retrieve WorkflowView_Overdue from WorkflowCommons.WorkflowView
- retrieve Workflow_InProgress_Overdue from System.Workflow
- CreateVariableAction: create variable CountOverdueTotal=$CountOverdue + $CountInProgressOverdue create variable CountOverdueTotal=$CountOverdue + $CountInProgressOverdue
- CreateVariableAction: create variable IgnoreStartedAfter=$StartedAfter = empty create variable IgnoreStartedAfter=$StartedAfter = empty

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.SUB_WorkflowSummary_CreateOrUpdate.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- System.Workflow, WorkflowCommons.WorkflowView

## Called / Called By

- Calls: none
- Called by: WorkflowCommons.SUB_WorkflowSummary_CreateOrUpdate

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=a07d1907-62ad-44fc-a637-2f3951256620; sourceKind=Database; entity=WorkflowCommons.WorkflowView; summary=retrieve WorkflowView_Overdue from WorkflowCommons.WorkflowView
- nodeId=e95c9353-c33e-4605-bbfc-0307da4effcf; sourceKind=Database; entity=System.Workflow; summary=retrieve Workflow_InProgress_Overdue from System.Workflow
- nodeId=99f10e34-24d5-4a26-b7d9-bbfcc2446415; actionKind=Create; summary=CreateVariableAction: create variable CountOverdueTotal=$CountOverdue + $CountInProgressOverdue create variable CountOverdueTotal=$CountOverdue + $CountInProgressOverdue
- nodeId=b76af92b-74bc-42da-ac5e-43f71d5ec417; actionKind=Create; summary=CreateVariableAction: create variable IgnoreStartedAfter=$StartedAfter = empty create variable IgnoreStartedAfter=$StartedAfter = empty
- nodeId=98e3a167-10ad-45ea-be90-26ade7054c50; actionKind=Create; summary=CreateVariableAction: create variable IgnoreStartedBefore=$StartedBefore = empty create variable IgnoreStartedBefore=$StartedBefore = empty

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflow-countoverdue.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
