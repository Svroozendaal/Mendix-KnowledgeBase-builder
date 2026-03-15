# Knowledge Base Structural Gaps

This document identifies structural information gaps in the generated knowledge base that limit AI agent capabilities. These are not bugs — the current KB pipeline produces technically correct output. These gaps describe **missing data structures** that would enable richer, faster, and more accurate agent responses.

Each gap includes: what is missing, why it matters, and what a solution could look like.

---

## 1. Missing: Feature Index (`routes/by-feature.md`)

### Problem

The KB has no concept of "business features". All content is organised by technical artefact type: entities in `DOMAIN.md`, flows in `FLOWS.md`, pages in `PAGES.md`. When a user asks "How does budget management work?", agents must scan flow names, entity names, and module descriptions for keyword matches — a slow, imprecise process.

### Why it matters

The `KB Feature Interpreter` agent currently synthesises feature-level answers at query time by combining keyword matches from `routes/by-flow.md`, `routes/by-entity.md`, and module READMEs. This works but is slow (many file reads) and fragile (depends on naming conventions). A pre-computed feature index would make feature queries as fast as entity or flow lookups.

### What a solution could look like

A `routes/by-feature.md` file generated during the compose phase. Each row maps a business feature name to:
- The modules that implement it
- The entry flows (Tier 1 flows that start the feature)
- The key entities involved
- The pages that surface the feature

Feature names could be derived from:
- Flow name prefixes (e.g., all `Budget_` flows → "Budget Management" feature)
- README Capability Map groupings
- INTERPRETATION.md narrative sections (if enriched)
- Manual annotation via a feature mapping file in the source data

---

## 2. Missing: Flow Chain Index (`routes/flow-chains.md`)

### Problem

The `flow-chain-tracing` skill must recursively read L1 overviews to resolve call chains at query time. For a flow that calls 5 sub-flows, each of which calls 2 more, this means 15+ file reads before the agent can answer. The call graph data already exists in the KB (each L1 overview lists its Calls and Called By), but it is not pre-resolved into complete chains.

### Why it matters

The `KB Flow Tracer` agent traces call chains by recursively reading L1 overview files. This is correct but slow. A pre-resolved chain index would turn a recursive multi-file traversal into a single file read, dramatically improving response time for trace queries.

### What a solution could look like

A `routes/flow-chains.md` file generated during the compose phase. For each entry-point flow (Tier 1 flows with no callers, or flows called by pages/events), pre-resolve:
- The complete call tree (with depth)
- All entities touched across the chain
- All pages shown across the chain
- Module boundary crossings

The compose phase already has access to `CALL_GRAPH.md` and all L1 overviews, so the data is available — it just needs to be pre-aggregated.

---

## 3. Missing: Business Purpose per Flow

### Problem

L1 flow overviews list technical steps (retrieve X, decide Y, change Z, commit) but do not state what the flow accomplishes in business terms. A flow named `ACT_Transaction_Recalculate_all` has steps like "Retrieve all TransactionLine objects, iterate, change Amount, commit" — but nowhere does the KB state "This flow recalculates all transaction line amounts when the parent transaction's currency changes."

### Why it matters

The `KB Feature Interpreter` must infer business purpose from technical steps and flow names. This inference is unreliable for flows with generic names or complex logic. An explicit business purpose field would let agents give accurate, confident feature-level answers.

### What a solution could look like

Add a `Business Purpose` field to L1 overview files (or L0 abstracts). This could be:
- AI-generated during the enrichment phase (`/enrichkb`), using the flow's steps, entities, and context to infer a one-sentence business purpose
- Manually annotated by developers
- Derived from INTERPRETATION.md Flow Narrative section if enriched

The L0 abstract currently has a one-line summary, but it describes *what* the flow does technically, not *why* it exists from a business perspective.

---

## 4. Missing: Module-Level Feature Groupings

### Problem

The README Capability Map groups flows by naming prefix (e.g., `ACT_` → 12 flows, `DS_` → 8 flows, `SUB_` → 15 flows). This tells agents how many action flows vs. data source flows exist, but it does not group by business feature. A module might have `ACT_Budget_Create`, `ACT_Budget_Delete`, `ACT_Transaction_Import`, and `ACT_Transaction_Export` — all grouped under "ACT_" rather than separated into "Budget Management" and "Transaction Import/Export".

### Why it matters

When the `feature-search` skill scans README Capability Maps for keyword matches, it finds the prefix group ("ACT_") but cannot distinguish which ACT_ flows relate to which business feature without reading individual flow abstracts. Feature-level groupings in the README would enable faster, more precise feature search.

### What a solution could look like

Extend the README Capability Map to group by business feature prefix rather than (or in addition to) technical prefix. For example:
- `Budget_` → 5 flows (ACT_Budget_Create, DS_Budget_Overview, ...)
- `Transaction_` → 8 flows (ACT_Transaction_Import, ACT_Transaction_Export, ...)

This could be generated during compose by analysing the second segment of flow names (after the technical prefix) to identify feature clusters.

---

## 5. Missing: Structured INTERPRETATION.md Content

### Problem

`INTERPRETATION.md` is designed as a flat narrative with sections: Module Purpose, Domain Narrative, Flow Narrative, Page Narrative. When enriched via `/enrichkb`, these sections contain free-text descriptions. This narrative format is good for human reading but difficult for agents to query programmatically.

### Why it matters

The `feature-search` skill currently scans INTERPRETATION.md for keyword matches in free text. This works for simple keywords but fails for structured queries like "which flows handle error cases?" or "what entities are optional?" A structured format would enable precise, targeted queries.

### What a solution could look like

Add structured subsections within INTERPRETATION.md:
- **Domain Narrative**: Keep as free text, but add a structured "Entity Purpose Map" table (`| Entity | Business Purpose | Lifecycle Summary |`)
- **Flow Narrative**: Keep as free text, but add a structured "Flow Purpose Map" table (`| Flow | Business Purpose | Trigger | End Result |`)
- **Page Narrative**: Keep as free text, but add a structured "Page Purpose Map" table (`| Page | Business Purpose | Primary Action |`)

The `/enrichkb` skill could generate both the narrative and the structured tables.

---

## 6. Missing: Entity Association Context in Route Index

### Problem

`routes/by-entity.md` lists each entity with its CRUD flows and shown-on pages, but does not include association information. To find an entity's associations, agents must read the module's `DOMAIN.md` file. This means the `impact-analysis` skill requires an extra file read per entity to assess association-level blast radius.

### Why it matters

Entity changes often cascade through associations. If `Transaction` has a 1-* association to `TransactionLine`, changing `Transaction` affects all `TransactionLine` flows too. Without association data in the route index, the `impact-analysis` skill must read DOMAIN.md for every entity in the affected set — multiplying file reads.

### What a solution could look like

Add an "Associations" column to `routes/by-entity.md`:
```
| Entity | Module | Create | Read | Update | Delete | Shown on pages | Associations |
```

The Associations column would list association partners with cardinality (e.g., `TransactionLine (1-*)`, `Currency (*-1)`). This data is already available in DOMAIN.md and could be extracted during compose.

---

## 7. Missing: Page Navigation Context in Route Index

### Problem

`routes/by-flow.md` has a "Shows Pages" column that lists which pages a flow opens, but it does not distinguish the navigation type: does the flow open a new page, show a popup, close the current page, or navigate back? This distinction matters for understanding user journey flows.

### Why it matters

The `KB UX Interpreter` and `KB Flow Tracer` agents cannot distinguish between a flow that opens a detail page (user navigates forward) and one that shows an error popup (user stays on current page). This makes it difficult to reconstruct the actual user navigation path through the application.

### What a solution could look like

Add a navigation type qualifier to the "Shows Pages" column in `routes/by-flow.md`:
- `PageName (navigate)` — opens as a new page
- `PageName (popup)` — shows as a modal/popup
- `PageName (close)` — closes the current page
- `PageName (snippet)` — used as a snippet/widget

This data is available in the L2 JSON export (the ShowPage action type includes the navigation type) and could be extracted during the parser or compose phase.

---

## Priority Assessment

| Gap | Impact on Agent Quality | Implementation Effort | Recommended Priority |
|---|---|---|---|
| 1. Feature Index | High — enables fast feature queries | Medium — requires feature clustering logic | High |
| 2. Flow Chain Index | High — eliminates recursive file reads | Low — data already exists, just needs aggregation | High |
| 3. Business Purpose | Medium — improves feature synthesis accuracy | Medium — requires AI inference or manual input | Medium |
| 4. Feature Groupings | Medium — improves feature search precision | Low — naming convention analysis | Medium |
| 5. Structured INTERPRETATION | Medium — enables structured narrative queries | Medium — requires enrichment skill update | Medium |
| 6. Association in Routes | Medium — speeds up impact analysis | Low — extract from DOMAIN.md during compose | High |
| 7. Page Navigation Type | Low — improves UX interpretation only | Low — extract from L2 JSON during parse | Low |
