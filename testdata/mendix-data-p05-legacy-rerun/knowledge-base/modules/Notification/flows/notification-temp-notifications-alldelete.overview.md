---
objectType: flow
module: Notification
qualifiedName: Notification.TEMP_Notifications_AllDelete
stableId: 8c1b0fd0-5c95-4a7f-936c-1377583545c3
slug: notification-temp-notifications-alldelete
layer: L1
l0: notification-temp-notifications-alldelete.abstract.md
l2Path: ../../../../app-overview/current/modules/Notification/flows/notification-temp-notifications-alldelete.json
l2Logical: flow:Notification.TEMP_Notifications_AllDelete
sourceRun: cli_2026-03-18T20-52-48.461Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Notification.TEMP_Notifications_AllDelete

## Summary

- Likely acts as a save, process, or background step for Notification.Notification because it mutates data without showing a page.
- L0: [abstract](notification-temp-notifications-alldelete.abstract.md)
- L2: [json](../../../../app-overview/current/modules/Notification/flows/notification-temp-notifications-alldelete.json)

## Main Steps

- RetrieveAction: retrieve NotificationList from Notification.Notification retrieve NotificationList from Notification.Notification
- DeleteAction: delete NotificationList (refreshInClient=false) delete NotificationList (refreshInClient=false)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- Notification.Notification

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=d10164c7-fbd6-4c28-8825-fa6fd4bc2278; sourceKind=Database; entity=Notification.Notification; summary=RetrieveAction: retrieve NotificationList from Notification.Notification retrieve NotificationList from Notification.Notification
- nodeId=423465b8-050b-4028-b78c-44bc78a6fa97; actionKind=Delete; members=refreshInClient=false; summary=DeleteAction: delete NotificationList (refreshInClient=false) delete NotificationList (refreshInClient=false)

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/Notification/flows/notification-temp-notifications-alldelete.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/Notification/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/Notification/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-52-48.461Z
