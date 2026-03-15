---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_UserTaskOutcomeView_AssignedToUser
stableId: 68255f32-97f8-4d7b-aaf6-40c48fff2f81
slug: workflowcommons-sub-usertaskoutcomeview-assignedtouser
layer: L1
l0: workflowcommons-sub-usertaskoutcomeview-assignedtouser.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertaskoutcomeview-assignedtouser.json
l2Logical: flow:WorkflowCommons.SUB_UserTaskOutcomeView_AssignedToUser
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_UserTaskOutcomeView_AssignedToUser

## Summary

- Likely serves as a helper flow invoked from WorkflowCommons.DS_WorkflowTask_AssignedToUser_Timeline.
- L0: [abstract](workflowcommons-sub-usertaskoutcomeview-assignedtouser.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertaskoutcomeview-assignedtouser.json)

## Main Steps

- retrieve UserTaskOutcomeViewList from WorkflowCommons.UserTaskOutcomeView

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.DS_WorkflowTask_AssignedToUser_Timeline.
- Output/UI context: No page output was exported; check L2 JSON if the exact user-facing effect matters.

## Key Entities Touched

- WorkflowCommons.UserTaskOutcomeView

## Called / Called By

- Calls: none
- Called by: WorkflowCommons.DS_WorkflowTask_AssignedToUser_Timeline

## Shown Pages

- No ShowPageAction was exported for this flow; it may serve validation, background processing, or delegate work to other flows.

## Important Retrieves/Decisions/Mutations

- nodeId=b6a061c1-0502-498e-a13d-79bf71e91239; sourceKind=Database; entity=WorkflowCommons.UserTaskOutcomeView; summary=retrieve UserTaskOutcomeViewList from WorkflowCommons.UserTaskOutcomeView

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertaskoutcomeview-assignedtouser.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
