# PROMPT 07: Live Query Enhancements

## Priority

Medium - this prompt adds read-only `mxcli` live-query capabilities after the core migration is already stable.

## Depends On

- `06-SWITCHOVER_DOCS_AGENTS_AND_SKILLS.md`

## Context

Read before starting:

1. `.agents/AGENTS.md`
2. `.agents/FRAMEWORK.md`
3. `.app-info/development/prompts/MxCLI integration/INDEX.md`
4. `.app-info/docs/MXCLI_KB_CREATOR_TARGET_ARCHITECTURE.md`
5. `.app-info/docs/MXCLI_COMMAND_CAPABILITY_MATRIX.md`
6. `.app-info/docs/MXCLI_PARITY_GAP_LEDGER.md`
7. `.app-info/development/prompts/MxCLI integration/App information/05-ENRICHMENT-STRATEGY.md`
8. `.app-info/development/prompts/MxCLI integration/App information/07-AGENTS-AND-SKILLS-ANALYSIS.md`
9. `.app-info/agents/OVERVIEW_KB_READER.md`
10. `mendix-data/knowledge-base/READER.md`
11. `.app-info/development/prompts/copilot/03-KB_NAVIGATOR_AND_TOOLS.md`

If any workflow or implementation ambiguity remains after reading the context, ask clarifying questions before changing files. If not, state that no workflow questions remain and continue.

## Problem Statement

The core migration should keep the KB static and stable first. After that is complete, the reader side can use installed `mxcli` commands for targeted read-only questions that the static KB cannot answer precisely. This prompt must add that capability without weakening the static-KB-first model.

## Entry Criteria

1. Prompt 06 is complete and its validation gate passed.
2. The default MxCLI extraction path is stable and green.
3. The command capability matrix clearly identifies which commands are safe for read-only live queries.

## Deliverable

Add read-only `mxcli` live-query guidance and supporting implementation updates on the KB-reader side.

The deliverable must include:

1. a static-KB-first escalation model,
2. a new `mxcli-live` confidence label,
3. a safe allowlist of read-only `mxcli` commands for live queries,
4. validation rules for when live queries are allowed, and
5. updated reader-side docs or prompts that explain the new behaviour.

Implementation rules:

- The KB remains the primary source of truth for narrative and routing.
- Live queries are only for targeted structural lookups that the static KB cannot answer precisely.
- Live queries must stay read-only; no mutation commands are allowed in this prompt.
- Commands used here must already be validated in the capability matrix.
- Resolve the live-query `.mpr` path from `knowledge-base/_sources/creator-link.json -> mprPath`. If the link file or `mprPath` is missing, disable live queries and report the reason instead of guessing.
- No user approval is required for the allowlisted read-only commands below, because they are a targeted `mxcli-live` layer, not raw `app-overview/` or `dumps/` traversal.
- User approval is still required before reading `app-overview/`, `dumps/`, or using any non-allowlisted command.
- The allowlisted read-only commands for this prompt are exactly:
  - `mxcli describe entity <qualified-name> -p <app.mpr>`
  - `mxcli describe enumeration <qualified-name> -p <app.mpr>`
  - `mxcli describe page <qualified-name> -p <app.mpr>`
  - `mxcli describe microflow <qualified-name> -p <app.mpr>`
  - `mxcli callers <qualified-name> -p <app.mpr> --transitive`
  - `mxcli refs <qualified-name> -p <app.mpr>`
  - `mxcli show associations <module> -p <app.mpr>`
  - `mxcli show constants <module> -p <app.mpr>`
  - `mxcli -p <app.mpr> -c "SHOW PROJECT SECURITY"`

## Acceptance Criteria

1. The KB-reader flow stays static-KB-first and treats live `mxcli` queries as a secondary, targeted escalation path.
2. A documented `mxcli-live` confidence level exists and is distinct from `export-backed`, `inferred`, and `unknown`.
3. The allowlisted live-query command set is read-only, maps to validated installed `mxcli` behaviour, and is explicitly documented.
4. Reader-side docs or prompts explain when to stay in the KB, when to run a live query, how the `.mpr` path is resolved, and when approval is still required.
5. The live-query enhancement is additive and does not alter the core KB generation contract.
6. Validation examples prove the flow works for at least one microflow, one page, and one security or reference question.

## Verification Steps

1. Validate reader-side examples using the installed CLI, such as:
   - exact microflow body: `mxcli describe microflow <qualified-name> -p <app.mpr>`
   - transitive callers: `mxcli callers <qualified-name> -p <app.mpr> --transitive`
   - page structure: `mxcli describe page <qualified-name> -p <app.mpr>`
   - exact references: `mxcli refs <qualified-name> -p <app.mpr>`
2. Confirm the updated reader guidance keeps the KB as the starting point, labels live results as `mxcli-live`, and distinguishes allowlisted live queries from approval-gated raw-data access.
3. Confirm no write-capable or model-changing command is introduced into the reader path.
4. Confirm the parity gap ledger records the live-query feature as additive rather than part of the core extraction parity contract.

## Exit Criteria

1. Read-only live-query behaviour is documented and, if implemented, usable.
2. The static KB remains the primary source of truth.
3. The new confidence model is documented and validated.
4. The track finishes with no ambiguity about how live `mxcli` queries fit alongside the generated KB.

## Design Gate

If implementation changes the intended KB-reader behaviour or confidence model, update the target architecture, capability matrix, and parity gap ledger before closing this prompt. Do not declare the track complete while the design docs and reader guidance disagree.

## Validation Gate

Claude must rerun the verification steps after implementation and explicitly report PASS or FAIL for every acceptance criterion plus an overall PASS or FAIL. If any criterion fails, stop and fix the live-query guidance or log the blocker before proceeding.

## Skill Suggestions

- `documentation`
- `testing`
- Developer, Documenter, and Tester agents
