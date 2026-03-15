# Module: New_Module

Category: Custom
Module roles: ModuleRole

## Summary

- Entities: 5
- Flows: 2
- Pages: 1
- Constants: 0

## Purpose

- Export-backed: module category and inventory from overview export.
- Inferred: module role is app-specific business behaviour.
- Deterministic fallback: This module appears to manage data such as entity2, entity3assossiatatedwith entity2, and entity5, flows such as aco new and bco new, and pages such as pagina test based on its exported entities, pages, flows, and resources.

## Capability Map

| Capability prefix | Flow count | Representative flow |
|---|---:|---|
| ACO | 1 | New_Module.ACO_new |
| BCO | 1 | New_Module.BCO_new |

## Primary User Journeys

| Entry flow | UI result | Entities touched |
|---|---|---|
| none | none | none |

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

- Domain export: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/New_Module/domain-model.pseudo.txt) and [domain-model.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/New_Module/domain-model.json).
- Flow export: [flows.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/New_Module/flows.pseudo.txt) and [flows.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/New_Module/flows.json).
- Page export: [pages.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/New_Module/pages.pseudo.txt) and [pages.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/New_Module/pages.json).
- Resource export: [resources.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/New_Module/resources.pseudo.txt) and [resources.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/New_Module/resources.json).
- Use `DOMAIN.md` for entity shape, lifecycle, access rules, associations, and XPath summaries.
- Use `FLOWS.md` and `flows/INDEX.abstract.md` for flow routing and compact module-level flow context.
- Use `PAGES.md` and `pages/INDEX.abstract.md` for page routing and compact module-level page context.
- Use `RESOURCES.md` for constants, scheduled events, and supporting module resources.

## Cross-Module Dependencies

- Calls to: none
- Called by: none
- Shared entities via associations: none

## Source

- Export module: New_Module
- Run folder: cli_2026-03-14T09-23-46.259Z
