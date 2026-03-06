# KB Composer Specification

## Objective

Specify deterministic markdown composition rules for `run-kb-compose.ps1`.

## Inputs

1. `<run-folder>/manifest.json`
2. `<run-folder>/general/*.json`
3. `<run-folder>/modules/<Module>/{domain-model,flows,pages,resources}.json`
4. `-AppName`, `-OutputRoot`

## Outputs

Writes all required KB markdown files under:

`mendix-data/knowledge-base/<app-name>/`

## Core Composition Steps

1. Validate source:
   - `schemaVersion == "2.0"`
   - required input files exist.
2. Discover module set from manifest.
3. Build in-memory model:
   - module metadata
   - entity inventory and persistability
   - flow graph and call graph
   - page inventory and parameters
   - resources.
4. Derive evidence maps:
   - `Page -> ShownByFlows`
   - `Flow -> Calls`, `Flow -> CalledBy`
   - `Flow -> TouchedEntities`
   - `Entity -> Create/Read/Update/Delete flows`.
5. Assign flow tiers for custom modules.
6. Render app docs, module docs, and route docs.
7. Write `READER.md` and `ROUTING.md`.

## Derivation Rules

### Page-flow links

Detect from flow node labels/details containing:

`show page <Module.Page>`

### Entity touch map

Use known entity set and node text evidence:

1. `create <Module.Entity>` -> create
2. `retrieve ... from <Module.Entity>` -> read
3. `change/commit` with entity mention -> update
4. `delete` with entity mention -> delete.

### Cross-module calls

Use `callEdges` from flow exports:

1. outbound edges (`callerModule -> targetModule`)
2. inbound edges (`targetModule` called by others)
3. pair counts for dependency matrix.

## Custom Module Deep Coverage Rules

1. Apply tiered narratives only to modules categorised `Custom`.
2. Non-custom modules:
   - keep required headings
   - provide concise summaries
   - include dependency relevance.

## Required Sections (Must Never Be Omitted)

1. Keep all headings required by current quality gate.
2. Add richer sections as additive headings only.
3. When data is empty, use explicit `none` markers.

## Determinism Requirements

1. Stable sorting for all tables.
2. Stable tie-breakers in rankings.
3. No random IDs or unstable timestamps in content body except source metadata sections.

## Failure Behaviour

Composer must exit non-zero when:

1. source schema/version invalid
2. critical input files missing
3. cannot write required KB documents.

## Traceability

Each generated KB must include:

1. source run folder
2. generation timestamp
3. confidence marker usage in app-level docs.
