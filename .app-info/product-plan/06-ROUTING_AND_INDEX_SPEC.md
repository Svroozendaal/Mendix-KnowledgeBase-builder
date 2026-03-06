# Routing and Index Specification

## Objective

Define deterministic synthesis rules for routing and cross-reference indexes.

## Files Covered

1. `ROUTING.md`
2. `routes/by-entity.md`
3. `routes/by-page.md`
4. `routes/by-flow.md`
5. `routes/cross-module.md`

## ROUTING.md Rules

Must include:

1. Quick lookup matrix for question types.
2. Module index with category and links.
3. Completeness section:
   - app-level status
   - module count
   - known gaps.
4. Source section with run folder and generated time.

Known gap policy:

1. Never report `Known gaps: none` if unresolved `Unknown` values remain for required derivable custom-module fields.

## Entity Index Rules (`by-entity.md`)

For each entity:

1. `Entity` fully qualified name.
2. `Module` linked to `DOMAIN.md`.
3. `Used by Flows`:
   - list flow names with evidence-based links where possible.
4. `Shown on Pages`:
   - pages where entity appears as parameter/evidence.

Sort order:

1. alphabetical by qualified entity name.

## Page Index Rules (`by-page.md`)

For each page:

1. `Page` qualified name.
2. `Title`.
3. `Module` link to `PAGES.md`.
4. `Shown by Flows` from show-page evidence.
5. `Roles`.
6. `Parameters`.

Sort order:

1. alphabetical by qualified page name.

## Flow Index Rules (`by-flow.md`)

For each flow:

1. `Flow` as `Module.Flow`.
2. `Type`.
3. `Module` link to `FLOWS.md`.
4. `Calls`.
5. `Called by`.
6. `Shows Pages`.
7. `Touches Entities`.

Custom-module rule:

1. Avoid `Unknown` in `Shows Pages` and `Touches Entities` when derivable from evidence.

## Cross-Module Rules (`cross-module.md`)

Must include:

1. Dependency matrix (`Source -> Target`) with:
   - flow call count
   - association link count.
2. `Hub Modules` section.
3. `Leaf Modules` section.
4. `Association Links` table.
5. `Custom Module Boundary` notes:
   - external callers of custom modules
   - external targets called by custom modules.

## Link and Integrity Constraints

1. All links must resolve relative to KB root.
2. No placeholder links (`modules/X/...`).
3. Every routed item must trace to a module-level source file.
