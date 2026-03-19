---
objectType: flow
module: Notification
qualifiedName: Notification.TEMP_Notifications_AllDelete
stableId: 8c1b0fd0-5c95-4a7f-936c-1377583545c3
slug: notification-temp-notifications-alldelete
layer: L1
l0: notification-temp-notifications-alldelete.abstract.md
l2Path: ../../../../../mendix-data-p05-mxcli-rerun/app-overview/current/modules/Notification/flows/notification-temp-notifications-alldelete.json
l2Logical: flow:Notification.TEMP_Notifications_AllDelete
sourceRun: cli_2026-03-18T20-53-14.243Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Notification.TEMP_Notifications_AllDelete

## Summary

- Likely acts as a save, process, or background step for Notification.Notification because it mutates data without showing a page.
- L0: [abstract](notification-temp-notifications-alldelete.abstract.md)
- L2: [json](../../../../../mendix-data-p05-mxcli-rerun/app-overview/current/modules/Notification/flows/notification-temp-notifications-alldelete.json)

## Main Steps

- retrieve from Notification.Notification
- delete $NotificationList

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

- nodeId=n002-retrieve; sourceKind=Database; entity=Notification.Notification; summary=retrieve from Notification.Notification
- nodeId=n003-delete; actionKind=Delete; entity=Notification.Notification; summary=delete $NotificationList

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../mendix-data-p05-mxcli-rerun/app-overview/current/modules/Notification/flows/notification-temp-notifications-alldelete.json)
- Aggregate export: [flows.json](../../../../../mendix-data-p05-mxcli-rerun/app-overview/cli_2026-03-18T20-53-14.243Z/modules/Notification/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../mendix-data-p05-mxcli-rerun/app-overview/cli_2026-03-18T20-53-14.243Z/modules/Notification/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-53-14.243Z
