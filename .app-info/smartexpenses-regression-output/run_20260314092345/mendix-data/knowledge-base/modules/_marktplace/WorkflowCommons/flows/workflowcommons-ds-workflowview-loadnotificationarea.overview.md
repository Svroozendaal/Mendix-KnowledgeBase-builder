---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.DS_WorkflowView_LoadNotificationArea
stableId: 6eb2d9f8-6927-42fc-bb00-5ee1fd2c03b5
slug: workflowcommons-ds-workflowview-loadnotificationarea
layer: L1
l0: workflowcommons-ds-workflowview-loadnotificationarea.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ds-workflowview-loadnotificationarea.json
l2Logical: flow:WorkflowCommons.DS_WorkflowView_LoadNotificationArea
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.DS_WorkflowView_LoadNotificationArea

## Summary

- Likely acts as a save, process, or background step for WorkflowCommons.NotificationArea because it mutates data without showing a page.
- L0: [abstract](workflowcommons-ds-workflowview-loadnotificationarea.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ds-workflowview-loadnotificationarea.json)

## Main Steps

- $WorkflowView/State = System.WorkflowState.Incompatible Incompatible? expression=$WorkflowView/State = System.WorkflowState.Incompatible
- $WorkflowView/State = System.WorkflowState.Paused Paused? expression=$WorkflowView/State = System.WorkflowState.Paused
- CreateObjectAction: create WorkflowCommons.NotificationArea as NewNotificationAreaBlocked (AlertTitle='Workflow is blocked', AlertMessage='See state information for more details. Please contact the development team to fix this or as an admin abort/initiator withdraw this workflow.', RenderAs=WorkflowCommons.Enum_NotificationArea_RenderAs.Error) create WorkflowCommons.NotificationArea as NewNotificationAreaBlocked (AlertTitle='Workflow is blocked', AlertMessage='See state information for more details. Please contact the development team to fix this or as an admin abort/initiator withdraw this workflow.', RenderAs=WorkflowCommons.Enum_NotificationArea_RenderAs.Error)
- CreateObjectAction: create WorkflowCommons.NotificationArea as NewNotificationAreaPaused (AlertTitle='Workflow is paused', AlertMessage='This workflow was paused an administrator is able to unpause and allow further execution.', RenderAs=WorkflowCommons.Enum_NotificationArea_RenderAs.Warning) create WorkflowCommons.NotificationArea as NewNotificationAreaPaused (AlertTitle='Workflow is paused', AlertMessage='This workflow was paused an administrator is able to unpause and allow further execution.', RenderAs=WorkflowCommons.Enum_NotificationArea_RenderAs.Warning)

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

- nodeId=90b45e40-54f9-4f51-9cb1-fa042462d535; caption=Incompatible?; expression=$WorkflowView/State = System.WorkflowState.Incompatible Incompatible? expression=$WorkflowView/State = System.WorkflowState.Incompatible
- nodeId=d9111fdd-fb38-41fb-a0be-642308b30adf; caption=Paused?; expression=$WorkflowView/State = System.WorkflowState.Paused Paused? expression=$WorkflowView/State = System.WorkflowState.Paused
- nodeId=822740ca-8621-4145-a395-4909c05b4c2c; caption=Workflow passed?; expression=$WorkflowView != empty Workflow passed? expression=$WorkflowView != empty
- nodeId=c8bd7a41-1d44-4b4d-92c6-5563bc05d68a; actionKind=Create; entity=WorkflowCommons.NotificationArea; members=AlertTitle='Workflow is blocked', AlertMessage='See state information for more details. Please contact the development team to fix this or as an admin abort/initiator withdraw this workflow.', RenderAs=WorkflowCommons.Enum_NotificationArea_RenderAs.Error; summary=CreateObjectAction: create WorkflowCommons.NotificationArea as NewNotificationAreaBlocked (AlertTitle='Workflow is blocked', AlertMessage='See state information for more details. Please contact the development team to fix this or as an admin abort/initiator withdraw this workflow.', RenderAs=WorkflowCommons.Enum_NotificationArea_RenderAs.Error) create WorkflowCommons.NotificationArea as NewNotificationAreaBlocked (AlertTitle='Workflow is blocked', AlertMessage='See state information for more details. Please contact the development team to fix this or as an admin abort/initiator withdraw this workflow.', RenderAs=WorkflowCommons.Enum_NotificationArea_RenderAs.Error)
- nodeId=75ab93ce-2021-45ba-9ae4-bc0858efc369; actionKind=Create; entity=WorkflowCommons.NotificationArea; members=AlertTitle='Workflow is paused', AlertMessage='This workflow was paused an administrator is able to unpause and allow further execution.', RenderAs=WorkflowCommons.Enum_NotificationArea_RenderAs.Warning; summary=CreateObjectAction: create WorkflowCommons.NotificationArea as NewNotificationAreaPaused (AlertTitle='Workflow is paused', AlertMessage='This workflow was paused an administrator is able to unpause and allow further execution.', RenderAs=WorkflowCommons.Enum_NotificationArea_RenderAs.Warning) create WorkflowCommons.NotificationArea as NewNotificationAreaPaused (AlertTitle='Workflow is paused', AlertMessage='This workflow was paused an administrator is able to unpause and allow further execution.', RenderAs=WorkflowCommons.Enum_NotificationArea_RenderAs.Warning)

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ds-workflowview-loadnotificationarea.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
