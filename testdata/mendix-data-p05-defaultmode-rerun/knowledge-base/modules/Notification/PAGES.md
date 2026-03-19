# Pages: Notification

## Page Inventory

| Page | Title | Allowed roles | Parameters | Popup |
|---|---|---|---|---|
| Notification.Notification_Overview_Read | Read notifications | Notification.Inspector, Notification.Manager | none | False |
| Notification.Notification_Overview_Unread | Unread notifications | Notification.Inspector, Notification.Manager | none | False |
| Notification.Script_Overview | Script Overview | Notification.Administrator | none | False |

## Page-Flow Links

| Page | Shown by flows |
|---|---|
| Notification.Notification_Overview_Read | none |
| Notification.Notification_Overview_Unread | none |
| Notification.Script_Overview | none |

## Journey Groups

| User intent group | Pages |
|---|---|
| Notification | Notification.Notification_Overview_Read, Notification.Notification_Overview_Unread |
| Script | Notification.Script_Overview |

## Page Links

| Page | Entry provenance | L0 | L1 | L2 |
|---|---|---|---|---|
| Notification.Notification_Overview_Read | Unknown (navigation metadata not exported) | [L0](pages/notification-notification-overview-read.abstract.md) | [L1](pages/notification-notification-overview-read.overview.md) | [L2](../../../../mendix-data-p05-mxcli-rerun/app-overview/current/modules/Notification/pages/notification-notification-overview-read.json) |
| Notification.Notification_Overview_Unread | MenuItem | [L0](pages/notification-notification-overview-unread.abstract.md) | [L1](pages/notification-notification-overview-unread.overview.md) | [L2](../../../../mendix-data-p05-mxcli-rerun/app-overview/current/modules/Notification/pages/notification-notification-overview-unread.json) |
| Notification.Script_Overview | MenuItem | [L0](pages/notification-script-overview.abstract.md) | [L1](pages/notification-script-overview.overview.md) | [L2](../../../../mendix-data-p05-mxcli-rerun/app-overview/current/modules/Notification/pages/notification-script-overview.json) |
