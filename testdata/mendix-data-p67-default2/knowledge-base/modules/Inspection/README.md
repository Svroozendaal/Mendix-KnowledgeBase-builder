# Module: Inspection

Category: Custom
Module roles: Administrator, Anonymous, Inspector, Manager

## Summary

- Entities: 12
- Flows: 39
- Pages: 18
- Constants: 0

## Purpose

- Export-backed: module category and inventory from overview export.
- Inferred: module role is app-specific business behaviour.
- Deterministic fallback: This module appears to manage data such as accessory, booking, and cover photo, flows such as accessory create, assessory book, and assessory delete, pages such as edit equipment and emixa inspection app, and supporting configuration and runtime resources based on its exported entities, pages, flows, and resources.

## Capability Map

| Capability prefix | Flow count | Representative flow |
|---|---:|---|
| ACT | 20 | Inspection.ACT_Accessory_Create |
| BCO | 1 | Inspection.BCo_Inspector |
| CAL | 2 | Inspection.CAL_Inspector_TasksOpen |
| DS | 4 | Inspection.DS_Booking_RetrieveUpcomming |
| DSL | 1 | Inspection.DSL_Inspector_Selectable |
| OCH | 1 | Inspection.OCH_Task_Refresh |
| SE | 2 | Inspection.SE_Booking_DeleteOlderThenToday |
| SUB | 4 | Inspection.SUB_Accessory_Order |
| VAL | 4 | Inspection.VAL_Inspector_Validate |

## Primary User Journeys

| Entry flow | UI result | Entities touched |
|---|---|---|
| Inspection.ACT_Accessory_Create | Inspection.Assessory_NewEdit | Inspection.Accessory |
| Inspection.ACT_Assessory_Book | none | Unknown |
| Inspection.ACT_Assessory_Delete | none | Unknown |
| Inspection.ACT_CoverPhoto_Create | Inspection.CoverPhoto_NewEdit | Inspection.CoverPhoto |
| Inspection.ACT_CoverPhoto_Save | none | Unknown |
| Inspection.ACT_Inspector_Save | none | Unknown |
| Inspection.ACT_InspectorPhoto_Create | Inspection.InspectorPhoto_NewEdit | Inspection.InspectorPhoto |
| Inspection.ACT_Registration_Create | Inspection.Registration_NewEdit | Inspection.Registration |

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

- Domain export: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-18T21-15-38.461Z/modules/Inspection/domain-model.pseudo.txt) and [domain-model.json](../../../app-overview/cli_2026-03-18T21-15-38.461Z/modules/Inspection/domain-model.json).
- Flow export: [flows.pseudo.txt](../../../app-overview/cli_2026-03-18T21-15-38.461Z/modules/Inspection/flows.pseudo.txt) and [flows.json](../../../app-overview/cli_2026-03-18T21-15-38.461Z/modules/Inspection/flows.json).
- Page export: [pages.pseudo.txt](../../../app-overview/cli_2026-03-18T21-15-38.461Z/modules/Inspection/pages.pseudo.txt) and [pages.json](../../../app-overview/cli_2026-03-18T21-15-38.461Z/modules/Inspection/pages.json).
- Resource export: [resources.pseudo.txt](../../../app-overview/cli_2026-03-18T21-15-38.461Z/modules/Inspection/resources.pseudo.txt) and [resources.json](../../../app-overview/cli_2026-03-18T21-15-38.461Z/modules/Inspection/resources.json).
- Use `DOMAIN.md` for entity shape, lifecycle, access rules, associations, and XPath summaries.
- Use `FLOWS.md` and `flows/INDEX.abstract.md` for flow routing and compact module-level flow context.
- Use `PAGES.md` and `pages/INDEX.abstract.md` for page routing and compact module-level page context.
- Use `RESOURCES.md` for constants, scheduled events, and supporting module resources.

## Cross-Module Dependencies

- Calls to: Notification
- Called by: Notification
- Shared entities via associations: Administration

## Source

- Export module: Inspection
- Run folder: cli_2026-03-18T21-15-38.461Z
