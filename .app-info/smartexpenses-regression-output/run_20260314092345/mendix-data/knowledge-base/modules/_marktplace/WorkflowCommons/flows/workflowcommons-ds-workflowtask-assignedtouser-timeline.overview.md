---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.DS_WorkflowTask_AssignedToUser_Timeline
stableId: fe244430-e81b-4d4d-ba69-7b4d91ba3362
slug: workflowcommons-ds-workflowtask-assignedtouser-timeline
layer: L1
l0: workflowcommons-ds-workflowtask-assignedtouser-timeline.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ds-workflowtask-assignedtouser-timeline.json
l2Logical: flow:WorkflowCommons.DS_WorkflowTask_AssignedToUser_Timeline
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.DS_WorkflowTask_AssignedToUser_Timeline

## Summary

- Likely acts as a save, process, or background step for WorkflowCommons.UserTaskTimeLine because it mutates data without showing a page.
- L0: [abstract](workflowcommons-ds-workflowtask-assignedtouser-timeline.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ds-workflowtask-assignedtouser-timeline.json)

## Main Steps

- State change events are not triggered for individual outcomes. For tasks that are still in progress, a separate retrieve is necessary.

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- WorkflowCommons.UserTaskTimeLine

## Called / Called By

- Calls: WorkflowCommons.DashboardContext_GetSelectedWorkflowDefinition, WorkflowCommons.DashboardContext_GetSelectedWorkflowTaskDefinition, WorkflowCommons.SUB_UserTaskOutcome_AssignedToUser, WorkflowCommons.SUB_UserTaskOutcomeView_AssignedToUser, WorkflowCommons.SUB_WorkflowTaskTimeline_Completed, WorkflowCommons.SUB_WorkflowTaskTimeline_InProgress
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=66b8f6b2-67e3-4733-a70c-ea1849c1b2df; sourceKind=Unknown; summary=State change events are not triggered for individual outcomes. For tasks that are still in progress, a separate retrieve is necessary.
- nodeId=66b8f6b2-67e3-4733-a70c-ea1849c1b2df; actionKind=Change; summary=State change events are not triggered for individual outcomes. For tasks that are still in progress, a separate retrieve is necessary.

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ds-workflowtask-assignedtouser-timeline.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
