# Semantic Benchmark Suite

## Objective

Define canonical QA-style checks proving that generated KB output supports real application understanding.

## Scoring Model

1. Total score: `100`.
2. Scenario count: `10`.
3. Base weight: `10` each.
4. Scenario score = matched evidence ratio (`0..10`).

Pass criteria:

1. Total score `>= 85`.
2. No critical scenario failure.

## Critical Scenarios

Critical scenarios:

1. transaction create/save behaviour
2. transaction mutation + role constraints
3. ImporterHelper to SmartExpenses dependency.

## Scenario Set

1. How is a transaction created and saved?
   - Evidence: custom flow docs + relevant pages.
2. Which flows can change `SmartExpenses.Transaction` and under which roles?
   - Evidence: domain lifecycle + security + flow details.
3. What does `ImporterHelper` call in `SmartExpenses`?
   - Evidence: cross-module dependency docs.
4. Which pages are shown during budget type management?
   - Evidence: page index + page-flow links + flow details.
5. What entity lifecycle exists for `BudgetTerm`?
   - Evidence: custom domain lifecycle matrix.
6. Which user roles can access parent home paths?
   - Evidence: security role mapping + pages/flows.
7. Where is transaction status determined?
   - Evidence: flow detail for `SUB_Transaction_setStatus`.
8. What scheduled/system automation affects custom modules?
   - Evidence: resources docs + dependency notes.
9. Which module is the custom orchestration hub?
   - Evidence: call graph + cross-module hub analysis.
10. What is still unknown and why?
   - Evidence: explicit known-gaps sections.

## Generalisation Strategy

The scenario set above is the **pilot calibration set** for `SmartExpenses`. For arbitrary apps the benchmark must be generated dynamically.

### Two-Tier Benchmark Model

1. **Structural benchmark (app-generic, mandatory)**:
   - S1: At least one custom flow has a Tier 1 deep narrative.
   - S2: Entity lifecycle matrix exists and is non-empty for every custom module.
   - S3: Cross-module dependency table has non-zero rows when `callEdges` exist.
   - S4: Page-flow linkage rows are non-`Unknown` where show-page evidence exists.
   - S5: Security role-to-module-role matrix is populated.
   - S6: ROUTING.md known-gaps section exists and is honest (not `none` when derivable unknowns remain).
   - S7: READER.md confidence legend is present.
   - S8: At least one route index has non-`Unknown` cross-references.
   - S9: Hub/leaf classification exists in `cross-module.md`.
   - S10: Source metadata (`_sources/manifest.json` and `SOURCE_REF.md`) present and non-empty.

   Scoring: same `10 × 10` model. Pass threshold: `>= 80`. No critical failures.

   Critical structural scenarios: S1, S2, S3.

2. **App-specific benchmark (optional, pilot-only)**:
   - The current SmartExpenses scenario set (above) is retained as the pilot calibration set.
   - Future apps may define their own `_reports/semantic-benchmark-custom.md` with app-specific QA scenarios.
   - App-specific benchmarks are additive and do not replace the structural benchmark.

### Script Implications

`run-kb-semantic-benchmark.ps1` must implement:

1. Structural benchmark (always runs, app-generic).
2. App-specific benchmark (runs only when a custom scenario file is provided via `-CustomScenarios` parameter).
3. Final score = structural score alone when no custom scenarios exist; weighted average when both are present.

## Evidence Rules

1. Each scenario has required files and regex evidence patterns.
2. Missing files score zero for corresponding checks.
3. Not-applicable scenarios (module absent) may be excluded from denominator if explicitly marked as `N/A`.

## Benchmark Output Contract

Benchmark output must include:

1. Scenario-by-scenario status (`PASS`, `FAIL`, `N/A`).
2. Matched evidence summary.
3. Total score and threshold.
4. Critical failure summary.
5. Final verdict.
