---
objectType: flow
module: Notification
qualifiedName: Notification.SUB_Notification_SendToManager
stableId: bbe7f916-bf8d-44e5-aabb-e7ae06112deb
slug: notification-sub-notification-sendtomanager
layer: L1
l0: notification-sub-notification-sendtomanager.abstract.md
l2Path: ../../../../../mendix-data-p05-mxcli-rerun/app-overview/current/modules/Notification/flows/notification-sub-notification-sendtomanager.json
l2Logical: flow:Notification.SUB_Notification_SendToManager
sourceRun: cli_2026-03-18T20-53-14.243Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Notification.SUB_Notification_SendToManager

## Summary

- Likely acts as a save, process, or background step for Administration.Account, Notification.Notification because it mutates data without showing a page.
- L0: [abstract](notification-sub-notification-sendtomanager.abstract.md)
- L2: [json](../../../../../mendix-data-p05-mxcli-rerun/app-overview/current/modules/Notification/flows/notification-sub-notification-sendtomanager.json)

## Main Steps

- retrieve over association $Task/Inspection.Task_Inspector
- retrieve over association $Inspector/Inspection.Inspector_Account
- create Notification.Notification (Title = 'An inspection task has been completed on ' + formatDateTime([%CurrentDateTime%], 'dd/MM/yyyy'), Notification_Account = $Account_Assigner, AssociatedObject = $Task/TaskID, Message = $Account_Inspector/FullName + ' has completed a task.' )

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

- nodeId=n002-retrieve; sourceKind=Association; association=$Task/Inspection.Task_Inspector; summary=retrieve over association $Task/Inspection.Task_Inspector
- nodeId=n003-retrieve; sourceKind=Association; association=$Inspector/Inspection.Inspector_Account; summary=retrieve over association $Inspector/Inspection.Inspector_Account
- nodeId=n004-retrieve; sourceKind=Database; entity=Administration.Account; xPath=id = $Task/System.owner; summary=retrieve from Administration.Account WHERE id = $Task/System.owner LIMIT 1
- nodeId=n005-create; actionKind=Create; entity=Notification.Notification; members=(Title = 'An inspection task has been completed on ' + formatDateTime([%CurrentDateTime%], 'dd/MM/yyyy'), Notification_Account = $Account_Assigner, AssociatedObject = $Task/TaskID, Message = $Account_Inspector/FullName + ' has completed a task.' ); summary=create Notification.Notification (Title = 'An inspection task has been completed on ' + formatDateTime([%CurrentDateTime%], 'dd/MM/yyyy'), Notification_Account = $Account_Assigner, AssociatedObject = $Task/TaskID, Message = $Account_Inspector/FullName + ' has completed a task.' )

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../mendix-data-p05-mxcli-rerun/app-overview/current/modules/Notification/flows/notification-sub-notification-sendtomanager.json)
- Aggregate export: [flows.json](../../../../../mendix-data-p05-mxcli-rerun/app-overview/cli_2026-03-18T20-53-14.243Z/modules/Notification/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../mendix-data-p05-mxcli-rerun/app-overview/cli_2026-03-18T20-53-14.243Z/modules/Notification/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-53-14.243Z
