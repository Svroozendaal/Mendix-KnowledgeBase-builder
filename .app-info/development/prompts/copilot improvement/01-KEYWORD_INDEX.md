# PROMPT 01: Pre-Computed Keyword Index

## Priority

Critical — saves thousands of tokens on every feature-search query by replacing brute-force file scanning with a single lookup table.

## Context

Read before starting:

1. `.agents/AGENTS.md`
2. `.app-info/development/prompts/copilot improvement/INDEX.md`
3. Generated KB: `mendix-data/knowledge-base/ROUTING.md`
4. Generated KB: `mendix-data/knowledge-base/routes/by-flow.md`
5. Generated KB: `mendix-data/knowledge-base/routes/by-entity.md`
6. Generated KB: `mendix-data/knowledge-base/.agents/skills/feature-search/SKILL.md`

## Problem Statement

The `feature-search` skill currently asks the reading bot to scan `routes/by-flow.md` (~50KB), `routes/by-entity.md` (~20KB), `app/MODULE_LANDSCAPE.md`, and every module README for keyword substring matches. For a single feature query, this costs 5,000–15,000 tokens just to locate relevant files — before any actual reasoning begins.

This is the single largest source of token waste in the KB reading workflow. A deterministic keyword index generated at compose time would reduce this to a single file read of <500 lines.

## Entry Criteria

1. The KB Creator pipeline compose step is functional.
2. The `routes/by-flow.md` and `routes/by-entity.md` files are generated with all flow/entity names, tiers, and module assignments.
3. Module READMEs with Capability Map tables are generated.

## Deliverable

### 1. New compose artifact: `routes/keyword-index.md`

Generate a keyword index during the compose step by extracting tokens from:

- **Entity names** — split on PascalCase boundaries (e.g., `TrainingEvent` → `training`, `event`).
- **Flow names** — split on PascalCase boundaries and strip prefixes (`ACT_`, `DS_`, `VAL_`, `SUB_`, `ACO_`, etc.). E.g., `ACT_TrainingEvent_RegisterByTrainee` → `training`, `event`, `register`, `trainee`.
- **Module names** — split on PascalCase/underscore boundaries.
- **Enumeration names and values** — from DOMAIN.md enumeration sections.
- **README Capability Map** — extract the "Representative Flow" and prefix description columns.

The index format:

```markdown
# Keyword Index

Generated at: [timestamp]

This file maps business keywords to KB artefacts. Use it as the first step in feature search instead of scanning full route files.

## How to use

1. Extract keywords from the user's question.
2. Look up each keyword in the table below.
3. Follow the links to the relevant KB files.
4. Read those files for detail — do not scan unrelated files.

## Index

| Keyword | Entities | Flows (Tier 1 first) | Modules | Pages |
|---|---|---|---|---|
| course | [Course](../modules/MyFirstModule/DOMAIN.md#course) | [ACT_Course_Create](../modules/MyFirstModule/flows/myfirstmodule-act-course-create.overview.md), [ACT_Course_Save](../modules/MyFirstModule/flows/myfirstmodule-act-course-save.overview.md) | MyFirstModule | [Course_Overview](...), [Course_NewEdit](...) |
| registration | [Registration](../modules/MyFirstModule/DOMAIN.md#registration) | [ACT_TrainingEvent_RegisterByTrainee](...) | MyFirstModule | ... |
| trainee | [Trainee](../modules/.../DOMAIN.md#trainee) | [ACT_TrainingEvent_RegisterByTrainee](...), ... | MyFirstModule | ... |
| training | [TrainingEvent](../modules/.../DOMAIN.md#trainingevent) | [ACT_TrainingEvent_Create](...), ... | MyFirstModule | ... |
| location | [Location](../modules/.../DOMAIN.md#location) | [ACT_Location_Create](...), [ACT_Location_Save](...) | MyFirstModule | ... |
| password | — | [ChangeMyPassword](...), [ChangePassword](...) | Administration | ... |
| account | [Account](...) | [NewAccount](...), [SaveNewAccount](...) | Administration | ... |
```

### 2. Update `feature-search` skill

Modify `.agents/skills/feature-search/SKILL.md` in the generated KB to use the keyword index as step 1:

**Current procedure step 2–6:** Scan `routes/by-entity.md`, `routes/by-flow.md`, `app/MODULE_LANDSCAPE.md`, module READMEs, and INTERPRETATION.md for keyword matches.

**New procedure:**

1. Extract keywords from the question (unchanged).
2. **Read `routes/keyword-index.md`.** For each keyword, collect the matched entities, flows, modules, and pages.
3. Merge and rank results (custom modules above marketplace, Tier 1 above Tier 2/3).
4. **Only if no matches found**, fall back to scanning `routes/by-flow.md` and `routes/by-entity.md` for substring matches (the current behaviour).
5. Read module READMEs and INTERPRETATION.md only for the matched modules (not all modules).

### 3. New compose template: `_artifacts/KEYWORD_INDEX_TEMPLATE.md`

Create the template that the compose step uses to generate the keyword index. The template should contain the header, usage instructions, and an empty table skeleton.

### 4. Update ROUTING.md

Add a row to the quick-lookup table in `ROUTING.md`:

```markdown
| "Find features related to keyword X" | `routes/keyword-index.md` | `modules/<Module>/README.md` |
```

### 5. Quality gate check

Add a quality gate rule that verifies:
- `routes/keyword-index.md` exists.
- Every entity in `routes/by-entity.md` has at least one keyword entry.
- Every Tier 1 flow in `routes/by-flow.md` has at least one keyword entry.

## Exit Criteria

1. `routes/keyword-index.md` is generated during compose with correct links.
2. The `feature-search` skill reads the keyword index first.
3. A bot answering "How does registration work?" reads keyword-index.md (1 file) instead of by-flow.md + by-entity.md + MODULE_LANDSCAPE.md + module READMEs (4+ files).
4. Quality gate passes with the new check.

## Skills to Use

- Agent: **Developer** (pipeline compose code changes)
- Agent: **Documenter** (template and skill doc updates)
- Skill: `.agents/skills/documentation/SKILL.md`

## Notes

- Keywords should be lowercased and deduplicated.
- Stop words to exclude: `the`, `a`, `an`, `is`, `are`, `was`, `were`, `be`, `been`, `of`, `in`, `to`, `for`, `and`, `or`, `not`, `with`, `from`, `by`, `on`, `at`, `as`, `my`, `new`, `get`, `set`.
- PascalCase splitting: insert boundary before each uppercase letter that follows a lowercase letter. E.g., `TrainingEvent` → `Training` + `Event` → `training`, `event`.
- Flow prefix stripping: remove the first segment before the first underscore if it matches a known prefix (`ACT`, `DS`, `VAL`, `SUB`, `ACO`, `RULE`, `SE`, `BCO`, `BCR`).
- The keyword index is a deterministic artefact — no AI enrichment needed.
