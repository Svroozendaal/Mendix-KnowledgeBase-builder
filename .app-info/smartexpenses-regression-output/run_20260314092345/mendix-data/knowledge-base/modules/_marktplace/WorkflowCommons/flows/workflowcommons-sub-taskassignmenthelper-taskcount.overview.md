---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_TaskAssignmentHelper_TaskCount
stableId: 8f0693e0-deb5-4ec1-9174-467539c4006f
slug: workflowcommons-sub-taskassignmenthelper-taskcount
layer: L1
l0: workflowcommons-sub-taskassignmenthelper-taskcount.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-taskassignmenthelper-taskcount.json
l2Logical: flow:WorkflowCommons.SUB_TaskAssignmentHelper_TaskCount
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_TaskAssignmentHelper_TaskCount

## Summary

- Likely serves as a helper flow invoked from WorkflowCommons.ACT_TaskAssignmentHelper_Reassign, WorkflowCommons.ACT_TaskAssignmentHelper_Retarget, WorkflowCommons.ACT_TaskAssignmentHelper_Unassign.
- L0: [abstract](workflowcommons-sub-taskassignmenthelper-taskcount.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-taskassignmenthelper-taskcount.json)

## Main Steps

- retrieve WorkflowUserTaskList over association TaskAssignmentHelper_WorkflowUserTask from TaskAssignmentHelper

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.ACT_TaskAssignmentHelper_Reassign, WorkflowCommons.ACT_TaskAssignmentHelper_Retarget, WorkflowCommons.ACT_TaskAssignmentHelper_Unassign.
- Output/UI context: No page output was exported; check L2 JSON if the exact user-facing effect matters.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: WorkflowCommons.ACT_TaskAssignmentHelper_Reassign, WorkflowCommons.ACT_TaskAssignmentHelper_Retarget, WorkflowCommons.ACT_TaskAssignmentHelper_Unassign

## Shown Pages

- No ShowPageAction was exported for this flow; it may serve validation, background processing, or delegate work to other flows.

## Important Retrieves/Decisions/Mutations

- nodeId=eda8c3f2-f5c5-49bb-bab6-94f94c1b15a5; sourceKind=Association; association=TaskAssignmentHelper_WorkflowUserTask; summary=retrieve WorkflowUserTaskList over association TaskAssignmentHelper_WorkflowUserTask from TaskAssignmentHelper

## Warnings/Unknowns

- Rollback hint detected in node detail.
- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-taskassignmenthelper-taskcount.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
