---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_TaskAssignmentHelper_Retarget
stableId: 9ed3319e-53d7-45da-98a6-3a0393e41e6f
slug: workflowcommons-sub-taskassignmenthelper-retarget
layer: L1
l0: workflowcommons-sub-taskassignmenthelper-retarget.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-taskassignmenthelper-retarget.json
l2Logical: flow:WorkflowCommons.SUB_TaskAssignmentHelper_Retarget
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_TaskAssignmentHelper_Retarget

## Summary

- Likely orchestrates downstream flow calls without direct UI output.
- L0: [abstract](workflowcommons-sub-taskassignmenthelper-retarget.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-taskassignmenthelper-retarget.json)

## Main Steps

- retrieve AssignedUser over association TaskAssignmentHelper_Account from TaskAssignmentHelper
- retrieve WorkflowUserTaskList over association TaskAssignmentHelper_WorkflowUserTask from TaskAssignmentHelper
- $KeepAsTargetUser Keep as target user? expression=$KeepAsTargetUser

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.ACT_TaskAssignmentHelper_Retarget.
- Output/UI context: No page output was exported; this likely delegates work to downstream flows.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: WorkflowCommons.SUB_UserTask_TargetUser_Add, WorkflowCommons.SUB_UserTask_TargetUser_Remove
- Called by: WorkflowCommons.ACT_TaskAssignmentHelper_Retarget

## Shown Pages

- No ShowPageAction was exported for this flow; it may serve validation, background processing, or delegate work to other flows.

## Important Retrieves/Decisions/Mutations

- nodeId=cd947887-c159-49b3-870a-dbc3fc2f8397; sourceKind=Association; association=TaskAssignmentHelper_Account; summary=retrieve AssignedUser over association TaskAssignmentHelper_Account from TaskAssignmentHelper
- nodeId=fd278d59-69ee-426c-ab03-01918fd9c5ef; sourceKind=Association; association=TaskAssignmentHelper_WorkflowUserTask; summary=retrieve WorkflowUserTaskList over association TaskAssignmentHelper_WorkflowUserTask from TaskAssignmentHelper
- nodeId=fc372905-56ed-4795-9435-507edfdbc05c; caption=Keep as target user?; expression=$KeepAsTargetUser Keep as target user? expression=$KeepAsTargetUser

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-taskassignmenthelper-retarget.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
