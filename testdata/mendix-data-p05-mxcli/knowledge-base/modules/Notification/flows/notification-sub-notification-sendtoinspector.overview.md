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
sourceRun: cli_2026-03-18T20-44-56.521Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Notification.SUB_Notification_SendToInspector

## Summary

- Likely acts as a save, process, or background step for Administration.Account, Notification.Notification because it mutates data without showing a page.
- L0: [abstract](notification-sub-notification-sendtoinspector.abstract.md)
- L2: [json](../../../../app-overview/current/modules/Notification/flows/notification-sub-notification-sendtoinspector.json)

## Main Steps

- retrieve over association $Task/Inspection.Task_Inspector
- retrieve from Administration.Account WHERE id = $Task/System.owner LIMIT 1
- create Notification.Notification (Title = 'An inspection task has been assigned to you on ' + formatDateTime([%CurrentDateTime%], 'dd/MM/yyyy'), Notification_Account = $Account_Inspector, AssociatedObject = $Task/TaskID, Message = $Account_Assigner/FullName + ' has assigned a task to you.' )

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

- nodeId=n002-retrieve; sourceKind=Association; association=$Task/Inspection.Task_Inspector; summary=retrieve over association $Task/Inspection.Task_Inspector
- nodeId=n004-retrieve; sourceKind=Database; entity=Administration.Account; xPath=id = $Task/System.owner; summary=retrieve from Administration.Account WHERE id = $Task/System.owner LIMIT 1
- nodeId=n005-create; actionKind=Create; entity=Notification.Notification; members=(Title = 'An inspection task has been assigned to you on ' + formatDateTime([%CurrentDateTime%], 'dd/MM/yyyy'), Notification_Account = $Account_Inspector, AssociatedObject = $Task/TaskID, Message = $Account_Assigner/FullName + ' has assigned a task to you.' ); summary=create Notification.Notification (Title = 'An inspection task has been assigned to you on ' + formatDateTime([%CurrentDateTime%], 'dd/MM/yyyy'), Notification_Account = $Account_Inspector, AssociatedObject = $Task/TaskID, Message = $Account_Assigner/FullName + ' has assigned a task to you.' )

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/Notification/flows/notification-sub-notification-sendtoinspector.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-18T20-44-56.521Z/modules/Notification/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-18T20-44-56.521Z/modules/Notification/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-44-56.521Z
