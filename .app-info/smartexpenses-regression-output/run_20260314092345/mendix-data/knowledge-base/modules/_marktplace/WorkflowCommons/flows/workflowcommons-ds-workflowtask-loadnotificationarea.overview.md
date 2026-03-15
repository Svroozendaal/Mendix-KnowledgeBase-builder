---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.DS_WorkflowTask_LoadNotificationArea
stableId: 2cafb75e-2ca1-471f-92dd-24a43ef7921f
slug: workflowcommons-ds-workflowtask-loadnotificationarea
layer: L1
l0: workflowcommons-ds-workflowtask-loadnotificationarea.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ds-workflowtask-loadnotificationarea.json
l2Logical: flow:WorkflowCommons.DS_WorkflowTask_LoadNotificationArea
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.DS_WorkflowTask_LoadNotificationArea

## Summary

- Likely acts as a save, process, or background step for WorkflowCommons.NotificationArea because it mutates data without showing a page.
- L0: [abstract](workflowcommons-ds-workflowtask-loadnotificationarea.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ds-workflowtask-loadnotificationarea.json)

## Main Steps

- retrieve Workflow over association WorkflowUserTask_Workflow from WorkflowUserTask
- $Workflow/State = System.WorkflowState.Incompatible Incompatible? expression=$Workflow/State = System.WorkflowState.Incompatible
- $Workflow/State = System.WorkflowState.Paused Paused? expression=$Workflow/State = System.WorkflowState.Paused
- CreateObjectAction: create WorkflowCommons.NotificationArea as NewNotificationAreaBlockedTask (AlertTitle='Task is blocked', AlertMessage='This task cannot be completed as a result of changes in the workflow. Please contact your workflow administrator.', RenderAs=WorkflowCommons.Enum_NotificationArea_RenderAs.Error) create WorkflowCommons.NotificationArea as NewNotificationAreaBlockedTask (AlertTitle='Task is blocked', AlertMessage='This task cannot be completed as a result of changes in the workflow. Please contact your workflow administrator.', RenderAs=WorkflowCommons.Enum_NotificationArea_RenderAs.Error)
- CreateObjectAction: create WorkflowCommons.NotificationArea as NewNotificationAreaPaused (AlertTitle='Task is paused', AlertMessage='This workflow was paused by an administrator. Please contact your workflow administrator.', RenderAs=WorkflowCommons.Enum_NotificationArea_RenderAs.Warning) create WorkflowCommons.NotificationArea as NewNotificationAreaPaused (AlertTitle='Task is paused', AlertMessage='This workflow was paused by an administrator. Please contact your workflow administrator.', RenderAs=WorkflowCommons.Enum_NotificationArea_RenderAs.Warning)

## Trigger/Input/Output Context

- Kind: Nanoflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- WorkflowCommons.NotificationArea

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=1c447ef8-94ee-4b3a-b8b0-fc8b8395cbfc; sourceKind=Association; association=WorkflowUserTask_Workflow; summary=retrieve Workflow over association WorkflowUserTask_Workflow from WorkflowUserTask
- nodeId=53542488-fcd2-430e-b2d7-e7bd41846b4f; caption=Incompatible?; expression=$Workflow/State = System.WorkflowState.Incompatible Incompatible? expression=$Workflow/State = System.WorkflowState.Incompatible
- nodeId=763fd4b0-1200-4455-9a37-8ba13d044671; caption=Paused?; expression=$Workflow/State = System.WorkflowState.Paused Paused? expression=$Workflow/State = System.WorkflowState.Paused
- nodeId=3be384ec-b515-48c0-be04-69161fe32cf8; caption=Workflow available?; expression=$Workflow != empty Workflow available? expression=$Workflow != empty
- nodeId=8e5eb56f-76bb-4221-9f28-859fa5270669; actionKind=Create; entity=WorkflowCommons.NotificationArea; members=AlertTitle='Task is blocked', AlertMessage='This task cannot be completed as a result of changes in the workflow. Please contact your workflow administrator.', RenderAs=WorkflowCommons.Enum_NotificationArea_RenderAs.Error; summary=CreateObjectAction: create WorkflowCommons.NotificationArea as NewNotificationAreaBlockedTask (AlertTitle='Task is blocked', AlertMessage='This task cannot be completed as a result of changes in the workflow. Please contact your workflow administrator.', RenderAs=WorkflowCommons.Enum_NotificationArea_RenderAs.Error) create WorkflowCommons.NotificationArea as NewNotificationAreaBlockedTask (AlertTitle='Task is blocked', AlertMessage='This task cannot be completed as a result of changes in the workflow. Please contact your workflow administrator.', RenderAs=WorkflowCommons.Enum_NotificationArea_RenderAs.Error)
- nodeId=1c9477c0-6943-4023-8ea7-b0de318966e9; actionKind=Create; entity=WorkflowCommons.NotificationArea; members=AlertTitle='Task is paused', AlertMessage='This workflow was paused by an administrator. Please contact your workflow administrator.', RenderAs=WorkflowCommons.Enum_NotificationArea_RenderAs.Warning; summary=CreateObjectAction: create WorkflowCommons.NotificationArea as NewNotificationAreaPaused (AlertTitle='Task is paused', AlertMessage='This workflow was paused by an administrator. Please contact your workflow administrator.', RenderAs=WorkflowCommons.Enum_NotificationArea_RenderAs.Warning) create WorkflowCommons.NotificationArea as NewNotificationAreaPaused (AlertTitle='Task is paused', AlertMessage='This workflow was paused by an administrator. Please contact your workflow administrator.', RenderAs=WorkflowCommons.Enum_NotificationArea_RenderAs.Warning)

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ds-workflowtask-loadnotificationarea.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
