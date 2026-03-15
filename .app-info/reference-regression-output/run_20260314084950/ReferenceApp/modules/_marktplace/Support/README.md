# Module: Support

Category: Marketplace
Module roles: Support.Operator

## Summary

- Entities: 1
- Flows: 1
- Pages: 0
- Constants: 0

## Purpose

- Export-backed: module category and inventory from overview export.
- Inferred: module role is support capability.
- Unknown: product-owner intent text is not included in export.

## Capability Map

| Capability prefix | Flow count | Representative flow |
|---|---:|---|
| SUB | 1 | Support.SUB_HandleOrder |

## Primary User Journeys

| Entry flow | UI result | Entities touched |
|---|---|---|
| support module | n/a | dependency-focused summary |

## Top risks/unknowns in model understanding
- No major derivation gaps detected for this module.

## Navigation

- [DOMAIN.md](DOMAIN.md)
- [FLOWS.md](FLOWS.md) - module flow overview
- [flows/INDEX.abstract.md](flows/INDEX.abstract.md) - flow routing file
- [PAGES.md](PAGES.md) - module page overview
- [pages/INDEX.abstract.md](pages/INDEX.abstract.md) - page routing file
- [RESOURCES.md](RESOURCES.md)
- [INTERPRETATION.md](INTERPRETATION.md) - AI narrative layer
- Use collection abstracts first, object overviews second, and stable JSON only when exact export-backed detail is required.

## Source Pointers

- Domain export: none and [domain-model.json](../../../../../../../tests/reference/app-overview/cli_reference_minimal/modules/Support/domain-model.json).
- Flow export: none and [flows.json](../../../../../../../tests/reference/app-overview/cli_reference_minimal/modules/Support/flows.json).
- Page export: none and [pages.json](../../../../../../../tests/reference/app-overview/cli_reference_minimal/modules/Support/pages.json).
- Resource export: none and [resources.json](../../../../../../../tests/reference/app-overview/cli_reference_minimal/modules/Support/resources.json).
- Ask DOMAIN.md for entity shape, lifecycle, access rules, associations, and XPath summaries.
- Ask FLOWS.md and lows/INDEX.abstract.md for flow routing and compact module-level flow context.
- Ask PAGES.md and pages/INDEX.abstract.md for page routing and compact module-level page context.
- Ask RESOURCES.md for constants, scheduled events, and supporting module resources.

## Cross-Module Dependencies

- Calls to: none
- Called by: Sales
- Shared entities via associations: Sales

## Source

- Export module: Support
- Run folder: cli_reference_minimal
