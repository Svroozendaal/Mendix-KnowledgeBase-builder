---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_UserTaskView_FindOrCreate
stableId: 6f3b8d9a-024f-4752-a20c-4a7f9393398b
slug: workflowcommons-sub-usertaskview-findorcreate
layer: L1
l0: workflowcommons-sub-usertaskview-findorcreate.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertaskview-findorcreate.json
l2Logical: flow:WorkflowCommons.SUB_UserTaskView_FindOrCreate
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_UserTaskView_FindOrCreate

## Summary

- Likely acts as a save, process, or background step for WorkflowCommons.UserTaskView, WorkflowCommons.WorkflowView because it mutates data without showing a page.
- L0: [abstract](workflowcommons-sub-usertaskview-findorcreate.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertaskview-findorcreate.json)

## Main Steps

- retrieve UserTaskView from WorkflowCommons.UserTaskView
- retrieve WorkflowView from WorkflowCommons.WorkflowView
- $UserTaskView != empty Exists? expression=$UserTaskView != empty
- CreateObjectAction: create WorkflowCommons.UserTaskView as NewUserTaskView (UserTaskView_WorkflowUserTask=$WorkflowUserTask, UserTaskView_WorkflowUserTaskDefinition=$WorkflowUserTask/System.WorkflowUserTask_WorkflowUserTaskDefinition, UserTaskView_TargetUsers=$WorkflowUserTask/System.WorkflowUserTask_TargetUsers, UserTaskView_Assignees=$WorkflowUserTask/System.WorkflowUserTask_Assignees, UserTaskView_WorkflowView=$WorkflowView, TaskKey=$TaskKey, Name=$WorkflowUserTask/Name, Description=$WorkflowUserTask/Description, +6 more) create WorkflowCommons.UserTaskView as NewUserTaskView (UserTaskView_WorkflowUserTask=$WorkflowUserTask, UserTaskView_WorkflowUserTaskDefinition=$WorkflowUserTask/System.WorkflowUserTask_WorkflowUserTaskDefinition, UserTaskView_TargetUsers=$WorkflowUserTask/System.WorkflowUserTask_TargetUsers, UserTaskView_Assignees=$WorkflowUserTask/System.WorkflowUserTask_Assignees, UserTaskView_WorkflowView=$WorkflowView, TaskKey=$TaskKey, Name=$WorkflowUserTask/Name, Description=$WorkflowUserTask/Description, +6 more)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.OCh_WorkflowUserTask_State.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- WorkflowCommons.UserTaskView, WorkflowCommons.WorkflowView

## Called / Called By

- Calls: none
- Called by: WorkflowCommons.OCh_WorkflowUserTask_State

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=829f824b-c417-4557-b52c-60937e8ca22d; sourceKind=Database; entity=WorkflowCommons.UserTaskView; summary=retrieve UserTaskView from WorkflowCommons.UserTaskView
- nodeId=426c0744-1209-4b13-97c5-82865fed064f; sourceKind=Database; entity=WorkflowCommons.WorkflowView; summary=retrieve WorkflowView from WorkflowCommons.WorkflowView
- nodeId=cb4c2db3-5b22-4362-a3c0-b599fd753393; caption=Exists?; expression=$UserTaskView != empty Exists? expression=$UserTaskView != empty
- nodeId=718b13a4-2577-47bc-b5cf-67a23b19055f; actionKind=Create; entity=WorkflowCommons.UserTaskView; members=UserTaskView_WorkflowUserTask=$WorkflowUserTask, UserTaskView_WorkflowUserTaskDefinition=$WorkflowUserTask/System.WorkflowUserTask_WorkflowUserTaskDefinition, UserTaskView_TargetUsers=$WorkflowUserTask/System.WorkflowUserTask_TargetUsers, UserTaskView_Assignees=$WorkflowUserTask/System.WorkflowUserTask_Assignees, UserTaskView_WorkflowView=$WorkflowView, TaskKey=$TaskKey, Name=$WorkflowUserTask/Name, Description=$WorkflowUserTask/Description, +6 more; summary=CreateObjectAction: create WorkflowCommons.UserTaskView as NewUserTaskView (UserTaskView_WorkflowUserTask=$WorkflowUserTask, UserTaskView_WorkflowUserTaskDefinition=$WorkflowUserTask/System.WorkflowUserTask_WorkflowUserTaskDefinition, UserTaskView_TargetUsers=$WorkflowUserTask/System.WorkflowUserTask_TargetUsers, UserTaskView_Assignees=$WorkflowUserTask/System.WorkflowUserTask_Assignees, UserTaskView_WorkflowView=$WorkflowView, TaskKey=$TaskKey, Name=$WorkflowUserTask/Name, Description=$WorkflowUserTask/Description, +6 more) create WorkflowCommons.UserTaskView as NewUserTaskView (UserTaskView_WorkflowUserTask=$WorkflowUserTask, UserTaskView_WorkflowUserTaskDefinition=$WorkflowUserTask/System.WorkflowUserTask_WorkflowUserTaskDefinition, UserTaskView_TargetUsers=$WorkflowUserTask/System.WorkflowUserTask_TargetUsers, UserTaskView_Assignees=$WorkflowUserTask/System.WorkflowUserTask_Assignees, UserTaskView_WorkflowView=$WorkflowView, TaskKey=$TaskKey, Name=$WorkflowUserTask/Name, Description=$WorkflowUserTask/Description, +6 more)

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertaskview-findorcreate.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
