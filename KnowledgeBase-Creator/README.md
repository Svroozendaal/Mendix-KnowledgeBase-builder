# KnowledgeBase Creator

Standalone CLI toolset for generating and enriching an AI-usable Mendix knowledge base from a `.mpr` file while preserving the KB file contract.

This package is now CLI-only. The Windows wizard executable, Copilot UI, and Mendix extension have been removed.

## Public Entry Points

Public repo-level skills:

- `../tool-usage/knowledgebase/SKILL.md` - end-to-end KB creation
- `../tool-usage/knowledgebase-reader/SKILL.md` - KB interpretation and routing

Creator-package internals:

- `.\cli\run-initkb.ps1` - preferred end-to-end runner
- `.\cli\run-enrichkb.ps1` - enrichment-only runner
- `.\cli\run-dump-parser.ps1` - deterministic pipeline primitive
- `.\AGENTS.md` - creator bootstrap for AI agents

## Output Layout

By default, output is written to `<mpr-folder>\mendix-data\`.

Generated structure:

- `mendix-data/app-overview/<run-folder>/` - parsed model exports
- `mendix-data/dumps/<timestamp>_<app>/` - raw dump files for the legacy extractor only
- `mendix-data/knowledge-base/` - standalone KB output
  - `knowledge-base/.agents/` - rich interpretation agents shipped with the KB
  - `knowledge-base/READER.md` - KB reader entry point
  - `knowledge-base/_sources/creator-link.json` - linkage back to this creator package

Each `mendix-data` folder is treated as one app workspace. The generated KB lives directly inside `knowledge-base/`.

## Environment Contract

`.env` in `KnowledgeBase-Creator/.env` is still supported.

Runtime precedence:

1. Process environment variables
2. `.env`
3. Built-in defaults

Common settings:

- `APP_NAME`
- `MPR_FILE_PATH` or `MENDIX_MPR_PATH`
- `MENDIX_MX_EXE`
- `STUDIO_PRO_PATH` or `MENDIX_STUDIO_PRO_PATH`
- `MENDIX_DATA_ROOT`
- `MENDIX_MODULES`
- `KB_EXTRACTION_MODE` (`LegacyDumpParser|MxCli`, default `MxCli`)
- `STRICT_MODE`
- `CUSTOM_SCENARIOS_PATH`
- `DUMP_FILE_PATH`

Backward-compatible aliases still resolve where supported by the scripts.

## CLI Usage

Full creation flow:

```powershell
.\cli\run-initkb.ps1 -OpenVsCode
```

Enrichment only:

```powershell
.\cli\run-enrichkb.ps1 -KnowledgeBaseRoot "C:\path\to\knowledge-base"
```

Pipeline primitive only:

```powershell
.\cli\run-dump-parser.ps1
```

Explicit legacy fallback:

```powershell
.\cli\run-dump-parser.ps1 -ExtractionMode LegacyDumpParser
```

Explicit MxCli mode:

```powershell
.\cli\run-dump-parser.ps1 -ExtractionMode MxCli
```

Resume from an existing run folder:

```powershell
.\cli\run-dump-parser.ps1 -SkipDump -SkipParser -SkipScaffold -RunFolder "mendix-data/app-overview/cli_2026-03-05T14-38-13.865Z"
```

## Quality and Benchmark

- `run-kb-quality-gate.ps1` fails on structural issues or semantic coverage below thresholds.
- `run-kb-semantic-benchmark.ps1` always runs structural scenarios.
- App-specific custom scenarios remain optional.

Do not report completion unless scaffold validation and the quality gate both pass.

## Regression

- Reference export fixture: `tests/reference/app-overview/cli_reference_minimal`
- Baseline KB snapshot: `tests/reference/baseline-kb/ReferenceApp`
- Regression runner: `KnowledgeBase-Creator/scripts/run-reference-regression.ps1`
- CI workflow: `.github/workflows/kb-regression.yml`
