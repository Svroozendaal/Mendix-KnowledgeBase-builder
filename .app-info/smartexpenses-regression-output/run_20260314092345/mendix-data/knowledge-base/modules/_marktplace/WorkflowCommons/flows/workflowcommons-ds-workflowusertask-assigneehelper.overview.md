---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.DS_WorkflowUserTask_AssigneeHelper
stableId: e5cc3521-9d27-4a78-830a-7c63f7016535
slug: workflowcommons-ds-workflowusertask-assigneehelper
layer: L1
l0: workflowcommons-ds-workflowusertask-assigneehelper.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ds-workflowusertask-assigneehelper.json
l2Logical: flow:WorkflowCommons.DS_WorkflowUserTask_AssigneeHelper
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.DS_WorkflowUserTask_AssigneeHelper

## Summary

- Likely acts as a save, process, or background step for WorkflowCommons.AssignmentHelper because it mutates data without showing a page.
- L0: [abstract](workflowcommons-ds-workflowusertask-assigneehelper.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ds-workflowusertask-assigneehelper.json)

## Main Steps

- retrieve AssignedUserList over association WorkflowUserTask_Assignees from WorkflowUserTask
- CreateObjectAction: create WorkflowCommons.AssignmentHelper as NewAssignmentHelper (IsAssignedUser=$CurrentUserAssignee != empty) create WorkflowCommons.AssignmentHelper as NewAssignmentHelper (IsAssignedUser=$CurrentUserAssignee != empty)

## Trigger/Input/Output Context

- Kind: Nanoflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- WorkflowCommons.AssignmentHelper

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=4beb15a0-b439-4679-b74c-646fa38b51e3; sourceKind=Association; association=WorkflowUserTask_Assignees; summary=retrieve AssignedUserList over association WorkflowUserTask_Assignees from WorkflowUserTask
- nodeId=01cc0ca6-67b1-4d54-b93b-4a58d39479f3; actionKind=Create; entity=WorkflowCommons.AssignmentHelper; members=IsAssignedUser=$CurrentUserAssignee != empty; summary=CreateObjectAction: create WorkflowCommons.AssignmentHelper as NewAssignmentHelper (IsAssignedUser=$CurrentUserAssignee != empty) create WorkflowCommons.AssignmentHelper as NewAssignmentHelper (IsAssignedUser=$CurrentUserAssignee != empty)

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ds-workflowusertask-assigneehelper.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
