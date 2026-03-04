# How to Read This Knowledge Base

## What is this?

This is an AI-generated knowledge base describing a Mendix application. It was built from a structured model overview export and contains documentation about the application's modules, domain models, flows, pages, security, and cross-module dependencies.

## How to navigate

1. **Start at [ROUTING.md](ROUTING.md)** — the master navigation document. It tells you which file answers which question.
2. **App-level questions** — go to `app/` folder:
   - [APP_OVERVIEW.md](app/APP_OVERVIEW.md) — what the app is, summary stats, security level
   - [MODULE_LANDSCAPE.md](app/MODULE_LANDSCAPE.md) — all modules, their categories and complexity
   - [SECURITY.md](app/SECURITY.md) — who can access what, role mappings, XPath constraints
   - [CALL_GRAPH.md](app/CALL_GRAPH.md) — how modules connect through flow calls
3. **Module-specific questions** — go to `modules/<ModuleName>/`:
   - `README.md` — module summary and navigation
   - `DOMAIN.md` — entities, attributes, associations, access rules
   - `FLOWS.md` — microflows, nanoflows, what they do
   - `PAGES.md` — pages, layouts, allowed roles
   - `RESOURCES.md` — constants, scheduled events
4. **Cross-cutting lookups** — go to `routes/`:
   - [by-entity.md](routes/by-entity.md) — find all flows and pages related to an entity
   - [by-page.md](routes/by-page.md) — find which flows show a page
   - [by-flow.md](routes/by-flow.md) — find what a flow calls, who calls it, what it touches
   - [cross-module.md](routes/cross-module.md) — module dependency map

## How to answer questions

When answering a question about this application:

1. **Identify the scope**: Is it about the whole app, a specific module, a specific entity/flow/page?
2. **Find the right file**: Use ROUTING.md or the navigation above.
3. **Read the relevant section**: Files are structured with clear headings and tables.
4. **Cross-reference when needed**: Use route indexes to find connections across modules.
5. **Check confidence**: Each document marks whether content is export-backed (factual) or inferred (from naming patterns).

## Confidence levels

- **Export-backed**: Data comes directly from the Mendix model export. Treat as factual.
- **Inferred**: Derived from naming conventions (ACT_ = action flow, DS_ = data source, VAL_ = validation, SUB_ = sub-microflow, BCO_ = before commit, BD_ = before delete, OCH_ = on-change handler) or structural patterns. Treat as likely but verify if critical.
- **Unknown**: Data was not available in the export. Marked explicitly.

## Source

See `_sources/SOURCE_REF.md` for details about the export run that produced this KB.
