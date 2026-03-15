---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_TaskAssignmentHelper_Reassign
stableId: 877c975a-3316-49fc-8450-2ed11dd7a154
slug: workflowcommons-sub-taskassignmenthelper-reassign
layer: L1
l0: workflowcommons-sub-taskassignmenthelper-reassign.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-taskassignmenthelper-reassign.json
l2Logical: flow:WorkflowCommons.SUB_TaskAssignmentHelper_Reassign
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_TaskAssignmentHelper_Reassign

## Summary

- Likely orchestrates downstream flow calls without direct UI output.
- L0: [abstract](workflowcommons-sub-taskassignmenthelper-reassign.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-taskassignmenthelper-reassign.json)

## Main Steps

- retrieve AssignedUser over association TaskAssignmentHelper_Account from TaskAssignmentHelper
- retrieve WorkflowUserTaskList over association TaskAssignmentHelper_WorkflowUserTask from TaskAssignmentHelper
- $KeepAsTargetUser Keep as target user? expression=$KeepAsTargetUser

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.ACT_TaskAssignmentHelper_Reassign.
- Output/UI context: No page output was exported; this likely delegates work to downstream flows.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: WorkflowCommons.SUB_UserTask_Assignee_Add, WorkflowCommons.SUB_UserTask_Assignee_Remove, WorkflowCommons.SUB_UserTask_TargetUser_Remove
- Called by: WorkflowCommons.ACT_TaskAssignmentHelper_Reassign

## Shown Pages

- No ShowPageAction was exported for this flow; it may serve validation, background processing, or delegate work to other flows.

## Important Retrieves/Decisions/Mutations

- nodeId=6faffffa-eace-49b6-8af9-cb6e35b24972; sourceKind=Association; association=TaskAssignmentHelper_Account; summary=retrieve AssignedUser over association TaskAssignmentHelper_Account from TaskAssignmentHelper
- nodeId=f693ba5d-c181-434a-a7ff-a2e2fca42699; sourceKind=Association; association=TaskAssignmentHelper_WorkflowUserTask; summary=retrieve WorkflowUserTaskList over association TaskAssignmentHelper_WorkflowUserTask from TaskAssignmentHelper
- nodeId=59ed4db8-45f9-480e-8bf5-94159eaf1ba0; caption=Keep as target user?; expression=$KeepAsTargetUser Keep as target user? expression=$KeepAsTargetUser

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-taskassignmenthelper-reassign.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
