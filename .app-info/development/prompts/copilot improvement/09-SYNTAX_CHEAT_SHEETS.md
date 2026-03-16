# PROMPT 09: Syntax Cheat Sheets

## Priority

Medium — reduces the number of skill files the Mendix Syntax agent must read during Phase 6 (Implementation Plan).

## Context

Read before starting:

1. `.agents/AGENTS.md`
2. `.app-info/development/prompts/copilot improvement/INDEX.md`
3. `KnowledgeBase-Creator/artifacts/.agents/agents/MENDIX_SYNTAX.md` — current syntax agent
4. `KnowledgeBase-Creator/artifacts/.agents/AGENTS.md` — current skills overview
5. `KnowledgeBase-Creator/artifacts/.agents/skills/mendix-xpath/SKILL.md`
6. `KnowledgeBase-Creator/artifacts/.agents/skills/mendix-microflows/SKILL.md`
7. `KnowledgeBase-Creator/artifacts/.agents/skills/mendix-domain-modeling/SKILL.md`
8. `KnowledgeBase-Creator/artifacts/.agents/skills/mendix-pages-widgets/SKILL.md`
9. `KnowledgeBase-Creator/artifacts/.agents/skills/mendix-security-model/SKILL.md`

## Problem Statement

The Mendix Syntax agent references up to 7 skill files for syntax enrichment. Each is a comprehensive reference (~100-300 lines). For a typical implementation plan with 10-20 tasks, the bot loads 4-5 of these files — 500-1,500 lines of reference, much irrelevant to the specific tasks.

Compact cheat sheets per task type would reduce reading to ~200 lines total.

## Entry Criteria

1. The Mendix platform skill files exist in `KnowledgeBase-Creator/artifacts/.agents/skills/`.
2. The Mendix Syntax agent is functional.

## Deliverable

### 1. Create cheat sheet skill files

Create under `KnowledgeBase-Creator/artifacts/.agents/skills/cheatsheets/`:

#### `ENTITY_SYNTAX.md` (~60 lines)

Compact reference covering:
- Entity definition (persistable/non-persistable, generalisation)
- Attribute types with syntax (String with length, Integer, Long, Decimal with precision, Boolean with default, DateTime with default expression, AutoNumber, enumeration with qualified name)
- Association syntax (Reference/ReferenceSet, owner, delete behaviour)
- Index syntax
- Validation rule syntax
- Event handler syntax
- Access rule syntax (CRUD per role, attribute restrictions, XPath constraints)
- Enumeration definition syntax

Use the same format as MENDIX_SYNTAX.md output examples — copy-ready blocks.

#### `FLOW_SYNTAX.md` (~80 lines)

Compact reference covering:
- Microflow definition (name, parameters, return type)
- Common activities: Create Object, Change Object, Commit, Retrieve (by association, from database with XPath), Delete, Exclusive Split (with expression), Merge, Show Page, Close Page, Validation Feedback, Sub-microflow Call (with parameter mapping), Java/JavaScript Action
- Error handling settings (Abort, Continue, Custom with Error Handler)
- Nanoflow differences (client-side, no database commits, no error handling)

#### `PAGE_SYNTAX.md` (~80 lines)

Compact reference covering:
- Page definition (name, layout, allowed roles)
- Data view (context, microflow, nanoflow, listen-to data sources)
- Data grid (XPath data source, microflow data source, search bar config)
- List view, Template grid
- Input widgets (text box, text area, drop-down, date picker, checkbox, reference selector, input reference set selector) with attribute binding
- Buttons (save, cancel, call microflow with parameters, show page with context)
- Conditional visibility syntax
- Navigation menu item syntax

#### `SECURITY_SYNTAX.md` (~40 lines)

Compact reference covering:
- Entity access rule syntax (CRUD permissions per module role)
- Attribute-level read/write restrictions
- XPath constraint patterns for row-level security (common patterns: owner check, role check, status check)
- Page access (allowed module roles)
- Microflow access (allowed module roles)
- Module role to user role mapping

### 2. Update MENDIX_SYNTAX.md

In `KnowledgeBase-Creator/artifacts/.agents/agents/MENDIX_SYNTAX.md`, replace the "Skills Used" section:

```markdown
## Quick Reference

For syntax enrichment, read the cheat sheet matching the task type:

| Task Type | Cheat Sheet | Full Reference (if cheat sheet insufficient) |
|---|---|---|
| Entity | `.agents/skills/cheatsheets/ENTITY_SYNTAX.md` | `mendix-domain-modeling/SKILL.md` |
| Flow | `.agents/skills/cheatsheets/FLOW_SYNTAX.md` | `mendix-microflows/SKILL.md`, `mendix-nanoflows/SKILL.md` |
| Page | `.agents/skills/cheatsheets/PAGE_SYNTAX.md` | `mendix-pages-widgets/SKILL.md` |
| Security | `.agents/skills/cheatsheets/SECURITY_SYNTAX.md` | `mendix-security-model/SKILL.md` |
| XPath (any task) | `.agents/skills/cheatsheets/SECURITY_SYNTAX.md` (constraint section) | `mendix-xpath/SKILL.md` |
| Naming | Follow app patterns from `FLOWS.md`/`PAGES.md` | `mendix-conventions/SKILL.md` |

Read the cheat sheet first. Only fall back to the full reference skill if the cheat sheet does not cover the specific syntax needed.
```

### 3. Register in AGENTS.md

In `KnowledgeBase-Creator/artifacts/.agents/AGENTS.md`, add under Skills Overview:

```markdown
### Cheat Sheets (Compact Syntax Reference)

- `.agents/skills/cheatsheets/ENTITY_SYNTAX.md` — entity, attribute, association, access rule syntax
- `.agents/skills/cheatsheets/FLOW_SYNTAX.md` — microflow/nanoflow activity and configuration syntax
- `.agents/skills/cheatsheets/PAGE_SYNTAX.md` — page layout, widget, data source, and button syntax
- `.agents/skills/cheatsheets/SECURITY_SYNTAX.md` — security configuration and XPath constraint syntax
```

## Files Changed (all under `KnowledgeBase-Creator/artifacts/.agents/`)

| File | Change |
|---|---|
| `skills/cheatsheets/ENTITY_SYNTAX.md` | **New** — compact entity syntax reference |
| `skills/cheatsheets/FLOW_SYNTAX.md` | **New** — compact flow syntax reference |
| `skills/cheatsheets/PAGE_SYNTAX.md` | **New** — compact page/widget syntax reference |
| `skills/cheatsheets/SECURITY_SYNTAX.md` | **New** — compact security syntax reference |
| `agents/MENDIX_SYNTAX.md` | Replace Skills Used with cheat sheet routing table |
| `AGENTS.md` | Add cheat sheets to skills overview |

## Exit Criteria

1. Four cheat sheet files exist under `skills/cheatsheets/`.
2. Each cheat sheet is under 100 lines.
3. MENDIX_SYNTAX.md references cheat sheets as the primary quick reference.
4. A bot enriching a 15-task plan reads 2-3 cheat sheets (~200 lines) instead of 5 full skill files (~800 lines).
5. Full reference skills remain for edge cases.
6. All future generated KBs include the cheat sheets (copied via `artifacts/.agents/`).

## Skills to Use

- Agent: **Developer** (cheat sheet creation, agent updates)
- Agent: **Documenter** (skills overview)

## Notes

- Cheat sheets are **static content** — they do not change per app. They are part of the agent framework, not generated KB content.
- The full reference skills remain authoritative. Cheat sheets are optimised extracts.
- The cheat sheet format matches the MENDIX_SYNTAX.md output format — the bot can copy syntax blocks directly.
- Before creating cheat sheets, check actual line counts of the full reference skills. If they are already compact (<100 lines each), cheat sheets may be redundant.
