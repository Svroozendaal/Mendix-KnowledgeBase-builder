---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_WorkflowTaskTimeline_Completed
stableId: 8b164c10-fb35-4d83-b7b4-7a4009640caa
slug: workflowcommons-sub-workflowtasktimeline-completed
layer: L1
l0: workflowcommons-sub-workflowtasktimeline-completed.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowtasktimeline-completed.json
l2Logical: flow:WorkflowCommons.SUB_WorkflowTaskTimeline_Completed
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_WorkflowTaskTimeline_Completed

## Summary

- Likely acts as a save, process, or background step for WorkflowCommons.UserTaskTimeLine because it mutates data without showing a page.
- L0: [abstract](workflowcommons-sub-workflowtasktimeline-completed.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowtasktimeline-completed.json)

## Main Steps

- retrieve UserTaskView over association UserTaskOutcomeView_UserTaskView from IteratorUserTaskOutcomeView
- ChangeListAction: change UserTaskTimeLineList (type=Add, value=$NewUserTaskTimeLine_1) change UserTaskTimeLineList (type=Add, value=$NewUserTaskTimeLine_1)
- CreateObjectAction: create WorkflowCommons.UserTaskTimeLine as NewUserTaskTimeLine_1 (TaskName=$UserTaskView/Name, CompletedOn=$IteratorUserTaskOutcomeView/Time, CompletionType=$UserTaskView/CompletionType, Outcome=$IteratorUserTaskOutcomeView/Outcome, State=$UserTaskView/State, StartedOn=$UserTaskView/StartTime) create WorkflowCommons.UserTaskTimeLine as NewUserTaskTimeLine_1 (TaskName=$UserTaskView/Name, CompletedOn=$IteratorUserTaskOutcomeView/Time, CompletionType=$UserTaskView/CompletionType, Outcome=$IteratorUserTaskOutcomeView/Outcome, State=$UserTaskView/State, StartedOn=$UserTaskView/StartTime)

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

- nodeId=ab7ba700-3eba-4bd6-a577-b6b1654e97bd; sourceKind=Association; association=UserTaskOutcomeView_UserTaskView; summary=retrieve UserTaskView over association UserTaskOutcomeView_UserTaskView from IteratorUserTaskOutcomeView
- nodeId=fe77f00a-9b43-4c02-93e6-092fe2d2c52b; actionKind=Change; members=type=Add, value=$NewUserTaskTimeLine_1; summary=ChangeListAction: change UserTaskTimeLineList (type=Add, value=$NewUserTaskTimeLine_1) change UserTaskTimeLineList (type=Add, value=$NewUserTaskTimeLine_1)
- nodeId=5f6f74bb-63ce-4f39-91ec-d4fd72f2b5da; actionKind=Create; entity=WorkflowCommons.UserTaskTimeLine; members=TaskName=$UserTaskView/Name, CompletedOn=$IteratorUserTaskOutcomeView/Time, CompletionType=$UserTaskView/CompletionType, Outcome=$IteratorUserTaskOutcomeView/Outcome, State=$UserTaskView/State, StartedOn=$UserTaskView/StartTime; summary=CreateObjectAction: create WorkflowCommons.UserTaskTimeLine as NewUserTaskTimeLine_1 (TaskName=$UserTaskView/Name, CompletedOn=$IteratorUserTaskOutcomeView/Time, CompletionType=$UserTaskView/CompletionType, Outcome=$IteratorUserTaskOutcomeView/Outcome, State=$UserTaskView/State, StartedOn=$UserTaskView/StartTime) create WorkflowCommons.UserTaskTimeLine as NewUserTaskTimeLine_1 (TaskName=$UserTaskView/Name, CompletedOn=$IteratorUserTaskOutcomeView/Time, CompletionType=$UserTaskView/CompletionType, Outcome=$IteratorUserTaskOutcomeView/Outcome, State=$UserTaskView/State, StartedOn=$UserTaskView/StartTime)

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowtasktimeline-completed.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
