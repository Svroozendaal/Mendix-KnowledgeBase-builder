# Cross-Module Dependencies

## Dependency matrix

| Source module | Target module | Flow call count | Association link count |
|---|---|---:|---:|
| Notification | Inspection | 2 | 0 |
| Inspection | Administration | 0 | 1 |
| Inspection | Notification | 3 | 0 |
| Notification | Administration | 0 | 1 |

## Flow-call edges

| Source flow | Target flow | Source module | Target module |
|---|---|---|---|
| Inspection.ACT_Task_Save | Notification.SUB_Notification_SendToInspector | Inspection | Notification |
| Inspection.ACT_Task_Save | Notification.SUB_Notification_SendToManager | Inspection | Notification |
| Inspection.ACT_Task_SetToDone | Notification.SUB_Notification_SendToManager | Inspection | Notification |
| Notification.SE_Notification_SendToInspectors | Inspection.SUB_Account_GetFromInspector | Notification | Inspection |
| Notification.SUB_Notification_SendToInspector | Inspection.SUB_Account_GetFromInspector | Notification | Inspection |

## Hub/leaf module classification

| Module | Outbound edges | Inbound edges | Classification |
|---|---:|---:|---|
| Administration | 0 | 0 | isolated |
| Atlas_Core | 0 | 0 | isolated |
| Atlas_Web_Content | 0 | 0 | isolated |
| DataWidgets | 0 | 0 | isolated |
| Inspection | 3 | 2 | hub |
| NanoflowCommons | 0 | 0 | isolated |
| Notification | 2 | 3 | hub |

## Hub Modules

- Inspection, Notification

## Leaf Modules

- none

## Association Links

| Association | From module | To module | Parent entity | Child entity |
|---|---|---|---|---|
| Inspection.Inspector_Account | Inspection | Administration | Inspection.Inspector | Administration.Account |
| Notification.Notification_Account | Notification | Administration | Notification.Notification | Administration.Account |

## Custom-boundary dependency lens

| Custom module | Depends on | Used by |
|---|---|---|
| Inspection | Notification | Notification |
| Notification | Inspection | Inspection |
