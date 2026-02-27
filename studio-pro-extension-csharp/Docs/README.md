# Studio Pro Extension Documentation

This folder contains the primary technical documentation for the `AutoCommitMessage` Studio Pro extension (`studio-pro-extension-csharp`).

## Audience

- Maintainers of the C# extension.
- Engineers working on the downstream commit-message pipeline.
- Contributors who need to debug change analysis or export behaviour.

## Reading order

1. `ARCHITECTURE.md` for the end-to-end component model and runtime flow.
2. `PROCESSING_PIPELINE.md` for model diffing, structuring, and display-text generation.
3. `EXPORT_CONTRACT.md` for JSON output and storage contracts.
4. `REPOSITORY_WORKFLOWS.md` for build, deploy, run, and collaboration workflows.
5. `OPEN_QUESTIONS.md` for unresolved product and operational decisions.

## Existing focused docs

- `info_studio-pro-extension-csharp.md`: compact module summary.
- `info_ui.md`: UI entry points and responsibilities.
- `info_processing.md`: processing module summary.
- `info_model-change-display-text-formatter.md`: formatter rule details.

## Source areas covered by these docs

- `UI/` (dockable pane, menu, in-extension web route/UI)
- `Processing/` (Git analysis, model dump comparison, export)
- `manifest.json` and `AutoCommitMessage.csproj`
- root workflow scripts:
  - `deploy-autocommitmessage.ps1`
  - `start-mendix-app.ps1`
