# Knowledge Base Routing

## Quick lookup

| Question type | Start here |
|---|---|
| What does the app do? | [app/APP_OVERVIEW.md](app/APP_OVERVIEW.md) |
| Which modules matter most? | [app/MODULE_LANDSCAPE.md](app/MODULE_LANDSCAPE.md) |
| Who can access what? | [app/SECURITY.md](app/SECURITY.md) |
| How modules connect | [app/CALL_GRAPH.md](app/CALL_GRAPH.md) |
| Entity-level lookup | [routes/by-entity.md](routes/by-entity.md) |
| Page-level lookup | [routes/by-page.md](routes/by-page.md) |
| Flow-level lookup | [routes/by-flow.md](routes/by-flow.md) |
| Cross-module dependencies | [routes/cross-module.md](routes/cross-module.md) |
| Exact microflow body | [routes/by-flow.md](routes/by-flow.md) |
| Exact retrieve or XPath evidence | [routes/by-flow.md](routes/by-flow.md) |
| Why a page opens | [routes/by-page.md](routes/by-page.md) |

## Module index

| Module | Category | Complexity | Quick link |
|---|---|---:|---|
| Sales | Custom | 8 | [README](modules/Sales/README.md) |
| Support | Marketplace | 5 | [README](modules/_marktplace/Support/README.md) |

## Completeness

- App-level status: generated
- Module count: 2
- Custom module flows: 2
- Tier 1 custom flows: 2
- Cross-module call edges: 1
- Derived page-flow links: 1
- Known gaps: none

## Deep lookup

- Open a route index or module collection abstract first.
- Open the object overview second.
- Open the stable L2 JSON under `app-overview/current/...` only when exact verification is required.
- If L1 and L2 differ, trust L2.

## Source

- Generated at: 2026-03-05T00:00:00Z
- Run folder: tests/reference/app-overview/cli_reference_minimal
