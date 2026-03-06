---
name: mendix-overview-module-interpretation
description: Interpret module-level Mendix overview exports (v2.0 split files per module) and produce Markdown knowledge-base files for domain model, flows, pages, and resources.
---

# MENDIX OVERVIEW MODULE INTERPRETATION

## Purpose

Use this skill to transform one module's overview export files into structured Markdown documentation that is easy for AI and humans to navigate. Each module has four dedicated export files in v2.0 format.

## Required inputs

1. `<run-folder>/modules/<Module>/domain-model.pseudo.txt` + `.json` â€” entities, associations, enumerations, access rules
2. `<run-folder>/modules/<Module>/flows.pseudo.txt` + `.json` â€” microflows, nanoflows, rules, workflows with execution order and call graph
3. `<run-folder>/modules/<Module>/pages.pseudo.txt` + `.json` â€” pages with titles, layouts, roles, parameters; snippets
4. `<run-folder>/modules/<Module>/resources.pseudo.txt` + `.json` â€” constants, scheduled events, other resources
5. Optional cross-module context:
   - `<run-folder>/general/all-modules.pseudo.txt` â€” module category and role context

## Workflow

1. **Read all four module files** â€” treat JSON as source-of-truth structure, pseudocode as human-readable reference.
2. **Extract and document domain model:**
   - List entities with attributes, types, and persistability
   - Document associations (parent/child, cardinality, type)
   - Document enumerations with values
   - Document access rules per entity:
     - Which roles can create/delete
     - Default member access rights
     - Per-member overrides
     - XPath constraints explained in plain language
3. **Extract and document flows:**
   - Catalogue microflows, nanoflows, rules, workflows
   - For each flow: node count, key actions (retrieve, create, commit, show page, call microflow)
   - Group flows by purpose when possible (ACT_ = action, DS_ = data source, VAL_ = validation, etc.)
   - Note cross-module calls (MicroflowCallAction targeting other modules)
   - Note page references (ShowPageAction targets)
4. **Extract and document pages:**
   - List all pages with title, layout, allowed roles, parameters
   - Note popup vs full pages
   - Link pages to flows that reference them (from ShowPageAction in flows)
   - List snippets with their types and parameters
5. **Extract and document resources:**
   - Constants with types, default values, client exposure
   - Scheduled events with schedules and target flows
   - Other resource types
6. **Write module Markdown** to KB output:
   - `README.md` â€” module summary, navigation, key metrics
   - `DOMAIN.md` â€” domain model details with access rules
   - `FLOWS.md` â€” flow catalogue with functional descriptions
   - `PAGES.md` â€” page inventory linked to flows
   - `RESOURCES.md` â€” constants, events, other resources

## Output contract

For each module, generate:

```text
<kb-root>/modules/<Module>/
  README.md
  DOMAIN.md
  FLOWS.md
  PAGES.md
  RESOURCES.md
```

### README.md structure

```markdown
# Module: [ModuleName]

Category: [Custom/Marketplace/System]
Module roles: [list]

## Summary
- Entities: [n], Associations: [n], Enumerations: [n]
- Flows: [n] (Microflows: [n], Nanoflows: [n])
- Pages: [n], Snippets: [n]
- Constants: [n], Scheduled events: [n]

## Purpose
[1-3 sentences inferring what this module does based on entity names, flow names, page names]

## Navigation
- [DOMAIN.md](DOMAIN.md) â€” entities, associations, access rules
- [FLOWS.md](FLOWS.md) â€” microflows, nanoflows, call relationships
- [PAGES.md](PAGES.md) â€” pages, layouts, role access
- [RESOURCES.md](RESOURCES.md) â€” constants, scheduled events

## Cross-Module Dependencies
- Calls to: [list of modules this module calls]
- Called by: [list of modules that call this module]
- Shared entities via associations: [list]

## Source
- Export: [relative path to module export folder]
```

### DOMAIN.md structure

```markdown
# Domain Model: [ModuleName]

## Entities

### [EntityName]
- Persistence: [persistent/non-persistent]
- Attributes:
  | Name | Type |
  |------|------|
  | ... | ... |
- Access rules:
  | Role(s) | Create | Delete | Default | XPath |
  |---------|--------|--------|---------|-------|
  | ... | ... | ... | ... | [plain language] |
  - Member overrides: [if any differ from default]

## Associations
| Association | Parent | Child | Type |
|-------------|--------|-------|------|

## Enumerations
### [EnumName]
- Values: [list]
```

### FLOWS.md structure

```markdown
# Flows: [ModuleName]

## Flow Catalogue

### Action Flows (ACT_*)
| Flow | Nodes | Key Actions | Pages Shown |
|------|-------|-------------|-------------|

### Data Sources (DS_*)
| Flow | Nodes | Key Actions | Returns |
|------|-------|-------------|---------|

### Validation Flows (VAL_*)
| Flow | Nodes | Key Actions |
|------|-------|-------------|

### Other Flows
| Flow | Type | Nodes | Key Actions |
|------|------|-------|-------------|

## Cross-Module Calls
| Flow | Calls | Target Module |
|------|-------|---------------|

## Flow Details
### [FlowName]
[Concise functional description based on actions: what it retrieves, creates, validates, shows]
```

### PAGES.md structure

```markdown
# Pages: [ModuleName]

## Page Inventory
| Page | Title | Layout | Type | Roles | Parameters |
|------|-------|--------|------|-------|------------|

## Page-Flow Links
| Page | Shown by Flows |
|------|----------------|

## Snippets
| Snippet | Type | Parameters |
|---------|------|------------|
```

### RESOURCES.md structure

```markdown
# Resources: [ModuleName]

## Constants
| Constant | Type | Default | Exposed to Client |
|----------|------|---------|-------------------|

## Scheduled Events
| Event | Schedule | Target Flow |
|-------|----------|-------------|

## Other Resources
| Resource | Type |
|----------|------|
```

## Guardrails

1. Preserve exact module/flow/entity/page names as exported â€” never rename or abbreviate.
2. Keep derived text deterministic and avoid speculative behaviour claims.
3. Use naming conventions (ACT_, DS_, VAL_, SUB_, ACR_) to infer flow purpose, but label as "inferred".
4. Prefer concise summaries for long flows; link to raw pseudocode when detail is needed.
5. Cross-reference pages with flows that show them via ShowPageAction.
6. Mark any section where data is incomplete or the module has no content for that category.

## Contract Enforcement

1. Keep all required sections from the output contract even when a module has no data.
2. `README.md` is incomplete without:
   - `## Source`
   - `Shared entities via associations` line under `## Cross-Module Dependencies` (set to `none` when empty).
3. `FLOWS.md` must always include:
   - `### Action Flows (ACT_*)`
   - `### Data Sources (DS_*)`
   - `### Validation Flows (VAL_*)`
   - `### Other Flows`
   - `## Flow Details`
4. `PAGES.md` must always include `## Page-Flow Links`, including `none` rows where relevant.
5. Module outputs must satisfy `KnowledgeBase-Creator/run-kb-quality-gate.ps1` before handoff.

