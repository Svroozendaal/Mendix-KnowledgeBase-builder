# Git Changes Pane and In-IDE Review

## Status

- `DONE`

## Goal

Provide a Studio Pro dockable pane that gives developers immediate visibility into relevant uncommitted Mendix changes.

## Current behaviour

1. Registers `AutoCommitMessage` dockable pane on the right side of Studio Pro.
2. Exposes menu actions to open and close the pane.
3. Loads extension web UI via internal route `autocommitmessage/`.
4. Shows:
   - branch name
   - changed files table (`*.mpr`, `*.mprops`)
   - file diff section
   - grouped model-change section for `.mpr` files
5. Supports manual `Refresh` to recompute repository and model analysis.

## Implementation references

- `studio-pro-extension-csharp/UI/DockablePane/AutoCommitMessageDockablePaneExtension.cs`
- `studio-pro-extension-csharp/UI/DockablePane/AutoCommitMessageDockablePaneViewModel.cs`
- `studio-pro-extension-csharp/UI/Menu/AutoCommitMessageMenuExtension.cs`
- `studio-pro-extension-csharp/UI/Web/AutoCommitMessageWebServerExtension.cs`
- `studio-pro-extension-csharp/UI/Web/AutoCommitMessagePanelHtml.cs`

## Constraints

- UI is embedded HTML/JS in extension runtime, not a separate npm or localhost app.
- Diff text for `.mpr` is binary/unavailable by design; semantic model changes are shown instead.

## Improvement opportunities

1. Add loading/performance hints for long-running refresh operations.
2. Add inline guidance when model analysis is skipped or partially unavailable.
3. Improve accessibility and keyboard navigation in file/model tables.
