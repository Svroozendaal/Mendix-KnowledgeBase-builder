# Repository Workflows

## Purpose

This document describes how this repository is currently used for extension development, validation, and data export operations.

## Prerequisites

- Windows environment (Studio Pro + `mx.exe`).
- .NET SDK compatible with `net8.0-windows`.
- Mendix Studio Pro 10 installation.
- Local Mendix app repository with an `.mpr` file.

## Key paths

- Extension project: `studio-pro-extension-csharp/AutoCommitMessage.csproj`
- Extension manifest: `studio-pro-extension-csharp/manifest.json`
- Deploy script: `deploy-autocommitmessage.ps1`
- Studio Pro launcher: `start-mendix-app.ps1`
- Data root default: `mendix-data/`

## Core local workflow

1. Set optional defaults in `.env` (copy from `.env.example`).
2. Build and deploy extension into app `extensions/AutoCommitMessage`.
3. Start Studio Pro with extension development enabled.
4. Open AutoCommitMessage pane in Studio Pro.
5. Use Refresh to inspect change analysis.
6. Use Export to generate JSON payload for downstream pipeline.

## `.env`-driven configuration

Supported values used by scripts:

- `MENDIX_APP_PATH`: target Mendix app root.
- `MENDIX_DATA_ROOT`: target export/data root for deploy build metadata.
- `MENDIX_STUDIOPRO_EXE`: optional explicit path to `studiopro.exe`.

## Build and deploy workflow

Command:

```powershell
.\deploy-autocommitmessage.ps1
```

What it does:

1. Resolves app/data paths from parameters or `.env`.
2. Builds project with explicit `MendixDataRoot` MSBuild property.
3. Copies `AutoCommitMessage.dll` and `manifest.json` to app extension folder.
4. Creates data-root folders if missing.

Useful variants:

```powershell
.\deploy-autocommitmessage.ps1 -Configuration Release
.\deploy-autocommitmessage.ps1 -AppPath "C:\Workspaces\Mendix\YourApp"
.\deploy-autocommitmessage.ps1 -DataRootPath "D:\MendixData\AutoCommit"
.\deploy-autocommitmessage.ps1 -SkipBuild
```

## Run workflow (Studio Pro)

Command:

```powershell
.\start-mendix-app.ps1
```

What it does:

1. Resolves app path and Studio Pro executable.
2. Locates first `.mpr` in app root.
3. Launches Studio Pro with `--enable-extension-development`.

## UI usage workflow

Inside Studio Pro:

1. Open pane via menu entries:
   - `Open AutoCommitMessage`
   - `Close AutoCommitMessage`
2. Review changed files table and diff pane.
3. Inspect model changes grouped by module for selected `.mpr`.
4. Refresh after local modifications.
5. Export when payload should be handed to downstream parser flow.

## Data processing workflow across repository

Current data path convention:

1. Extension writes raw exports to `mendix-data/exports`.
2. Downstream tooling (outside this project area) can move files to:
   - `processed`
   - `errors`
   - `structured`
3. Model dump snapshots for export sessions are stored in `mendix-data/dumps`.

## Documentation workflow

Current intended split:

- Deep technical documentation for extension runtime: `studio-pro-extension-csharp/Docs`.
- App-level index and routing documentation: `.app-info/`.

Update pattern:

1. Update extension docs first when behaviour changes.
2. Update `.app-info` product/features/docs index pointers.
3. Keep feature status and implementation notes aligned.

## Change and release hygiene

- Keep extension class naming aligned with `AutoCommitMessage*`.
- Avoid committing generated `bin/` and `obj/` artefacts.
- Rebuild when changing compile-time metadata such as `MendixDataRoot`.
- Validate export contract changes with downstream parser owners before merge.

## Improvement opportunities

- Add automated smoke script to run build + deploy + basic route checks.
- Add CI validation for docs link integrity and schema examples.
- Define a lightweight release checklist for versioned extension drops.
