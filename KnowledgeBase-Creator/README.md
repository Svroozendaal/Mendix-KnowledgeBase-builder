# KnowledgeBase Creator

Standalone Windows toolchain for generating an AI-usable Mendix knowledge base from a `.mpr` file while preserving the KB file contract.

Root layout contract:

- `.env`
- `AGENTS.md`
- `README.md`
- `KnowledgeBaseCreator.exe`
- all folders

## Default Entry Point (Wizard EXE)

Run:

```powershell
.\KnowledgeBaseCreator.exe
```

The wizard guides you through:

1. Selecting the source `.mpr` file.
2. Auto-detecting the correct Mendix `mx.exe` (with manual override).
3. Running the full pipeline (dump -> parser -> scaffold -> compose -> validate -> quality -> benchmark).
4. Showing the Mendix app folder path that was used as source.

By default, output is written to:

`<mpr-folder>\mendix-data\`

Generated structure:

- `mendix-data/app-overview/<run-folder>/` - parsed model exports
- `mendix-data/dumps/<timestamp>_<app>/` - raw dump files
- `mendix-data/knowledge-base/` - the standalone AI-navigable KB
  - `knowledge-base/.agents/` - AI interpretation agents (shipped with KB)
  - `knowledge-base/CLAUDE.md` - AI bootstrap entry point
  - `knowledge-base/_sources/creator-link.json` - linkage back to this creator package for `/enrichkb` and `/initkb`

Each `mendix-data` folder is treated as one app workspace. The generated knowledge base lives directly inside `knowledge-base`, not inside `knowledge-base/<app-name>`.
The `knowledge-base/` folder is self-contained and can be copied/shared standalone.
If a non-empty `mendix-data` folder already exists, a fresh parser run now fails instead of overwriting it.

## AI-Assisted KB Creation

Use the `/initkb` slash command from inside `KnowledgeBase-Creator` to run the full pipeline and then guide AI enrichment with the existing creator agents and skills:

```
/initkb
```

This is a creator-package command, not a generated-KB command. It runs the pipeline (Phase 1), continues with semantic enrichment guidance (Phase 2), and finishes with scaffold and quality-gate revalidation. See `AGENTS.md` for the full creation workflow.

If the pipeline already completed and you only want phase 2 AI enrichment, use:

```text
/enrichkb
```

Inside a generated KB, `/enrichkb` is the explicit in-place AI enrichment command. `/initkb` remains available as the full rebuild or compatibility path.

The executable backend behind `/initkb` is:

```powershell
.\wizard\run-initkb.ps1
```

## Script Locations

Core pipeline scripts live in `wizard/`:

- `wizard/run-initkb.ps1`
- `wizard/run-dump-parser.ps1`
- `wizard/run-kb-scaffold.ps1`
- `wizard/run-kb-compose.ps1`
- `wizard/run-kb-quality-gate.ps1`
- `wizard/run-kb-semantic-benchmark.ps1`

## `.env` + Environment Contract

Script mode still supports `.env` in `KnowledgeBase-Creator/.env`.

Runtime precedence:

1. Process environment variables
2. `.env` values
3. Built-in defaults

Common settings:

- `APP_NAME`
- `MPR_FILE_PATH` (or `MENDIX_MPR_PATH`)
- `MENDIX_MX_EXE` (preferred explicit `mx.exe` path)
- `STUDIO_PRO_PATH` / `MENDIX_STUDIO_PRO_PATH` (fallback when `MENDIX_MX_EXE` is not set)
- `MENDIX_DATA_ROOT` (default: `../mendix-data` in script mode)
- `MENDIX_MODULES` (default: `*`)
- `STRICT_MODE` (`true|false`, default: `false`)
- `CUSTOM_SCENARIOS_PATH` (optional)
- `DUMP_FILE_PATH` (for `-SkipDump` without `-SkipParser`)

Backward-compatible aliases remain accepted (`MENDIX_APP_PATH`, `STRICT_QUALITY_GATE`, `CUSTOM_SCENARIOS`, `DUMP_PATH`).

When no MPR path is configured, script mode also auto-detects a single `.mpr` in the parent folder of `KnowledgeBase-Creator` (or in `KnowledgeBase-Creator` itself).

## Script Usage (Advanced / CI)

Full run:

```powershell
.\wizard\run-initkb.ps1 -OpenVsCode
```

AI enrichment only:

```text
/enrichkb
```

Target an existing generated KB:

```powershell
.\wizard\run-initkb.ps1 -KnowledgeBaseRoot "C:\path\to\knowledge-base" -OpenVsCode
```

Pipeline primitive only:

```powershell
.\wizard\run-dump-parser.ps1
```

Resume from existing parser run folder:

```powershell
.\wizard\run-dump-parser.ps1 -SkipDump -SkipParser -SkipScaffold -RunFolder "mendix-data/app-overview/cli_2026-03-05T14-38-13.865Z"
```

## Quality + Benchmark Policy

- `run-kb-quality-gate.ps1` fails on structural issues or semantic coverage below thresholds:
  - Page-flow linkage: `>=95%`
  - Flow entity coverage: `>=90%`
  - Entity lifecycle mapping: `>=90%`
- `run-kb-semantic-benchmark.ps1` always runs structural scenarios:
  - pass requires `>=80/100` and no critical failures.
- App-specific benchmark is optional (`-CustomScenarios`):
  - pass requires `>=85/100` and no critical failures.
- Final benchmark score:
  - structural-only when no custom scenarios;
  - weighted score when both run (default weights: structural `0.7`, custom `0.3`).

## CI Regression

- Reference export fixture: `tests/reference/app-overview/cli_reference_minimal`
- Baseline KB snapshot: `tests/reference/baseline-kb/ReferenceApp`
- Regression runner: `KnowledgeBase-Creator/scripts/run-reference-regression.ps1`
- GitHub Actions workflow: `.github/workflows/kb-regression.yml` (runs on PR + push to `main`)
