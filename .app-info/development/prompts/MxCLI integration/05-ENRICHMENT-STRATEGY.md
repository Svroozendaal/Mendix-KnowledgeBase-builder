# Enrichment Strategy — Preservation & Enhancement

## Core Principle

The enrichment model is **completely preserved**. The mxcli integration only replaces the extraction layer — everything downstream (composition, enrichment, quality gates) continues to operate on the same static KB structure.

```
Extraction (CHANGED)  →  Composition (UNCHANGED)  →  Enrichment (UNCHANGED + ENHANCED)
    mxcli                   PowerShell/templates         AI agents
```

---

## What Enrichment Does Today

Enrichment is the AI-driven phase that adds **functional and business context** the deterministic pipeline cannot produce:

| Enrichment Target | File | What Gets Added |
|-------------------|------|-----------------|
| Module interpretation | `modules/<Mod>/INTERPRETATION.md` | Business purpose narrative: what the module does in business terms |
| Flow abstracts | `modules/<Mod>/flows/<slug>.abstract.md` | 3–5 line L0 summary: why this flow exists |
| Flow overviews | `modules/<Mod>/flows/<slug>.overview.md` | L1 narrative: business logic walkthrough |
| Page abstracts | `modules/<Mod>/pages/<slug>.abstract.md` | 3–5 line L0 summary: user-facing purpose |
| Page overviews | `modules/<Mod>/pages/<slug>.overview.md` | L1 narrative: UX flow and data bindings |
| Gap resolution | `_reports/UNKNOWN_TODO.md` | Fill gaps marked as "Unknown" during composition |
| App overview narrative | `app/APP_OVERVIEW.md` | Business context, architecture summary |

### How Enrichment Works

1. The composer creates markdown files with **structural facts** (entity names, flow steps, page layouts)
2. Enrichment agents read these files and the L2 JSON source data
3. They add **functional interpretation** — the "why" behind the "what"
4. They mark their additions with confidence markers:
   - **Export-backed** — derived directly from model data
   - **Inferred** — derived from naming patterns and structural analysis
   - **Unknown** — gap to be resolved

---

## Why Enrichment Is Not Affected

The enrichment agents operate on **the composed KB files**, not on the extraction artifacts. They read:
- `modules/<Mod>/DOMAIN.md` — entity descriptions to understand data model
- `modules/<Mod>/FLOWS.md` — flow summaries to understand behavior
- `modules/<Mod>/PAGES.md` — page structure to understand UX
- `routes/*` — cross-references to understand relationships
- `app-overview/<run>/` — L2 JSON for verification of facts

As long as the composer produces the **same markdown structure** from the JSON, enrichment sees no difference. And since the mxcli integration outputs **the same JSON v2.0 schema**, the composer doesn't change.

```
Today:    C# parser → JSON v2.0 → Composer → Markdown → Enrichment reads markdown
Tomorrow: mxcli     → JSON v2.0 → Composer → Markdown → Enrichment reads markdown
                      ↑ identical                        ↑ identical
```

---

## How mxcli Enhances Enrichment

While the enrichment model is preserved, mxcli provides **richer input data** that makes enrichment more effective:

### 1. Better Cross-References → Better Narratives

**Today:** The parser extracts `callEdges[]` from the dump, but relationships are limited to direct flow-to-flow calls. The enrichment agent must infer indirect relationships from naming patterns.

**With mxcli:** The `refs` catalog table captures **all** reference types:
- `call` — flow calls another flow
- `use` — page uses a flow as data source
- `reference` — entity referenced in access rule XPath
- `contains` — structural containment

Plus `SHOW CALLERS/CALLEES TRANSITIVE` gives the **full transitive call chain**, not just direct calls.

**Impact on enrichment:** When an agent writes `INTERPRETATION.md` for a module, it can now see the complete dependency graph. Instead of "this module seems to interact with OrderModule (inferred from naming)", it can say "this module calls OrderModule.ACT_CreateOrder and is called by DashboardModule.ACT_RefreshStats (export-backed)".

### 2. Activity-Level Detail → Better Flow Narratives

**Today:** Flow nodes have `label` and `detail` fields from the dump, which are often terse.

**With mxcli (Full mode):** The `activities` table provides `ActivityType`, `Caption`, `EntityRef`, and `ActionType` for every activity. Combined with `DESCRIBE MICROFLOW` (which produces readable MDL), the enrichment agent gets a much clearer picture of what each flow step does.

**Impact on enrichment:** L1 flow overviews become more precise. Instead of "Step 3: An action is performed on Customer", the agent can write "Step 3: Retrieves active Customers from database where Status='Active', filtered by the logged-in user's company".

### 3. XPath Analysis → Better Security Narratives

**Today:** XPath constraints are stored as raw strings in access rules. The enrichment agent must interpret them.

**With mxcli:** The `xpath_expressions` catalog table provides **parsed XPath ASTs**, `TargetEntity`, and `ReferencedEntities`. This gives the agent structured understanding of row-level security.

**Impact on enrichment:** The `SECURITY.md` narrative can explain "Users can only see Orders belonging to their Company (via Company_User association)" rather than just quoting the raw XPath.

### 4. Lint & Report Data → Quality Context

**Today:** Quality gates measure structural completeness (file existence, heading presence, link validity). Business quality is measured by semantic benchmark scenarios.

**With mxcli:** `mxcli lint` and `mxcli report` provide **architectural quality analysis** with 41 rules across security, naming, complexity, and design categories. This data can be fed into enrichment.

**Impact on enrichment:** `INTERPRETATION.md` can include quality observations: "This module has 3 security warnings (SEC002: missing access rules on Order entity) and 2 naming violations. Complexity score: 7.2/10."

### 5. Widget Inventory → Better Page Narratives

**Today:** Page data includes `dataSources` and `clientActions` but not detailed widget information.

**With mxcli (Full mode):** The `widgets` table catalogs every widget instance with type, entity binding, and attribute binding.

**Impact on enrichment:** L1 page overviews can describe the actual UI: "This page displays a DataGrid2 of Orders, with inline editing via TextBox widgets for Status and Notes, and a Save button that calls ACT_SaveOrder."

### 6. Workflow Coverage → New Enrichment Targets

**Today:** Workflows are counted but not detailed (the parser reports `workflowCount: 0` for apps without workflows, and has limited workflow parsing).

**With mxcli:** Full workflow metadata including activities, user tasks, decisions, and microflow calls.

**Impact on enrichment:** New enrichment target: `modules/<Mod>/WORKFLOWS.md` with L0/L1 abstracts for each workflow, explaining the business process they automate.

---

## New Enrichment Opportunities (Post-Integration)

These are **additive** — they don't replace existing enrichment but extend it:

| Opportunity | Source | New KB Content |
|-------------|--------|---------------|
| Architecture quality narrative | `mxcli report --format json` | Quality section in `APP_OVERVIEW.md` or new `app/QUALITY.md` |
| Security analysis | `SHOW SECURITY MATRIX` + `xpath_expressions` | Enhanced `SECURITY.md` with interpreted access patterns |
| Widget inventory | `CATALOG.widgets` (Full mode) | Widget summary in `PAGES.md` or new `modules/<Mod>/WIDGETS.md` |
| Workflow narratives | `CATALOG.workflows` | New `modules/<Mod>/WORKFLOWS.md` with L0/L1 abstracts |
| OData service docs | `CATALOG.odata_services` + `CATALOG.odata_clients` | New `modules/<Mod>/INTEGRATIONS.md` |
| Business events | `CATALOG.business_event_services` | New `modules/<Mod>/EVENTS.md` |
| Full-text search index | `CATALOG.strings` + `CATALOG.source` | Enhanced route files with search-optimized content |
| Database connections | `CATALOG.database_connections` | New `modules/<Mod>/CONNECTIONS.md` |
| Navigation map | `CATALOG.navigation_profiles` + `navigation_menu_items` | Enhanced `app/APP_OVERVIEW.md` navigation section |

---

## Migration Path

### Phase 1: Drop-In Replacement (No Enrichment Changes)
- mxcli produces JSON v2.0 → existing composer → existing enrichment
- Enrichment agents see identical KB structure
- Zero risk to enrichment quality

### Phase 2: Enhanced Extraction (Richer Input)
- Enable Full catalog mode → activities, widgets, refs, XPath data flows into JSON
- Existing v2.0 fields get richer data (more detailed activity labels, complete cross-references)
- Enrichment automatically benefits from richer L2 source data

### Phase 3: Extended KB Sections (New Enrichment Targets)
- Add new JSON files for workflows, OData, business events
- Add new composer templates for these sections
- Add new enrichment targets (WORKFLOWS.md, INTEGRATIONS.md, etc.)
- Existing enrichment untouched — new targets are additive

### Phase 4: Live Copilot Enhancement (Optional)
- Copilot can invoke mxcli commands alongside reading the enriched static KB
- Static KB remains the primary source for business/functional context
- mxcli provides real-time structural queries the static KB can't answer (e.g., "what changed since last KB generation?")

---

## Summary

| Aspect | Status |
|--------|--------|
| Existing enrichment model | **Preserved** — zero changes required |
| Enrichment input quality | **Enhanced** — richer L2 data from mxcli |
| New enrichment targets | **Available** — workflows, OData, widgets, quality |
| Enrichment agents | **Compatible** — read same KB structure |
| Risk to enrichment | **None** — extraction change is transparent to enrichment layer |
