---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.ACT_Workflow_WithdrawConfirmation
stableId: 4dbe7b48-9603-439e-87d2-8b70e6fb2cce
slug: workflowcommons-act-workflow-withdrawconfirmation
layer: L1
l0: workflowcommons-act-workflow-withdrawconfirmation.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-workflow-withdrawconfirmation.json
l2Logical: flow:WorkflowCommons.ACT_Workflow_WithdrawConfirmation
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.ACT_Workflow_WithdrawConfirmation

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](workflowcommons-act-workflow-withdrawconfirmation.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-workflow-withdrawconfirmation.json)

## Main Steps

- retrieve Workflow over association WorkflowComment_Workflow from WorkflowComment
- retrieve WorkflowViewList over association WorkflowView_Workflow from Workflow
- $WorkflowComment/Content != empty and length(trim($WorkflowComment/Content)) > 0 Comment filled? expression=$WorkflowComment/Content != empty and length(trim($WorkflowComment/Content)) > 0
- $Workflow != empty Found? expression=$Workflow != empty
- ChangeObjectAction: change WorkflowView (State=$Workflow/State, Reason=$Workflow/Reason, EndTime=$Workflow/EndTime; refreshInClient=true) change WorkflowView (State=$Workflow/State, Reason=$Workflow/Reason, EndTime=$Workflow/EndTime; refreshInClient=true)
- CommitAction: commit WorkflowComment (refreshInClient=false, withEvents=true) commit WorkflowComment (refreshInClient=false, withEvents=true)

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

- nodeId=f022448b-f3ea-445c-9b6b-a82581c9cd06; sourceKind=Association; association=WorkflowComment_Workflow; summary=retrieve Workflow over association WorkflowComment_Workflow from WorkflowComment
- nodeId=081d17da-3bae-435e-97ca-fb1c44507dd4; sourceKind=Association; association=WorkflowView_Workflow; summary=retrieve WorkflowViewList over association WorkflowView_Workflow from Workflow
- nodeId=568945a0-4212-4048-9511-a42d7ecf5364; caption=Comment filled?; expression=$WorkflowComment/Content != empty and length(trim($WorkflowComment/Content)) > 0 Comment filled? expression=$WorkflowComment/Content != empty and length(trim($WorkflowComment/Content)) > 0
- nodeId=cc021a53-1eb6-4a18-988c-47fe1d86e56f; caption=Found?; expression=$Workflow != empty Found? expression=$Workflow != empty
- nodeId=ff42c042-7a2e-45dd-abef-7b20a264c4d6; caption=Found?; expression=$WorkflowView != empty Found? expression=$WorkflowView != empty
- nodeId=541d79aa-befe-4a00-a0ca-f990fbe3e34d; actionKind=Change; members=State=$Workflow/State, Reason=$Workflow/Reason, EndTime=$Workflow/EndTime; refreshInClient=true; summary=ChangeObjectAction: change WorkflowView (State=$Workflow/State, Reason=$Workflow/Reason, EndTime=$Workflow/EndTime; refreshInClient=true) change WorkflowView (State=$Workflow/State, Reason=$Workflow/Reason, EndTime=$Workflow/EndTime; refreshInClient=true)
- nodeId=f0ec8a31-23af-4ca0-9ea4-b6863feb8061; actionKind=Commit; members=refreshInClient=false, withEvents=true; summary=CommitAction: commit WorkflowComment (refreshInClient=false, withEvents=true) commit WorkflowComment (refreshInClient=false, withEvents=true)
- nodeId=57dcb30b-867a-44fb-9258-003efe94a487; actionKind=Change; summary=Force a refresh of the new workflow state, since the state change event is executed asynchronously.

## Warnings/Unknowns

- Rollback hint detected in node detail.
- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-workflow-withdrawconfirmation.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
