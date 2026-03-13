---
name: initkb
description: Run the full KnowledgeBase Creator workflow from the creator package. Use when the user wants to initialise, rebuild, or regenerate a Mendix knowledge base by calling the targetable `wizard/run-initkb.ps1` backend and then continuing with manual AI enrichment.
---

# INITKB

## Purpose

Use `/initkb` as the creator-side shortcut backed by `.\wizard\run-initkb.ps1`.

If the deterministic pipeline has already completed and only phase 2 is needed, use `/enrichkb` instead.

## Canonical invocations

Run from the `KnowledgeBase-Creator` root:

```powershell
.\wizard\run-initkb.ps1 -OpenVsCode
```

To rebuild an existing generated KB from the creator package:

```powershell
.\wizard\run-initkb.ps1 -KnowledgeBaseRoot "<path-to-knowledge-base>" -OpenVsCode
```

## Preconditions

Before invoking the runner, verify:

- `.env` exists when the runner must fall back to creator defaults
- `.\wizard\run-initkb.ps1` exists in the creator package
- either `MprPath` or creator defaults can resolve the source `.mpr`
- either `MxPath` or creator defaults can resolve `mx.exe`

## Runner behaviour

`.\wizard\run-initkb.ps1` is responsible for:

- normalising `DataRoot` or `KnowledgeBaseRoot`
- archiving an existing non-empty `mendix-data` workspace before rebuild
- running `wizard/run-dump-parser.ps1`
- writing `knowledge-base/_sources/creator-link.json`
- writing `knowledge-base/_sources/INITKB_HANDOFF.md`
- optionally opening the resolved `mendix-data` workspace in VS Code

Treat the rebuild as ready for phase 2 only when:

- scaffold validation passes
- quality gate status is `pass`
- a KB folder path and run folder path are reported

Benchmark failure is not an automatic blocker in non-strict mode, but it must be reported in the handoff.

## Phase 2: Continue with AI enrichment

After the runner completes:

1. Read `AGENTS.md`
2. Read `.agents/agents/KNOWLEDGEBASE_CREATOR.md`
3. Read `.agents/agents/OVERVIEW_KB_BUILDER.md`
4. Read the generated `knowledge-base/_sources/INITKB_HANDOFF.md`

Use the handoff file as the source of truth for the KB path, source run folder, archive path, revalidation commands, and ready-to-paste enrichment prompt.

Prioritise custom modules. Do not change required headings, table structures, or link targets.

## Post-enrichment validation

Re-run the validation commands listed in `INITKB_HANDOFF.md`.

Do not report success unless both pass after enrichment.

## Failure handling

Stop and report concrete remediation when any of these occur:

- `mx.exe` cannot be resolved
- no `.mpr` can be resolved
- the runner exits with an error
- the quality gate reports `fail`
- a KB-targeted rebuild cannot resolve `_sources/creator-link.json`

Use the runner's current guidance when reporting remediation:

- set or fix `MENDIX_MX_EXE`, `STUDIO_PRO_PATH`, or `MENDIX_STUDIO_PRO_PATH`
- set or fix `MPR_FILE_PATH`, `MENDIX_MPR_PATH`, or `MENDIX_APP_PATH`
- inspect the archived `mendix-data.archive.<timestamp>` folder when a targeted rebuild needs the previous output
- recreate or repair `_sources/creator-link.json` when the KB redirect has lost its creator linkage

## Completion report

When `/initkb` finishes, report:

- app name
- source run folder
- data root
- KB root
- creator-link path
- handoff file path
- pipeline status: scaffold validation, quality gate, benchmark
- enrichment summary: which files were enriched and what was added
- remaining gaps or unresolved Unknown items
- post-enrichment validation results
