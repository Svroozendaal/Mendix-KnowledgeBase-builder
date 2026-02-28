# features/
## Feature Registry

This folder tracks everything this application does — one entry per implemented feature or module.

## Contents

| File | Purpose |
|---|---|
| `FEATURES.md` | Index of all features with status and links |
| Per-feature files | Detailed scope, behaviour, constraints, and improvement notes per feature |

Current per-feature files:

- `git-changes-panel.md`
- `model-diff-analysis.md`
- `data-export-pipeline.md`
- `model-overview-export-pipeline.md`
- `commit-parser-agent.md`
- `developer-workflow-env.md`

## How to Use

1. When a feature is planned, add it to `FEATURES.md` with status `PLANNED`.
2. When implementation starts, update status to `IN_PROGRESS` and create a per-feature file.
3. When a feature is complete, update status to `DONE` and finalise the per-feature file.
4. The Documenter agent is responsible for keeping this folder up to date.

## Naming Convention

Per-feature files: `<feature-name>.md` in kebab-case. Example: `commit-parser.md`.

## Deep technical links

Detailed runtime documentation is maintained in:

- `studio-pro-extension-csharp/Docs/README.md`
