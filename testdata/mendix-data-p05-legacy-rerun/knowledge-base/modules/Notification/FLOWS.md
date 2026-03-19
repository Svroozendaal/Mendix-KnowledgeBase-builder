# Flows: Notification

## Flow Catalogue

### Action Flows (ACT_*)

| Flow | Nodes | Key Actions | Pages Shown |
|---|---:|---|---|
| ACT_Notification_MarkAsRead | 4 | none | none |

### Data Sources (DS_*)

| Flow | Nodes | Key Actions | Returns |
|---|---:|---|---|
| none | 0 | none | none |

### Validation Flows (VAL_*)

| Flow | Nodes | Key Actions |
|---|---:|---|
| none | 0 | none |

### Other Flows

| Flow | Type | Nodes | Key Actions |
|---|---|---:|---|
| SE_Notification_SendToInspectors | Microflow | 10 | Inspection.Task, Notification.Notification |
| SUB_Notification_SendToInspector | Microflow | 7 | Administration.Account, Notification.Notification |
| SUB_Notification_SendToManager | Microflow | 7 | Administration.Account, Notification.Notification |
| TEMP_Notifications_AllDelete | Microflow | 5 | Notification.Notification |

## Cross-Module Calls

| Flow | Calls | Target Module |
|---|---|---|
| SE_Notification_SendToInspectors | Inspection.SUB_Account_GetFromInspector | Inspection |
| SUB_Notification_SendToInspector | Inspection.SUB_Account_GetFromInspector | Inspection |

## Tier 1 Shortlist

| Flow | Shown Pages | Entities |
|---|---|---|
| Notification.ACT_Notification_MarkAsRead | none | none |
| Notification.SE_Notification_SendToInspectors | none | Inspection.Task, Notification.Notification |
| Notification.SUB_Notification_SendToInspector | none | Administration.Account, Notification.Notification |
| Notification.SUB_Notification_SendToManager | none | Administration.Account, Notification.Notification |
| Notification.TEMP_Notifications_AllDelete | none | Notification.Notification |

## Flow Details

| Flow | Kind | Nodes | Tier | Calls Out | Called By |
|---|---|---:|---:|---:|---:|
| ACT_Notification_MarkAsRead | Microflow | 4 | 1 | 0 | 0 |
| SE_Notification_SendToInspectors | Microflow | 10 | 1 | 1 | 0 |
| SUB_Notification_SendToInspector | Microflow | 7 | 1 | 1 | 1 |
| SUB_Notification_SendToManager | Microflow | 7 | 1 | 0 | 2 |
| TEMP_Notifications_AllDelete | Microflow | 5 | 1 | 0 | 0 |

## Tier 1 Deep Narratives

### Notification.ACT_Notification_MarkAsRead

- Intent: User action flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: none.
- UI interactions (shown pages): none.
- Calls/called-by: out=0, in=0.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: No rollback behaviour was explicitly indicated in exported node detail.

### Notification.SE_Notification_SendToInspectors

- Intent: General behavioural flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: Inspection.Task, Notification.Notification.
- UI interactions (shown pages): none.
- Calls/called-by: out=1, in=0.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: Rollback hint detected in flow node detail.

### Notification.SUB_Notification_SendToInspector

- Intent: General behavioural flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: Administration.Account, Notification.Notification.
- UI interactions (shown pages): none.
- Calls/called-by: out=1, in=1.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: No rollback behaviour was explicitly indicated in exported node detail.

### Notification.SUB_Notification_SendToManager

- Intent: General behavioural flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: Administration.Account, Notification.Notification.
- UI interactions (shown pages): none.
- Calls/called-by: out=0, in=2.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: No rollback behaviour was explicitly indicated in exported node detail.

### Notification.TEMP_Notifications_AllDelete

- Intent: General behavioural flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: Notification.Notification.
- UI interactions (shown pages): none.
- Calls/called-by: out=0, in=0.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: No rollback behaviour was explicitly indicated in exported node detail.

## Flow Links

| Flow | Type | Tier | L0 | L1 | L2 |
|---|---|---:|---|---|---|
| Notification.ACT_Notification_MarkAsRead | Microflow | 1 | [L0](flows/notification-act-notification-markasread.abstract.md) | [L1](flows/notification-act-notification-markasread.overview.md) | [L2](../../../app-overview/current/modules/Notification/flows/notification-act-notification-markasread.json) |
| Notification.SE_Notification_SendToInspectors | Microflow | 1 | [L0](flows/notification-se-notification-sendtoinspectors.abstract.md) | [L1](flows/notification-se-notification-sendtoinspectors.overview.md) | [L2](../../../app-overview/current/modules/Notification/flows/notification-se-notification-sendtoinspectors.json) |
| Notification.SUB_Notification_SendToInspector | Microflow | 1 | [L0](flows/notification-sub-notification-sendtoinspector.abstract.md) | [L1](flows/notification-sub-notification-sendtoinspector.overview.md) | [L2](../../../app-overview/current/modules/Notification/flows/notification-sub-notification-sendtoinspector.json) |
| Notification.SUB_Notification_SendToManager | Microflow | 1 | [L0](flows/notification-sub-notification-sendtomanager.abstract.md) | [L1](flows/notification-sub-notification-sendtomanager.overview.md) | [L2](../../../app-overview/current/modules/Notification/flows/notification-sub-notification-sendtomanager.json) |
| Notification.TEMP_Notifications_AllDelete | Microflow | 1 | [L0](flows/notification-temp-notifications-alldelete.abstract.md) | [L1](flows/notification-temp-notifications-alldelete.overview.md) | [L2](../../../app-overview/current/modules/Notification/flows/notification-temp-notifications-alldelete.json) |
