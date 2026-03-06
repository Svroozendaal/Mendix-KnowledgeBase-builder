---
name: mendix-overview-routing-synthesis
description: Synthesize app-level and module-level KB interpretations into a routing layer with cross-reference indexes for entity, page, flow, and dependency lookups.
---

# MENDIX OVERVIEW ROUTING SYNTHESIS

## Purpose

Use this skill to combine interpreted app and module KB documents into a routing layer that enables fast, pointer-based navigation for LLM workflows and human readers. This is the final step of KB generation, run after general and module interpretation are complete.

## Required inputs

1. Completed `<kb-root>/app/` documents (from `mendix-overview-general-interpretation`):
   - `APP_OVERVIEW.md`, `MODULE_LANDSCAPE.md`, `SECURITY.md`, `CALL_GRAPH.md`
2. Completed `<kb-root>/modules/<Module>/` documents (from `mendix-overview-module-interpretation`):
   - `README.md`, `DOMAIN.md`, `FLOWS.md`, `PAGES.md`, `RESOURCES.md` per module
3. `<kb-root>/_sources/manifest.json` â€” artifact inventory for validation

## Workflow

1. **Validate coverage:**
   - Each module listed in manifest has a `modules/<Module>/README.md`
   - Each app-level document exists in `app/`
   - Report any missing documents before proceeding
2. **Build entity cross-reference** (`routes/by-entity.md`):
   - For each entity across all modules: which module owns it, which flows reference it (create, retrieve, change, commit), which pages display it (via parameters)
   - Sort alphabetically by qualified entity name
3. **Build page cross-reference** (`routes/by-page.md`):
   - For each page across all modules: owning module, title, which flows show it (ShowPageAction), which roles can access it, entity parameters
   - Sort alphabetically by qualified page name
4. **Build flow cross-reference** (`routes/by-flow.md`):
   - For each flow across all modules: type (microflow/nanoflow/rule/workflow), which flows it calls, which flows call it, which pages it shows, which entities it touches
   - Sort alphabetically by qualified flow name
5. **Build dependency map** (`routes/cross-module.md`):
   - Module-to-module dependency edges derived from flow calls and entity associations
   - Dependency direction and strength (number of call edges)
   - Identify hub modules (most connections) and leaf modules (few dependencies)
6. **Build master routing document** (`ROUTING.md`):
   - How to navigate the knowledge base
   - Which document answers which question type
   - Quick lookup guide for common query patterns
   - Explicit pointers to all app-level and module-level files
7. **Record completeness markers:**
   - Flag any modules with empty sections
   - Note inferred vs export-backed content

## Output contract

Generate routing structure:

```text
<kb-root>/
  ROUTING.md
  routes/
    by-entity.md
    by-page.md
    by-flow.md
    cross-module.md
```

### ROUTING.md structure

```markdown
# Knowledge Base Routing

## How to use this knowledge base

1. Start here to find the right document
2. Follow pointers to app-level or module-level files
3. Use route indexes for cross-cutting lookups

## Quick lookup

| Question type | Start here |
|---------------|------------|
| What does this app do? | [app/APP_OVERVIEW.md](app/APP_OVERVIEW.md) |
| What modules exist? | [app/MODULE_LANDSCAPE.md](app/MODULE_LANDSCAPE.md) |
| Who can access what? | [app/SECURITY.md](app/SECURITY.md) |
| How do modules connect? | [app/CALL_GRAPH.md](app/CALL_GRAPH.md) |
| What does module `<ModuleName>` do? | [modules/<ModuleName>/README.md](modules/<ModuleName>/README.md) |
| What entities exist in module `<ModuleName>`? | [modules/<ModuleName>/DOMAIN.md](modules/<ModuleName>/DOMAIN.md) |
| What flows exist in module `<ModuleName>`? | [modules/<ModuleName>/FLOWS.md](modules/<ModuleName>/FLOWS.md) |
| What pages exist in module `<ModuleName>`? | [modules/<ModuleName>/PAGES.md](modules/<ModuleName>/PAGES.md) |
| Find all flows that use entity Y | [routes/by-entity.md](routes/by-entity.md) |
| Find all flows that show page Z | [routes/by-page.md](routes/by-page.md) |
| Find what flow X calls and who calls it | [routes/by-flow.md](routes/by-flow.md) |
| Which modules depend on each other? | [routes/cross-module.md](routes/cross-module.md) |

## Module index

| Module | Category | Quick link |
|--------|----------|------------|
| [name] | [Custom/Marketplace/System] | [README](modules/name/README.md) |

## Completeness

- App-level: [complete/partial]
- Modules documented: [n/total]
- Known gaps: [list or "none"]

## Source

- Generated from: [run folder path]
- Generated at: [timestamp]
```

### routes/by-entity.md structure

```markdown
# Entity Index

| Entity | Module | Used by Flows | Shown on Pages |
|--------|--------|---------------|----------------|
| [Module.Entity] | [link to DOMAIN.md] | [flow list with links] | [page list with links] |
```

### routes/by-page.md structure

```markdown
# Page Index

| Page | Title | Module | Shown by Flows | Roles | Parameters |
|------|-------|--------|----------------|-------|------------|
| [Module.Page] | [title] | [link to PAGES.md] | [flow list] | [roles] | [entity params] |
```

### routes/by-flow.md structure

```markdown
# Flow Index

| Flow | Type | Module | Calls | Called by | Shows Pages | Touches Entities |
|------|------|--------|-------|----------|-------------|------------------|
| [Module.Flow] | [MF/NF/Rule/WF] | [link to FLOWS.md] | [list] | [list] | [list] | [list] |
```

### routes/cross-module.md structure

```markdown
# Cross-Module Dependencies

## Dependency Matrix

| Source â†’ Target | [Module1] | [Module2] | ... |
|-----------------|-----------|-----------|-----|
| [Module1] | - | [n calls] | ... |

## Hub Modules
- [Module]: [n] inbound + [n] outbound connections

## Leaf Modules
- [Module]: [n] connections total

## Association Links
| Association | From Module | To Module |
|-------------|-------------|-----------|
```

## Guardrails

1. Always explain purpose before linking pointers â€” never present naked link lists.
2. Keep pointer paths relative to `<kb-root>` â€” all links must work from KB root.
3. Mark missing or inferred sections explicitly instead of silently omitting them.
4. Keep routing concise â€” it serves as first-context for an LLM, not a full reference.
5. Sort all indexes alphabetically for deterministic output.
6. Cross-validate: every entity, page, and flow mentioned in route indexes must trace back to a module document.

## Contract Enforcement

1. Never leave placeholder module links in final output (for example `modules/X/README.md`).
2. Every relative link written to `ROUTING.md` and `routes/*.md` must resolve on disk.
3. `Known gaps: none` is only valid when no required-field values are marked `Unknown` in generated KB outputs.
4. `by-flow.md` must include `Shows Pages` and `Touches Entities` columns as defined in the output contract.
5. Routing outputs must satisfy `KnowledgeBase-Creator/run-kb-quality-gate.ps1` before handoff.

