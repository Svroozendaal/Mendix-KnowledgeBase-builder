# Cross-Module Dependencies

## Dependency matrix

| Source module | Target module | Flow call count | Association link count |
|---|---|---:|---:|
| Notification | Inspection | 2 | 0 |
| Inspection | Notification | 3 | 0 |

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
| System | 0 | 0 | isolated |
| Unknown | 0 | 0 | isolated |

## Hub Modules

- Inspection, Notification

## Leaf Modules

- none

## Association Links

| Association | From module | To module | Parent entity | Child entity |
|---|---|---|---|---|
| none | none | none | none | none |

## Custom-boundary dependency lens

| Custom module | Depends on | Used by |
|---|---|---|
| Inspection | Notification | Notification |
| Notification | Inspection | Inspection |
