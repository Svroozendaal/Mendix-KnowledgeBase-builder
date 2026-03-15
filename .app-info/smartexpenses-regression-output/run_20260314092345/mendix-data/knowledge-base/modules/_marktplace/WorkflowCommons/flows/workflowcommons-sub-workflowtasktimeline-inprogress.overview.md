---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_WorkflowTaskTimeline_InProgress
stableId: e65e5475-4fbf-45f7-99c1-2842aaae8e2d
slug: workflowcommons-sub-workflowtasktimeline-inprogress
layer: L1
l0: workflowcommons-sub-workflowtasktimeline-inprogress.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowtasktimeline-inprogress.json
l2Logical: flow:WorkflowCommons.SUB_WorkflowTaskTimeline_InProgress
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_WorkflowTaskTimeline_InProgress

## Summary

- Likely acts as a save, process, or background step for WorkflowCommons.UserTaskTimeLine because it mutates data without showing a page.
- L0: [abstract](workflowcommons-sub-workflowtasktimeline-inprogress.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowtasktimeline-inprogress.json)

## Main Steps

- retrieve WorkflowUserTask over association WorkflowUserTaskOutcome_WorkflowUserTask from IteratorUserTaskOutcome
- ChangeListAction: change UserTaskTimeLineList (type=Add, value=$NewUserTaskTimeLine) change UserTaskTimeLineList (type=Add, value=$NewUserTaskTimeLine)
- CreateObjectAction: create WorkflowCommons.UserTaskTimeLine as NewUserTaskTimeLine (TaskName=$WorkflowUserTask/Name, CompletedOn=$IteratorUserTaskOutcome/Time, CompletionType=$WorkflowUserTask/CompletionType, Outcome=$IteratorUserTaskOutcome/Outcome, State=$WorkflowUserTask/State, StartedOn=$WorkflowUserTask/StartTime) create WorkflowCommons.UserTaskTimeLine as NewUserTaskTimeLine (TaskName=$WorkflowUserTask/Name, CompletedOn=$IteratorUserTaskOutcome/Time, CompletionType=$WorkflowUserTask/CompletionType, Outcome=$IteratorUserTaskOutcome/Outcome, State=$WorkflowUserTask/State, StartedOn=$WorkflowUserTask/StartTime)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.DS_WorkflowTask_AssignedToUser_Timeline.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- WorkflowCommons.UserTaskTimeLine

## Called / Called By

- Calls: none
- Called by: WorkflowCommons.DS_WorkflowTask_AssignedToUser_Timeline

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=11184212-c4bb-4510-bc0a-cea11f8f520a; sourceKind=Association; association=WorkflowUserTaskOutcome_WorkflowUserTask; summary=retrieve WorkflowUserTask over association WorkflowUserTaskOutcome_WorkflowUserTask from IteratorUserTaskOutcome
- nodeId=7fd65a8d-6fb7-4364-950f-152f54cd19f8; actionKind=Change; members=type=Add, value=$NewUserTaskTimeLine; summary=ChangeListAction: change UserTaskTimeLineList (type=Add, value=$NewUserTaskTimeLine) change UserTaskTimeLineList (type=Add, value=$NewUserTaskTimeLine)
- nodeId=a1e9f125-75dc-4852-9975-68819397cc0e; actionKind=Create; entity=WorkflowCommons.UserTaskTimeLine; members=TaskName=$WorkflowUserTask/Name, CompletedOn=$IteratorUserTaskOutcome/Time, CompletionType=$WorkflowUserTask/CompletionType, Outcome=$IteratorUserTaskOutcome/Outcome, State=$WorkflowUserTask/State, StartedOn=$WorkflowUserTask/StartTime; summary=CreateObjectAction: create WorkflowCommons.UserTaskTimeLine as NewUserTaskTimeLine (TaskName=$WorkflowUserTask/Name, CompletedOn=$IteratorUserTaskOutcome/Time, CompletionType=$WorkflowUserTask/CompletionType, Outcome=$IteratorUserTaskOutcome/Outcome, State=$WorkflowUserTask/State, StartedOn=$WorkflowUserTask/StartTime) create WorkflowCommons.UserTaskTimeLine as NewUserTaskTimeLine (TaskName=$WorkflowUserTask/Name, CompletedOn=$IteratorUserTaskOutcome/Time, CompletionType=$WorkflowUserTask/CompletionType, Outcome=$IteratorUserTaskOutcome/Outcome, State=$WorkflowUserTask/State, StartedOn=$WorkflowUserTask/StartTime)

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowtasktimeline-inprogress.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
