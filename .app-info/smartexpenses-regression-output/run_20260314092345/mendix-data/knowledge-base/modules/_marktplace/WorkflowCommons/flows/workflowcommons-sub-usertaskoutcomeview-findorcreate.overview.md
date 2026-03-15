---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_UserTaskOutcomeView_FindOrCreate
stableId: 986d6d70-e6cf-447f-9605-170fb51f2d4d
slug: workflowcommons-sub-usertaskoutcomeview-findorcreate
layer: L1
l0: workflowcommons-sub-usertaskoutcomeview-findorcreate.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertaskoutcomeview-findorcreate.json
l2Logical: flow:WorkflowCommons.SUB_UserTaskOutcomeView_FindOrCreate
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_UserTaskOutcomeView_FindOrCreate

## Summary

- Likely acts as a save, process, or background step for WorkflowCommons.UserTaskOutcomeView because it mutates data without showing a page.
- L0: [abstract](workflowcommons-sub-usertaskoutcomeview-findorcreate.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertaskoutcomeview-findorcreate.json)

## Main Steps

- retrieve UserTaskOutcomeView from WorkflowCommons.UserTaskOutcomeView
- $UserTaskOutcomeView != empty Exists? expression=$UserTaskOutcomeView != empty
- CreateObjectAction: create WorkflowCommons.UserTaskOutcomeView as NewUserTaskOutcomeView (UserTaskOutcomeView_UserTaskView=$UserTaskView, UserTaskOutcomeView_WorkflowUserTaskOutcome=$WorkflowUserTaskOutcome, UserTaskOutcomeView_User=$WorkflowUserTaskOutcome/System.WorkflowUserTaskOutcome_User, Outcome=$WorkflowUserTaskOutcome/Outcome, Time=$WorkflowUserTaskOutcome/Time) create WorkflowCommons.UserTaskOutcomeView as NewUserTaskOutcomeView (UserTaskOutcomeView_UserTaskView=$UserTaskView, UserTaskOutcomeView_WorkflowUserTaskOutcome=$WorkflowUserTaskOutcome, UserTaskOutcomeView_User=$WorkflowUserTaskOutcome/System.WorkflowUserTaskOutcome_User, Outcome=$WorkflowUserTaskOutcome/Outcome, Time=$WorkflowUserTaskOutcome/Time)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.OCh_WorkflowUserTask_State.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- WorkflowCommons.UserTaskOutcomeView

## Called / Called By

- Calls: none
- Called by: WorkflowCommons.OCh_WorkflowUserTask_State

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=28d49cac-d766-4b13-a197-6c64a13df9e0; sourceKind=Database; entity=WorkflowCommons.UserTaskOutcomeView; summary=retrieve UserTaskOutcomeView from WorkflowCommons.UserTaskOutcomeView
- nodeId=83eb2934-468d-4ce2-a011-8ed00bfef5b0; caption=Exists?; expression=$UserTaskOutcomeView != empty Exists? expression=$UserTaskOutcomeView != empty
- nodeId=9b07fa49-5ad7-41c3-8901-3c9bf8496401; actionKind=Create; entity=WorkflowCommons.UserTaskOutcomeView; members=UserTaskOutcomeView_UserTaskView=$UserTaskView, UserTaskOutcomeView_WorkflowUserTaskOutcome=$WorkflowUserTaskOutcome, UserTaskOutcomeView_User=$WorkflowUserTaskOutcome/System.WorkflowUserTaskOutcome_User, Outcome=$WorkflowUserTaskOutcome/Outcome, Time=$WorkflowUserTaskOutcome/Time; summary=CreateObjectAction: create WorkflowCommons.UserTaskOutcomeView as NewUserTaskOutcomeView (UserTaskOutcomeView_UserTaskView=$UserTaskView, UserTaskOutcomeView_WorkflowUserTaskOutcome=$WorkflowUserTaskOutcome, UserTaskOutcomeView_User=$WorkflowUserTaskOutcome/System.WorkflowUserTaskOutcome_User, Outcome=$WorkflowUserTaskOutcome/Outcome, Time=$WorkflowUserTaskOutcome/Time) create WorkflowCommons.UserTaskOutcomeView as NewUserTaskOutcomeView (UserTaskOutcomeView_UserTaskView=$UserTaskView, UserTaskOutcomeView_WorkflowUserTaskOutcome=$WorkflowUserTaskOutcome, UserTaskOutcomeView_User=$WorkflowUserTaskOutcome/System.WorkflowUserTaskOutcome_User, Outcome=$WorkflowUserTaskOutcome/Outcome, Time=$WorkflowUserTaskOutcome/Time)

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertaskoutcomeview-findorcreate.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
