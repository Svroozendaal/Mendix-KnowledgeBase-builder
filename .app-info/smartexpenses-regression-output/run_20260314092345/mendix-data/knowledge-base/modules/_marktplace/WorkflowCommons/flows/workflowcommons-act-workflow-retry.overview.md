---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.ACT_Workflow_Retry
stableId: 7e3f91d2-0d2a-44ca-b8c9-1c292ed7e2f8
slug: workflowcommons-act-workflow-retry
layer: L1
l0: workflowcommons-act-workflow-retry.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-workflow-retry.json
l2Logical: flow:WorkflowCommons.ACT_Workflow_Retry
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.ACT_Workflow_Retry

## Summary

- Likely acts as a UI entry or navigation handler because it shows WorkflowCommons.Workflow_Retry_Options.
- L0: [abstract](workflowcommons-act-workflow-retry.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-workflow-retry.json)

## Main Steps

- retrieve WorkflowUserTaskList from System.WorkflowUserTask
- $Count > 0 User task exists with targeted user? expression=$Count > 0
- ShowPageAction: show page WorkflowCommons.Workflow_Retry_Options show page WorkflowCommons.Workflow_Retry_Options

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: Shows WorkflowCommons.Workflow_Retry_Options.

## Key Entities Touched

- System.WorkflowUserTask

## Called / Called By

- Calls: WorkflowCommons.SUB_Workflow_Retry
- Called by: none

## Shown Pages

- WorkflowCommons.Workflow_Retry_Options

## Important Retrieves/Decisions/Mutations

- nodeId=0be1f9dd-278c-4fc4-bcd9-44abc7db6b5c; sourceKind=Database; entity=System.WorkflowUserTask; summary=retrieve WorkflowUserTaskList from System.WorkflowUserTask
- nodeId=5d0723e5-6132-4d31-934c-ea4f2bdcc6b0; caption=User task exists with targeted user?; expression=$Count > 0 User task exists with targeted user? expression=$Count > 0

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-workflow-retry.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
