# Implementation Roadmap

## Objective

Deliver the AI-useful KB upgrade in controlled phases with measurable gates.

## Phase 0: Planning Baseline

Deliverables:

1. `.app-info/product-plan/` document set (`00` to `10`).

Gate:

1. Decision-complete plan docs exist and are linked from index.

## Phase 1: Composer Foundation

Deliverables:

1. `KnowledgeBase-Creator/run-kb-compose.ps1` (new).
2. Deterministic extraction for:
   - page-flow links
   - entity touch evidence
   - call graph edges.
3. Full file generation with current KB contract.

Gate:

1. scaffold validation passes
2. existing quality gate structural checks pass.

## Phase 2: Tiered Custom Flow Narratives

Deliverables:

1. Tier assignment implementation (`Tier 1/2/3`).
2. Rich narrative sections in custom module `FLOWS.md`.

Gate:

1. custom flow tiering deterministic
2. required headings preserved.

## Phase 3: Routing and Index Hardening

Deliverables:

1. Upgraded `routes/by-entity.md`, `by-page.md`, `by-flow.md`, `cross-module.md`.
2. Reduction of derivable `Unknown` values for custom modules.

Gate:

1. route links valid
2. custom derivable unknowns minimised by threshold checks.

## Phase 4: Hybrid Quality Gate

Deliverables:

1. Expanded `run-kb-quality-gate.ps1` with semantic thresholds A/B/C.

Gate:

1. structural + semantic checks print explicit metric values
2. fail/pass logic matches threshold policy.

## Phase 5: Semantic Benchmark

Deliverables:

1. `run-kb-semantic-benchmark.ps1` (new).
2. Canonical 10-scenario benchmark with scoring and critical checks.

Gate:

1. benchmark script returns non-zero on failure
2. score and scenario breakdown printed.

## Phase 6: Entrypoint Integration

Deliverables:

1. `run-dump-parser.ps1` updated to run:
   - scaffold
   - composer
   - scaffold validation
   - quality gate
   - semantic benchmark.

Gate:

1. end-to-end command produces a complete KB and final verdict.

## Phase 7: Packaging and Documentation

Deliverables:

1. `KnowledgeBase-Creator/README.md` updated for new flow.
2. Artifact packaging includes new scripts.

Gate:

1. package remains runnable on clean machine assumptions.

## Phase 8: Pilot and Calibration

Deliverables:

1. Pilot run on `SmartExpenses`.
2. Threshold tuning notes and false-positive review.

Gate:

1. benchmark score >= 85 and no critical failures.

## Phase 9: Generalisation Readiness

Deliverables:

1. Guidance for applying custom-depth policy to other apps.
2. Explicit assumptions/limits documented.
3. Structural benchmark (app-generic) implemented in `run-kb-semantic-benchmark.ps1`.
4. SmartExpenses-specific scenarios moved to optional app-specific benchmark layer.
5. KB format version field added to `READER.md`.

Gate:

1. No app-specific hardcoding in core composer logic.
2. Structural benchmark passes on SmartExpenses without app-specific scenario file.
3. `READER.md` contains `KB Format Version: 1.0`.

## Phase 10: CI and Regression Testing

Deliverables:

1. GitHub Actions workflow that runs the full pipeline on a reference export and validates:
   - scaffold validation passes
   - quality gate passes
   - structural benchmark passes.
2. Reference export snapshot committed to repository for deterministic regression testing.
3. Diff-based regression check: compare generated KB output against a committed baseline to detect unintended changes.

Gate:

1. CI workflow runs on PR and push to main.
2. Pipeline failure blocks merge.
