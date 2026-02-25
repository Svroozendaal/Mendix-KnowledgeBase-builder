---
name: mendix-studio-pro-10
description: Mendix Studio Pro 10 extension constraints and implementation rules. Use when work touches Studio Pro integration, Git change reading, .mpr/.mprops handling, mx tooling, dockable panes, or Mendix-specific runtime behaviour.
---

# MENDIX_STUDIO_PRO_10

## TASKS

1. Apply only Studio Pro 10 compatible extension patterns.
2. Keep Git change scope focused on Mendix-relevant files (`*.mpr`, `*.mprops`) unless explicitly extended.
3. Treat `.mpr` as binary for plain diff; use model-level analysis when available.
4. Keep error handling user-friendly and non-crashing.
5. Keep UI responsive by isolating heavy work from the UI thread.
6. Ensure refresh behaviour re-runs Git + model analysis, not only UI reload.
7. Keep the model panel as the primary text-heavy pane in the docked UI.
8. Persist full dump artifacts only during explicit export actions to control storage churn.

## CONSTRAINTS

1. Prefer additive changes that do not break existing extension behaviour.
2. Do not assume unsupported Studio Pro API capabilities.
3. Validate integration behaviour against real project paths and repository states.
4. Preserve route/query compatibility for `autocommitmessage` actions (`refresh`, `export`).
5. Keep extension export payload parser-compatible (`schemaVersion`, `modelChanges`, `modelDumpArtifact`).

