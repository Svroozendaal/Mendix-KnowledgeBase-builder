# PROMPT 07: Add Partial Re-Run Flags to Pipeline

## Priority

Medium — saves significant development iteration time and is a prerequisite for comfortable daily use.

## Context

Read before starting:

1. `.agents/AGENTS.md` and `.agents/FRAMEWORK.md`
2. `.app-info/product-plan/03-TOOLCHAIN_ARCHITECTURE.md` — partial re-run strategy section.

## Problem Statement

`run-dump-parser.ps1` runs all 8 steps sequentially every time. Steps 1-2 (Mendix dump + parser) are the most time-consuming and require Mendix Studio Pro to be installed. During development and iteration on the composer/quality gate/benchmark, you must re-run the entire pipeline including these expensive steps even when the source export has not changed.

There is no way to:
- Skip the dump step when you already have the `.mpr` dump.
- Skip the parser step when you already have the parsed JSON.
- Skip the scaffold step when the KB folder structure already exists.
- Point to a specific run folder instead of auto-detecting the latest.

## Entry Criteria

1. Pipeline script exists at `KnowledgeBase-Creator/run-dump-parser.ps1`.
2. The script has a clear step structure (steps 1-8).

## Acceptance Criteria

1. Four new parameters are supported:
   - `-SkipDump` (switch) — skip step 1 (`mx dump-mpr`).
   - `-SkipParser` (switch) — skip step 2 (`ModelOverviewCli`).
   - `-SkipScaffold` (switch) — skip step 3 (scaffold creation) and step 4 (template seeding).
   - `-RunFolder` (string) — explicit run folder path, bypassing auto-detection.
2. Parameters are validated:
   - `-SkipDump` requires either `-RunFolder` or an existing run folder from a previous execution.
   - `-SkipParser` requires parsed JSON files to exist in the run folder.
   - `-SkipScaffold` requires the KB output folder to already exist.
   - `-RunFolder` must point to an existing directory containing `manifest.json`.
3. Step output clearly indicates when a step is skipped: `[1/8] Dump .mpr — SKIPPED (--SkipDump)`.
4. Skipped steps do not affect subsequent steps — all downstream steps receive the correct paths.
5. The full pipeline (no skip flags) continues to work identically to today.
6. Combined usage works: `.\run-dump-parser.ps1 -SkipDump -SkipParser -SkipScaffold -RunFolder "path/to/run"` runs only steps 5-8 (compose, validate, quality gate, benchmark).

## Scope

### Files to Modify

1. `KnowledgeBase-Creator/run-dump-parser.ps1` — add parameters and skip logic.

### Specific Changes

#### Step 1: Add parameters to the param block

The current param block reads `.env` for configuration. Add the new switch and string parameters:

```powershell
param(
    [switch]$SkipDump,
    [switch]$SkipParser,
    [switch]$SkipScaffold,
    [string]$RunFolder
)
```

These are in addition to the existing `.env`-based configuration (`STUDIO_PRO_PATH`, `MPR_FILE_PATH`, `APP_NAME`, `MENDIX_DATA_ROOT`).

#### Step 2: Add validation logic

After loading `.env` and before step 1:

```powershell
# If RunFolder is specified, validate it exists and contains manifest.json
if ($RunFolder) {
    if (-not (Test-Path $RunFolder -PathType Container)) {
        Write-Host "ERROR: RunFolder does not exist: $RunFolder" -ForegroundColor Red
        exit 1
    }
    if (-not (Test-Path (Join-Path $RunFolder "manifest.json") -PathType Leaf)) {
        Write-Host "ERROR: RunFolder does not contain manifest.json: $RunFolder" -ForegroundColor Red
        exit 1
    }
}

# If SkipDump is set, we need an existing run folder
if ($SkipDump -and -not $RunFolder) {
    # Auto-detect latest run folder
    $latestRun = Get-ChildItem "$dataRoot/app-overview" -Directory | Sort-Object Name -Descending | Select-Object -First 1
    if (-not $latestRun) {
        Write-Host "ERROR: -SkipDump requires -RunFolder or an existing run in app-overview/" -ForegroundColor Red
        exit 1
    }
    $RunFolder = $latestRun.FullName
    Write-Host "Auto-detected run folder: $RunFolder"
}

# If SkipParser is set, verify parsed JSON exists
if ($SkipParser) {
    $manifestPath = Join-Path $RunFolder "manifest.json"
    if (-not (Test-Path $manifestPath -PathType Leaf)) {
        Write-Host "ERROR: -SkipParser requires parsed JSON in RunFolder. Missing: manifest.json" -ForegroundColor Red
        exit 1
    }
}

# If SkipScaffold is set, verify KB output folder exists
if ($SkipScaffold) {
    $kbDir = Join-Path $dataRoot "knowledge-base/$appName"
    if (-not (Test-Path $kbDir -PathType Container)) {
        Write-Host "ERROR: -SkipScaffold requires existing KB folder: $kbDir" -ForegroundColor Red
        exit 1
    }
}
```

#### Step 3: Wrap each step in a skip guard

For each of the 8 steps, wrap in a conditional:

```powershell
# Step 1: Dump
if ($SkipDump) {
    Write-Host "`n[1/8] Dump .mpr — SKIPPED (-SkipDump)" -ForegroundColor Yellow
} else {
    Write-Host "`n[1/8] Dumping .mpr..."
    # existing dump logic
}

# Step 2: Parser
if ($SkipParser) {
    Write-Host "`n[2/8] Run parser — SKIPPED (-SkipParser)" -ForegroundColor Yellow
} else {
    Write-Host "`n[2/8] Running parser..."
    # existing parser logic
}

# Step 3 & 4: Scaffold + templates
if ($SkipScaffold) {
    Write-Host "`n[3/8] Scaffold KB — SKIPPED (-SkipScaffold)" -ForegroundColor Yellow
    Write-Host "`n[4/8] Seed templates — SKIPPED (-SkipScaffold)" -ForegroundColor Yellow
} else {
    Write-Host "`n[3/8] Scaffolding KB..."
    # existing scaffold logic
    Write-Host "`n[4/8] Seeding templates..."
    # existing template logic
}

# Steps 5-8 always run (compose, validate, quality gate, benchmark)
```

#### Step 4: Ensure run folder variable flows through

After the skip guards, ensure the `$RunFolder` variable (whether auto-detected or user-provided) is used consistently by all downstream steps. The composer needs `-RunFolder`, the quality gate needs the KB root, and the benchmark needs the KB root. Trace through the existing variable assignments to make sure they work when earlier steps are skipped.

#### Step 5: Update the README

Add a "Development Shortcuts" section to `KnowledgeBase-Creator/README.md` documenting the skip flags:

```markdown
## Development Shortcuts

Re-run only composition and validation (fastest iteration loop):

```powershell
.\run-dump-parser.ps1 -SkipDump -SkipParser -SkipScaffold -RunFolder "mendix-data/app-overview/cli_2026-03-05T14-38-13.865Z"
```

Re-run from parser onwards (when .mpr has not changed):

```powershell
.\run-dump-parser.ps1 -SkipDump
```
```

### What NOT to Change

1. Do not change the step logic itself — only wrap it in conditionals.
2. Do not change the `.env` loading behaviour.
3. Do not change the composer, quality gate, or benchmark scripts.
4. Do not change the step ordering (1-8).

## Verification Steps

After implementing:

1. Run the full pipeline (no flags) — must work identically to before:
   ```powershell
   .\run-dump-parser.ps1
   ```
2. Run with `-SkipDump -SkipParser -SkipScaffold -RunFolder "path/to/latest/run"`:
   - Steps 1-4 should print "SKIPPED".
   - Steps 5-8 should run normally.
   - Output should match a full pipeline run.
3. Run with `-SkipDump` only (no RunFolder):
   - Should auto-detect the latest run folder.
   - Step 1 should print "SKIPPED".
   - Steps 2-8 should run normally.
4. Run with invalid `-RunFolder`:
   - Should fail with a clear error message and exit code 1.
5. Run with `-SkipParser` but no existing JSON:
   - Should fail with a clear error message.

## Exit Criteria

1. All four parameters work correctly.
2. Validation catches invalid parameter combinations.
3. Full pipeline (no flags) is unaffected.
4. Skip messages clearly indicate which steps were skipped.
5. README updated with usage examples.

## Estimated Scope

Moderate change to `run-dump-parser.ps1`:

- Add param block (~5 lines).
- Add validation logic (~30 lines).
- Wrap 4 steps in skip guards (~20 lines of conditionals).
- Update README (~10 lines).
