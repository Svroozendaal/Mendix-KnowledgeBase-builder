# KnowledgeBase Creator

Portable toolchain for generating an AI-usable Mendix knowledge base from parser export JSON while preserving the existing KB file contract.

## Included Scripts

- `run-dump-parser.ps1`: full pipeline entrypoint (dump -> parser -> scaffold -> compose -> validate -> quality -> benchmark).
- `run-kb-scaffold.ps1`: scaffold and structural file-presence validation.
- `run-kb-compose.ps1`: deterministic KB composition with conservative `Unknown` handling and `_reports/UNKNOWN_TODO.md`.
- `run-kb-quality-gate.ps1`: structural + semantic completeness gate.
- `run-kb-semantic-benchmark.ps1`: structural benchmark (mandatory) + optional app-specific benchmark.

## `.env` Contract

Required for dump step:

- `STUDIO_PRO_PATH`
- `MPR_FILE_PATH`
- `APP_NAME`

Optional:

- `MENDIX_MX_EXE` (explicit `mx.exe` override)
- `MENDIX_DATA_ROOT` (default: `../mendix-data`)
- `MENDIX_MODULES` (default: `*`)
- `STRICT_MODE` (`true|false`, default: `false`)
- `CUSTOM_SCENARIOS_PATH` (optional app-specific benchmark JSON)
- `DUMP_FILE_PATH` (when using `-SkipDump` without `-SkipParser`)

Backward-compatible aliases are still accepted (`MENDIX_STUDIO_PRO_PATH`, `MENDIX_MPR_PATH`, `MENDIX_APP_PATH`, `STRICT_QUALITY_GATE`).

## Main Usage

Full run:

```powershell
./run-dump-parser.ps1
```

Resume from existing parser run folder:

```powershell
./run-dump-parser.ps1 -SkipDump -SkipParser -SkipScaffold -RunFolder "mendix-data/app-overview/cli_2026-03-05T14-38-13.865Z"
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

## App-Specific Scenarios

SmartExpenses pilot scenarios are provided at:

- `benchmarks/smartexpenses-custom-scenarios.json`

Run directly:

```powershell
./run-kb-semantic-benchmark.ps1 -OutputRoot mendix-data/knowledge-base -AppName SmartExpenses -CustomScenarios benchmarks/smartexpenses-custom-scenarios.json
```

## CI Regression

- Reference export fixture: `tests/reference/app-overview/cli_reference_minimal`
- Baseline KB snapshot: `tests/reference/baseline-kb/ReferenceApp`
- Regression runner: `KnowledgeBase-Creator/scripts/run-reference-regression.ps1`
- GitHub Actions workflow: `.github/workflows/kb-regression.yml` (runs on PR + push to `main`)
