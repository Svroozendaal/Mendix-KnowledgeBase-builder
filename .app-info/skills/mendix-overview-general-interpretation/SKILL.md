---
name: mendix-overview-general-interpretation
description: Interpret app-level Mendix overview exports (v2.0 structured format) and produce high-level Markdown documentation for architecture, module landscape, security, and call graph understanding.
---

# MENDIX OVERVIEW GENERAL INTERPRETATION

## Purpose

Use this skill to convert app-wide overview exports into a readable top-level knowledge layer before module-deep documentation. This skill reads from the v2.0 export structure (`general/` folder with split files) and produces app-level KB documents.

## Required inputs

1. `<run-folder>/general/app-info.pseudo.txt` + `.json` â€” app metadata, summary stats, security level
2. `<run-folder>/general/user-roles.pseudo.txt` + `.json` â€” user roles with module role mappings
3. `<run-folder>/general/all-modules.pseudo.txt` + `.json` â€” all modules with categories, roles, counts
4. `<run-folder>/general/marketplace-modules.pseudo.txt` + `.json` â€” marketplace modules subset
5. `<run-folder>/manifest.json` â€” artifact inventory and generation metadata
6. `<run-folder>/modules/*/flows.pseudo.txt` â€” module flow files (for call graph extraction)
7. `<run-folder>/modules/*/domain-model.pseudo.txt` â€” module domain models (for access rule synthesis)

## Workflow

1. **Parse app summary** from `app-info` â€” extract module count, entity/association/flow totals, security level, admin user, guest access settings.
2. **Build module landscape** from `all-modules` and `marketplace-modules`:
   - Classify each module by category (Custom, Marketplace, System)
   - List module roles per module
   - Calculate relative complexity indicators (entity count, flow count, page count)
   - Identify the core custom modules vs supporting marketplace modules
3. **Build security overview** from `user-roles` + access rules found across module domain models:
   - Map each user role to its module role set
   - Summarise access patterns: which roles can create/delete/read entities
   - Identify XPath-constrained access rules and explain their meaning
   - Note guest access configuration
4. **Build call graph summary** by scanning module flow files:
   - Identify `MicroflowCallAction` references across modules
   - Map internal module clusters (flows calling flows in same module)
   - Map cross-module dependencies (flows calling flows in other modules)
   - Identify high-fan-out flows (many outgoing calls) and high-fan-in flows (called by many)
5. **Write app-level Markdown** to KB output:
   - `APP_OVERVIEW.md` â€” app identity, security level, summary stats, source metadata
   - `MODULE_LANDSCAPE.md` â€” module table with categories, roles, complexity, and brief purpose notes
   - `SECURITY.md` â€” user roles, module role mappings, access patterns, XPath constraints explained
   - `CALL_GRAPH.md` â€” cross-module dependency map, high-connectivity flows, module clusters

## Output contract

Generate app-level documentation under:

```text
<kb-root>/app/
  APP_OVERVIEW.md
  MODULE_LANDSCAPE.md
  SECURITY.md
  CALL_GRAPH.md
```

### APP_OVERVIEW.md structure

```markdown
# Application Overview

## Identity
- Source: [dump path]
- Generated: [timestamp]
- Schema version: 2.0

## Summary
- Modules: [count] (Custom: [n], Marketplace: [n], System: [n])
- Entities: [count], Associations: [count], Enumerations: [count]
- Flows: [count] (Microflows: [n], Nanoflows: [n], Rules: [n], Workflows: [n])

## Security
- Security level: [level]
- Admin user: [name]
- Guest access: [yes/no] (role: [name])

## Key observations
- [2-3 bullet points about app scale, architecture patterns, notable characteristics]
```

### MODULE_LANDSCAPE.md structure

```markdown
# Module Landscape

## Custom Modules
| Module | Roles | Entities | Flows | Pages | Constants | Purpose |
|--------|-------|----------|-------|-------|-----------|---------|
| [name] | [roles] | [n] | [n] | [n] | [n] | [inferred from names/structure] |

## Marketplace Modules
| Module | Roles | Purpose |
|--------|-------|---------|
| [name] | [roles] | [standard description based on known module] |

## Complexity Profile
- Largest module by flows: [name] ([n] flows)
- Largest module by entities: [name] ([n] entities)
- Modules with no custom content: [list]
```

### SECURITY.md structure

```markdown
# Security Model

## User Roles
### [RoleName]
- Module roles: [list]
- Manage all roles: [yes/no]
- Entity access summary: [brief]

## Access Patterns
### [EntityName]
- [Role]: [Create/Read/Write/Delete summary]
- XPath constraints: [explained in plain language]

## Observations
- [Notable security patterns, open access areas, tightly controlled entities]
```

### CALL_GRAPH.md structure

```markdown
# Flow Call Graph

## Cross-Module Dependencies
| Source Module | Target Module | Call Count | Key Flows |
|--------------|---------------|------------|-----------|

## High-Connectivity Flows
### Most called (fan-in)
- [flow name] â€” called by [n] flows from [modules]

### Most calling (fan-out)
- [flow name] â€” calls [n] other flows

## Module Clusters
- [Module]: [n] internal calls, [n] external calls
```

## Guardrails

1. Keep quantitative facts aligned with exported counts â€” do not invent numbers.
2. Distinguish measured facts from inferred interpretation (use "likely", "appears to" for inferences).
3. Include source run folder and generated timestamp in APP_OVERVIEW.md.
4. Do not duplicate full raw exports inside Markdown â€” summarise and point to source files.
5. For marketplace modules, use well-known descriptions (e.g. ExcelImporter, MxModelReflection) when recognised.
6. Mark any section where data is incomplete or unavailable.

## Contract Enforcement

1. `APP_OVERVIEW.md`, `MODULE_LANDSCAPE.md`, `SECURITY.md`, and `CALL_GRAPH.md` must each include at least one explicit confidence marker (`Export-backed`, `Inferred`, or `Unknown`).
2. If data is unavailable, keep the required section and mark values as `Unknown`; do not remove sections.
3. `MODULE_LANDSCAPE.md` must include non-placeholder purpose text for modules; avoid repeating generic phrases for every marketplace module.
4. App-level outputs must satisfy `KnowledgeBase-Creator/run-kb-quality-gate.ps1` before handoff.

