# PROMPT 02: Extraction Foundation

## Priority

Critical - this prompt establishes the reusable `mxcli` execution and parsing foundation without changing the active creator default.

## Depends On

- `01-TARGET_ARCHITECTURE_AND_BASELINE.md`

## Context

Read before starting:

1. `.agents/AGENTS.md`
2. `.agents/FRAMEWORK.md`
3. `.app-info/development/prompts/MxCLI integration/INDEX.md`
4. `.app-info/docs/MXCLI_KB_CREATOR_TARGET_ARCHITECTURE.md`
5. `.app-info/docs/MXCLI_COMMAND_CAPABILITY_MATRIX.md`
6. `.app-info/docs/MXCLI_PARITY_GAP_LEDGER.md`
7. `.app-info/development/prompts/MxCLI integration/App information/03-MXCLI-CATALOG-SCHEMA.md`
8. `.app-info/development/prompts/MxCLI integration/App information/04-SCHEMA-MAPPING.md`
9. `KnowledgeBase-Creator/wizard/run-dump-parser.ps1`
10. `KnowledgeBase-Creator/wizard/src/KnowledgeBaseCreator.Wizard/`

If any workflow or implementation ambiguity remains after reading the context, ask clarifying questions before changing files. If not, state that no workflow questions remain and continue.

## Problem Statement

The migration needs a reusable `mxcli` foundation: PATH-only resolution, command execution, output capture, parsing strategy for table output, MDL output, and JSON output, plus a clear rule for when `REFRESH CATALOG FULL` is required. This prompt builds that foundation without changing the active extraction path yet.

## Entry Criteria

1. Prompt 01 is complete and its validation gate passed.
2. The capability matrix already records the commands this prompt plans to rely on.
3. The current dump/parser path remains the active default.

## Deliverable

Implement the reusable `mxcli` extraction foundation in the creator codebase.

The deliverable must include:

1. PATH-only `mxcli` resolution with clear diagnostics when the CLI is missing.
2. A command runner that captures exit code, stdout, stderr, and working-directory context.
3. A parsing strategy for:
   - table output,
   - MDL output from `describe`, and
   - JSON output from validated commands.
4. A consistent warning-handling rule so non-data warning lines do not corrupt parsed results.
5. A staged command plan that documents when fast mode is enough and when `REFRESH CATALOG FULL` is mandatory.
6. No default switch away from the legacy dump/parser route.

## Acceptance Criteria

1. The creator codebase has a reusable `mxcli` runner that resolves `mxcli` from `PATH` and fails clearly when it is unavailable.
2. The runner can execute validated command categories and return raw outputs without losing stderr or exit-code information.
3. The parsing layer explicitly distinguishes table output, MDL output, and JSON output, and documents which commands use each path.
4. Warning lines such as the validated `vibe-coded PoC` warning are handled consistently and do not pollute parsed data.
5. The foundation documents or implements when `REFRESH CATALOG FULL` is required, especially for refs, widgets, permissions, and similar full-mode tables.
6. The legacy dump/parser flow remains untouched as the active default extraction path after this prompt.

## Verification Steps

1. Execute the new runner against the validated app for each output category:
   - `mxcli --version`
   - `mxcli describe microflow Inspection.ACT_Task_Save -p <app.mpr>`
   - `mxcli search -p <app.mpr> Task --format json`
   - `mxcli -p <app.mpr> -c "REFRESH CATALOG FULL; SELECT SourceName, TargetName, RefKind FROM CATALOG.refs LIMIT 10"`
2. Confirm the parsed result for each category is structurally usable by downstream extraction code.
3. Confirm that warning output is either filtered or separated without deleting important error information.
4. Confirm the current dump/parser workflow still runs from the legacy entry point without new defaults or regressions.

## Exit Criteria

1. The codebase has a reusable `mxcli` execution foundation.
2. Output capture and parsing rules are stable enough for JSON-generation prompts to build on.
3. The legacy pipeline remains the active default.
4. Prompt 03 can start without redefining command-resolution or parsing behaviour.

## Design Gate

If implementation changes the planned extraction architecture, update the target architecture, capability matrix, and parity gap ledger before closing this prompt. Do not move to Prompt 03 while the design docs still describe an older execution model.

## Validation Gate

Claude must rerun the verification steps after implementation and explicitly report PASS or FAIL for every acceptance criterion plus an overall PASS or FAIL. If any criterion fails, stop and fix the foundation or log the blocker before proceeding.

## Skill Suggestions

- `testing`
- `documentation`
- Developer and Tester agents
