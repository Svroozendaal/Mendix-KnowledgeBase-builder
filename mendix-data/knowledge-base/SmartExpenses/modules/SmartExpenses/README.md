# Module: SmartExpenses

Category: Custom
Module roles: Admin, Anonymous, Parent, User

## Summary
- Entities: 10, Associations: 12, Enumerations: 6
- Flows: 42 (Microflows: 34, Nanoflows: 7, Workflows: 1)
- Pages: 29, Snippets: 1
- Constants: 0, Scheduled events: 0

## Purpose
SmartExpenses is the core business module implementing a **personal finance management system**. It provides:
- **Budget management**: budget types with configurable intervals (week/month/year), budget terms with amounts and date ranges
- **Balance tracking**: named balances linked to user profiles, with automatic recalculation
- **Transaction processing**: income/expenditure transactions with status tracking, bulk editing, and validation
- **User profiles (FBGProfile)**: per-user profile linking accounts to their budgets, balances, and transactions
- **Standard budgets**: template budgets that can be copied to new user profiles
- **Parent oversight**: read-only access for parent accounts to monitor linked profiles

## Navigation
- [DOMAIN.md](DOMAIN.md) — entities, associations, access rules
- [FLOWS.md](FLOWS.md) — microflows, nanoflows, call relationships
- [PAGES.md](PAGES.md) — pages, layouts, role access
- [RESOURCES.md](RESOURCES.md) — constants, scheduled events

## Cross-Module Dependencies
- Called by: ImporterHelper (ACT_ImportTransaction_AcceptTransactions -> SUB_Transaction_setStatus)
- Calls to: none (self-contained)
- Shared entities via associations: FBGProfile is referenced by ImporterHelper.ImportTransaction_Overview page parameters

## Source
- Export: mendix-data/app-overview/cli-test-v2/modules/SmartExpenses/
