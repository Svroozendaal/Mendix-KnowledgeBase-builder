---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.OCh_WorkflowUserTask_State
stableId: 7d50b8e5-dc90-4c2b-95eb-b81ce407e8f5
slug: workflowcommons-och-workflowusertask-state
layer: L1
l0: workflowcommons-och-workflowusertask-state.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-och-workflowusertask-state.json
l2Logical: flow:WorkflowCommons.OCh_WorkflowUserTask_State
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.OCh_WorkflowUserTask_State

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](workflowcommons-och-workflowusertask-state.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-och-workflowusertask-state.json)

## Main Steps

- retrieve WorkflowUserTaskOutcomeList over association WorkflowUserTaskOutcome_WorkflowUserTask from UserTask
- ChangeObjectAction: change UserTaskView (UserTaskView_TargetUsers=$UserTask/System.WorkflowUserTask_TargetUsers, UserTaskView_Assignees=$UserTask/System.WorkflowUserTask_Assignees, EndTime=$UserTask/EndTime, DueDate=$UserTask/DueDate, Outcome=$UserTask/Outcome, State=$UserTask/State, CompletionType=$UserTask/CompletionType; refreshInClient=true) change UserTaskView (UserTaskView_TargetUsers=$UserTask/System.WorkflowUserTask_TargetUsers, UserTaskView_Assignees=$UserTask/System.WorkflowUserTask_Assignees, EndTime=$UserTask/EndTime, DueDate=$UserTask/DueDate, Outcome=$UserTask/Outcome, State=$UserTask/State, CompletionType=$UserTask/CompletionType; refreshInClient=true)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: WorkflowCommons.SUB_UserTaskOutcomeView_FindOrCreate, WorkflowCommons.SUB_UserTaskView_FindOrCreate
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=d2687ce0-f021-4242-9114-dea930c2e2bc; sourceKind=Association; association=WorkflowUserTaskOutcome_WorkflowUserTask; summary=retrieve WorkflowUserTaskOutcomeList over association WorkflowUserTaskOutcome_WorkflowUserTask from UserTask
- nodeId=7c4b1884-13a0-442c-9243-c085c3ef8f6b; actionKind=Change; entity=System.WorkflowUserTask_TargetUsers; members=UserTaskView_TargetUsers=$UserTask/System.WorkflowUserTask_TargetUsers, UserTaskView_Assignees=$UserTask/System.WorkflowUserTask_Assignees, EndTime=$UserTask/EndTime, DueDate=$UserTask/DueDate, Outcome=$UserTask/Outcome, State=$UserTask/State, CompletionType=$UserTask/CompletionType; refreshInClient=true; summary=ChangeObjectAction: change UserTaskView (UserTaskView_TargetUsers=$UserTask/System.WorkflowUserTask_TargetUsers, UserTaskView_Assignees=$UserTask/System.WorkflowUserTask_Assignees, EndTime=$UserTask/EndTime, DueDate=$UserTask/DueDate, Outcome=$UserTask/Outcome, State=$UserTask/State, CompletionType=$UserTask/CompletionType; refreshInClient=true) change UserTaskView (UserTaskView_TargetUsers=$UserTask/System.WorkflowUserTask_TargetUsers, UserTaskView_Assignees=$UserTask/System.WorkflowUserTask_Assignees, EndTime=$UserTask/EndTime, DueDate=$UserTask/DueDate, Outcome=$UserTask/Outcome, State=$UserTask/State, CompletionType=$UserTask/CompletionType; refreshInClient=true)

## Warnings/Unknowns

- Rollback hint detected in node detail.
- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-och-workflowusertask-state.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
