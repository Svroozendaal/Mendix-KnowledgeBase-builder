# PHASE_8_SEMANTIC_CHANGE_QUALITY
## Goal

Define and approve a concrete remediation plan so structured output contains only real semantic model changes, with explicit per-element deltas and no layout-only noise.

## Scope

1. Plan-level work only for Mendix model-change signal quality.
2. Root-cause mapping across:
   - `studio-pro-extension-csharp/` model diff and export flow.
   - `MendixCommitParser/` raw-to-structured flow.
3. Contract design for improved raw export and structured output.
4. Validation strategy and rollout plan.

## Non-Goals

1. No production code implementation in this phase.
2. No schema migration execution in this phase.
3. No runtime/deployment changes in this phase.

## Entry Criteria

1. A failing or noisy sample exists in:
   - `mendix-data/processed/*.json`
   - `mendix-data/structured/*.json`
   - `mendix-data/dumps/*/working-dump.json`
   - `mendix-data/dumps/*/head-dump.json`
2. Clarifying workflow questions have been asked as needed.
3. Target behaviour is explicitly confirmed (semantic-only element list with actionable deltas).

## Required First Action

1. Read `development/AGENTS.md`.
2. Read `development/AI_WORKFLOW.md`.
3. Ask workflow questions first.
4. Confirm scope, non-goals, and acceptance criteria.
5. Ask which skills should be used and suggest relevant defaults.
6. Load relevant skills, including:
   - `development/skills/mendix-model-dump-inspection/SKILL.md`
   - `development/skills/mendix-commit-structuring/SKILL.md`
   - `development/skills/testing/SKILL.md`
   - `development/skills/documentation/SKILL.md`
   - `development/skills/mendix-studio-pro-10/SKILL.md`

## Suggested Agent Sequence

1. Architect: define target contract, boundaries, and decision records.
2. Prompt Refiner: ensure phase prompt and wording are operational and unambiguous.
3. Documenter: align docs and hand-off guidance.
4. Reviewer: quality-gate the plan and classify unresolved risks.
5. Memory: finalise session and hand-off records.

## Tasks

1. Pause at `WAIT_FOR_APPROVAL` before implementation changes, unless `AUTO_APPROVE` is explicit.
2. Build a baseline evidence set from one or more noisy commits:
   - identify false positives (for example layout-only modified elements),
   - identify missing semantic detail (for example role names removed, exact action deltas).
3. Produce a root-cause map with file-level references for each gap:
   - detection gap,
   - data-contract gap,
   - parser-enrichment gap,
   - testing gap.
4. Define target output behaviour for model changes:
   - only include semantically changed elements,
   - include explicit per-element delta details,
   - exclude layout-only or ordering-only churn by default.
5. Define required element-level delta detail contract (minimum):
   - Page security changes:
     - `allowedRolesBefore`, `allowedRolesAfter`,
     - `allowedRolesAdded`, `allowedRolesRemoved`, `allowedRolesKept`.
   - Microflow semantic changes:
     - `actionsAdded`, `actionsRemoved`, `actionsModified`,
     - `flowGraphChanges` (sequence reroutes, split/merge changes),
     - `layoutOnlyChanges` (tracked but excluded from semantic change list).
6. Define missing raw export fields needed for deterministic parsing:
   - stable element identifiers (`$ID`-equivalent),
   - raw model type,
   - structured property-level diffs with before/after where feasible,
   - change classification (`semantic`, `layout`, `metadata`).
7. Define parser-first remediation plan (backward compatible path):
   - how parser can enrich/filter using persisted dump artifacts,
   - fallback behaviour when dump artifacts are unavailable,
   - compatibility with existing `schemaVersion: 1.0` exports.
8. Define extension-source remediation plan:
   - improved diff semantics in `MendixModelDiffService`,
   - removal or downgrading of layout-only noise,
   - structured model-change payload emission in export.
9. Define contract versioning strategy:
   - raw export version evolution (`1.0` to planned successor),
   - structured schema evolution (`2.0` to planned successor),
   - backward compatibility guarantees and deprecation timeline.
10. Define acceptance criteria and test matrix:
    - positive cases (true semantic changes),
    - negative cases (layout-only),
    - mixed cases (semantic + layout),
    - regression fixtures for known noisy samples.
11. Produce a prioritised implementation backlog:
    - `MUST FIX` before rollout,
    - `SHOULD FIX` follow-up,
    - dependencies, risks, and mitigations.
12. Record decisions and progress in:
    - `development/agent-memory/DECISIONS_LOG.md`
    - `development/agent-memory/PROGRESS.md`
    - `development/agent-memory/REVIEW_NOTES.md`
13. Document plan outputs and hand-off expectations for implementation phase.

## Required Planning Deliverables

1. Gap report with evidence-backed examples.
2. Target data contract draft with concrete field definitions.
3. Parser remediation plan and extension remediation plan.
4. Test and validation plan with explicit PASS/FAIL conditions.
5. Prioritised implementation backlog with effort/risk notes.

## Exit Criteria

1. Root-cause gaps are documented with file-level references.
2. Target semantic-only output contract is defined and reviewable.
3. Data gaps in current raw export are explicitly listed.
4. Parser-side and extension-side development plans are complete and prioritised.
5. Acceptance criteria and regression strategy are documented.
6. No production implementation changes are made in this phase.
