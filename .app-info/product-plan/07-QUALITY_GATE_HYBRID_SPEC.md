# Quality Gate Hybrid Specification

## Objective

Define pass/fail criteria combining structural validity with semantic usefulness.

## Gate Layers

1. Structural gate (existing, mandatory).
2. Semantic completeness gate (new, mandatory).
3. Semantic benchmark gate (new, mandatory via separate script).

## Structural Gate

Structural checks remain based on:

1. file presence
2. required headings
3. valid links
4. no placeholder routes.

The existing contracts from `run-kb-scaffold.ps1` and `run-kb-quality-gate.ps1` remain active.

## Semantic Completeness Gate (Custom Modules)

### Metric A: Page-flow linkage

Definition:

1. Build custom page set where show-page evidence exists.
2. Count rows in `routes/by-page.md` with non-empty, non-`Unknown` `Shown by Flows`.

Threshold:

1. `>= 95%`.

### Metric B: Flow entity touch coverage

Definition:

1. Build custom flow set where entity action evidence exists.
2. Count rows in `routes/by-flow.md` with non-empty, non-`Unknown` `Touches Entities`.

Threshold:

1. `>= 90%`.

### Metric C: Entity lifecycle mapping

Definition:

1. Build custom entity set referenced by custom flow evidence.
2. Count rows in `routes/by-entity.md` with non-empty, non-`Unknown` `Used by Flows`.

Threshold:

1. `>= 90%`.

## Unknown Usage Rule

1. `Unknown` is allowed only when evidence cannot be derived.
2. Repeated `Unknown` for derivable fields is a quality failure.

## Failure Policy

Quality gate fails when any condition is true:

1. structural issues exist
2. Metric A below threshold
3. Metric B below threshold
4. Metric C below threshold.

## Known Evidence Extraction Limitations

The composer derives evidence from flow node `label` and `detail` text using regex patterns. These limitations affect semantic metric baselines:

1. **Show-page detection**: only captures explicit `show page Module.Page` patterns. Pages opened via navigation layouts, deep links, or button widgets are not detected. Expected miss rate: ~30-50% of actual page navigations.
2. **Entity touch detection**: relies on text patterns like `create Module.Entity`, `retrieve ... from Module.Entity`. Implicit entity access (e.g. via associations, list operations without explicit entity name) is missed. Expected miss rate: ~10-20%.
3. **Cross-module calls**: well-captured via `callEdges` in flow exports. Miss rate: negligible.
4. **Parameter typing**: flow parameter types are not exported; lifecycle and page-parameter links rely on name matching only.

These limitations are acceptable for v1.0 and are partially addressed by the parser enrichment roadmap (see [04-PARSER_ENRICHMENT_SPEC.md](04-PARSER_ENRICHMENT_SPEC.md)). Semantic thresholds account for these known miss rates.

## Output Contract

Quality gate output must print:

1. structural issue count
2. semantic metric values and thresholds
3. pass/fail verdict per metric
4. final overall verdict.
