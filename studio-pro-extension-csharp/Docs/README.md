# Studio Pro Extension Documentation

This folder contains the primary technical documentation for the `AutoCommitMessage` Studio Pro extension (`studio-pro-extension-csharp`).

## Audience

- Maintainers of the C# extension.
- Engineers working on downstream parsing and commit-message automation.
- Contributors debugging change analysis, overview generation, or export behaviour.

## Reading order

1. `ARCHITECTURE.md` for runtime components, routes, and data-path model.
2. `PROCESSING_PIPELINE.md` for change analysis, export, overview, and commit-message storage pipelines.
3. `EXPORT_CONTRACT.md` for raw-change JSON contract.
4. `MODEL_OVERVIEW_EXPORT_CONTRACT.md` for full-model overview contracts.
5. `REPOSITORY_WORKFLOWS.md` for build/deploy/run workflows.
6. `OPEN_QUESTIONS.md` for unresolved decisions.

## Focused docs

- `info_studio-pro-extension-csharp.md`: compact module summary.
- `info_ui.md`: UI entry points and responsibilities.
- `info_processing.md`: processing module summary.
- `info_model-change-display-text-formatter.md`: formatter rule details.

## Source areas covered

- `UI/` (dockable pane, menu, route handler, embedded web UI)
- `Processing/` (Git analysis, dump diffing, overview parsing, export, storage)
- `manifest.json` and `AutoCommitMessage.csproj`
- Root scripts:
  - `deploy-autocommitmessage.ps1`
  - `start-mendix-app.ps1`

