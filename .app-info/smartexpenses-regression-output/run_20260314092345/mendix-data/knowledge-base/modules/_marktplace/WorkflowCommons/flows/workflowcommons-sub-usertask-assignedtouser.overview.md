---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_UserTask_AssignedToUser
stableId: e5178cce-46ad-4eb3-a03f-3f52e56de83d
slug: workflowcommons-sub-usertask-assignedtouser
layer: L1
l0: workflowcommons-sub-usertask-assignedtouser.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertask-assignedtouser.json
l2Logical: flow:WorkflowCommons.SUB_UserTask_AssignedToUser
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_UserTask_AssignedToUser

## Summary

- Deterministic overview derived from exported flow structure.
- L0: [abstract](workflowcommons-sub-usertask-assignedtouser.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertask-assignedtouser.json)

## Main Steps

- retrieve UserTaskViewList from WorkflowCommons.UserTaskView

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; check L2 JSON if the exact user-facing effect matters.

## Key Entities Touched

- WorkflowCommons.UserTaskView

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it may serve validation, background processing, or delegate work to other flows.

## Important Retrieves/Decisions/Mutations

- nodeId=e45f1ae0-ea89-40b4-8f0e-d5360d05e62f; sourceKind=Database; entity=WorkflowCommons.UserTaskView; summary=retrieve UserTaskViewList from WorkflowCommons.UserTaskView

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertask-assignedtouser.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
