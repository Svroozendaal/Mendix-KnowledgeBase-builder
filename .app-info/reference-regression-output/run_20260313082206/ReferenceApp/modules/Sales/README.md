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
- Unknown: product-owner intent text is not included in export.

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
- No major derivation gaps detected for this module.

## Navigation

- [DOMAIN.md](DOMAIN.md)
- [FLOWS.md](FLOWS.md)
- [PAGES.md](PAGES.md)
- [RESOURCES.md](RESOURCES.md)

## Cross-Module Dependencies

- Calls to: Support
- Called by: none
- Shared entities via associations: Support

## Source

- Export module: Sales
- Run folder: cli_reference_minimal
