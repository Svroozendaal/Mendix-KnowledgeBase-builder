# info_studio-pro-extension-csharp

> Last updated: 2026-02-26

## Purpose

Studio Pro 10 extension that inspects Mendix repository changes (`.mpr`, `.mprops`), shows change analysis in a dockable pane, and exports structured JSON for downstream commit-message processing.

## Folder map

| Folder | Responsibility |
|---|---|
| `UI/` | Mendix UI entry points, pane wiring, menu actions, and in-extension web UI |
| `Processing/` | Change discovery, model diffing, export preparation, and display-text formatting |
| `Docs/` | Co-located technical documentation for this extension |

## Public entry points

| Entry point | File | Notes |
|---|---|---|
| Dockable pane extension | `UI/DockablePane/AutoCommitMessageDockablePaneExtension.cs` | Registers pane and opens web UI |
| Menu extension | `UI/Menu/AutoCommitMessageMenuExtension.cs` | Exposes open/close menu actions |
| Web server extension | `UI/Web/AutoCommitMessageWebServerExtension.cs` | Serves HTML and handles `refresh` / `export` routes |

## Security-sensitive routes and handlers

- `autocommitmessage/?action=export` in `AutoCommitMessageWebServerExtension`:
  - writes export JSON into `mendix-data/exports`
  - can persist model dumps into `mendix-data/dumps`
  - returns filesystem paths to the caller
- `autocommitmessage/?action=refresh`:
  - triggers repository inspection and model analysis

## Key module docs

- `Docs/info_ui.md`
- `Docs/info_processing.md`
- `Docs/info_model-change-display-text-formatter.md`

## Operational notes

- `ChangesPanel` WinForms legacy UI has been removed; the extension UI is web-only.
- Build artefacts under `studio-pro-extension-csharp/bin` and `studio-pro-extension-csharp/obj` are ignored and are not part of source.
- Extension naming has been normalised to `AutoCommitMessage*` for classes and user-visible labels.
