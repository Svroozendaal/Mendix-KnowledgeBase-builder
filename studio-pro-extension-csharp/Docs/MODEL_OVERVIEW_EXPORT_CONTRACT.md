# Model Overview Export Contract

## Purpose

Defines full-model overview outputs produced by:

- `Processing/Services/AutoCommitMessageModelOverviewService.cs`
- `Processing/ModelDiff/MendixModelOverviewParser.cs`

Unlike diff export, overview export is inventory-centric and uses committed (`HEAD`) model state.

## Output location

Overview artefacts are written to:

- `<DataRoot>/app-overview/overviews/<run-folder>`

## Trigger modes

Overview generation modes:

- `App`
- `Modules`
- `Both`

Web actions:

- `generate-overview-app`
- `generate-overview-modules`
- `generate-overview-module`
- `generate-overview-both` (and alias `generate-overview`)

Module discovery action:

- `list-overview-modules`

## Run folder naming

Pattern:

`<UTC timestamp>_<repository token>_<guid>`

This allows multiple concurrent runs without collisions.

## Produced artefacts

Depending on mode and output flags:

- `app-overview.json`
- `app-overview.pseudo.txt`
- `modules/*.overview.json`
- `modules/*.overview.pseudo.txt`
- `modules/modules.index.json`
- `manifest.json`

If multiple `.mpr` files exist, artefacts can include a per-MPR token prefix.

## JSON overview shape (high level)

Top-level app overview fields:

- `schemaVersion`
- `generatedAtUtc`
- `sourceMprPath`
- `sourceDumpPath`
- `summary`
- `modules[]`
- `flowCallGraph[]`
- `appPseudocode`

`summary` includes counts for modules, entities, associations, enumerations, flow types, nodes, edges, and call edges.

`modules[]` includes:

- domain model inventory (`entities`, `associations`, `enumerations`)
- flow inventory (`microflow`, `nanoflow`, `rule`, `workflow`)

Flow records include:

- node inventory
- edge inventory
- detected flow calls
- start node IDs
- deterministic primary execution order
- pseudocode rendering

## Flow ordering contract

Execution order is graph-based:

1. Start from `StartEvent` nodes (fallback to nodes without incoming edges).
2. Traverse `SequenceFlow(origin -> destination)` in deterministic order.
3. Preserve branch and loop structure.
4. Emit:
   - `primaryExecutionOrderNodeIds`
   - pseudocode text for human/AI review.

## Module list contract (`list-overview-modules`)

Response includes:

- `appName`
- `mprFileCount`
- `moduleCount`
- `modules[]` where each item contains:
  - `name`
  - `sourceMprPath`
  - `category` (`System`, `Marketplace`, `Custom`)
  - `appName`
- `generatedAtUtc`

## Manifest contract

Each run writes `manifest.json` with:

- `schemaVersion`
- `generatedAtUtc`
- `mode`
- `selectedModules`
- `includeStructuredOutput`
- `includePseudocodeOutput`
- `artifactCount`
- `artifacts[]` (`type`, `path`)

## Compatibility notes

- Overview export is additive; raw diff export remains separate.
- Consumers must treat unknown fields as forward-compatible.
- Module filtering is case-insensitive from request input.

## Improvement opportunities

- Publish dedicated overview JSON Schema.
- Add stable run ID for cross-pipeline correlation.
- Add overview regression tests with reference dumps and expected call graphs.

