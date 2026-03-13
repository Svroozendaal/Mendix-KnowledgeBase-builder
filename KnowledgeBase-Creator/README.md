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

- `mendix-data/.agents/`
- `mendix-data/app-overview/<run-folder>/`
- `mendix-data/dumps/<timestamp>_<app>/`
- `mendix-data/knowledge-base/`

Each `mendix-data` folder is treated as one app workspace. The generated knowledge base lives directly inside `knowledge-base`, not inside `knowledge-base/<app-name>`.
If a non-empty `mendix-data` folder already exists, a fresh parser run now fails instead of overwriting it.

## Script Locations

Core pipeline scripts now live in `wizard/`:

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
