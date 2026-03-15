---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.DS_Workflow_LoadNotificationArea
stableId: 422be6bf-9e7b-47c9-81ae-eee69692cbbd
slug: workflowcommons-ds-workflow-loadnotificationarea
layer: L1
l0: workflowcommons-ds-workflow-loadnotificationarea.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ds-workflow-loadnotificationarea.json
l2Logical: flow:WorkflowCommons.DS_Workflow_LoadNotificationArea
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.DS_Workflow_LoadNotificationArea

## Summary

- Likely acts as a save, process, or background step for WorkflowCommons.NotificationArea because it mutates data without showing a page.
- L0: [abstract](workflowcommons-ds-workflow-loadnotificationarea.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ds-workflow-loadnotificationarea.json)

## Main Steps

- $Workflow/State = System.WorkflowState.Incompatible Incompatible? expression=$Workflow/State = System.WorkflowState.Incompatible
- $Workflow/State = System.WorkflowState.Paused Paused? expression=$Workflow/State = System.WorkflowState.Paused
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

- nodeId=3bc00a52-ca67-4d0c-bc90-14e2de819e0c; caption=Incompatible?; expression=$Workflow/State = System.WorkflowState.Incompatible Incompatible? expression=$Workflow/State = System.WorkflowState.Incompatible
- nodeId=5c4309a9-863e-48c6-847b-0f1cf26411ed; caption=Paused?; expression=$Workflow/State = System.WorkflowState.Paused Paused? expression=$Workflow/State = System.WorkflowState.Paused
- nodeId=a963806f-daa4-4dc0-baf3-8ec7e3e1caab; caption=Workflow passed?; expression=$Workflow != empty Workflow passed? expression=$Workflow != empty
- nodeId=5bcb7bc5-f63b-4d4d-ba48-bc7d26b1fed7; actionKind=Create; entity=WorkflowCommons.NotificationArea; members=AlertTitle='Workflow is blocked', AlertMessage='See state information for more details. Please contact the development team to fix this or as an admin abort/initiator withdraw this workflow.', RenderAs=WorkflowCommons.Enum_NotificationArea_RenderAs.Error; summary=CreateObjectAction: create WorkflowCommons.NotificationArea as NewNotificationAreaBlocked (AlertTitle='Workflow is blocked', AlertMessage='See state information for more details. Please contact the development team to fix this or as an admin abort/initiator withdraw this workflow.', RenderAs=WorkflowCommons.Enum_NotificationArea_RenderAs.Error) create WorkflowCommons.NotificationArea as NewNotificationAreaBlocked (AlertTitle='Workflow is blocked', AlertMessage='See state information for more details. Please contact the development team to fix this or as an admin abort/initiator withdraw this workflow.', RenderAs=WorkflowCommons.Enum_NotificationArea_RenderAs.Error)
- nodeId=b4a126b0-393f-4a2e-a44c-128a43c7a819; actionKind=Create; entity=WorkflowCommons.NotificationArea; members=AlertTitle='Workflow is paused', AlertMessage='This workflow was paused an administrator is able to unpause and allow further execution.', RenderAs=WorkflowCommons.Enum_NotificationArea_RenderAs.Warning; summary=CreateObjectAction: create WorkflowCommons.NotificationArea as NewNotificationAreaPaused (AlertTitle='Workflow is paused', AlertMessage='This workflow was paused an administrator is able to unpause and allow further execution.', RenderAs=WorkflowCommons.Enum_NotificationArea_RenderAs.Warning) create WorkflowCommons.NotificationArea as NewNotificationAreaPaused (AlertTitle='Workflow is paused', AlertMessage='This workflow was paused an administrator is able to unpause and allow further execution.', RenderAs=WorkflowCommons.Enum_NotificationArea_RenderAs.Warning)

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ds-workflow-loadnotificationarea.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
