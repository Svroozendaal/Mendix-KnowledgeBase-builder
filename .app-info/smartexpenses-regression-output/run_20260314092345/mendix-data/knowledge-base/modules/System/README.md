# Module: System

Category: System
Module roles: Administrator, User

## Summary

- Entities: 36
- Flows: 1
- Pages: 0
- Constants: 0

## Purpose

- Export-backed: module category and inventory from overview export.
- Inferred: module role is platform baseline.
- Deterministic fallback: This module appears to provide platform-level support for data such as consumed odata configuration, error, and file document and flows such as show home page based on its exported entities, pages, flows, and resources.

## Capability Map

| Capability prefix | Flow count | Representative flow |
|---|---:|---|
| OTHER | 1 | System.ShowHomePage |

## Primary User Journeys

| Entry flow | UI result | Entities touched |
|---|---|---|
| System.ShowHomePage | none | none |

## Top risks/unknowns in model understanding
- Some flows have behavioural actions without explicit entity name tokens (parser gap).

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

- Domain export: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.pseudo.txt) and [domain-model.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.json).
- Flow export: [flows.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/flows.pseudo.txt) and [flows.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/flows.json).
- Page export: [pages.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/pages.pseudo.txt) and [pages.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/pages.json).
- Resource export: [resources.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/resources.pseudo.txt) and [resources.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/resources.json).
- Use `DOMAIN.md` for entity shape, lifecycle, access rules, associations, and XPath summaries.
- Use `FLOWS.md` and `flows/INDEX.abstract.md` for flow routing and compact module-level flow context.
- Use `PAGES.md` and `pages/INDEX.abstract.md` for page routing and compact module-level page context.
- Use `RESOURCES.md` for constants, scheduled events, and supporting module resources.

## Cross-Module Dependencies

- Calls to: none
- Called by: none
- Shared entities via associations: none

## Source

- Export module: System
- Run folder: cli_2026-03-14T09-23-46.259Z
