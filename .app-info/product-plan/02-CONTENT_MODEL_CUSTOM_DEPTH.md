# Content Model (Custom-Module Depth)

## Objective

Define the exact behaviour-first content model for KB generation with deep focus on `Custom` modules.

## Confidence Semantics

1. `Export-backed`: direct from export JSON fields.
2. `Inferred`: deterministic interpretation from naming or graph structure.
3. `Unknown`: information not derivable from available export artifacts.

Rule: `Unknown` may only be used when derivation is genuinely impossible.

## Behaviour-First Narrative Template

Use this template in custom flow and journey narratives:

1. Trigger or entry context.
2. Primary flow chain and branching.
3. Entity mutations (`create/read/update/delete`).
4. UI impact (shown pages or navigational outcomes).
5. Security/role constraints touched.
6. External dependencies (cross-module calls).
7. Known unknowns (if any).

## Tiered Flow-Depth Rules

### Tier 1 (deep narrative required)

A custom-module flow is Tier 1 if any condition matches:

1. Prefix is `ACT_`, `VAL_`, or `ACR_`.
2. Has inbound or outbound cross-module calls.
3. Shows at least one page.
4. Writes at least one persistent entity (create/change/commit/delete evidence).
5. Fan-in `>= 2` or fan-out `>= 2`.

### Tier 2 (concise behavioural summary)

A custom flow is Tier 2 if:

1. Not Tier 1, and
2. Has at least one action that affects entities, variables, or flow calls.

### Tier 3 (catalog-only)

A custom flow is Tier 3 if:

1. Not Tier 1 or Tier 2, and
2. Low behavioural impact utility/helper flow without UI or cross-module interaction.

Rule: all custom flows remain listed in catalogue tables; tier only controls narrative depth.

## Entity Lifecycle Model

For each custom entity:

1. `Create flows`
2. `Read flows`
3. `Update flows`
4. `Delete flows`
5. `Shown on pages`
6. `Role constraints`

Populate lifecycle matrix from flow action evidence plus domain access rules.

## Page Journey Model

For custom modules:

1. Inventory pages with roles/parameters.
2. Resolve `Page -> Shown by Flows` using show-page evidence.
3. Group pages into journey fragments by intent keywords:
   - budget
   - transaction
   - profile
   - admin
   - import
   - other.

## Capability Map Model (Custom README)

Include:

1. Capability clusters inferred from custom entity and flow naming.
2. Journey starters (entry flows/pages).
3. Module-level risks:
   - sparse metadata
   - weak linkage confidence
   - implicit business logic.

## Marketplace/System Coverage Model

1. Keep the same required file headings.
2. Provide concise inventory and dependency context.
3. Emphasise relevance to custom behaviours only.

## Unknowns Policy

Acceptable unknown classes:

1. Runtime-only behaviour not encoded in model export.
2. Scheduling semantics absent in event data.
3. Unresolvable parameter/variable typing due missing references.

Unacceptable unknowns:

1. Page-flow links when show-page evidence exists.
2. Flow touch-points when entity evidence exists.
3. Entity usage when direct references are present.
