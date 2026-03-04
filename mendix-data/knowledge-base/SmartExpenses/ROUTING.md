# Knowledge Base Routing

## How to use this knowledge base

1. Start here to find the right document for your question.
2. Follow pointers to app-level or module-level files.
3. Use route indexes in `routes/` for cross-cutting lookups across modules.
4. See [READER.md](READER.md) for detailed navigation instructions and confidence level definitions.

## Quick Lookup

| Question Type | Start Here |
|---------------|------------|
| What does this app do? | [app/APP_OVERVIEW.md](app/APP_OVERVIEW.md) |
| What modules exist? | [app/MODULE_LANDSCAPE.md](app/MODULE_LANDSCAPE.md) |
| Who can access what? | [app/SECURITY.md](app/SECURITY.md) |
| How do modules connect? | [app/CALL_GRAPH.md](app/CALL_GRAPH.md) |
| What does SmartExpenses do? | [modules/SmartExpenses/README.md](modules/SmartExpenses/README.md) |
| What does ImporterHelper do? | [modules/ImporterHelper/README.md](modules/ImporterHelper/README.md) |
| What entities exist in SmartExpenses? | [modules/SmartExpenses/DOMAIN.md](modules/SmartExpenses/DOMAIN.md) |
| What entities exist in ImporterHelper? | [modules/ImporterHelper/DOMAIN.md](modules/ImporterHelper/DOMAIN.md) |
| What flows exist in SmartExpenses? | [modules/SmartExpenses/FLOWS.md](modules/SmartExpenses/FLOWS.md) |
| What flows exist in ImporterHelper? | [modules/ImporterHelper/FLOWS.md](modules/ImporterHelper/FLOWS.md) |
| What pages exist? | [modules/SmartExpenses/PAGES.md](modules/SmartExpenses/PAGES.md), [modules/ImporterHelper/PAGES.md](modules/ImporterHelper/PAGES.md) |
| Find all flows that use entity Y | [routes/by-entity.md](routes/by-entity.md) |
| Find all flows that show page Z | [routes/by-page.md](routes/by-page.md) |
| Find what flow X calls | [routes/by-flow.md](routes/by-flow.md) |
| Which modules depend on each other? | [routes/cross-module.md](routes/cross-module.md) |

## Module Index

| Module | Category | Quick Link |
|--------|----------|------------|
| SmartExpenses | Custom | [README](modules/SmartExpenses/README.md) |
| ImporterHelper | Custom | [README](modules/ImporterHelper/README.md) |

## Completeness

- App-level: complete (4/4 files)
- Modules documented: 2/2 selected modules (SmartExpenses, ImporterHelper)
- Known gaps: none for documented modules. 16 additional modules exist in the app but were not selected for detailed export.

## Source

- Generated from: mendix-data/app-overview/cli-test-v2
- Generated at: 2026-03-03T20:58:20Z
- Schema version: 2.0
