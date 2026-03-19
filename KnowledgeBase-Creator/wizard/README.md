# KnowledgeBase Creator Wizard

This folder contains the pipeline scripts and the wizard source project.

## Start

```powershell
..\KnowledgeBaseCreator.exe
```

The published executable lives in the `KnowledgeBase-Creator/` root folder.
This `wizard/` folder keeps the implementation source and the `run-*` scripts only.

If the executable is not present yet (for local source usage), publish it:

```powershell
dotnet publish .\src\KnowledgeBaseCreator.Wizard\KnowledgeBaseCreator.Wizard.csproj -c Release -r win-x64 -o ..
```

## Scripts

- `run-initkb.ps1`
- `run-dump-parser.ps1`
- `run-mxcli-foundation-check.ps1`
- `run-mxcli-json-v2-general-domain.ps1`
- `run-mxcli-json-v2-general-domain-check.ps1`
- `run-mxcli-json-v2-full-run.ps1`
- `run-mxcli-json-v2-full-run-check.ps1`
- `run-kb-scaffold.ps1`
- `run-kb-compose.ps1`
- `run-kb-quality-gate.ps1`
- `run-kb-semantic-benchmark.ps1`

All executable pipeline scripts, including `run-initkb.ps1`, live in `wizard/`.

The standard `run-dump-parser.ps1` pipeline also writes `knowledge-base/_sources/creator-link.json` so generated KBs can run `/enrichkb` in place and use `/initkb` when a creator-side rebuild is required.

## Extraction Mode Contract

Prompts 05-06 use a dual-path extraction contract with MxCli as the default:

- Script parameter: `-ExtractionMode LegacyDumpParser|MxCli`
- Environment/.env key: `KB_EXTRACTION_MODE=LegacyDumpParser|MxCli`
- Default mode from Prompt 06: `MxCli`

`MxCli` mode resolves `mxcli` from `PATH` (`mxcli --version` preflight) and does not require `mx.exe`.
`LegacyDumpParser` remains available as an explicit fallback mode.

## Shared MxCLI Foundation

Prompt 02 adds a reusable MxCLI helper layer at `lib/mxcli-foundation.ps1` plus a smoke-test script at `run-mxcli-foundation-check.ps1`.

See `MXCLI_FOUNDATION.md` for output-kind rules, warning handling, and the fast-versus-full catalog plan used by later extraction prompts.

## Prompt 03 Generator

Prompt 03 adds a reusable partial run-folder generator at `lib/mxcli-json-v2-general-domain.ps1`, an entry script at `run-mxcli-json-v2-general-domain.ps1`, and a verification script at `run-mxcli-json-v2-general-domain-check.ps1`.

See `MXCLI_JSON_V2_GENERAL_DOMAIN.md` for the command set, module-classification rules, and the current evidence-backed gap handling.

## Prompt 04 Generator

Prompt 04 adds full run-folder generation at `lib/mxcli-json-v2-full-run.ps1` with an entry script at `run-mxcli-json-v2-full-run.ps1`.

This stage keeps phase-1 `.pseudo.txt` compatibility while generating:

- module `flows.json`, `pages.json`, `resources.json`
- split detail outputs (`flows/INDEX.json`, `flows/<slug>.json`, `pages/INDEX.json`, `pages/<slug>.json`)
- general/module `.pseudo.txt` companions required by existing downstream consumers
