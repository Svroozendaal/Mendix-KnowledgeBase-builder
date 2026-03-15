# PROMPT 05: Fix Non-Custom Module Rendering

## Priority

Medium â€” non-custom modules currently show contradictory data (README summary counts vs empty detail files).

## Context

Read before starting:

1. `.agents/AGENTS.md` and `.agents/FRAMEWORK.md`
2. `.app-info/product-plan/01-END_STATE_KB_SPEC.md` â€” scope policy for non-custom modules.
3. `.app-info/product-plan/02-CONTENT_MODEL_CUSTOM_DEPTH.md` â€” marketplace/system coverage model.

## Problem Statement

Non-custom modules (Marketplace and System) have a contradictory KB output. Their `README.md` shows accurate summary counts (e.g. Administration: 2 entities, 8 flows, 9 pages), but their detail files (`DOMAIN.md`, `FLOWS.md`, `PAGES.md`) render all tables as "none".

This happens because the composer loads the data correctly (it reads `domain-model.json`, `flows.json`, `pages.json` for every module) but the rendering logic either skips non-custom modules or fails to iterate their data.

The product plan spec (01-END_STATE_KB_SPEC.md) says non-custom modules should have:

1. Same file structure and required headings preserved.
2. Concise summaries.
3. Dependency-aware context (relevance to custom modules).

"Concise summaries" means the tables should be populated â€” just without Tier 1 narratives.

### Current state example (Administration/DOMAIN.md):

```markdown
## Entities

| Entity | Persistable | Attributes | Access Rules |
|---|---|---:|---:|
| none | false | 0 | 0 |
```

### Expected state:

```markdown
## Entities

| Entity | Persistable | Attributes | Access Rules |
|---|---|---:|---:|
| Administration.Account | true | 5 | 3 |
| Administration.ActiveSession | true | 2 | 1 |
```

## Entry Criteria

1. Composer script exists at `KnowledgeBase-Creator/wizard/run-kb-compose.ps1`.
2. Non-custom module data is loaded from JSON (verify by checking `$domainsByModule["Administration"]` is non-empty).

## Acceptance Criteria

1. Non-custom module `DOMAIN.md` files show entity tables populated from the export data.
2. Non-custom module `FLOWS.md` files show flow catalogue tables populated from the export data.
3. Non-custom module `PAGES.md` files show page inventory tables populated from the export data.
4. Non-custom modules do NOT get Tier 1 deep narratives (catalogue-only, as specified in plan).
5. Non-custom modules do NOT get entity lifecycle matrices (custom-module-only feature).
6. Non-custom modules include a dependency note: "This module supports custom-module behaviour through [specific relevance]" â€” or "No direct custom-module dependency detected" if no cross-module edges exist.
7. Quality gate and benchmark still pass.
8. Deterministic output preserved.

## Scope

### Files to Modify

1. `KnowledgeBase-Creator/wizard/run-kb-compose.ps1` â€” rendering logic for non-custom modules.

### Investigation Required

Before making changes, investigate why non-custom modules render empty tables. The issue is likely in one of these areas:

1. **Module data loading** (lines ~216-227): check whether the `$base = Join-Path $RunFolder "modules/$module"` path resolves correctly for marketplace modules. The parser may store marketplace modules under `modules/marketplace/<ModuleName>/` instead of `modules/<ModuleName>/`. Check the manifest's artifact paths to confirm.

2. **Rendering conditionals**: check whether the entity/flow/page rendering loops have an early exit or filter that skips non-custom modules. Search for conditions like `$isCustom`, `$category -eq "Custom"`, or similar guards.

3. **Empty data objects**: check whether `$domainsByModule["Administration"].domainModel.entities` is an empty array or a populated array. If empty, the problem is in the loader. If populated, the problem is in the renderer.

### Expected Changes (after investigation)

#### If the problem is path-based (marketplace subfolder):

Fix the module data loading to handle the marketplace subfolder structure. Check the manifest's artifact paths:

```json
{ "type": "module-domain-model-json", "path": "...\\modules\\marketplace\\Administration\\domain-model.json" }
```

If marketplace modules use a different path convention, update the loading loop to check both locations.

#### If the problem is a rendering conditional:

Remove or relax the guard so non-custom modules render basic inventory tables. Keep the Tier 1 narrative guard (non-custom modules should not get deep narratives).

#### Add dependency relevance note

For each non-custom module, check whether it has cross-module edges to/from custom modules. Add a line in `README.md`:

```markdown
## Custom-Module Relevance

[ExcelImporter is called by ImporterHelper for spreadsheet import processing.]
or
[No direct cross-module flow calls to/from custom modules detected.]
```

### What NOT to Change

1. Do not add Tier 1 narratives to non-custom modules.
2. Do not add entity lifecycle matrices to non-custom modules.
3. Do not change the depth or detail of custom module rendering.
4. Do not change the module category classification logic.

## Verification Steps

After implementing:

1. Run the full pipeline.
2. Open `mendix-data/knowledge-base/SmartExpenses/modules/Administration/DOMAIN.md`.
3. Verify that entity table is populated (not all "none").
4. Open `mendix-data/knowledge-base/SmartExpenses/modules/Administration/FLOWS.md`.
5. Verify that flow catalogue has entries (Administration has 8 flows).
6. Open `mendix-data/knowledge-base/SmartExpenses/modules/Administration/PAGES.md`.
7. Verify that page inventory has entries (Administration has 9 pages).
8. Verify that no non-custom module has Tier 1 narratives.
9. Verify quality gate passes.
10. Verify benchmark score >= 85.
11. Spot-check `ExcelImporter` module (196 flows) â€” should show populated tables without deep narratives.

## Exit Criteria

1. All non-custom modules show populated inventory tables for entities, flows, and pages.
2. README.md summary counts match detail file row counts.
3. No Tier 1 narratives on non-custom modules.
4. Dependency relevance note present.
5. Quality gate passes.
6. Benchmark score >= 85.

## Estimated Scope

Investigation + fix:

- Debug the loading/rendering path for non-custom modules (~30 min investigation).
- Fix loader or renderer (~10-30 lines depending on root cause).
- Add dependency relevance note to non-custom README rendering (~10 lines).

