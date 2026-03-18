# MxCLI Integration Prompt Index

## Purpose

Implementation prompts for converting KnowledgeBase Creator from `mx dump-mpr + C# parser` to `mxcli` on `PATH`, while keeping the existing JSON v2.0 -> composer -> static KB -> enrichment model intact through the core migration.

## Research Subfolder

Use `.app-info/development/prompts/MxCLI integration/App information/` as the research baseline for architecture, schema mapping, routing, enrichment, and agent impact. Treat it as research, not as the final source of truth. The installed `mxcli` contract validated on the machine is authoritative.

## Required Design Artefacts

Prompt 01 creates or updates these artefacts. Every later prompt must keep them current before moving on:

- `.app-info/docs/MXCLI_KB_CREATOR_TARGET_ARCHITECTURE.md`
- `.app-info/docs/MXCLI_COMMAND_CAPABILITY_MATRIX.md`
- `.app-info/docs/MXCLI_PARITY_GAP_LEDGER.md`

## Execution Rules

1. Before each prompt, read `.agents/AGENTS.md`, `.agents/FRAMEWORK.md`, `.app-info/ROUTING.md`, this index, and the relevant design artefacts.
2. After reading the context, ask clarifying workflow questions before execution if any material ambiguity remains. If nothing material is unclear, state that no workflow questions remain and proceed.
3. Validate `mxcli` assumptions on the command line before relying on them in implementation details.
4. Use `mendix-data/knowledge-base/` as the folder-contract and content-pattern reference, not as a strict numeric parity oracle.
5. Keep `mxcli` PATH-only for this track. Do not bundle it in the package and do not require changes in `C:\Workspaces\Tools\mxcli`.
6. Until Prompt 06, preserve the legacy extraction route and avoid changing the creator default.
7. If implementation changes the intended system shape, update the target architecture, capability matrix, and parity gap ledger before proceeding.
8. Before closing a prompt, Claude must run the prompt's verification steps and explicitly report acceptance-criteria PASS/FAIL. Do not continue to the next prompt on a failed validation gate.

## Reference Inputs

- Validation app: `C:\Workspaces\Mendix\Emixa_InspectionApp\Emixa_InspectionApp.mpr`
- Creator package: `KnowledgeBase-Creator/`
- Current composer: `KnowledgeBase-Creator/wizard/run-kb-compose.ps1`
- KB reference: `mendix-data/knowledge-base/`
- Research notes: `.app-info/development/prompts/MxCLI integration/App information/`

## Prompt Map

| # | Prompt | Priority | Depends On | Scope |
|---|---|---|---|---|
| 01 | [01-TARGET_ARCHITECTURE_AND_BASELINE.md](01-TARGET_ARCHITECTURE_AND_BASELINE.md) | Critical | - | Lock the real installed `mxcli` contract and create the design artefacts. |
| 02 | [02-EXTRACTION_FOUNDATION.md](02-EXTRACTION_FOUNDATION.md) | Critical | 01 | Build the reusable `mxcli` runner, output parsing strategy, and catalog refresh staging. |
| 03 | [03-JSON_V2_GENERAL_MODULE_AND_DOMAIN_OUTPUTS.md](03-JSON_V2_GENERAL_MODULE_AND_DOMAIN_OUTPUTS.md) | Critical | 02 | Generate `manifest.json`, `general/*`, module inventory files, and `domain-model.json`. |
| 04 | [04-FLOW_PAGE_RESOURCE_AND_DETAIL_OUTPUTS.md](04-FLOW_PAGE_RESOURCE_AND_DETAIL_OUTPUTS.md) | Critical | 03 | Generate flows, pages, resources, detail files, and `.pseudo.txt` compatibility outputs. |
| 05 | [05-CREATOR_PIPELINE_DUAL_PATH.md](05-CREATOR_PIPELINE_DUAL_PATH.md) | High | 04 | Add the new extractor to the creator as a selectable dual path. |
| 06 | [06-SWITCHOVER_DOCS_AGENTS_AND_SKILLS.md](06-SWITCHOVER_DOCS_AGENTS_AND_SKILLS.md) | High | 05 | Make `mxcli` the default and update docs, agents, and skills. |
| 07 | [07-LIVE_QUERY_ENHANCEMENTS.md](07-LIVE_QUERY_ENHANCEMENTS.md) | Medium | 06 | Add read-only `mxcli` live-query enhancements without weakening the static-KB-first model. |

## Dependency Graph

```text
Prompt 01 (Target Architecture and Baseline)
  -> Prompt 02 (Extraction Foundation)
    -> Prompt 03 (JSON v2 General, Module, and Domain Outputs)
      -> Prompt 04 (Flow, Page, Resource, and Detail Outputs)
        -> Prompt 05 (Creator Pipeline Dual Path)
          -> Prompt 06 (Switchover, Docs, Agents, and Skills)
            -> Prompt 07 (Live Query Enhancements)
```

## Baseline Validation Commands

Prompt 01 must validate or reconfirm these commands before later prompts depend on them:

- `mxcli --version`
- `mxcli structure -p <app.mpr> -d 1`
- `mxcli project-tree -p <app.mpr>`
- `mxcli show modules -p <app.mpr>`
- `mxcli show associations <module> -p <app.mpr>`
- `mxcli show constants <module> -p <app.mpr>`
- `mxcli describe entity <qualified-name> -p <app.mpr>`
- `mxcli describe enumeration <qualified-name> -p <app.mpr>`
- `mxcli describe page <qualified-name> -p <app.mpr>`
- `mxcli describe microflow <qualified-name> -p <app.mpr>`
- `mxcli callers <qualified-name> -p <app.mpr> --transitive`
- `mxcli refs <qualified-name> -p <app.mpr>`
- `mxcli search -p <app.mpr> <term> --format json`
- `mxcli lint -p <app.mpr> --format json`
- `mxcli report -p <app.mpr> --format json`

## Track-Level Acceptance Rules

- Every prompt must use the acceptance-criteria format.
- Every prompt must include a Design Gate and a Validation Gate.
- Every prompt must block progression until design docs are current and validation has been rerun.
- The core migration prompts must validate app-overview structure, JSON contract compatibility, composer success when applicable, KB contract validation, quality gate, semantic benchmark, and gap-ledger updates.
