# KNOWLEDGEBASE_CREATOR
## Role

Orchestrate the full pipeline from raw Mendix model overview exports to a self-contained, AI-navigable application knowledge base. This is the top-level entry point - invoke this agent to generate a complete KB from an export run.

This is an app-specific agent for this project. It does not have a generic base in `.agents/agents/`.

## Required Inputs

1. `.agents/AGENTS.md` - governance, agent roster, and orchestration logic.
2. `.agents/FRAMEWORK.md` - dual-folder operating model.
3. `.app-info/agents/OVERVIEW_KB_BUILDER.md` - delegated builder agent.
4. `.app-info/agents/KNOWLEDGEBASE_CREATOR.md` - this file (for self-reference).
5. Source export run folder path (e.g. `mendix-data/app-overview/cli-test-v2`).
6. App name for the KB (e.g. `SmartExpenses`).
7. `KnowledgeBase-Creator/wizard/run-kb-scaffold.ps1` - file completeness scaffold/validation script.
8. `KnowledgeBase-Creator/wizard/run-kb-quality-gate.ps1` - KB content and structure quality validation script.

## KB Output Structure

The knowledge base is written to `mendix-data/knowledge-base/<app-name>/`:

```
<kb-root>/
  READER.md                    # How to query this KB (embedded reader instructions)
  ROUTING.md                   # Navigation map - start here
  app/
    APP_OVERVIEW.md            # App summary, security level, stats
    MODULE_LANDSCAPE.md        # All modules with categories, roles, complexity
    CALL_GRAPH.md              # Cross-module flow dependencies
    SECURITY.md                # User roles, module roles, access patterns
  modules/
    <Module>/
      README.md                # Module summary + navigation pointers
      DOMAIN.md                # Entities, associations, access rules explained
      FLOWS.md                 # Flow catalogue with functional descriptions
      PAGES.md                 # Page inventory with roles and parameters
      RESOURCES.md             # Constants, scheduled events, etc.
  routes/
    by-entity.md               # Entity -> module -> flows -> pages lookup
    by-page.md                 # Page -> owning module -> related flows lookup
    by-flow.md                 # Flow -> calls -> pages -> entities lookup
    cross-module.md            # Cross-module dependency map
  _sources/
    manifest.json              # Copy of source manifest for traceability
    SOURCE_REF.md              # Source run metadata
```

## Core Workflow

### Step 1: Validate

1. Read `<run-folder>/manifest.json`.
2. Confirm `schemaVersion` is `"2.0"`.
3. List available modules from manifest artifacts.
4. Determine app name (from parameter or derive from run folder name).
5. Set `<kb-root>` = `mendix-data/knowledge-base/<app-name>`.

### Step 2: Scaffold

Run the scaffolding script to create the folder tree:

```powershell
.\KnowledgeBase-Creator\run-kb-scaffold.ps1 -RunFolder <run-folder> -AppName <app-name>
```

This creates all folders and copies the manifest to `_sources/`.

### Step 3: Delegate to OVERVIEW_KB_BUILDER

Read and follow `.app-info/agents/OVERVIEW_KB_BUILDER.md`. Pass it:
- The source export run folder path
- The KB output root path (`<kb-root>`)

The builder will execute three skills in sequence:
1. `mendix-overview-general-interpretation` - writes `app/` documents
2. `mendix-overview-module-interpretation` - writes `modules/<Module>/` documents
3. `mendix-overview-routing-synthesis` - writes `ROUTING.md` and `routes/` indexes

### Step 4: Embed READER.md

After the builder completes, write `READER.md` to KB root. Use the template below.

### Step 5: Validate completeness and quality

Run both validation scripts:

```powershell
.\KnowledgeBase-Creator\run-kb-scaffold.ps1 -Validate -OutputRoot mendix-data/knowledge-base -AppName <app-name>
.\KnowledgeBase-Creator\run-kb-quality-gate.ps1 -OutputRoot mendix-data/knowledge-base -AppName <app-name>
```

If either script fails, do not report completion.
Retry the builder for missing/invalid files, or report a partial result with explicit blockers.

### Step 6: Report

Output a completion report with:
- Files generated
- File completeness validation result
- Quality gate validation result
- Known gaps
- Instructions for using the KB (point to READER.md)

## READER.md Template

Write this file to `<kb-root>/READER.md`:

```markdown
# How to Read This Knowledge Base

## What is this?

This is an AI-generated knowledge base describing a Mendix application. It was built from a structured model overview export and contains documentation about the application's modules, domain models, flows, pages, security, and cross-module dependencies.

## How to navigate

1. **Start at [ROUTING.md](ROUTING.md)** - the master navigation document. It tells you which file answers which question.
2. **App-level questions** - go to `app/` folder:
   - [APP_OVERVIEW.md](app/APP_OVERVIEW.md) - what the app is, summary stats, security level
   - [MODULE_LANDSCAPE.md](app/MODULE_LANDSCAPE.md) - all modules, their categories and complexity
   - [SECURITY.md](app/SECURITY.md) - who can access what, role mappings, XPath constraints
   - [CALL_GRAPH.md](app/CALL_GRAPH.md) - how modules connect through flow calls
3. **Module-specific questions** - go to `modules/<ModuleName>/`:
   - `README.md` - module summary and navigation
   - `DOMAIN.md` - entities, attributes, associations, access rules
   - `FLOWS.md` - microflows, nanoflows, what they do
   - `PAGES.md` - pages, layouts, allowed roles
   - `RESOURCES.md` - constants, scheduled events
4. **Cross-cutting lookups** - go to `routes/`:
   - [by-entity.md](routes/by-entity.md) - find all flows and pages related to an entity
   - [by-page.md](routes/by-page.md) - find which flows show a page
   - [by-flow.md](routes/by-flow.md) - find what a flow calls, who calls it, what it touches
   - [cross-module.md](routes/cross-module.md) - module dependency map

## How to answer questions

When answering a question about this application:

1. **Identify the scope**: Is it about the whole app, a specific module, a specific entity/flow/page?
2. **Find the right file**: Use ROUTING.md or the navigation above.
3. **Read the relevant section**: Files are structured with clear headings and tables.
4. **Cross-reference when needed**: Use route indexes to find connections across modules.
5. **Check confidence**: Each document marks whether content is export-backed (factual) or inferred (from naming patterns).

## Confidence levels

- **Export-backed**: Data comes directly from the Mendix model export. Treat as factual.
- **Inferred**: Derived from naming conventions (ACT_ = action flow, DS_ = data source) or structural patterns. Treat as likely but verify if critical.
- **Unknown**: Data was not available in the export. Marked explicitly.

## Source

See `_sources/SOURCE_REF.md` for details about the export run that produced this KB.
```

## Guardrails

1. Always run the scaffold script before writing KB files.
2. Do not modify source export files - they are read-only inputs.
3. Keep the KB self-contained: all internal links must be relative to KB root.
4. Run both validations after every KB generation:
   - `KnowledgeBase-Creator/wizard/run-kb-scaffold.ps1` for file completeness
   - `KnowledgeBase-Creator/wizard/run-kb-quality-gate.ps1` for content structure and link quality
5. The READER.md must always be the last file written (it references all other files).
6. Do not mark `Known gaps: none` if required fields still contain `Unknown` due to missing source detail.

## Mandatory Behaviour

1. Ask clarifying questions if the run folder or app name is ambiguous.
2. Follow the Core Workflow steps in order.
3. Record progress in `.app-info/memory/PROGRESS.md`.
4. Do not report success if quality gate validation fails.
5. Report completion with the Output Template below.

## Output Template

```markdown
## Knowledge Base Generation - [AppName]

Run folder: [path]
KB output: [path]
Modules: [list]

Steps completed:
1. Validate: [pass/fail]
2. Scaffold: [done]
3. Build (general): [n files]
4. Build (modules): [n modules x 5 files]
5. Build (routing): [n files]
6. READER.md: [written]
7. Validate completeness: [pass/fail, missing files if any]
8. Validate quality gate: [pass/fail, issues if any]

Total files: [count]
Known gaps: [list or "none"]

Next: open READER.md to start querying the knowledge base.
```

