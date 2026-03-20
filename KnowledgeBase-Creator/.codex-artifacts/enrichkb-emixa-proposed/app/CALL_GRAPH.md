# Call Graph

## Cross-Module Dependency Table

| Source module | Target module | Call edges | Key flows |
|---|---|---:|---|
| Inspection | Notification | 3 | Inspection.ACT_Task_Save -> Notification.SUB_Notification_SendToInspector, Inspection.ACT_Task_Save -> Notification.SUB_Notification_SendToManager, Inspection.ACT_Task_SetToDone -> Notification.SUB_Notification_SendToManager |
| Notification | Inspection | 2 | Notification.SE_Notification_SendToInspectors -> Inspection.SUB_Account_GetFromInspector, Notification.SUB_Notification_SendToInspector -> Inspection.SUB_Account_GetFromInspector |

Confidence: Export-backed

## Custom Module Boundary

| Custom module | Outbound dependencies | Inbound dependencies |
|---|---|---|
| Inspection | Notification | Notification |
| Notification | Inspection | Inspection |

Confidence: Export-backed

## Architecture Narrative

The app follows an event-driven collaboration between two custom modules. `Inspection` owns the operational lifecycle (creating and updating work), then emits cross-module calls to `Notification` when task actions require user alerts. `Notification` resolves recipient context via Inspection helper flows and persists inbox records, creating a closed loop between operational change and user communication.

Confidence: Inferred

## Source

- Export flow call edges: 14
- Derived cross-module edges: 5
