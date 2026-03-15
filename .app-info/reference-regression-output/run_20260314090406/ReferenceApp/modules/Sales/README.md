# Module: Sales

Category: Custom
Module roles: Sales.Admin, Sales.User

## Summary

- Entities: 1
- Flows: 2
- Pages: 1
- Constants: 1

## Purpose

- Export-backed: module category and inventory from overview export.
- Inferred: module role is app-specific business behaviour.
- Deterministic fallback: This module appears to manage data such as o rd er, flows such as o rd er c he ck and o rd er c re at e, pages such as o rd er n ew/e di t, and supporting configuration and runtime resources based on its exported entities, pages, flows, and resources.

## Capability Map

| Capability prefix | Flow count | Representative flow |
|---|---:|---|
| ACT | 1 | Sales.ACT_Order_Create |
| VAL | 1 | Sales.VAL_Order_Check |

## Primary User Journeys

| Entry flow | UI result | Entities touched |
|---|---|---|
| Sales.ACT_Order_Create | Sales.Order_NewEdit | Sales.Order |
| Sales.VAL_Order_Check | none | Sales.Order |

## Top risks/unknowns in model understanding
- No material export interpretation gaps were detected for this module.

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

- Domain export: none and [domain-model.json](../../../../../../tests/reference/app-overview/cli_reference_minimal/modules/Sales/domain-model.json).
- Flow export: none and [flows.json](../../../../../../tests/reference/app-overview/cli_reference_minimal/modules/Sales/flows.json).
- Page export: none and [pages.json](../../../../../../tests/reference/app-overview/cli_reference_minimal/modules/Sales/pages.json).
- Resource export: none and [resources.json](../../../../../../tests/reference/app-overview/cli_reference_minimal/modules/Sales/resources.json).
- Use `DOMAIN.md` for entity shape, lifecycle, access rules, associations, and XPath summaries.
- Use `FLOWS.md` and `flows/INDEX.abstract.md` for flow routing and compact module-level flow context.
- Use `PAGES.md` and `pages/INDEX.abstract.md` for page routing and compact module-level page context.
- Use `RESOURCES.md` for constants, scheduled events, and supporting module resources.

## Cross-Module Dependencies

- Calls to: Support
- Called by: none
- Shared entities via associations: Support

## Source

- Export module: Sales
- Run folder: cli_reference_minimal
