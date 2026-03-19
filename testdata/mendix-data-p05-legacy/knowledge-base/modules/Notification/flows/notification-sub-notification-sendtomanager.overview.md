---
objectType: flow
module: Notification
qualifiedName: Notification.SUB_Notification_SendToManager
stableId: bbe7f916-bf8d-44e5-aabb-e7ae06112deb
slug: notification-sub-notification-sendtomanager
layer: L1
l0: notification-sub-notification-sendtomanager.abstract.md
l2Path: ../../../../app-overview/current/modules/Notification/flows/notification-sub-notification-sendtomanager.json
l2Logical: flow:Notification.SUB_Notification_SendToManager
sourceRun: cli_2026-03-18T20-44-56.522Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Notification.SUB_Notification_SendToManager

## Summary

- Likely acts as a save, process, or background step for Administration.Account, Notification.Notification because it mutates data without showing a page.
- L0: [abstract](notification-sub-notification-sendtomanager.abstract.md)
- L2: [json](../../../../app-overview/current/modules/Notification/flows/notification-sub-notification-sendtomanager.json)

## Main Steps

- RetrieveAction: retrieve Account_Assigner from Administration.Account retrieve Account_Assigner from Administration.Account
- RetrieveAction: retrieve Inspector over association Task_Inspector from Task retrieve Inspector over association Task_Inspector from Task
- CreateObjectAction: create Notification.Notification as NewNotification (Title='An inspection task has been completed on ' + formatDateTime([%CurrentDateTime%], 'dd/MM/yyyy'), Notification_Account=$Account_Assigner, Asso...

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by Inspection.ACT_Task_Save, Inspection.ACT_Task_SetToDone.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- Administration.Account, Notification.Notification

## Called / Called By

- Calls: none
- Called by: Inspection.ACT_Task_Save, Inspection.ACT_Task_SetToDone

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=97e8cd38-dd39-4266-a594-efedcac82043; sourceKind=Database; entity=Administration.Account; summary=RetrieveAction: retrieve Account_Assigner from Administration.Account retrieve Account_Assigner from Administration.Account
- nodeId=b8975efd-edce-4f27-81d5-9b6275facb7d; sourceKind=Association; association=Task_Inspector; summary=RetrieveAction: retrieve Inspector over association Task_Inspector from Task retrieve Inspector over association Task_Inspector from Task
- nodeId=d061d1ba-b763-41bb-a081-598a75ddeeec; sourceKind=Association; association=Inspector_Account; summary=RetrieveAction: retrieve Account_Inspector over association Inspector_Account from Inspector retrieve Account_Inspector over association Inspector_Account from Inspector
- nodeId=89d85c92-34db-40cf-9662-fc2a1a770d95; actionKind=Create; entity=Notification.Notification; members=Title='An inspection task has been completed on ' + formatDateTime([%CurrentDateTime%], 'dd/MM/yyyy'; summary=CreateObjectAction: create Notification.Notification as NewNotification (Title='An inspection task has been completed on ' + formatDateTime([%CurrentDateTime%], 'dd/MM/yyyy'), Notification_Account=$Account_Assigner, Asso...

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/Notification/flows/notification-sub-notification-sendtomanager.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-18T20-44-56.522Z/modules/Notification/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-18T20-44-56.522Z/modules/Notification/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-44-56.522Z
