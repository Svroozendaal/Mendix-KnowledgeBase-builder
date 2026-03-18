# PROMPT 01: Target Architecture and Baseline

## Priority

Critical - this prompt locks the real installed `mxcli` contract before any implementation work can depend on it.

## Depends On

- `INDEX.md`

## Context

Read before starting:

1. `.agents/AGENTS.md`
2. `.agents/FRAMEWORK.md`
3. `.app-info/ROUTING.md`
4. `.app-info/development/prompts/MxCLI integration/INDEX.md`
5. `.app-info/development/prompts/MxCLI integration/App information/01-OVERVIEW.md`
6. `.app-info/development/prompts/MxCLI integration/App information/03-MXCLI-CATALOG-SCHEMA.md`
7. `.app-info/development/prompts/MxCLI integration/App information/04-SCHEMA-MAPPING.md`
8. `KnowledgeBase-Creator/README.md`
9. `KnowledgeBase-Creator/AGENTS.md`
10. `mendix-data/knowledge-base/READER.md`
11. `mendix-data/knowledge-base/app/APP_OVERVIEW.md`

If any workflow or implementation ambiguity remains after reading the context, ask clarifying questions before changing files. If not, state that no workflow questions remain and continue.

## Problem Statement

The current research notes are useful but partially stale. The migration must be driven by the real installed `mxcli` contract on this machine, not by assumptions copied from the `mxcli` repo or older notes. Before code is planned or changed, we need a validated architecture baseline, a command capability matrix, and a parity gap ledger.

## Entry Criteria

1. `mxcli` is available on `PATH`, or this prompt fails with a documented blocker.
2. A real Mendix `.mpr` is available for validation.
3. The current generated KB exists at `mendix-data/knowledge-base/` for folder-contract reference.

## Deliverable

Create or update the following documents:

- `.app-info/docs/MXCLI_KB_CREATOR_TARGET_ARCHITECTURE.md`
- `.app-info/docs/MXCLI_COMMAND_CAPABILITY_MATRIX.md`
- `.app-info/docs/MXCLI_PARITY_GAP_LEDGER.md`

The deliverable must:

1. lock the intended system shape for the migration,
2. record only tested commands as safe dependencies,
3. record rejected or stale assumptions explicitly,
4. document current gaps that block parity or need mitigation, and
5. define the switchover rule for later prompts.

## Acceptance Criteria

1. The target architecture document states that `mxcli` on `PATH` replaces the extraction layer while the JSON v2.0 -> composer -> static KB model remains the phase-1 compatibility target.
2. The command capability matrix records validated command categories for version, structure, project tree, show, describe, callers, refs, search, lint, report, and catalog queries.
3. The capability matrix explicitly rejects unsupported assumptions discovered during validation, including any missing commands or unsupported output modes.
4. The parity gap ledger contains baseline gaps, baseline mitigations, and a clear rule for when Prompt 06 is allowed to switch the default extraction path.
5. The documents cite the real validation app and the current generated KB reference so later prompts use the same baseline.
6. No implementation prompt depends on an unvalidated command without a documented revalidation requirement.

## Verification Steps

1. Run these commands against `C:\Workspaces\Mendix\Emixa_InspectionApp\Emixa_InspectionApp.mpr` and capture the outcome in the docs:
   - `mxcli --version`
   - `mxcli structure -p <app.mpr> -d 1`
   - `mxcli project-tree -p <app.mpr>`
   - `mxcli show modules -p <app.mpr>`
   - `mxcli show associations Inspection -p <app.mpr>`
   - `mxcli show constants Inspection -p <app.mpr>`
   - `mxcli describe entity Inspection.Task -p <app.mpr>`
   - `mxcli describe enumeration Inspection.Enum_TaskStatus -p <app.mpr>`
   - `mxcli describe page Inspection.Dashboard_Home -p <app.mpr>`
   - `mxcli describe microflow Inspection.ACT_Task_Save -p <app.mpr>`
   - `mxcli callers Inspection.ACT_Task_Save -p <app.mpr> --transitive`
   - `mxcli refs Inspection.Dashboard_Home -p <app.mpr>`
   - `mxcli search -p <app.mpr> Task --format json`
   - `mxcli lint -p <app.mpr> --format json`
   - `mxcli report -p <app.mpr> --format json`
2. Explicitly test known stale assumptions and record the result:
   - `mxcli open --help`
   - `mxcli snapshot --help`
   - `mxcli show pages Inspection -p <app.mpr> --format json`
3. Confirm the architecture document matches the validated command reality.
4. Confirm the capability matrix and parity gap ledger cross-reference each other.

## Exit Criteria

1. All three design artefacts exist and are internally consistent.
2. The installed `mxcli` contract is the documented source of truth for later prompts.
3. Stale assumptions are recorded as rejected or revalidation-required items.
4. Prompt 02 can proceed without having to make baseline architectural decisions.

## Design Gate

If command-line validation changes the intended system shape, update the target architecture, capability matrix, and parity gap ledger before closing this prompt. Do not move to Prompt 02 while the design artefacts still describe stale command behaviour.

## Validation Gate

Claude must rerun the verification steps after updating the design artefacts and explicitly report PASS or FAIL for every acceptance criterion plus an overall PASS or FAIL. If any criterion fails, stop and fix the docs or log the blocker before proceeding.

## Skill Suggestions

- `documentation`
- `testing`
- Developer, Documenter, and Tester agents
