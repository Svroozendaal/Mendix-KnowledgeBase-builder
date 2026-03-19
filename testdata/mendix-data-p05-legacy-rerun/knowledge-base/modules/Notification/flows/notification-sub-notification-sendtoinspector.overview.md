---
objectType: flow
module: Notification
qualifiedName: Notification.SUB_Notification_SendToInspector
stableId: e177067f-ceb7-4f02-a440-2783e58cbad5
slug: notification-sub-notification-sendtoinspector
layer: L1
l0: notification-sub-notification-sendtoinspector.abstract.md
l2Path: ../../../../app-overview/current/modules/Notification/flows/notification-sub-notification-sendtoinspector.json
l2Logical: flow:Notification.SUB_Notification_SendToInspector
sourceRun: cli_2026-03-18T20-52-48.461Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Notification.SUB_Notification_SendToInspector

## Summary

- Likely acts as a save, process, or background step for Administration.Account, Notification.Notification because it mutates data without showing a page.
- L0: [abstract](notification-sub-notification-sendtoinspector.abstract.md)
- L2: [json](../../../../app-overview/current/modules/Notification/flows/notification-sub-notification-sendtoinspector.json)

## Main Steps

- RetrieveAction: retrieve Inspector over association Task_Inspector from Task retrieve Inspector over association Task_Inspector from Task
- RetrieveAction: retrieve Account_Assigner from Administration.Account retrieve Account_Assigner from Administration.Account
- CreateObjectAction: create Notification.Notification as NewNotification (Title='An inspection task has been assigned to you on ' + formatDateTime([%CurrentDateTime%], 'dd/MM/yyyy'), Notification_Account=$Account_Inspecto...

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by Inspection.ACT_Task_Save.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- Administration.Account, Notification.Notification

## Called / Called By

- Calls: Inspection.SUB_Account_GetFromInspector
- Called by: Inspection.ACT_Task_Save

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=25414eba-a62b-409e-9e52-873a1b5c9041; sourceKind=Association; association=Task_Inspector; summary=RetrieveAction: retrieve Inspector over association Task_Inspector from Task retrieve Inspector over association Task_Inspector from Task
- nodeId=8ed00d42-1c99-48f6-b2ce-3e0c58fe9751; sourceKind=Database; entity=Administration.Account; summary=RetrieveAction: retrieve Account_Assigner from Administration.Account retrieve Account_Assigner from Administration.Account
- nodeId=b60142d5-c4fe-4af9-88da-3b9c0661acd8; actionKind=Create; entity=Notification.Notification; members=Title='An inspection task has been assigned to you on ' + formatDateTime([%CurrentDateTime%], 'dd/MM/yyyy'; summary=CreateObjectAction: create Notification.Notification as NewNotification (Title='An inspection task has been assigned to you on ' + formatDateTime([%CurrentDateTime%], 'dd/MM/yyyy'), Notification_Account=$Account_Inspecto...

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/Notification/flows/notification-sub-notification-sendtoinspector.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/Notification/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/Notification/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-52-48.461Z
