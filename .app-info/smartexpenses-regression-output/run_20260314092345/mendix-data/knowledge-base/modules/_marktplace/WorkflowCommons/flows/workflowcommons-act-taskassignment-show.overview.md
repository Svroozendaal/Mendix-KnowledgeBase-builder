---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.ACT_TaskAssignment_Show
stableId: 4c539bf1-0865-4359-8521-4c6a66c53be3
slug: workflowcommons-act-taskassignment-show
layer: L1
l0: workflowcommons-act-taskassignment-show.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-taskassignment-show.json
l2Logical: flow:WorkflowCommons.ACT_TaskAssignment_Show
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.ACT_TaskAssignment_Show

## Summary

- Likely acts as a UI entry or navigation handler because it shows WorkflowCommons.ManageTaskAssignments.
- L0: [abstract](workflowcommons-act-taskassignment-show.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-taskassignment-show.json)

## Main Steps

- ShowPageAction: show page WorkflowCommons.ManageTaskAssignments show page WorkflowCommons.ManageTaskAssignments
- CreateObjectAction: create WorkflowCommons.TaskAssignmentHelper as NewTaskAssignmentHelper create WorkflowCommons.TaskAssignmentHelper as NewTaskAssignmentHelper

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: Shows WorkflowCommons.ManageTaskAssignments.

## Key Entities Touched

- WorkflowCommons.TaskAssignmentHelper

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- WorkflowCommons.ManageTaskAssignments

## Important Retrieves/Decisions/Mutations

- nodeId=1daad260-327b-40b7-9b3c-ae8184275efe; actionKind=Create; entity=WorkflowCommons.TaskAssignmentHelper; summary=CreateObjectAction: create WorkflowCommons.TaskAssignmentHelper as NewTaskAssignmentHelper create WorkflowCommons.TaskAssignmentHelper as NewTaskAssignmentHelper

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-taskassignment-show.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
