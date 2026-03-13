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

## Files to enrich

### `modules/<Name>/README.md`

The compose script writes "Unknown: product-owner intent text is not included in export" under Purpose. Replace this with:

1. **Purpose statement**: One paragraph describing what this module does in business terms. Infer from entity names (e.g., Course, Registration, TrainingEvent = training management), flow prefixes (ACT_ = user actions, VAL_ = validations), and page names.

2. **What this module does**: 2-3 bullet points summarising the key capabilities. Example:
   - Allows administrators to create and manage training courses
   - Enables trainees to register for scheduled training events
   - Tracks registration counts and validates capacity

Write only in `## Interpretation`.

### `modules/<Name>/DOMAIN.md`

Add an **Entity Relationship Narrative** section after the entity tables:
- Describe what the domain model represents in business terms
- Explain how entities relate to each other (use association data)
- Note any interesting patterns (e.g., "Registration acts as a many-to-many join between Trainee and TrainingEvent")

Write only in `## Domain Interpretation`. Read `## Entity Evidence` first and link back to entity names already present there.

### `modules/<Name>/FLOWS.md`

For each **Tier 1** flow in the Deep Narratives section:
- Add a **Business intent** line: why does this flow exist? What user need does it serve?
- Add a **Business rule** line if the flow enforces validation or constraints
- Infer from flow name prefixes:
  - `ACT_` = user-triggered action
  - `VAL_` / `Rule_` = validation or business rule
  - `DS_` = data source for a page
  - `OCH_` = on-change handler
  - `ACO_` = after-commit handler
  - `BCO_` = before-commit handler

Write only in `## Flow Interpretation`. Read `## Flow Evidence` first; do not rewrite flow evidence bullets, source links, IDs, anchors, or pseudocode.

### `modules/<Name>/PAGES.md`

Add a **User Journey Context** section:
- Group pages by user intent (what is the user trying to do?)
- Note which pages are entry points vs detail views vs popups

Write only in `## Page Interpretation`. Read `## Page Evidence` first; do not rewrite source links, navigation provenance, or page anchors.

## Rules

- Never remove existing export-backed content (tables, counts, markers)
- Never change required headings (quality gate checks these)
- Never edit `## Source Pointers`, `## Entity Evidence`, `## Flow Evidence`, or `## Page Evidence`
- Never rewrite anchors, IDs, pseudocode, or source artefact links
- Always mark AI-added content with `Confidence: Inferred`
- Use explicit `none` markers when data is empty
- Cite entity/flow names as evidence for inferences
