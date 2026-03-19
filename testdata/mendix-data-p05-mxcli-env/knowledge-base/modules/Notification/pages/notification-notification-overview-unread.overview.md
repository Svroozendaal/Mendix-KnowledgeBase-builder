---
objectType: page
module: Notification
qualifiedName: Notification.Notification_Overview_Unread
stableId: Notification.Notification_Overview_Unread
slug: notification-notification-overview-unread
layer: L1
l0: notification-notification-overview-unread.abstract.md
l2Path: ../../../../app-overview/current/modules/Notification/pages/notification-notification-overview-unread.json
l2Logical: page:Notification.Notification_Overview_Unread
sourceRun: cli_2026-03-18T20-49-03.032Z
collectionL0: INDEX.abstract.md
collectionL1: ../PAGES.md
---
# Page Overview: Notification.Notification_Overview_Unread

## Summary

- Unread notifications. Likely serves as an overview or browse page for reviewing records and starting related tasks.
- L0: [abstract](notification-notification-overview-unread.abstract.md)
- L2: [json](../../../../app-overview/current/modules/Notification/pages/notification-notification-overview-unread.json)

## Roles and Entry Provenance

- Roles: Notification.Inspector, Notification.Manager
- Entry provenance: MenuItem

## Parameters

- none

## Datasource Summary

- sourceId=dataView1; sourceType=Microflow; flow=Inspection.DS_Task_GetFromNotification; summary=Microflow datasource: Inspection.DS_Task_GetFromNotification

## Client Actions

- actionId=actionButton1; actionType=MicroflowClientAction; flow=Notification.ACT_Notification_MarkAsRead; summary=MicroflowClientAction, flow=Notification.ACT_Notification_MarkAsRead
- actionId=actionButton2; actionType=DeleteClientAction; summary=DeleteClientAction

## Shown by Flows

- No ShowPageAction was resolved from exported flows; this page may be reached from navigation or a client-side action. Check L2 JSON if exact provenance matters.

## Navigation/Homepage Provenance

- provenanceId=nav-7e56ca8a178b; sourceType=MenuItem; summary=Menu item "Notifications" in profile Responsive

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/Notification/pages/notification-notification-overview-unread.json)
- Aggregate export: [pages.json](../../../../app-overview/cli_2026-03-18T20-49-03.032Z/modules/Notification/pages.json)
- Aggregate pseudo: [pages.pseudo.txt](../../../../app-overview/cli_2026-03-18T20-49-03.032Z/modules/Notification/pages.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-49-03.032Z
