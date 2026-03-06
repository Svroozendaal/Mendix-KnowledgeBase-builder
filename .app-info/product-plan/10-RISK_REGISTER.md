# Risk Register

## Objective

Track delivery and operational risks for the AI-useful KB upgrade.

## Risk Matrix

## R1: Overfitting to SmartExpenses naming

Impact: High  
Likelihood: Medium

Description:

1. Tiering or capability inference could become too app-specific.

Mitigation:

1. Use generic rules based on evidence patterns, not module names.
2. Add fallback handling for unknown prefixes and sparse models.

## R2: False semantic failures

Impact: Medium  
Likelihood: Medium

Description:

1. Semantic thresholds may fail good outputs due to conservative evidence extraction.

Mitigation:

1. Pilot calibration phase with metric diagnostics.
2. Keep threshold values configurable if needed.

## R3: Markdown parsing fragility in validators

Impact: Medium  
Likelihood: Medium

Description:

1. Table parsers in PowerShell can misread unusual markdown formatting.

Mitigation:

1. Keep deterministic markdown layout from composer.
2. Add tolerant parsing and clear error messages.

## R4: Runtime cost increase

Impact: Medium  
Likelihood: Low

Description:

1. Composer + semantic checks may increase generation time on large apps.

Mitigation:

1. Keep linear scans and avoid expensive nested loops where possible.
2. Print timing checkpoints to identify hotspots.

## R5: Missing source metadata

Impact: Medium  
Likelihood: Medium

Description:

1. Some fields (for example schedules) may be absent in source dumps.

Mitigation:

1. Keep explicit `Unknown` policy only for non-derivable fields.
2. Implement optional parser enrichments.

## R6: Existing consumer compatibility

Impact: High  
Likelihood: Low

Description:

1. Richer content might accidentally break existing navigation assumptions.

Mitigation:

1. Preserve file and heading contracts required by current validators.
2. Add new sections as additive only.

## R7: Dirty repository context during rollout

Impact: Medium  
Likelihood: High

Description:

1. Unrelated workspace changes can obscure verification outcomes.

Mitigation:

1. Validate only target scripts/docs for this feature.
2. Report tested commands and exact results explicitly.

## R8: Benchmark not portable to other apps

Impact: High
Likelihood: High

Description:

1. All 10 benchmark scenarios reference SmartExpenses entities and flows by name.
2. Running the benchmark on any other app would score 0/100, giving a false negative.

Mitigation:

1. Implement two-tier benchmark model (structural + app-specific) per 08-SEMANTIC_BENCHMARK_SUITE.md.
2. Structural benchmark uses app-generic evidence checks that work on any export.
3. App-specific scenarios are optional and loaded from a parameter file.

## R9: Template and composer drift

Impact: Medium
Likelihood: Medium

Description:

1. Templates in `artifacts/` define required heading contracts; composer generates files from scratch.
2. If one is updated without the other, quality gate may fail on valid content or pass on invalid content.

Mitigation:

1. Document the dual-update rule in 03-TOOLCHAIN_ARCHITECTURE.md.
2. Quality gate heading checks should be derived from templates as single source of truth.

## R10: No regression baseline for output stability

Impact: Medium
Likelihood: Medium

Description:

1. Without a committed reference output, changes to composer logic may silently alter KB content.
2. Semantic benchmark only checks pattern presence, not absence of regressions.

Mitigation:

1. Phase 10 introduces CI with diff-based regression testing.
2. Commit a reference KB output snapshot and compare against it on each pipeline run.

## Fallback Strategy

If semantic gates block delivery unexpectedly:

1. Keep structural gate mandatory.
2. Emit semantic diagnostics without relaxing thresholds silently.
3. Iterate extraction rules first; only adjust thresholds with documented rationale.
