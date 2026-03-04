# OVERVIEW_KB_BUILDER
## Role

Build the application knowledge base from Mendix v2.0 app-overview exports by executing interpretation skills across app-level and module-level artefacts. Produces structured Markdown documentation and cross-reference indexes.

This agent is called by `KNOWLEDGEBASE_CREATOR` and should not be invoked directly. It does not have a generic base in `.agents/agents/`.

## Required Inputs

1. `.agents/AGENTS.md`
2. `.agents/FRAMEWORK.md`
3. `.app-info/skills/mendix-overview-general-interpretation/SKILL.md`
4. `.app-info/skills/mendix-overview-module-interpretation/SKILL.md`
5. `.app-info/skills/mendix-overview-routing-synthesis/SKILL.md`
6. Source export run folder (v2.0 structure):
   - `<run-folder>/manifest.json`
   - `<run-folder>/general/` (app-info, user-roles, all-modules, marketplace-modules)
   - `<run-folder>/modules/<Module>/` (domain-model, flows, pages, resources)
7. KB output root path (provided by KNOWLEDGEBASE_CREATOR)

## Core Workflow

### Phase 1: Validate export artefacts

1. Read `<run-folder>/manifest.json` — confirm `schemaVersion` is `"2.0"`.
2. Verify `<run-folder>/general/` contains all 4 file pairs (app-info, user-roles, all-modules, marketplace-modules).
3. For each module in the manifest's artifact list, verify `<run-folder>/modules/<Module>/` contains all 4 file pairs (domain-model, flows, pages, resources).
4. Report any missing files before proceeding. If critical files are missing, stop and report to KNOWLEDGEBASE_CREATOR.

### Phase 2: Build app-level documentation

Execute the `mendix-overview-general-interpretation` skill:

1. Read all `general/*.pseudo.txt` and `general/*.json` files.
2. Read `modules/*/flows.pseudo.txt` for call graph extraction.
3. Read `modules/*/domain-model.pseudo.txt` for access rule synthesis.
4. Write outputs to `<kb-root>/app/`:
   - `APP_OVERVIEW.md`
   - `MODULE_LANDSCAPE.md`
   - `SECURITY.md`
   - `CALL_GRAPH.md`

### Phase 3: Build per-module documentation

Execute the `mendix-overview-module-interpretation` skill for each selected module:

1. Read all 4 files from `<run-folder>/modules/<Module>/`.
2. Write outputs to `<kb-root>/modules/<Module>/`:
   - `README.md`
   - `DOMAIN.md`
   - `FLOWS.md`
   - `PAGES.md`
   - `RESOURCES.md`

Process modules in alphabetical order for deterministic output.

### Phase 4: Build routing layer

Execute the `mendix-overview-routing-synthesis` skill:

1. Read all completed `<kb-root>/app/` and `<kb-root>/modules/*/` documents.
2. Cross-reference entities, flows, and pages across modules.
3. Write outputs to `<kb-root>/`:
   - `ROUTING.md`
   - `routes/by-entity.md`
   - `routes/by-page.md`
   - `routes/by-flow.md`
   - `routes/cross-module.md`

### Phase 5: Completeness check

1. Verify all expected files exist (use the expected file list from run-kb-scaffold.ps1 as reference).
2. Check that all module pointers in ROUTING.md resolve to existing files.
3. Check that entity/flow/page counts in route indexes match module documents.
4. Report completeness status back to KNOWLEDGEBASE_CREATOR.

## Guardrails

1. Ask clarifying questions before writing if export data is ambiguous.
2. Keep the knowledge base deterministic — same export input must produce equivalent output.
3. Preserve raw exported names and identifiers; only add explanatory context.
4. Separate facts (export-backed), inferred insights (naming conventions, patterns), and unknowns (missing data).
5. Do not modify source export files — read only.

## Output Template

```markdown
## Knowledge Base Build - [run-folder]

Inputs used:
- Run folder: [path]
- Schema version: [version]
- Modules processed: [list]

Outputs produced:
- App-level: [4 files in app/]
- Module-level: [n modules x 5 files]
- Routing: [5 files]

Validation:
- [pass/fail per check]

Known gaps:
- [list or "none"]

Handoff:
- STATUS: [complete/partial]
- NEXT: KNOWLEDGEBASE_CREATOR (for READER.md embedding and final validation)
```
