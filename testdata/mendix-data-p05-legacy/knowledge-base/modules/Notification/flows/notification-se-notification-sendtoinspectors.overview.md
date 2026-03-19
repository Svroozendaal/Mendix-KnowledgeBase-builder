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
sourceRun: cli_2026-03-18T20-44-56.522Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Notification.SE_Notification_SendToInspectors

## Summary

- Likely acts as a save, process, or background step for Inspection.Task, Notification.Notification because it mutates data without showing a page.
- L0: [abstract](notification-se-notification-sendtoinspectors.abstract.md)
- L2: [json](../../../../app-overview/current/modules/Notification/flows/notification-se-notification-sendtoinspectors.json)

## Main Steps

- RetrieveAction: retrieve Inspector over association Task_Inspector from IteratorTask retrieve Inspector over association Task_Inspector from IteratorTask
- RetrieveAction: retrieve TaskList from Inspection.Task retrieve TaskList from Inspection.Task
- CreateObjectAction: create Notification.Notification as NewNotification (Title='Task: ' + $IteratorTask/Title + ' is due today.', Notification_Account=$Account_Inspector, AssociatedObject=$IteratorTask/TaskID) create Not...
- CommitAction: commit NotificationList_ToCommit (refreshInClient=false, withEvents=true) commit NotificationList_ToCommit (refreshInClient=false, withEvents=true)

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

- nodeId=1ff59e39-5369-46d5-a3b9-6a9c8afebd83; sourceKind=Association; association=Task_Inspector; summary=RetrieveAction: retrieve Inspector over association Task_Inspector from IteratorTask retrieve Inspector over association Task_Inspector from IteratorTask
- nodeId=5f047945-b271-4926-a4f6-00cf22330aa9; sourceKind=Database; entity=Inspection.Task; summary=RetrieveAction: retrieve TaskList from Inspection.Task retrieve TaskList from Inspection.Task
- nodeId=0b9ae13f-306c-4169-b5d5-44c6b8470bed; actionKind=Create; entity=Notification.Notification; members=Title='Task: ' + $IteratorTask/Title + ' is due today.', Notification_Account=$Account_Inspector, AssociatedObject=$IteratorTask/TaskID; summary=CreateObjectAction: create Notification.Notification as NewNotification (Title='Task: ' + $IteratorTask/Title + ' is due today.', Notification_Account=$Account_Inspector, AssociatedObject=$IteratorTask/TaskID) create Not...
- nodeId=dc45ca9e-d89b-4d2f-a9d2-bc21be332151; actionKind=Commit; members=refreshInClient=false, withEvents=true; summary=CommitAction: commit NotificationList_ToCommit (refreshInClient=false, withEvents=true) commit NotificationList_ToCommit (refreshInClient=false, withEvents=true)
- nodeId=e28ccadc-2f7e-4db9-98a2-bbdacaec56d4; actionKind=Change; members=type=Add, value=$NewNotification; summary=ChangeListAction: change NotificationList_ToCommit (type=Add, value=$NewNotification) change NotificationList_ToCommit (type=Add, value=$NewNotification)
- nodeId=f61cf5aa-0be8-4989-a452-a645f0f1e585; actionKind=Commit; entity=Notification.Notification; members=output=NotificationList_ToCommit, entity=Notification.Notification, errorHandlingType=Rollback; summary=CreateListAction: CreateListAction (output=NotificationList_ToCommit, entity=Notification.Notification, errorHandlingType=Rollback) CreateListAction (output=NotificationList_ToCommit, entity=Notification.Notification, er...

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/Notification/flows/notification-se-notification-sendtoinspectors.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-18T20-44-56.522Z/modules/Notification/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-18T20-44-56.522Z/modules/Notification/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-44-56.522Z
