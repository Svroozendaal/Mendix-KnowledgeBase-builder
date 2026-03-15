---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_WorkflowView_FindOrCreate
stableId: ac3ca60e-f5d2-4f1a-84a2-cd4d7f7f0e5f
slug: workflowcommons-sub-workflowview-findorcreate
layer: L1
l0: workflowcommons-sub-workflowview-findorcreate.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowview-findorcreate.json
l2Logical: flow:WorkflowCommons.SUB_WorkflowView_FindOrCreate
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_WorkflowView_FindOrCreate

## Summary

- Likely acts as a save, process, or background step for WorkflowCommons.WorkflowView because it mutates data without showing a page.
- L0: [abstract](workflowcommons-sub-workflowview-findorcreate.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowview-findorcreate.json)

## Main Steps

- retrieve WorkflowView from WorkflowCommons.WorkflowView
- $WorkflowView != empty Exists? expression=$WorkflowView != empty
- CreateObjectAction: create WorkflowCommons.WorkflowView as NewWorkflowView (WorkflowView_Workflow=$Workflow, WorkflowView_WorkflowDefinition=$Workflow/System.Workflow_WorkflowDefinition, WorkflowView_Initiator=$Workflow/System.owner, WorkflowKey=$WorkflowKey, Name=$Workflow/Name, Description=$Workflow/Description, StartTime=$Workflow/StartTime, EndTime=$Workflow/EndTime, +3 more) create WorkflowCommons.WorkflowView as NewWorkflowView (WorkflowView_Workflow=$Workflow, WorkflowView_WorkflowDefinition=$Workflow/System.Workflow_WorkflowDefinition, WorkflowView_Initiator=$Workflow/System.owner, WorkflowKey=$WorkflowKey, Name=$Workflow/Name, Description=$Workflow/Description, StartTime=$Workflow/StartTime, EndTime=$Workflow/EndTime, +3 more)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.DS_Workflow_WorkflowView, WorkflowCommons.DS_WorkflowUserTask_WorkflowView, WorkflowCommons.OCh_Workflow_State.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- WorkflowCommons.WorkflowView

## Called / Called By

- Calls: none
- Called by: WorkflowCommons.DS_Workflow_WorkflowView, WorkflowCommons.DS_WorkflowUserTask_WorkflowView, WorkflowCommons.OCh_Workflow_State

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=0902e85d-3657-4e23-addd-716a8bde4172; sourceKind=Database; entity=WorkflowCommons.WorkflowView; summary=retrieve WorkflowView from WorkflowCommons.WorkflowView
- nodeId=2be73e8b-9f82-44df-b742-297c640fdab9; caption=Exists?; expression=$WorkflowView != empty Exists? expression=$WorkflowView != empty
- nodeId=1d58c2a5-da29-4ee3-924c-8d0cf1200f47; actionKind=Create; entity=WorkflowCommons.WorkflowView; members=WorkflowView_Workflow=$Workflow, WorkflowView_WorkflowDefinition=$Workflow/System.Workflow_WorkflowDefinition, WorkflowView_Initiator=$Workflow/System.owner, WorkflowKey=$WorkflowKey, Name=$Workflow/Name, Description=$Workflow/Description, StartTime=$Workflow/StartTime, EndTime=$Workflow/EndTime, +3 more; summary=CreateObjectAction: create WorkflowCommons.WorkflowView as NewWorkflowView (WorkflowView_Workflow=$Workflow, WorkflowView_WorkflowDefinition=$Workflow/System.Workflow_WorkflowDefinition, WorkflowView_Initiator=$Workflow/System.owner, WorkflowKey=$WorkflowKey, Name=$Workflow/Name, Description=$Workflow/Description, StartTime=$Workflow/StartTime, EndTime=$Workflow/EndTime, +3 more) create WorkflowCommons.WorkflowView as NewWorkflowView (WorkflowView_Workflow=$Workflow, WorkflowView_WorkflowDefinition=$Workflow/System.Workflow_WorkflowDefinition, WorkflowView_Initiator=$Workflow/System.owner, WorkflowKey=$WorkflowKey, Name=$Workflow/Name, Description=$Workflow/Description, StartTime=$Workflow/StartTime, EndTime=$Workflow/EndTime, +3 more)

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowview-findorcreate.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
