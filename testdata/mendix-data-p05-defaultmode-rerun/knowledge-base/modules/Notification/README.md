# Module: Notification

Category: Custom
Module roles: Administrator, Inspector, Manager

## Summary

- Entities: 1
- Flows: 5
- Pages: 3
- Constants: 0

## Purpose

- Export-backed: module category and inventory from overview export.
- Inferred: module role is app-specific business behaviour.
- Deterministic fallback: This module appears to manage data such as notification, flows such as notification mark as read, notification send to inspector, and se notification send to inspectors, pages such as read notifications and unread notifications, and supporting configuration and runtime resources based on its exported entities, pages, flows, and resources.

## Capability Map

| Capability prefix | Flow count | Representative flow |
|---|---:|---|
| ACT | 1 | Notification.ACT_Notification_MarkAsRead |
| SE | 1 | Notification.SE_Notification_SendToInspectors |
| SUB | 2 | Notification.SUB_Notification_SendToInspector |
| TEMP | 1 | Notification.TEMP_Notifications_AllDelete |

## Primary User Journeys

| Entry flow | UI result | Entities touched |
|---|---|---|
| Notification.ACT_Notification_MarkAsRead | none | Unknown |
| Notification.SE_Notification_SendToInspectors | none | Inspection.Task, Notification.Notification |
| Notification.SUB_Notification_SendToInspector | none | Administration.Account, Notification.Notification |
| Notification.SUB_Notification_SendToManager | none | Administration.Account, Notification.Notification |
| Notification.TEMP_Notifications_AllDelete | none | Notification.Notification |

## Top risks/unknowns in model understanding
- Some flows have behavioural actions without explicit entity name tokens (parser gap).
- Some pages have no explicit ShowPageAction evidence in exported flows.

## Navigation

- [DOMAIN.md](DOMAIN.md)
- [FLOWS.md](FLOWS.md) - module flow overview
- [flows/INDEX.abstract.md](flows/INDEX.abstract.md) - flow routing file
- [PAGES.md](PAGES.md) - module page overview
- [pages/INDEX.abstract.md](pages/INDEX.abstract.md) - page routing file
- [RESOURCES.md](RESOURCES.md)
- [INTERPRETATION.md](INTERPRETATION.md) - AI narrative layer
- Open collection abstracts first, then object overview files, and use stable JSON only when exact export-backed detail is required.

## Source Pointers

- Domain export: [domain-model.pseudo.txt](../../../../mendix-data-p05-mxcli-rerun/app-overview/cli_2026-03-18T20-53-14.243Z/modules/Notification/domain-model.pseudo.txt) and [domain-model.json](../../../../mendix-data-p05-mxcli-rerun/app-overview/cli_2026-03-18T20-53-14.243Z/modules/Notification/domain-model.json).
- Flow export: [flows.pseudo.txt](../../../../mendix-data-p05-mxcli-rerun/app-overview/cli_2026-03-18T20-53-14.243Z/modules/Notification/flows.pseudo.txt) and [flows.json](../../../../mendix-data-p05-mxcli-rerun/app-overview/cli_2026-03-18T20-53-14.243Z/modules/Notification/flows.json).
- Page export: [pages.pseudo.txt](../../../../mendix-data-p05-mxcli-rerun/app-overview/cli_2026-03-18T20-53-14.243Z/modules/Notification/pages.pseudo.txt) and [pages.json](../../../../mendix-data-p05-mxcli-rerun/app-overview/cli_2026-03-18T20-53-14.243Z/modules/Notification/pages.json).
- Resource export: [resources.pseudo.txt](../../../../mendix-data-p05-mxcli-rerun/app-overview/cli_2026-03-18T20-53-14.243Z/modules/Notification/resources.pseudo.txt) and [resources.json](../../../../mendix-data-p05-mxcli-rerun/app-overview/cli_2026-03-18T20-53-14.243Z/modules/Notification/resources.json).
- Use `DOMAIN.md` for entity shape, lifecycle, access rules, associations, and XPath summaries.
- Use `FLOWS.md` and `flows/INDEX.abstract.md` for flow routing and compact module-level flow context.
- Use `PAGES.md` and `pages/INDEX.abstract.md` for page routing and compact module-level page context.
- Use `RESOURCES.md` for constants, scheduled events, and supporting module resources.

## Cross-Module Dependencies

- Calls to: Inspection
- Called by: Inspection
- Shared entities via associations: Administration

## Source

- Export module: Notification
- Run folder: cli_2026-03-18T20-53-14.243Z
