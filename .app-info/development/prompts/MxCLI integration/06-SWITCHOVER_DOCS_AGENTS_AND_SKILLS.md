# PROMPT 06: Switchover, Docs, Agents, and Skills

## Priority

High - this prompt makes `mxcli` the default extraction path only after parity and validation evidence is green.

## Depends On

- `05-CREATOR_PIPELINE_DUAL_PATH.md`

## Context

Read before starting:

1. `.agents/AGENTS.md`
2. `.agents/FRAMEWORK.md`
3. `.app-info/ROUTING.md`
4. `.app-info/development/prompts/MxCLI integration/INDEX.md`
5. `.app-info/docs/MXCLI_KB_CREATOR_TARGET_ARCHITECTURE.md`
6. `.app-info/docs/MXCLI_COMMAND_CAPABILITY_MATRIX.md`
7. `.app-info/docs/MXCLI_PARITY_GAP_LEDGER.md`
8. `.app-info/development/prompts/MxCLI integration/App information/05-ENRICHMENT-STRATEGY.md`
9. `.app-info/development/prompts/MxCLI integration/App information/06-ROUTING-ANALYSIS.md`
10. `.app-info/development/prompts/MxCLI integration/App information/07-AGENTS-AND-SKILLS-ANALYSIS.md`
11. `KnowledgeBase-Creator/README.md`
12. `KnowledgeBase-Creator/AGENTS.md`
13. `KnowledgeBase-Creator/wizard/README.md`
14. `.app-info/skills/OVERVIEW.md`
15. `mendix-data/knowledge-base/READER.md`

If any workflow or implementation ambiguity remains after reading the context, ask clarifying questions before changing files. If not, state that no workflow questions remain and continue.

## Problem Statement

The creator can now run the new extraction path, but the package, docs, agents, and skills still describe the old world. This prompt switches the creator default to `mxcli` only when the evidence is green and then updates the documentation and agent guidance to match the new default.

## Entry Criteria

1. Prompt 05 is complete and its validation gate passed.
2. The parity gap ledger has no blocking switchover gaps left open.
3. Composer, scaffold validation, quality gate, and semantic benchmark evidence is current and green for the MxCLI path.

## Deliverable

Make `mxcli` the default extraction path and update the surrounding documentation and guidance.

The deliverable must include:

1. default extraction-path switchover in the creator workflow,
2. updated creator docs and generated-KB wording,
3. updated app-level routing or pipeline descriptions that still reference dump/parser as the primary path,
4. creation or update of the app-specific `mendix-mxcli` skill, and
5. deprecation of stale dump/parser assumptions only after evidence is recorded.

Implementation rules:

- Keep the legacy path available behind an explicit opt-in switch until deprecation is consciously completed.
- Do not remove or rewrite downstream KB behaviour that is outside the switchover scope.
- Use the parity gap ledger as the release gate for the default switch.
- Use the exact skill location `.app-info/skills/mendix-mxcli/SKILL.md`.
- Update `.app-info/skills/OVERVIEW.md` with a new row for `mendix-mxcli`.
- At minimum, update the following exact files when switching the default:
  - `KnowledgeBase-Creator/README.md`
  - `KnowledgeBase-Creator/AGENTS.md`
  - `KnowledgeBase-Creator/wizard/README.md`
  - `.app-info/ROUTING.md`
  - `.app-info/agents/KNOWLEDGEBASE_CREATOR.md`
  - `.app-info/agents/OVERVIEWSMITH.md`
  - `.app-info/agents/OVERVIEW_KB_BUILDER.md`
  - `.app-info/agents/GAPSMITH.md`
  - `.app-info/agents/OVERVIEW_KB_READER.md`
  - `.app-info/skills/mendix-model-overview-export/SKILL.md`
  - `.app-info/skills/mendix-model-dump-inspection/SKILL.md`
- The `mendix-mxcli` skill must include, at minimum: Purpose, When To Use, Required Inputs, Validated Command Set, Output Modes, Full-Catalog Rules, Reader Live-Query Allowlist, Gap Handling, and Verification Checklist.

## Acceptance Criteria

1. The creator default extraction path is `mxcli`, with the legacy path still available as an explicit fallback.
2. Creator docs, agent guidance, and routing text no longer describe dump/parser as the primary extraction path.
3. A `mendix-mxcli` app-specific skill exists or is updated and is linked from the skills overview.
4. Generated-KB and creator wording that references the extraction layer is updated to match the new default.
5. Switchover evidence is captured in the parity gap ledger before the default changes.
6. The default MxCLI path still passes compose, KB validation, quality gate, and semantic benchmark checks.

## Verification Steps

1. Run the full creator workflow without an explicit extraction override and confirm that it uses the MxCLI path by default.
2. Run the explicit legacy override and confirm that the fallback still works.
3. Inspect updated docs and agent/skill files to confirm they describe the new default correctly.
4. Confirm the parity gap ledger records the switchover evidence and remaining deferred items.
5. Re-run compose, scaffold validation, quality gate, and semantic benchmark on the default MxCLI path.

## Exit Criteria

1. `mxcli` is the default extraction path.
2. Surrounding docs, agents, and skills describe the new default accurately.
3. The legacy path remains available only as an explicit fallback.
4. Prompt 07 can focus on additive live-query enhancements rather than core migration repair.

## Design Gate

If implementation changes the intended default workflow, documentation contract, or skill model, update the target architecture, capability matrix, and parity gap ledger before closing this prompt. Do not move to Prompt 07 while the design docs and shipped guidance disagree.

## Validation Gate

Claude must rerun the verification steps after implementation and explicitly report PASS or FAIL for every acceptance criterion plus an overall PASS or FAIL. If any criterion fails, stop and fix the switchover work or log the blocker before proceeding.

## Skill Suggestions

- `documentation`
- `testing`
- Developer, Documenter, and Tester agents
