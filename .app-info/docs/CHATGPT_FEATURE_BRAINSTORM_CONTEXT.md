# ChatGPT Feature Brainstorm Context Pack

Paste the prompt block below into ChatGPT to brainstorm technical feature ideas that reuse current functionality instead of replacing it.

## Prompt To Paste

```text
You are helping design the next feature roadmap for a Mendix Studio Pro 10 extension called AutoCommitMessage.

Context:
- Runtime: C# extension in Studio Pro, target framework net8.0-windows.
- Scope: analyse uncommitted Mendix changes (.mpr, .mprops), derive semantic model diffs, and export deterministic artefacts.
- Core route prefix: autocommitmessage/
- Existing route actions:
  - refresh
  - export
  - list-overview-modules
  - generate-overview-app
  - generate-overview-modules
  - generate-overview-module
  - generate-overview-both (alias generate-overview)
  - store-commit-message

Current major capabilities:
1) Change analysis pipeline
- Uses LibGit2Sharp to filter Git status + patch for .mpr/.mprops.
- For each changed .mpr:
  - creates working dump via mx dump-mpr
  - reconstructs HEAD snapshot and dumps that
  - semantically compares dumps
  - groups changes by module and category (DomainModel, Microflows, Pages, Nanoflows, Resources)
- Produces deterministic displayText for each model change.

2) Raw-change export pipeline
- schemaVersion = 1.0
- Writes JSON to <DataRoot>/raw-changes
- Can include modelDumpArtifact paths when dump persistence enabled.

3) Model overview pipeline (committed-state inventory, not diff)
- Lists modules from committed dumps, with category: System / Marketplace / Custom
- Generates app/module overview artefacts to <DataRoot>/app-overview/overviews/<run-folder>
- Exports JSON + pseudocode + manifest (+ module index for module mode)

4) Embedded UI capabilities
- Views: Model changes, Model overview, Settings
- Refresh and Export actions
- Module picker for selected-module overview generation
- Copy model changes to clipboard
- Commit-message compose modal (copy-to-clipboard)

5) Persisted settings in UI (localStorage)
- theme
- data root base path
- signature
- export output toggles (raw changes, dumps, overview structured, overview pseudocode)
- commit-messages base path / store flag

6) Storage and contracts
- Data root resolves from query override, env/build metadata, fallback project/mendix-data
- Runtime folders: raw-changes, processed, errors, app-overview, dumps
- Commit-message storage endpoint writes text files to <base>/Commit messages

Known constraints / opportunities:
- Some resource types still use generic diff summaries (parser coverage gap).
- Large models can make refresh/overview generation expensive.
- UI currently composes and copies commit message text, but store-commit-message endpoint is not fully wired into the primary UI flow.
- Deploy script pre-creates legacy folders (exports/structured), while runtime now uses raw-changes/app-overview.

Task:
Generate 12-18 feature ideas that are tightly grounded in this existing architecture.

Hard requirements:
- Every idea must explicitly reuse at least 2 existing components/services/routes.
- Do not propose replacing the current extension stack with a new platform.
- Keep ideas implementable in incremental PRs.
- Assume no cloud dependency is required unless clearly justified.

For each feature idea, output:
1) Feature name
2) User problem solved
3) Reuse map (exact existing files/classes/routes to leverage)
4) New/changed contracts (query keys, JSON fields, folders, UI state)
5) Implementation sketch (backend + UI steps)
6) Risk and complexity (Low/Medium/High) with why
7) Test strategy (unit/integration/manual)
8) Migration or compatibility notes

Then provide:
- A prioritised roadmap in 3 waves (Quick wins, Medium bets, Strategic bets)
- A dependency graph (which ideas unlock others)
- Top 5 ideas that maximise value with minimal contract breakage

Be concrete and technical. Reference current behaviour patterns (semantic diffing, module grouping, deterministic displayText, overview generation, local storage settings) in the proposals.
```

## Optional Add-On Prompt

Use this after the first answer if you want implementation-ready planning:

```text
Take the top 5 ideas and produce:
- PR slicing plan (smallest safe increments)
- File-by-file change map
- Acceptance criteria with Given/When/Then
- Regression risk checklist
- Rollback plan per feature
```

