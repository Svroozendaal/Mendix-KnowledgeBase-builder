# Module: ImporterHelper

Category: Custom
Module roles: ExcelImporter, RESTImporter

## Summary

- Entities: 3
- Flows: 7
- Pages: 3
- Constants: 1

## Purpose

- Export-backed: module category and inventory from overview export.
- Inferred: module role is app-specific business behaviour.
- Deterministic fallback: This module appears to manage data such as excel file import, import transaction, and import transaction helper, flows such as excel file import create, excel file import import to np, and import transaction accept transactions, pages such as excel file import upload and pas transactie aan, and supporting configuration and runtime resources based on its exported entities, pages, flows, and resources.

## Capability Map

| Capability prefix | Flow count | Representative flow |
|---|---:|---|
| ACT | 5 | ImporterHelper.ACT_ExcelFileImport_Create |
| CWS | 1 | ImporterHelper.CWS_GetProducts |
| SUB | 1 | ImporterHelper.SUB_ImportTemplateDocument |

## Primary User Journeys

| Entry flow | UI result | Entities touched |
|---|---|---|
| ImporterHelper.ACT_ExcelFileImport_Create | ImporterHelper.ExcelFileImport_Upload | ImporterHelper.ExcelFileImport |
| ImporterHelper.ACT_ExcelFileImport_ImportToNP | none | Unknown |
| ImporterHelper.ACT_ImportTransaction_AcceptTransactions | none | SmartExpenses.Transaction |
| ImporterHelper.ACT_ImportTransaction_Refreshpage | none | Unknown |
| ImporterHelper.ACT_ImportTransaction_ShowPage | ImporterHelper.ImportTransaction_Overview | ImporterHelper.ImportTransactionHelper |

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

- Domain export: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-14T09-26-12.835Z/modules/ImporterHelper/domain-model.pseudo.txt) and [domain-model.json](../../../app-overview/cli_2026-03-14T09-26-12.835Z/modules/ImporterHelper/domain-model.json).
- Flow export: [flows.pseudo.txt](../../../app-overview/cli_2026-03-14T09-26-12.835Z/modules/ImporterHelper/flows.pseudo.txt) and [flows.json](../../../app-overview/cli_2026-03-14T09-26-12.835Z/modules/ImporterHelper/flows.json).
- Page export: [pages.pseudo.txt](../../../app-overview/cli_2026-03-14T09-26-12.835Z/modules/ImporterHelper/pages.pseudo.txt) and [pages.json](../../../app-overview/cli_2026-03-14T09-26-12.835Z/modules/ImporterHelper/pages.json).
- Resource export: [resources.pseudo.txt](../../../app-overview/cli_2026-03-14T09-26-12.835Z/modules/ImporterHelper/resources.pseudo.txt) and [resources.json](../../../app-overview/cli_2026-03-14T09-26-12.835Z/modules/ImporterHelper/resources.json).
- Use `DOMAIN.md` for entity shape, lifecycle, access rules, associations, and XPath summaries.
- Use `FLOWS.md` and `flows/INDEX.abstract.md` for flow routing and compact module-level flow context.
- Use `PAGES.md` and `pages/INDEX.abstract.md` for page routing and compact module-level page context.
- Use `RESOURCES.md` for constants, scheduled events, and supporting module resources.

## Cross-Module Dependencies

- Calls to: SmartExpenses
- Called by: none
- Shared entities via associations: none

## Source

- Export module: ImporterHelper
- Run folder: cli_2026-03-14T09-26-12.835Z
