# AutoCommitMessage Extension (Studio Pro 10)

Studio Pro 10 dockable-pane extension for analysing Mendix repository changes (`.mpr`, `.mprops`) with model-level `.mpr` diff extraction and export-ready JSON.

## Structure

- `UI/`
  - Dockable pane and menu integration
  - Internal web route handler
  - In-extension HTML/CSS/JS view
- `Processing/`
  - Contracts and shared constants
  - Change discovery and export services
  - Mendix dump diffing and converter formatting
- `Docs/`
  - Technical module documentation (`info_*.md`)

## Current behaviour

1. Filters repository status to Mendix model/config files only (`*.mpr`, `*.mprops`).
2. Renders a WebView UI with:
   - left pane: `Model changes (.mpr)`
   - right pane: `Changed files` and `Diff`
3. `Refresh` re-runs repository and model analysis.
4. `Export` writes payload JSON and persists `working/head` model dumps for changed `.mpr` files.
5. Exported model elements include `displayText` generated from converter rules.

## Build

```powershell
dotnet build .\studio-pro-extension-csharp\AutoCommitMessage.csproj -c Debug
```

Build output:

- `studio-pro-extension-csharp\bin\Debug\net8.0-windows\AutoCommitMessage.dll`
- `studio-pro-extension-csharp\bin\Debug\net8.0-windows\manifest.json`

## Deploy to Mendix app

Default target app path:

```powershell
.\deploy-autocommitmessage.ps1
```

Set shared local defaults in a repo-root `.env` file (copy from `.env.example`):

```dotenv
MENDIX_APP_PATH=C:\MendixWorkers\Smart Expenses app-main
MENDIX_DATA_ROOT=C:\Workspace\Mendix-AutoCommitMessage\mendix-data
```

The deploy script uses `MENDIX_APP_PATH` and `MENDIX_DATA_ROOT` automatically when parameters are not provided.

Or specify a custom app path directly:

```powershell
.\deploy-autocommitmessage.ps1 -AppPath "C:\Workspaces\Mendix\YourApp"
```

Custom shared data root:

```powershell
.\deploy-autocommitmessage.ps1 -DataRootPath "C:\Path\To\Mendix-CommitMessage\mendix-data"
```

Deployment target:

- `<AppPath>\extensions\AutoCommitMessage\AutoCommitMessage.dll`
- `<AppPath>\extensions\AutoCommitMessage\manifest.json`

The extension writes data to `<DataRootPath>` folders:

- `exports`
- `processed`
- `errors`
- `structured`
- `dumps`

## Start the Mendix app quickly

Use the root launcher script:

```powershell
.\start-mendix-app.ps1
```

It reads `MENDIX_APP_PATH` from `.env`, locates `studiopro.exe`, and starts Studio Pro with extension development enabled using `--enable-extension-development`.

## Notes

- No localhost web server or `npm` workflow is required.
- Pane URL includes a cache-buster token per open.
- Build artefacts under `studio-pro-extension-csharp/bin` and `studio-pro-extension-csharp/obj` are intentionally ignored by git.
