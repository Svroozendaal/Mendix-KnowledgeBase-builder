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
- [FLOWS.md](FLOWS.md)
- [PAGES.md](PAGES.md)
- [RESOURCES.md](RESOURCES.md)

## Cross-Module Dependencies

- Calls to: none
- Called by: Sales
- Shared entities via associations: Sales

## Source

- Export module: Support
- Run folder: cli_reference_minimal
