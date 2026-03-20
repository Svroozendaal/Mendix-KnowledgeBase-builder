# PROMPT 09: Development Team /develop Performance and Token Efficiency Review

## Priority

Medium - optimise `/develop` orchestration cost and response speed after `/applyplan` execution flow has been established.

## Depends On

- `08-DEVELOPMENT_TEAM_APPLYPLAN_MXCLI_EXECUTION.md`

## Context

Read before starting:

1. `.agents/AGENTS.md`
2. `.agents/FRAMEWORK.md`
3. `.app-info/ROUTING.md`
4. `.app-info/development/prompts/MxCLI integration/INDEX.md`
5. `.app-info/docs/MXCLI_KB_CREATOR_TARGET_ARCHITECTURE.md`
6. `.app-info/docs/MXCLI_COMMAND_CAPABILITY_MATRIX.md`
7. `.app-info/docs/MXCLI_PARITY_GAP_LEDGER.md`
8. `KnowledgeBase-Creator/artifacts/.agents/AGENTS.md`
9. `KnowledgeBase-Creator/artifacts/.agents/AI_WORKFLOW.md`
10. `KnowledgeBase-Creator/artifacts/.agents/agents/DEVELOPMENT_TEAM.md`
11. `KnowledgeBase-Creator/artifacts/.agents/agents/USER_STORY_INTERPRETER.md`
12. `KnowledgeBase-Creator/artifacts/.agents/agents/KB_FEATURE_INTERPRETER.md`
13. `KnowledgeBase-Creator/artifacts/.agents/agents/KB_ANALYST.md`
14. `KnowledgeBase-Creator/artifacts/.agents/agents/KB_SECURITY_REVIEWER.md`
15. `KnowledgeBase-Creator/artifacts/.agents/agents/MENDIX_DEVELOPER.md`
16. `KnowledgeBase-Creator/artifacts/.agents/agents/PLANNER.md`
17. `KnowledgeBase-Creator/artifacts/.agents/agents/TODO_MAKER.md`
18. `KnowledgeBase-Creator/artifacts/.agents/agents/MENDIX_SYNTAX.md`
19. `KnowledgeBase-Creator/artifacts/.agents/agents/KB_FLOW_TRACER.md`
20. `KnowledgeBase-Creator/artifacts/.agents/agents/BEST_PRACTICE_RECOMMENDER.md`
21. Relevant `/develop` skills referenced by Development Team.

If any workflow ambiguity remains after reading context, ask clarifying questions before changing files. If not, state that no workflow questions remain and continue.

## Problem Statement

`/develop` provides high-quality, gated orchestration but can be expensive in token usage and latency due to repeated reads, overlapping delegation, and verbose intermediate outputs.

This prompt produces a focused performance and token-efficiency review of the full `/develop` path, with concrete improvement proposals that preserve quality, coverage, and safety guardrails.

## Entry Criteria

1. Prompt 08 is complete and validation gate passed.
2. `/develop` and `/applyplan` documentation is present in KB artifact agent docs.
3. The latest MxCLI design artefacts are aligned and up to date.

## Deliverable

Produce a complete `/develop` performance review package (analysis-only; no implementation changes yet).

The deliverable must include:

1. a phase-by-phase execution map of `/develop`,
2. a ranked hotspot analysis for token and latency cost,
3. a 3-tier recommendation set,
4. quantified impact and risk per recommendation, and
5. a top-10 ordered rollout plan.

Implementation rules:

- Scope includes:
  - `KnowledgeBase-Creator/artifacts/.agents/agents/DEVELOPMENT_TEAM.md`
  - all Development Team sub-agents used in `/develop`
  - `KnowledgeBase-Creator/artifacts/.agents/AGENTS.md`
  - `KnowledgeBase-Creator/artifacts/.agents/AI_WORKFLOW.md`
  - relevant referenced skills
- Investigate hotspots including:
  - repeated file reads,
  - redundant cross-module scans,
  - over- or duplicate delegation,
  - unnecessary intermediate verbosity,
  - expensive checks that can be deferred or cached.
- Recommendations must be specific and measurable:
  - exact file paths and section targets,
  - current vs proposed behaviour,
  - expected token reduction percentage,
  - expected latency reduction percentage,
  - risk level with mitigation.
- Preserve safety and output quality; do not suggest bypassing approval gates without compensating controls.
- Do not implement code or edit KB/agent files as part of this prompt outcome.

## Output Format

Use exactly these sections:

- **Section A: Current flow map**
- **Section B: Hotspot analysis (ranked by cost)**
- **Section C: Recommendations table (with impact/risk)**
- **Section D: Proposed change plan (ordered rollout)**
- **Section E: Validation plan (optional)**

Section E is optional. If omitted, state briefly why it is omitted and what minimum validation checks are still recommended before implementation.

## Acceptance Criteria

1. The review maps the full `/develop` path end-to-end with clear phase boundaries, inputs, delegations, outputs, and approval gates.
2. The hotspot analysis is ranked by expected cost and identifies concrete token/latency drivers.
3. Recommendations are split into Tier 1 (prompt/content), Tier 2 (workflow), and Tier 3 (architecture).
4. Each recommendation includes exact change targets, current vs proposed behaviour, token and latency estimates, and risk/mitigation.
5. The rollout plan prioritises the top 10 improvements in implementation order.
6. The review keeps safety and quality constraints explicit and does not weaken controlled command boundaries.
7. The output follows Sections A-D exactly, and Section E is handled as optional per this prompt.

## Verification Steps

1. Verify all scoped files were reviewed and cited in the analysis.
2. Verify hotspot ranking includes both token and latency considerations.
3. Verify every recommendation row includes all required fields (path, behaviour delta, estimates, risk, mitigation).
4. Verify Section D lists exactly the top 10 prioritized improvements.
5. Verify output format compliance:
   - Sections A-D present,
   - Section E present or explicitly omitted with rationale.
6. Verify no implementation edits were made as part of this review output.

## Exit Criteria

1. A decision-ready optimisation review exists for `/develop`.
2. Improvement options are actionable, measurable, and risk-scored.
3. The team can start implementation from the ordered top-10 plan without further restructuring.
4. Section E is present if validation design is complete, or omitted with rationale if intentionally deferred.

## Design Gate

If recommendations alter orchestration scope, phase gate semantics, or controlled command boundaries, update architecture, capability matrix, and gap ledger docs before closing this prompt. Do not close while prompt content and design artefacts disagree.

## Validation Gate

Claude must rerun the verification steps and explicitly report PASS or FAIL for every acceptance criterion plus an overall PASS or FAIL. If any criterion fails, stop and correct the review output or log the blocker before proceeding.

## Skill Suggestions

- `documentation`
- `testing`
- Reviewer and Documenter agents
