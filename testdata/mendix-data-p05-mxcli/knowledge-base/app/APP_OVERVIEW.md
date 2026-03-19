# App Overview

## Mission Summary

The application centres on the custom modules Inspection, Notification and orchestrates data and UI behaviour through model-driven flows and pages.

Confidence: Inferred

## Core Business Capabilities

| Module | Flow Count | Tier 1 Flows | Detail |
|---|---:|---:|---|
| Inspection | 39 | 28 | [FLOWS](../modules/Inspection/FLOWS.md) |
| Notification | 5 | 5 | [FLOWS](../modules/Notification/FLOWS.md) |

Confidence: Export-backed

## Top Behavioural Entry Points (Top 10)

| Flow | Tier | Impact reason | Link |
|---|---:|---|---|
| Notification.SUB_Notification_SendToInspector | Tier 1 | cross-module, writes data | [Flow](../modules/Notification/FLOWS.md) |
| Notification.SUB_Notification_SendToManager | Tier 1 | cross-module, fan-in 2, writes data | [Flow](../modules/Notification/FLOWS.md) |
| Inspection.SE_Equipment_OrderNew | Tier 1 | fan-out 2, writes data | [Flow](../modules/Inspection/FLOWS.md) |
| Inspection.ACT_Task_Save | Tier 1 | cross-module, fan-out 3 | [Flow](../modules/Inspection/FLOWS.md) |
| Inspection.ACT_Registration_Save | Tier 1 | writes data | [Flow](../modules/Inspection/FLOWS.md) |
| Inspection.VAL_Task_Validate | Tier 1 | fan-in 2 | [Flow](../modules/Inspection/FLOWS.md) |
| Notification.SE_Notification_SendToInspectors | Tier 1 | cross-module, writes data | [Flow](../modules/Notification/FLOWS.md) |
| Inspection.ACT_Accessory_Create | Tier 1 | shows UI, writes data | [Flow](../modules/Inspection/FLOWS.md) |
| Inspection.SUB_Booking_Delete | Tier 1 | writes data | [Flow](../modules/Inspection/FLOWS.md) |
| Inspection.ACT_Task_SetToDone | Tier 1 | cross-module, fan-out 2 | [Flow](../modules/Inspection/FLOWS.md) |

Confidence: Inferred

## Source

- Export summary: modules=7, flows=55, entities=18
- Generated at: 2026-03-18T20:44:57.0004259Z
