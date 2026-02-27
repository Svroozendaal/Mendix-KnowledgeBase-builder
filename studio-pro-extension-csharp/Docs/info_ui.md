# info_ui

## Primary documentation

For full request lifecycle, route handling, and UI workflow context, use:

- `Docs/ARCHITECTURE.md`
- `Docs/REPOSITORY_WORKFLOWS.md`

## Purpose

- Hosts all Studio Pro UI integration points for AutoCommitMessage.
- Keeps pane/menu/web rendering concerns isolated from processing logic.
- Makes UI changes low-risk by containing them under one top-level folder.

## Files and responsibilities

| File | Responsibility |
|---|---|
| `UI/DockablePane/AutoCommitMessageDockablePaneExtension.cs` | Dockable pane registration, pane URL generation, cache-busting query parameter |
| `UI/DockablePane/AutoCommitMessageDockablePaneViewModel.cs` | WebView initialisation and pane title binding |
| `UI/Menu/AutoCommitMessageMenuExtension.cs` | Menu entries for opening/closing the pane |
| `UI/Web/AutoCommitMessageWebServerExtension.cs` | Internal HTTP routing for default view, `refresh`, and `export` actions |
| `UI/Web/AutoCommitMessagePanelHtml.cs` | HTML/CSS/JS UI rendering and client interactions |

## Public entry points

- `[Export(typeof(DockablePaneExtension))]` in `AutoCommitMessageDockablePaneExtension`
- `[Export(typeof(MenuExtension))]` in `AutoCommitMessageMenuExtension`
- `[Export(typeof(WebServerExtension))]` in `AutoCommitMessageWebServerExtension`

## Data touched

- Reads current project path from Studio Pro context.
- Sends refresh/export requests to local extension routes.
- Displays change payload returned by processing services.

## Dependencies

- Mendix Extensions API:
  - `Mendix.StudioPro.ExtensionsAPI.UI.DockablePane`
  - `Mendix.StudioPro.ExtensionsAPI.UI.Menu`
  - `Mendix.StudioPro.ExtensionsAPI.UI.WebServer`
  - `Mendix.StudioPro.ExtensionsAPI.UI.WebView`
- Browser runtime within Studio Pro WebView.

## Operational notes

- Security-sensitive route handling lives in `AutoCommitMessageWebServerExtension`; treat route changes as high impact.
- `AutoCommitMessagePanelHtml` contains all UI text/markup, so visual changes should be done there first.
