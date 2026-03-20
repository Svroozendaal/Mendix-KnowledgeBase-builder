# PROMPT 08: Development Team ApplyPlan MxCLI Execution

## Priority

Medium - this prompt adds a controlled mutation workflow after the static KB and live-query tracks are stable.

## Depends On

- `07-LIVE_QUERY_ENHANCEMENTS.md`

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
11. `KnowledgeBase-Creator/artifacts/templates/CLAUDE_MD_TEMPLATE.md`
12. `KnowledgeBase-Creator/artifacts/templates/KNOWLEDGEBASE_READER.md`

If any workflow or implementation ambiguity remains after reading the context, ask clarifying questions before changing files. If not, state that no workflow questions remain and continue.

## Problem Statement

`/develop` currently ends at a syntax-enriched implementation plan. It does not provide a controlled, reproducible way to apply that approved plan to the linked Mendix app via `mxcli`.

This prompt adds a separate `/applyplan` workflow (not automatic in `/develop`) that:

1. reads an approved `_plans/STORY_<slug>.md`,
2. resolves `.mpr` from `_sources/creator-link.json -> mprPath`,
3. runs preview-first checks and diffs for each phase batch, and
4. executes only after explicit user confirmation.

## Entry Criteria

1. Prompt 07 is complete and validation gate passed.
2. KB-level `creator-link.json` contains `mprPath`, or the missing-path behaviour is defined and tested.
3. The mutation command contract is validated in the capability matrix at least at interface level.
4. The KB artifacts ship with updated agent and skill guidance for `/applyplan`.

## Deliverable

Introduce `/applyplan` as a controlled execution workflow in KB artifacts and supporting docs.

The deliverable must include:

1. prompt-level design and acceptance criteria for `/applyplan`,
2. a new execution agent in KB artifacts (`MENDIX_CLI_EXECUTOR.md`),
3. a new slash-command skill (`.agents/skills/applyplan/SKILL.md`),
4. development-team handoff guidance from `/develop` to `/applyplan`, and
5. architecture/capability/ledger updates for controlled mutation.

Implementation rules:

- `/applyplan` remains separate from `/develop`; no automatic execution in Phase 7.
- Every mutation batch must run preview checks first:
  - `mxcli check <batch>.mdl`
  - `mxcli check <batch>.mdl -p <app.mpr> --references`
  - `mxcli diff -p <app.mpr> <batch>.mdl --format struct`
- No `mxcli exec` may run before explicit user confirmation of the preview.
- Required post-apply quick validation:
  - `mxcli docker check -p <app.mpr>`
  - `mxcli lint -p <app.mpr> --format json`
  - `mxcli report -p <app.mpr> --format json`
- Required app-local asset contract:
  - `<app-root>/.ai-context/skills`
  - `<app-root>/.claude/commands`
  If either is missing, fail with a clear remediation path (`mxcli init` or `mxcli add-tool claude`).
- Execution artefacts are stored under:
  - `_plans/_execution/STORY_<slug>/`
  including phase scripts, preview summary, and final execution report.

## Acceptance Criteria

1. A new prompt 08 exists and defines `/applyplan` as separate from `/develop`.
2. KB artifacts include a dedicated execution agent and `applyplan` skill with scoped mutation guardrails.
3. Development Team guidance clearly ends planning at Phase 7 and hands off to `/applyplan` only on explicit developer request.
4. Scope documentation reflects controlled mutation as an exception limited to `/applyplan`.
5. Execution pipeline guidance is phase-batched and preview-gated before any `mxcli exec`.
6. Design docs include Stage 8 architecture, mutation command contract, and new parity risks/mitigations.
7. Templates used in generated KBs reference `/applyplan` and its safety boundaries consistently.

## Verification Steps

1. Verify prompt index includes Prompt 08 and dependency graph is updated.
2. Verify new files exist:
   - `KnowledgeBase-Creator/artifacts/.agents/agents/MENDIX_CLI_EXECUTOR.md`
   - `KnowledgeBase-Creator/artifacts/.agents/skills/applyplan/SKILL.md`
3. Verify framework docs register `/applyplan`:
   - `.agents/AGENTS.md`
   - `.agents/AI_WORKFLOW.md`
   - `.agents/FRAMEWORK.md` (execution artefact folder description)
4. Verify template updates:
   - `artifacts/templates/CLAUDE_MD_TEMPLATE.md`
   - `artifacts/templates/KNOWLEDGEBASE_READER.md`
   - `artifacts/templates/QUICKSTART_TEMPLATE.md`
5. Verify design docs were updated:
   - Stage 8 in target architecture
   - mutation/validation command rows in capability matrix
   - new risk rows in parity gap ledger
6. Validate command availability used by this prompt:
   - `mxcli exec --help`
   - `mxcli check --help`
   - `mxcli diff --help`
   - `mxcli docker check --help`
   - `mxcli lint --help`
   - `mxcli report --help`
   - `mxcli diff-local --help`

## Exit Criteria

1. `/applyplan` is fully documented as a controlled, separate post-plan workflow.
2. The KB framework still defaults to read-only interpretation except documented command exceptions.
3. `mxcli` mutation flow is gated by preview and explicit confirmation.
4. Prompt track is decision-complete for implementation of plan-to-apply execution.

## Design Gate

If implementation changes scope boundaries, execution gating, or artefact layout, update the target architecture, capability matrix, and parity gap ledger before closing this prompt. Do not close while prompt content and KB artifact guidance disagree.

## Validation Gate

Claude must rerun the verification steps and explicitly report PASS or FAIL for every acceptance criterion plus an overall PASS or FAIL. If any criterion fails, stop and fix the prompt/docs/agent-skill alignment or log the blocker.

## Skill Suggestions

- `documentation`
- `testing`
- `mcp-server` (only if execution contract is exposed through tooling interfaces)
