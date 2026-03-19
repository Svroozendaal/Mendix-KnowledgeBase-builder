---
objectType: flow
module: Notification
qualifiedName: Notification.ACT_Notification_MarkAsRead
stableId: 8dc114fc-d9fe-4b54-ac9e-d8a89885e315
slug: notification-act-notification-markasread
layer: L1
l0: notification-act-notification-markasread.abstract.md
l2Path: ../../../../app-overview/current/modules/Notification/flows/notification-act-notification-markasread.json
l2Logical: flow:Notification.ACT_Notification_MarkAsRead
sourceRun: cli_2026-03-18T20-56-46.385Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Notification.ACT_Notification_MarkAsRead

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](notification-act-notification-markasread.abstract.md)
- L2: [json](../../../../app-overview/current/modules/Notification/flows/notification-act-notification-markasread.json)

## Main Steps

- ChangeObjectAction: change Notification (isRead=true; refreshInClient=true) change Notification (isRead=true; refreshInClient=true)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=d9507306-e929-4169-a898-35410853dc1c; actionKind=Change; members=isRead=true; refreshInClient=true; summary=ChangeObjectAction: change Notification (isRead=true; refreshInClient=true) change Notification (isRead=true; refreshInClient=true)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/Notification/flows/notification-act-notification-markasread.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-18T20-56-46.385Z/modules/Notification/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-18T20-56-46.385Z/modules/Notification/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-56-46.385Z
