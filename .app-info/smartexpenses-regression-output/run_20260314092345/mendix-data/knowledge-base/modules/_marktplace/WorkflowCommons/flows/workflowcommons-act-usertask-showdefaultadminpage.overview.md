---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.ACT_UserTask_ShowDefaultAdminPage
stableId: 2f524bb2-2c66-40c1-8957-41ef48012f2c
slug: workflowcommons-act-usertask-showdefaultadminpage
layer: L1
l0: workflowcommons-act-usertask-showdefaultadminpage.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-usertask-showdefaultadminpage.json
l2Logical: flow:WorkflowCommons.ACT_UserTask_ShowDefaultAdminPage
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.ACT_UserTask_ShowDefaultAdminPage

## Summary

- Likely acts as a UI entry or navigation handler because it shows WorkflowCommons.DefaultWorkflowAdmin.
- L0: [abstract](workflowcommons-act-usertask-showdefaultadminpage.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-usertask-showdefaultadminpage.json)

## Main Steps

- retrieve Workflow over association WorkflowUserTask_Workflow from WorkflowUserTask
- ShowPageAction: show page WorkflowCommons.DefaultWorkflowAdmin show page WorkflowCommons.DefaultWorkflowAdmin

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: Shows WorkflowCommons.DefaultWorkflowAdmin.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- WorkflowCommons.DefaultWorkflowAdmin

## Important Retrieves/Decisions/Mutations

- nodeId=1df2eb99-d736-4af8-a3da-3f73804fffd5; sourceKind=Association; association=WorkflowUserTask_Workflow; summary=retrieve Workflow over association WorkflowUserTask_Workflow from WorkflowUserTask

## Warnings/Unknowns

- Rollback hint detected in node detail.
- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-usertask-showdefaultadminpage.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
