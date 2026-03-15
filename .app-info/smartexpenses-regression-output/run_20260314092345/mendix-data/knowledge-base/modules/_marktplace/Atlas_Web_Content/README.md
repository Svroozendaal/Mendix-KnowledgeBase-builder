# Module: Atlas_Web_Content

Category: Marketplace
Module roles: Anonymous

## Summary

- Entities: 1
- Flows: 2
- Pages: 0
- Constants: 0

## Purpose

- Export-backed: module category and inventory from overview export.
- Inferred: module role is support capability.
- Deterministic fallback: This module appears to provide supporting capability for data such as login context and flows such as login and login context based on its exported entities, pages, flows, and resources.

## Capability Map

| Capability prefix | Flow count | Representative flow |
|---|---:|---|
| ACT | 1 | Atlas_Web_Content.ACT_Login |
| DS | 1 | Atlas_Web_Content.DS_LoginContext |

## Primary User Journeys

| Entry flow | UI result | Entities touched |
|---|---|---|
| Atlas_Web_Content.ACT_Login | none | none |
| Atlas_Web_Content.DS_LoginContext | none | Atlas_Web_Content.LoginContext |

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

- Domain export: [domain-model.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/Atlas_Web_Content/domain-model.pseudo.txt) and [domain-model.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/Atlas_Web_Content/domain-model.json).
- Flow export: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/Atlas_Web_Content/flows.pseudo.txt) and [flows.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/Atlas_Web_Content/flows.json).
- Page export: [pages.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/Atlas_Web_Content/pages.pseudo.txt) and [pages.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/Atlas_Web_Content/pages.json).
- Resource export: [resources.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/Atlas_Web_Content/resources.pseudo.txt) and [resources.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/Atlas_Web_Content/resources.json).
- Use `DOMAIN.md` for entity shape, lifecycle, access rules, associations, and XPath summaries.
- Use `FLOWS.md` and `flows/INDEX.abstract.md` for flow routing and compact module-level flow context.
- Use `PAGES.md` and `pages/INDEX.abstract.md` for page routing and compact module-level page context.
- Use `RESOURCES.md` for constants, scheduled events, and supporting module resources.

## Cross-Module Dependencies

- Calls to: none
- Called by: none
- Shared entities via associations: none

## Source

- Export module: Atlas_Web_Content
- Run folder: cli_2026-03-14T09-23-46.259Z
