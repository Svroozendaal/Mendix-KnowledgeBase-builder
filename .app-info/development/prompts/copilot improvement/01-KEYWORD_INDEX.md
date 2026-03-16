# PROMPT 01: Pre-Computed Keyword Index

## Priority

Critical — saves thousands of tokens on every feature-search query by replacing brute-force file scanning with a single lookup table.

## Context

Read before starting:

1. `.agents/AGENTS.md`
2. `.app-info/development/prompts/copilot improvement/INDEX.md`
3. `KnowledgeBase-Creator/artifacts/templates/ROUTING_TEMPLATE.md` — current routing template
4. `KnowledgeBase-Creator/artifacts/.agents/skills/feature-search/SKILL.md` — current feature-search skill
5. `KnowledgeBase-Creator/wizard/run-kb-compose.ps1` — compose script
6. `KnowledgeBase-Creator/wizard/run-kb-quality-gate.ps1` — quality gate script
7. Generated KB example: `mendix-data/knowledge-base/routes/by-flow.md` (to understand the output being replaced)

## Problem Statement

The `feature-search` skill currently asks the reading bot to scan `routes/by-flow.md` (~50KB), `routes/by-entity.md` (~20KB), `app/MODULE_LANDSCAPE.md`, and every module README for keyword substring matches. For a single feature query, this costs 5,000–15,000 tokens just to locate relevant files — before any actual reasoning begins.

This is the single largest source of token waste in the KB reading workflow. A deterministic keyword index generated at compose time would reduce this to a single file read of <500 lines.

## Entry Criteria

1. The compose script (`run-kb-compose.ps1`) generates `routes/by-flow.md` and `routes/by-entity.md`.
2. Module READMEs with Capability Map tables are generated.
3. Entity and flow data is available from the model-overview export JSON during compose.

## Deliverable

### 1. New compose template: `KnowledgeBase-Creator/artifacts/templates/KEYWORD_INDEX_TEMPLATE.md`

Create the template:

```markdown
# Keyword Index

Generated at: {{GeneratedAt}}

This file maps business keywords to KB artefacts. Use it as the first step in feature search instead of scanning full route files.

## How to use

1. Extract keywords from the user's question.
2. Look up each keyword in the table below.
3. Follow the links to the relevant KB files.
4. Read those files for detail — do not scan unrelated files.

## Index

| Keyword | Entities | Flows (Tier 1 first) | Modules | Pages |
|---|---|---|---|---|
{{KeywordRows}}
```

### 2. Add keyword index generation to compose script

In `KnowledgeBase-Creator/wizard/run-kb-compose.ps1`, add a function to generate `routes/keyword-index.md`:

**Keyword extraction logic:**
- **Entity names** — split on PascalCase boundaries (e.g., `TrainingEvent` → `training`, `event`).
- **Flow names** — split on PascalCase boundaries and strip known prefixes (`ACT_`, `DS_`, `VAL_`, `SUB_`, `ACO_`, `BCO_`, `BCR_`, `RULE_`, `SE_`). E.g., `ACT_TrainingEvent_RegisterByTrainee` → `training`, `event`, `register`, `trainee`.
- **Module names** — split on PascalCase/underscore boundaries.
- **Enumeration names and values** — from domain model export data.

**Stop words to exclude:** `the`, `a`, `an`, `is`, `are`, `was`, `were`, `be`, `been`, `of`, `in`, `to`, `for`, `and`, `or`, `not`, `with`, `from`, `by`, `on`, `at`, `as`, `my`, `new`, `get`, `set`.

**PascalCase splitting:** Insert boundary before each uppercase letter that follows a lowercase letter. E.g., `TrainingEvent` → `Training` + `Event` → `training`, `event`.

**Output:** One row per keyword, with relative-path links to the relevant DOMAIN.md section, L1 overview files, module folders, and page overview files.

**Placement:** Write the output to `{KB}/routes/keyword-index.md`.

### 3. Update feature-search skill source

In `KnowledgeBase-Creator/artifacts/.agents/skills/feature-search/SKILL.md`, change the procedure:

**Current steps 2–6:** Scan `routes/by-entity.md`, `routes/by-flow.md`, `app/MODULE_LANDSCAPE.md`, module READMEs, and INTERPRETATION.md for keyword matches.

**New procedure:**

1. Extract keywords from the question (unchanged).
2. **Read `routes/keyword-index.md`.** For each keyword, collect the matched entities, flows, modules, and pages.
3. Merge and rank results (custom modules above marketplace, Tier 1 above Tier 2/3).
4. **Only if no matches found**, fall back to scanning `routes/by-flow.md` and `routes/by-entity.md` for substring matches (the current behaviour).
5. Read module READMEs and INTERPRETATION.md only for the matched modules (not all modules).

### 4. Update ROUTING template

In `KnowledgeBase-Creator/artifacts/templates/ROUTING_TEMPLATE.md`, add a row to the quick-lookup table:

```markdown
| "Find features related to keyword X" | `routes/keyword-index.md` | `modules/<Module>/README.md` |
```

### 5. Add quality gate check

In `KnowledgeBase-Creator/wizard/run-kb-quality-gate.ps1`, add validation rules:
- `routes/keyword-index.md` exists.
- Every entity in `routes/by-entity.md` has at least one keyword entry.
- Every Tier 1 flow in `routes/by-flow.md` has at least one keyword entry.

### 6. Register in pipeline

In `KnowledgeBase-Creator/wizard/run-dump-parser.ps1`, ensure the keyword index generation is called after `routes/by-flow.md` and `routes/by-entity.md` are generated (it depends on both).

## Files Changed (all under `KnowledgeBase-Creator/`)

| File | Change |
|---|---|
| `artifacts/templates/KEYWORD_INDEX_TEMPLATE.md` | **New** — template for keyword index |
| `artifacts/templates/ROUTING_TEMPLATE.md` | Add keyword-index row to quick-lookup table |
| `artifacts/.agents/skills/feature-search/SKILL.md` | Rewrite procedure to use keyword index first |
| `wizard/run-kb-compose.ps1` | Add keyword extraction and index generation function |
| `wizard/run-kb-quality-gate.ps1` | Add keyword index validation rules |
| `wizard/run-dump-parser.ps1` | Wire keyword index generation into pipeline sequence |

## Exit Criteria

1. `routes/keyword-index.md` is generated during compose with correct relative-path links.
2. The `feature-search` skill reads the keyword index first.
3. A bot answering "How does registration work?" reads keyword-index.md (1 file) instead of by-flow.md + by-entity.md + MODULE_LANDSCAPE.md + module READMEs (4+ files).
4. Quality gate passes with the new check.
5. Regenerating any KB produces the keyword index automatically.

## Skills to Use

- Agent: **Developer** (compose script, quality gate script)
- Agent: **Documenter** (template and skill doc)

## Notes

- Keywords should be lowercased and deduplicated.
- The keyword index is a deterministic artefact — no AI enrichment needed.
- For large apps (100+ entities, 500+ flows), the keyword index may exceed 500 lines. Consider grouping by module with collapsible sections, or truncating to Tier 1/2 flows only.
