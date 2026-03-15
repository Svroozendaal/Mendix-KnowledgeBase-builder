---
name: mendix-overview-module-interpretation
description: Enrich per-module KB docs with domain stories and flow explanations after pipeline compose.
---

# MENDIX OVERVIEW MODULE INTERPRETATION

## Context

The pipeline has already composed per-module files with export-backed data, pointer bundles, and evidence blocks. This skill guides the AI to add business context without altering those deterministic sections.

## Scope

Enrich **custom modules only**. Skip marketplace and system modules unless they have significant custom behaviour (check the module category in `ROUTING.md`).

## Source data to read

For each custom module, from `mendix-data/app-overview/<run-folder>/modules/<Name>/`:
- `domain-model.pseudo.txt` - entities, attributes, associations, access rules
- `flows.pseudo.txt` - flow graphs with nodes, actions, decisions
- `pages.pseudo.txt` - page layouts, widgets, data sources
- `resources.pseudo.txt` - constants, scheduled events

Read the KB module files in this order:
- `README.md` - compact summary, navigation hub, and source pointers
- `DOMAIN.md` - entity shape, lifecycle matrix, and access rules
- `FLOWS.md` - flow catalogue with L0/L1/L2 links in the Flow Links table
- `flows/INDEX.abstract.md` - collection L0 abstract listing all flows with tier ranking
- Individual L1 flow overviews (`flows/<slug>.overview.md`) - for Tier 1 flows only
- `PAGES.md` - page inventory with L0/L1/L2 links in the Page Links table
- `pages/INDEX.abstract.md` - collection L0 abstract listing all pages
- Individual L1 page overviews (`pages/<slug>.overview.md`) - as needed
- `INTERPRETATION.md` - the only writable file for module narratives

## Files to enrich

### `modules/<Name>/INTERPRETATION.md`

Add or refine narrative in these sections only:

#### `## Module Purpose`

Add:
1. **Purpose statement**: One paragraph describing what this module does in business terms. Infer from entity names, flow prefixes, and page names.
2. **What this module does**: 2-3 concise bullets summarising the key capabilities.

Read `README.md` first for compact navigation and source pointers.

#### `## Domain Narrative`

Add an entity relationship narrative:
- Describe what the domain model represents in business terms
- Explain how entities relate to each other (use association data)
- Note any interesting patterns (e.g., "Registration acts as a many-to-many join between Trainee and TrainingEvent")

Read `DOMAIN.md` first and link back to entity names already present there.

#### `## Flow Narrative`

For each **Tier 1** flow in the summary/evidence set:
- Add a **Business intent** line: why does this flow exist? What user need does it serve?
- Add a **Business rule** line if the flow enforces validation or constraints
- Infer from flow name prefixes:
  - `ACT_` = user-triggered action
  - `VAL_` / `Rule_` = validation or business rule
  - `DS_` = data source for a page
  - `OCH_` = on-change handler
  - `ACO_` = after-commit handler
  - `BCO_` = before-commit handler

Read `FLOWS.md` for the Flow Links table, then use collection L0 (`flows/INDEX.abstract.md`) for triage, and L1 overviews (`flows/<slug>.overview.md`) for Tier 1 flow detail. Do not rewrite L0/L1 files, source links, IDs, or anchors.

#### `## Page Narrative`

Add a **User Journey Context** section:
- Group pages by user intent (what is the user trying to do?)
- Note which pages are entry points vs detail views vs popups

Read `PAGES.md` for inventory, then use collection L0 (`pages/INDEX.abstract.md`) and L1 overviews (`pages/<slug>.overview.md`) for datasource/navigation detail. Do not rewrite L0/L1 files, source links, navigation provenance, or page anchors.

## Rules

- Never remove existing export-backed content (tables, counts, markers)
- Never change required headings (quality gate checks these)
- Never edit `README.md`, `DOMAIN.md`, `FLOWS.md`, `PAGES.md`, or `RESOURCES.md`
- Never edit L0 abstract or L1 overview files (`flows/*.abstract.md`, `flows/*.overview.md`, `pages/*.abstract.md`, `pages/*.overview.md`)
- Never rewrite anchors, IDs, or source artefact links
- Always mark AI-added content with `Confidence: Inferred`
- Use explicit `none` markers when data is empty
- Cite entity/flow names as evidence for inferences
- Work module-by-module; do not preload unrelated module pseudo exports
