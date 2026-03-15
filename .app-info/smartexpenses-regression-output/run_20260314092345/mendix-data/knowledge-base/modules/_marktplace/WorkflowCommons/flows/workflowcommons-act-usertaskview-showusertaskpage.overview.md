---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.ACT_UserTaskView_ShowUserTaskPage
stableId: 0be38b97-3e8f-4310-b116-b5a9c208af0e
slug: workflowcommons-act-usertaskview-showusertaskpage
layer: L1
l0: workflowcommons-act-usertaskview-showusertaskpage.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-usertaskview-showusertaskpage.json
l2Logical: flow:WorkflowCommons.ACT_UserTaskView_ShowUserTaskPage
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.ACT_UserTaskView_ShowUserTaskPage

## Summary

- Likely acts as a UI entry or navigation handler because it shows WorkflowCommons.CompletedUserTaskView.
- L0: [abstract](workflowcommons-act-usertaskview-showusertaskpage.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-usertaskview-showusertaskpage.json)

## Main Steps

- retrieve WorkflowUserTask over association UserTaskView_WorkflowUserTask from UserTaskView
- $UserTaskView/State != System.WorkflowUserTaskState.Completed Not completed? expression=$UserTaskView/State != System.WorkflowUserTaskState.Completed
- ShowPageAction: show page WorkflowCommons.CompletedUserTaskView show page WorkflowCommons.CompletedUserTaskView

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: Shows WorkflowCommons.CompletedUserTaskView.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- WorkflowCommons.CompletedUserTaskView

## Important Retrieves/Decisions/Mutations

- nodeId=49ee5199-e210-4191-902a-1b2d320a8934; sourceKind=Association; association=UserTaskView_WorkflowUserTask; summary=retrieve WorkflowUserTask over association UserTaskView_WorkflowUserTask from UserTaskView
- nodeId=c8b8619d-f2b5-49e2-bfe3-00b7049114ff; caption=Not completed?; expression=$UserTaskView/State != System.WorkflowUserTaskState.Completed Not completed? expression=$UserTaskView/State != System.WorkflowUserTaskState.Completed

## Warnings/Unknowns

- Rollback hint detected in node detail.
- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-usertaskview-showusertaskpage.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
