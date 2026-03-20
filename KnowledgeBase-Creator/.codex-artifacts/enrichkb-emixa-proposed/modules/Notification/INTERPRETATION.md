# Interpretation: Notification

## Module Purpose

The `Notification` module handles operational messaging. It creates and manages notification records tied to user accounts so inspectors and managers receive task-related updates and can maintain read/unread inbox views.

What this module does:
- Creates notification records from inspection events and routes them to target users.
- Supports read/unread inbox views for inspectors and managers.
- Provides utility cleanup/maintenance flows for notification data.

Confidence: Inferred

## Domain Narrative

`Notification.Notification` is a single-purpose persistent entity that stores the message payload (`Title`, `Message`), read-state (`isRead`), and object linkage (`AssociatedObject`). The `Notification.Notification_Account` reference-set associates each notification with one or more `Administration.Account` records, enabling recipient-targeted delivery.

Role rules imply different responsibilities: inspectors mainly consume notifications, while managers have broader write capabilities on message fields. Delete rights on both roles suggest inbox lifecycle management is user-facing and expected as part of normal operation.

Confidence: Inferred

## Flow Narrative

| Tier 1 flow | Business intent | Business rule |
|---|---|---|
| Notification.ACT_Notification_MarkAsRead | Mark a selected notification as read from inbox interaction. | Read-state transition (`isRead`) is implied by flow naming and page action usage. |
| Notification.SE_Notification_SendToInspectors | Scheduled or automated dispatcher that creates notifications from inspection task events. | Uses Inspection task context plus account resolution to target recipients consistently. |
| Notification.SUB_Notification_SendToInspector | Subflow that composes and sends a notification to the assigned inspector. | Must resolve recipient account and persist notification-account association. |
| Notification.SUB_Notification_SendToManager | Subflow that composes and sends a notification to manager recipients. | Must resolve recipient role/account and persist notification-account association. |
| Notification.TEMP_Notifications_AllDelete | Administrative cleanup path for bulk notification deletion. | Intended for controlled cleanup; should be limited to privileged admin contexts. |

Confidence: Inferred

## Page Narrative

### User Journey Context

- Entry/working views: `Notification.Notification_Overview_Unread` and `Notification.Notification_Overview_Read` are inbox views for day-to-day notification consumption.
- Action context: `Notification.Notification_Overview_Unread` triggers `ACT_Notification_MarkAsRead`, representing the primary user interaction loop.
- Administrative utility view: `Notification.Script_Overview` is an admin-only page used for script or cleanup operations (including bulk delete).
- Popup pages: none.

Confidence: Inferred
