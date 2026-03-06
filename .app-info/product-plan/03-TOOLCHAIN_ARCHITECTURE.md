# Toolchain Architecture

## Objective

Define the script-level architecture for generating an AI-useful KB with current file contract preserved.

## Runtime Pipeline

1. `run-dump-parser.ps1` (entrypoint):
   - dumps `.mpr`
   - runs overview parser
   - scaffolds KB structure
   - runs KB composer
   - runs scaffold validation
   - runs quality gate
   - runs semantic benchmark.
2. `run-kb-scaffold.ps1` (existing):
   - creates expected folder/file skeleton and manifest copy.
3. `run-kb-compose.ps1` (new):
   - composes all KB markdown from overview export JSON.
4. `run-kb-quality-gate.ps1` (expanded):
   - structural checks
   - semantic threshold checks.
5. `run-kb-semantic-benchmark.ps1` (new):
   - canonical QA benchmark with score and critical-failure policy.

## Data Flow

1. Input:
   - `mendix-data/app-overview/<run>/manifest.json`
   - `general/*.json`
   - `modules/*/{domain-model,flows,pages,resources}.json`
2. Output:
   - `mendix-data/knowledge-base/<app>/...` markdown files
   - benchmark/validation terminal report.

## Generation Boundaries

1. Parser is source-of-truth for model extraction (`schemaVersion: 2.0`).
2. Composer owns markdown synthesis and tiered narratives.
3. Quality gate owns pass/fail enforcement.
4. Benchmark owns QA-style confidence scoring.

## Deterministic Composition Rules

1. Sort modules alphabetically.
2. Use stable sort on names for entities/pages/flows.
3. Build rankings using deterministic score formulas and tie-breakers.
4. Keep link paths relative and resolvable.

## Script Contracts

### `run-kb-compose.ps1`

Parameters:

1. `-RunFolder` (required)
2. `-AppName` (required)
3. `-OutputRoot` (optional, default `mendix-data/knowledge-base`)
4. `-SkipScaffold` (optional)

Responsibilities:

1. Validate source contract.
2. Build app, module, route docs.
3. Apply custom-depth and tier rules.
4. Minimise avoidable unknowns.

### `run-kb-quality-gate.ps1` (expanded)

Responsibilities:

1. Preserve existing structural checks.
2. Add semantic checks for custom modules.
3. Emit explicit metric values and thresholds.

### `run-kb-semantic-benchmark.ps1`

Responsibilities:

1. Execute canonical QA scenarios.
2. Score each scenario.
3. Enforce minimum score and critical-failure policy.

## Backward Compatibility

1. No file path changes for generated KB.
2. Existing consumers can continue using current pointer structure.
3. New scripts are additive and integrated through `run-dump-parser.ps1`.

## Configuration Contract (`.env`)

`run-dump-parser.ps1` reads a `.env` file in the `KnowledgeBase-Creator/` root. Required variables:

| Variable | Required | Default | Description |
|---|---|---|---|
| `STUDIO_PRO_PATH` | Yes (for dump step) | none | Path to Mendix Studio Pro installation containing `mx.exe` |
| `MPR_FILE_PATH` | Yes | none | Absolute path to the `.mpr` file to dump |
| `APP_NAME` | Yes | none | Logical app name used as KB output folder name |
| `MENDIX_DATA_ROOT` | No | `../mendix-data` | Root for `app-overview/` and `knowledge-base/` output |
| `STRICT_MODE` | No | `false` | When `true`, quality gate warnings become errors |

Validation:

1. `run-dump-parser.ps1` must fail early with a clear message if required variables are missing.
2. Path variables must be validated for existence before proceeding.

## Partial Re-Run Strategy

The pipeline supports skip flags to allow resuming from a specific step:

1. `-SkipDump` — skip `mx dump-mpr` (step 1). Requires an existing run folder.
2. `-SkipParser` — skip `ModelOverviewCli` (step 2). Requires parsed JSON already present.
3. `-SkipScaffold` — skip scaffold creation (step 3). Requires KB folder structure to exist.
4. `-RunFolder` — explicit run folder path, bypassing auto-detection of latest run.

Usage pattern for re-running only composition and validation:

```powershell
.\run-dump-parser.ps1 -SkipDump -SkipParser -SkipScaffold -RunFolder "path/to/run"
```

## Template and Composer Relationship

Templates in `artifacts/` serve two purposes:

1. **Scaffold seeding** (step 4): templates are copied with token substitution to create initial file structure. This ensures the KB folder is immediately navigable even before composition runs.
2. **Contract reference**: template headings define the structural contract that the quality gate enforces.

The composer (step 5) **overwrites** template-seeded files with fully derived content. Templates are therefore not redundant — they provide the fallback structure when composition is skipped or partially fails, and they are the source of truth for required heading contracts.

Rule: when adding new required headings, update both the relevant template in `artifacts/` and the composer's rendering logic.

## Parser Build and Distribution

The C# parser (`Mendix-model-overview-parser/`) is distributed as:

1. **Pre-built binary**: `ModelOverviewCli.exe` included in the portable package for Windows.
2. **Source fallback**: `dotnet run` against the project file when the binary is absent or on non-Windows platforms.

Build and versioning rules:

1. Parser version is tracked in the project's `.csproj` file.
2. The GitHub Actions artifact workflow (`build-knowledgebase-creator-artifact.yml`) must include a `dotnet publish` step.
3. Schema version (`2.0`) is embedded in parser output and validated by both scaffold and composer.

## Operational Logging

Each run should print:

1. Run folder
2. App name
3. Module count
4. Structural validation status
5. Quality gate status with semantic metrics
6. Benchmark score and verdict.
