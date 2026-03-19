# Domain: Notification

## Entities

| Entity | Persistable | Attribute count | Access rule count |
|---|---|---:|---:|
| Notification.Notification | True | 4 | 2 |

Confidence: Export-backed

## Entity Lifecycle Matrix

| Entity | Create flows | Update flows | Delete flows | Read flows |
|---|---|---|---|---|
| Notification.Notification | Notification.SE_Notification_SendToInspectors, Notification.SUB_Notification_SendToInspector, Notification.SUB_Notification_SendToManager [members unknown] | Notification.SE_Notification_SendToInspectors [members unknown] | Notification.TEMP_Notifications_AllDelete | Notification.SE_Notification_SendToInspectors, Notification.SUB_Notification_SendToInspector, Notification.SUB_Notification_SendToManager, Notification.TEMP_Notifications_AllDelete |

Confidence: Inferred

## Role impacts per sensitive entity

| Entity | Module roles | Default member rights | XPath constraint |
|---|---|---|---|
| Notification.Notification | Notification.Inspector |  | none |
| Notification.Notification | Notification.Manager |  | none |

Confidence: Export-backed

## Associations

| Association | Parent | Child | Cardinality | Type | Owner |
|---|---|---|---|---|---|
| Notification.Notification_Account | Notification.Notification | Administration.Account | *-* | ReferenceSet | Default |

## Enumerations

| Enumeration | Value count | Sample values |
|---|---:|---|
| none | 0 | none |

## Entity Index

<a id="entity-notification-notification"></a>
### Notification.Notification

- Generalization: none.
- Lifecycle: create=Notification.SE_Notification_SendToInspectors, Notification.SUB_Notification_SendToInspector, Notification.SUB_Notification_SendToManager; update=Notification.SE_Notification_SendToInspectors; delete=Notification.TEMP_Notifications_AllDelete; read=Notification.SE_Notification_SendToInspectors, Notification.SUB_Notification_SendToInspector, Notification.SUB_Notification_SendToManager, Notification.TEMP_Notifications_AllDelete.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-18T20-57-13.045Z/modules/Notification/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-18T20-57-13.045Z/modules/Notification/domain-model.json).

| Attribute | Type | Length/Precision | Default | Validation |
|---|---|---|---|---|
| Title | String | — | — | — |
| Message | String | — | — | — |
| isRead | Boolean | — | false | — |
| AssociatedObject | Long | — | 0 | — |

## Source

- Domain export pseudo: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-18T20-57-13.045Z/modules/Notification/domain-model.pseudo.txt)
- Domain export json: [domain-model.json](../../../app-overview/cli_2026-03-18T20-57-13.045Z/modules/Notification/domain-model.json)
