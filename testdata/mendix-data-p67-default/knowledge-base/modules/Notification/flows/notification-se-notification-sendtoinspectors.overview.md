---
objectType: flow
module: Notification
qualifiedName: Notification.SE_Notification_SendToInspectors
stableId: 6fb3fe1e-1357-4f6b-8e91-08fbb96f8e90
slug: notification-se-notification-sendtoinspectors
layer: L1
l0: notification-se-notification-sendtoinspectors.abstract.md
l2Path: ../../../../app-overview/current/modules/Notification/flows/notification-se-notification-sendtoinspectors.json
l2Logical: flow:Notification.SE_Notification_SendToInspectors
sourceRun: cli_2026-03-18T21-10-02.160Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Notification.SE_Notification_SendToInspectors

## Summary

- Likely acts as a save, process, or background step for Inspection.Task, Notification.Notification because it mutates data without showing a page.
- L0: [abstract](notification-se-notification-sendtoinspectors.abstract.md)
- L2: [json](../../../../app-overview/current/modules/Notification/flows/notification-se-notification-sendtoinspectors.json)

## Main Steps

- retrieve from Inspection.Task WHERE DueDate = '[%BeginOfCurrentDay%]'
- retrieve over association $IteratorTask/Inspection.Task_Inspector
- create list of Notification.Notification
- create Notification.Notification (Title = 'Task: ' + $IteratorTask/Title + ' is due today.' , Notification_Account = $Account_Inspector, AssociatedObject = $IteratorTask/TaskID)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- Inspection.Task, Notification.Notification

## Called / Called By

- Calls: Inspection.SUB_Account_GetFromInspector
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=n002-retrieve; sourceKind=Database; entity=Inspection.Task; xPath=DueDate = '[%BeginOfCurrentDay%]'; summary=retrieve from Inspection.Task WHERE DueDate = '[%BeginOfCurrentDay%]'
- nodeId=n005-retrieve; sourceKind=Association; association=$IteratorTask/Inspection.Task_Inspector; summary=retrieve over association $IteratorTask/Inspection.Task_Inspector
- nodeId=n003-create; actionKind=Create; entity=Notification.Notification; summary=create list of Notification.Notification
- nodeId=n007-create; actionKind=Create; entity=Notification.Notification; members=(Title = 'Task: ' + $IteratorTask/Title + ' is due today.' , Notification_Account = $Account_Inspector, AssociatedObject = $IteratorTask/TaskID); summary=create Notification.Notification (Title = 'Task: ' + $IteratorTask/Title + ' is due today.' , Notification_Account = $Account_Inspector, AssociatedObject = $IteratorTask/TaskID)
- nodeId=n009-commit; actionKind=Commit; entity=Notification.Notification; summary=commit $NotificationList_ToCommit WITH EVENTS ON ERROR ROLLBACK

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/Notification/flows/notification-se-notification-sendtoinspectors.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-18T21-10-02.160Z/modules/Notification/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-18T21-10-02.160Z/modules/Notification/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T21-10-02.160Z
