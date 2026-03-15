# Module: SmartExpenses

Category: Custom
Module roles: Admin, Anonymous, Parent, User

## Summary

- Entities: 10
- Flows: 39
- Pages: 29
- Constants: 0

## Purpose

- Export-backed: module category and inventory from overview export.
- Inferred: module role is app-specific business behaviour.
- Deterministic fallback: This module appears to manage data such as balance, budget term, and budget type, flows such as acr fbgprofile set standard budgets, balance create, and balance new/edit, and pages such as balance overview and edit balance based on its exported entities, pages, flows, and resources.

## Capability Map

| Capability prefix | Flow count | Representative flow |
|---|---:|---|
| ACR | 1 | SmartExpenses.ACR_FBGProfile_setStandardBudgets |
| ACT | 17 | SmartExpenses.ACT_Balance_Create |
| BCO | 1 | SmartExpenses.BCO_Transaction |
| BD | 1 | SmartExpenses.BD_Transaction |
| DS | 5 | SmartExpenses.DS_BudgetTerm_New |
| OCH | 5 | SmartExpenses.OCH_BulkEditHelper_setBalance |
| OTHER | 1 | SmartExpenses.Nanoflow |
| SUB | 5 | SmartExpenses.SUB_Balance_Recalculate |
| VAL | 3 | SmartExpenses.VAL_Balance_NewEdit |

## Primary User Journeys

| Entry flow | UI result | Entities touched |
|---|---|---|
| SmartExpenses.ACR_FBGProfile_setStandardBudgets | none | SmartExpenses.BudgetTerm, SmartExpenses.BudgetType, SmartExpenses.StandardBudget |
| SmartExpenses.ACT_Balance_Create | SmartExpenses.Balance_NewEdit | SmartExpenses.Balance |
| SmartExpenses.ACT_Balance_NewEdit | none | Unknown |
| SmartExpenses.ACT_BudgetTerm_BudgetType_Edit | SmartExpenses.BudgetTerm_NewEdit | SmartExpenses.Logo |
| SmartExpenses.ACT_BudgetTerm_New | none | SmartExpenses.BudgetTerm |
| SmartExpenses.ACT_BudgetTerm_setStartdateOnInterval | none | Unknown |
| SmartExpenses.ACT_BudgetType_New | SmartExpenses.BudgetTerm_NewEdit | SmartExpenses.BudgetTerm, SmartExpenses.BudgetType, SmartExpenses.Logo |
| SmartExpenses.ACT_BudgetType_OpenOverviewPAge | SmartExpenses.BudgetType_Overview | Unknown |

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

- Domain export: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/domain-model.pseudo.txt) and [domain-model.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/domain-model.json).
- Flow export: [flows.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.pseudo.txt) and [flows.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.json).
- Page export: [pages.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/pages.pseudo.txt) and [pages.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/pages.json).
- Resource export: [resources.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/resources.pseudo.txt) and [resources.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/resources.json).
- Use `DOMAIN.md` for entity shape, lifecycle, access rules, associations, and XPath summaries.
- Use `FLOWS.md` and `flows/INDEX.abstract.md` for flow routing and compact module-level flow context.
- Use `PAGES.md` and `pages/INDEX.abstract.md` for page routing and compact module-level page context.
- Use `RESOURCES.md` for constants, scheduled events, and supporting module resources.

## Cross-Module Dependencies

- Calls to: none
- Called by: ImporterHelper
- Shared entities via associations: none

## Source

- Export module: SmartExpenses
- Run folder: cli_2026-03-14T09-23-46.259Z
