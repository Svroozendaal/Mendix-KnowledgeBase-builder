---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_UserTaskOutcome_AssignedToUser
stableId: 5930be0d-dbe6-462d-b055-0a080de8cda8
slug: workflowcommons-sub-usertaskoutcome-assignedtouser
layer: L1
l0: workflowcommons-sub-usertaskoutcome-assignedtouser.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertaskoutcome-assignedtouser.json
l2Logical: flow:WorkflowCommons.SUB_UserTaskOutcome_AssignedToUser
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_UserTaskOutcome_AssignedToUser

## Summary

- Likely serves as a helper flow invoked from WorkflowCommons.DS_WorkflowTask_AssignedToUser_Timeline.
- L0: [abstract](workflowcommons-sub-usertaskoutcome-assignedtouser.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertaskoutcome-assignedtouser.json)

## Main Steps

- retrieve UserTaskOutcomeList from System.WorkflowUserTaskOutcome

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.DS_WorkflowTask_AssignedToUser_Timeline.
- Output/UI context: No page output was exported; check L2 JSON if the exact user-facing effect matters.

## Key Entities Touched

- System.WorkflowUserTaskOutcome

## Called / Called By

- Calls: none
- Called by: WorkflowCommons.DS_WorkflowTask_AssignedToUser_Timeline

## Shown Pages

- No ShowPageAction was exported for this flow; it may serve validation, background processing, or delegate work to other flows.

## Important Retrieves/Decisions/Mutations

- nodeId=1ee245a5-1c3e-468d-beb2-5b42121397c5; sourceKind=Database; entity=System.WorkflowUserTaskOutcome; summary=retrieve UserTaskOutcomeList from System.WorkflowUserTaskOutcome

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertaskoutcome-assignedtouser.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
