---
name: applyplan
description: Apply an approved `_plans/STORY_<slug>.md` to the linked Mendix `.mpr` via phase-batched, preview-gated `mxcli` execution with explicit confirmation.
---

# APPLYPLAN

## Purpose

Use `/applyplan` to execute an already-approved implementation plan, not to design one. This workflow applies plan changes to the linked Mendix app through controlled `mxcli` batches.

## Required Inputs

1. Plan file: `_plans/STORY_<slug>.md`
2. Linkage file: `_sources/creator-link.json`
3. Linked project path: `_sources/creator-link.json -> mprPath`
4. App-local init assets:
   - `<app-root>/.ai-context/skills`
   - `<app-root>/.claude/commands`

## Procedure

1. Read `.agents/agents/MENDIX_CLI_EXECUTOR.md` (agent procedure and guardrails).
2. Run preflight:
   - `mxcli --version`
   - verify `creator-link.json` and `mprPath`
   - verify `.mpr` exists and extension is `.mpr`
   - verify `.ai-context/skills` and `.claude/commands` exist
3. Parse `_plans/STORY_<slug>.md` and generate phase scripts under:
   - `_plans/_execution/STORY_<slug>/`
4. For each phase batch, run preview gates:
   - `mxcli check <batch>.mdl`
   - `mxcli check <batch>.mdl -p <app.mpr> --references`
   - `mxcli diff -p <app.mpr> <batch>.mdl --format struct`
5. Present preview summary and request explicit confirmation.
6. Only after confirmation, execute:
   - `mxcli exec <batch>.mdl -p <app.mpr>`
7. After confirmed batches, run quick validation:
   - `mxcli docker check -p <app.mpr>`
   - `mxcli lint -p <app.mpr> --format json`
   - `mxcli report -p <app.mpr> --format json`
8. Write final `execution-report.md` in `_plans/_execution/STORY_<slug>/`.

## Guardrails

- `/applyplan` is separate from `/develop`; do not auto-apply plans from planning workflow.
- Never run `mxcli exec` before preview plus explicit confirmation.
- Never guess the `.mpr`; always resolve from `creator-link.json`.
- Never mutate KB markdown outside `_plans/`.
- On failure, stop and report exact command and phase status.

## Output

Execution artefacts in `_plans/_execution/STORY_<slug>/`:

1. phase scripts (`*.mdl`)
2. preview summaries
3. final execution report with PASS/FAIL per phase and validation step
