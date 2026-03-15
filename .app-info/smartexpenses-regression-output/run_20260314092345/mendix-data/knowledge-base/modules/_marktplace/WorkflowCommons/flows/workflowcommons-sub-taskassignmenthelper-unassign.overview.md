---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_TaskAssignmentHelper_Unassign
stableId: a97b7484-c6ff-4ee8-959f-ba4d1ad71aea
slug: workflowcommons-sub-taskassignmenthelper-unassign
layer: L1
l0: workflowcommons-sub-taskassignmenthelper-unassign.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-taskassignmenthelper-unassign.json
l2Logical: flow:WorkflowCommons.SUB_TaskAssignmentHelper_Unassign
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_TaskAssignmentHelper_Unassign

## Summary

- Likely orchestrates downstream flow calls without direct UI output.
- L0: [abstract](workflowcommons-sub-taskassignmenthelper-unassign.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-taskassignmenthelper-unassign.json)

## Main Steps

- retrieve AssignedUser over association TaskAssignmentHelper_Account from TaskAssignmentHelper
- retrieve WorkflowUserTaskList over association TaskAssignmentHelper_WorkflowUserTask from TaskAssignmentHelper
- $KeepAsTargetUser Keep as target user? expression=$KeepAsTargetUser

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.ACT_TaskAssignmentHelper_Unassign.
- Output/UI context: No page output was exported; this likely delegates work to downstream flows.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: WorkflowCommons.SUB_UserTask_Assignee_Remove, WorkflowCommons.SUB_UserTask_TargetUser_Remove
- Called by: WorkflowCommons.ACT_TaskAssignmentHelper_Unassign

## Shown Pages

- No ShowPageAction was exported for this flow; it may serve validation, background processing, or delegate work to other flows.

## Important Retrieves/Decisions/Mutations

- nodeId=4760fc93-e37b-419c-9af2-de646971fb44; sourceKind=Association; association=TaskAssignmentHelper_Account; summary=retrieve AssignedUser over association TaskAssignmentHelper_Account from TaskAssignmentHelper
- nodeId=df0b3301-7d51-42bd-8ec5-8c3b5ccd2b86; sourceKind=Association; association=TaskAssignmentHelper_WorkflowUserTask; summary=retrieve WorkflowUserTaskList over association TaskAssignmentHelper_WorkflowUserTask from TaskAssignmentHelper
- nodeId=2511f84b-1439-4d70-91d5-582087079a49; caption=Keep as target user?; expression=$KeepAsTargetUser Keep as target user? expression=$KeepAsTargetUser

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-taskassignmenthelper-unassign.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
