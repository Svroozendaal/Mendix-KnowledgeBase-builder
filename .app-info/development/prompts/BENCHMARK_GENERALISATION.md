# PROMPT 06: Generalise Semantic Benchmark

## Priority

Medium — required for Phase 9 (Generalisation Readiness) and blocks use on any non-SmartExpenses app.

## Context

Read before starting:

1. `.agents/AGENTS.md` and `.agents/FRAMEWORK.md`
2. `.app-info/product-plan/08-SEMANTIC_BENCHMARK_SUITE.md` — benchmark specification including the new two-tier model.
3. `.app-info/product-plan/09-IMPLEMENTATION_ROADMAP.md` — Phase 9 deliverables.
4. `.app-info/product-plan/10-RISK_REGISTER.md` — R8 (benchmark portability risk).

## Problem Statement

`run-kb-semantic-benchmark.ps1` currently hard-codes 10 QA scenarios that reference SmartExpenses entities and flows by name (e.g. `ACT_Transaction_Create`, `SUB_Transaction_setStatus`, `ImporterHelper.ACT_ImportTransaction_AcceptTransactions`). Running this benchmark on any other Mendix app would score 0/100, producing a false negative.

The updated product plan (08-SEMANTIC_BENCHMARK_SUITE.md) specifies a two-tier benchmark model:

1. **Structural benchmark (app-generic, mandatory)**: 10 scenarios that verify structural quality of any KB, regardless of app content.
2. **App-specific benchmark (optional)**: the current SmartExpenses scenarios, retained as a pilot calibration set loaded via parameter.

## Entry Criteria

1. Benchmark script exists at `KnowledgeBase-Creator/run-kb-semantic-benchmark.ps1`.
2. A valid generated KB exists under `mendix-data/knowledge-base/<AppName>/`.
3. The updated product plan spec (08) defines all 10 structural scenarios.

## Acceptance Criteria

1. The benchmark script implements two tiers:
   - Structural tier: always runs, app-generic, 10 scenarios (S1-S10).
   - App-specific tier: runs only when `-CustomScenarios` parameter is provided.
2. Structural benchmark scenarios (from 08-SEMANTIC_BENCHMARK_SUITE.md):
   - S1: At least one custom flow has a Tier 1 deep narrative.
   - S2: Entity lifecycle matrix exists and is non-empty for every custom module.
   - S3: Cross-module dependency table has non-zero rows when `callEdges` exist.
   - S4: Page-flow linkage rows are non-`Unknown` where show-page evidence exists.
   - S5: Security role-to-module-role matrix is populated.
   - S6: ROUTING.md known-gaps section exists and is honest.
   - S7: READER.md confidence legend is present.
   - S8: At least one route index has non-`Unknown` cross-references.
   - S9: Hub/leaf classification exists in `cross-module.md`.
   - S10: Source metadata (`_sources/manifest.json` and `SOURCE_REF.md`) present and non-empty.
3. Critical structural scenarios: S1, S2, S3 — any critical failure blocks pass.
4. Structural scoring: `10 x 10` model, pass threshold `>= 80`.
5. App-specific scoring: retained at `10 x 10`, pass threshold `>= 85`.
6. Final score: structural score alone when no custom scenarios; weighted average when both.
7. The existing SmartExpenses scenarios are moved to a custom scenario configuration (not deleted).
8. The benchmark report (`_reports/semantic-benchmark.md`) includes both tiers when both run.
9. Script returns non-zero exit code on failure.
10. Deterministic output.

## Scope

### Files to Modify

1. `KnowledgeBase-Creator/run-kb-semantic-benchmark.ps1` — major refactor.

### Specific Changes

#### Step 1: Add `-CustomScenarios` parameter

```powershell
param(
    [Parameter(Mandatory = $true)]
    [string]$KBRoot,
    [string]$AppName,
    [string]$CustomScenarios  # optional path to app-specific scenario file
)
```

#### Step 2: Implement structural benchmark scenarios

Each structural scenario is an evidence check that works on any KB, not referencing specific entity or flow names. Implementation approach:

**S1: Tier 1 narrative presence**
- Find all `modules/*/FLOWS.md` files.
- Check if any file contains the heading `## Tier 1 Deep Narratives` followed by at least one `### ` subheading.
- Score: 10 if found in at least one custom module, 0 otherwise.

**S2: Entity lifecycle matrix non-empty**
- For each custom module (determined from `ROUTING.md` module index where category = Custom), check `DOMAIN.md` for `## Entity Lifecycle Matrix` heading.
- Score: 10 if all custom modules have non-empty lifecycle matrices. Partial credit: `10 * (modules with matrix / total custom modules)`.

**S3: Cross-module dependency table**
- Read `routes/cross-module.md`.
- Check if `## Flow-call edges` table has at least one non-header, non-"none" row.
- Additionally check `app/CALL_GRAPH.md` for the same.
- Score: 10 if dependency evidence exists when cross-module calls exist in the app (check against `_sources/manifest.json` summary if available, or infer from `cross-module.md` content). Score: 10 (N/A pass) if no cross-module calls exist.

**S4: Page-flow linkage quality**
- Read `routes/by-page.md`.
- Count rows with non-`Unknown`, non-"none" `Shown by Flows` values.
- Score: `10 * (linked pages / total pages with possible evidence)`. If no show-page evidence exists in any flow, score N/A.

**S5: Security matrix populated**
- Read `app/SECURITY.md`.
- Check for `## Role-to-Module-Role Matrix` with at least one non-header row.
- Score: 10 if populated, 0 otherwise.

**S6: ROUTING.md known-gaps honesty**
- Read `ROUTING.md`.
- Check for a `## Completeness` or `Known gaps` section.
- Score: 10 if section exists and contains content. Bonus check: if derivable unknowns exist in route files but known gaps says "none", reduce score.

**S7: READER.md confidence legend**
- Read `READER.md`.
- Check for `Export-backed`, `Inferred`, and `Unknown` keywords in a confidence section.
- Score: 10 if all three present, partial credit for subset.

**S8: Route index cross-references**
- Read `routes/by-entity.md`, `routes/by-flow.md`, `routes/by-page.md`.
- Check if at least one index has non-`Unknown`, non-"none" cross-reference values.
- Score: 10 if found, 0 otherwise.

**S9: Hub/leaf classification**
- Read `routes/cross-module.md`.
- Check for `Hub`, `Leaf`, `hub`, `leaf`, `sink-leaf`, `source-leaf`, or `isolated` keywords.
- Score: 10 if classification exists, 0 otherwise.

**S10: Source metadata**
- Check `_sources/manifest.json` exists and is valid JSON.
- Check `_sources/SOURCE_REF.md` exists and is non-empty.
- Score: 10 if both present and non-empty, 5 if only one, 0 if neither.

#### Step 3: Refactor existing SmartExpenses scenarios

Move the current 10 hard-coded SmartExpenses scenarios into a separate function or data structure that is only invoked when `-CustomScenarios` is provided. The current scenario definitions (Q1-Q10 with their file paths and regex patterns) become the default custom scenario set for SmartExpenses.

Option A: Keep them inline but gated behind `-CustomScenarios "SmartExpenses"` (simple).
Option B: Extract to a JSON/PSON config file that can be provided per app (more portable).

Recommend Option A for now — keeps the script self-contained.

#### Step 4: Update scoring and reporting

The benchmark report should include:

```markdown
# Semantic Benchmark Report

## Structural Benchmark (app-generic)

| # | Scenario | Status | Score | Critical |
|---|---|---|---:|---|
| S1 | Tier 1 narrative presence | PASS | 10 | Yes |
| S2 | Entity lifecycle matrix | PASS | 10 | Yes |
...

**Structural Score: 95/100** (threshold: 80)
**Critical failures: 0**

## App-Specific Benchmark (SmartExpenses)

[Only shown when -CustomScenarios is provided]

| # | Scenario | Status | Score | Critical |
...

**App-Specific Score: 100/100** (threshold: 85)
**Critical failures: 0**

## Final Verdict

**PASS** — Structural: 95/100, App-specific: 100/100
```

#### Step 5: Update `run-dump-parser.ps1` integration

The master pipeline script calls the benchmark. Update the call to pass the new parameters. When running on SmartExpenses, pass `-CustomScenarios "SmartExpenses"`. When running on an unknown app, omit the parameter (structural-only).

### What NOT to Change

1. Do not delete the SmartExpenses scenario definitions — move/gate them.
2. Do not change the quality gate script.
3. Do not change any KB file rendering.

## Verification Steps

After implementing:

1. Run the full pipeline on SmartExpenses:
   ```powershell
   cd KnowledgeBase-Creator
   .\run-dump-parser.ps1
   ```
2. Verify the benchmark report shows both tiers (structural + SmartExpenses app-specific).
3. Verify structural score >= 80.
4. Verify app-specific score >= 85 (should still be ~100).
5. Run the benchmark without `-CustomScenarios`:
   ```powershell
   .\run-kb-semantic-benchmark.ps1 -KBRoot "mendix-data/knowledge-base/SmartExpenses" -AppName "SmartExpenses"
   ```
6. Verify it runs structural-only and passes.
7. Verify exit code is 0 on pass and non-zero on failure.
8. Verify the report file at `_reports/semantic-benchmark.md` is updated with the new format.

## Exit Criteria

1. Structural benchmark (10 app-generic scenarios) implemented and passing.
2. App-specific benchmark gated behind `-CustomScenarios` parameter.
3. SmartExpenses scenarios preserved and still passing.
4. Benchmark report includes both tiers when applicable.
5. Script returns non-zero on failure.
6. Integrated into `run-dump-parser.ps1`.

## Estimated Scope

Major refactor of `run-kb-semantic-benchmark.ps1`:

- Add 10 structural scenario implementations (~150-200 lines).
- Refactor existing 10 scenarios into gated section (~30 lines moved/wrapped).
- Update scoring/reporting logic (~50 lines).
- Update `run-dump-parser.ps1` benchmark call (~5 lines).
