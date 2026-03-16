# PROMPT 09: Syntax Cheat Sheets

## Priority

Medium — reduces the number of skill files the Mendix Syntax agent must read during Phase 6 (Implementation Plan) by providing compact, task-type-specific reference cards.

## Context

Read before starting:

1. `.agents/AGENTS.md`
2. `.app-info/development/prompts/copilot improvement/INDEX.md`
3. Generated KB: `mendix-data/knowledge-base/.agents/agents/MENDIX_SYNTAX.md`
4. Generated KB: `mendix-data/knowledge-base/.agents/skills/mendix-xpath/SKILL.md`
5. Generated KB: `mendix-data/knowledge-base/.agents/skills/mendix-microflows/SKILL.md`
6. Generated KB: `mendix-data/knowledge-base/.agents/skills/mendix-nanoflows/SKILL.md`
7. Generated KB: `mendix-data/knowledge-base/.agents/skills/mendix-domain-modeling/SKILL.md`
8. Generated KB: `mendix-data/knowledge-base/.agents/skills/mendix-pages-widgets/SKILL.md`
9. Generated KB: `mendix-data/knowledge-base/.agents/skills/mendix-security-model/SKILL.md`
10. Generated KB: `mendix-data/knowledge-base/.agents/skills/mendix-conventions/SKILL.md`

## Problem Statement

The Mendix Syntax agent (Phase 6 of `/develop`) must enrich every task in the implementation plan with precise, Studio Pro-ready syntax. To do this, it references up to 7 skill files:

1. `mendix-xpath/SKILL.md` — XPath syntax
2. `mendix-microflows/SKILL.md` — microflow activities
3. `mendix-nanoflows/SKILL.md` — nanoflow capabilities
4. `mendix-domain-modeling/SKILL.md` — entity/attribute/association syntax
5. `mendix-pages-widgets/SKILL.md` — widget and layout syntax
6. `mendix-security-model/SKILL.md` — access rule syntax
7. `mendix-conventions/SKILL.md` — naming patterns

Each skill file is a comprehensive reference (~100-300 lines). For a typical implementation plan with 10-20 tasks, the bot needs syntax reference for entities, flows, pages, and security — meaning it loads 4-5 of these files. That is 500-1,500 lines of reference material, much of which is irrelevant to the specific tasks at hand.

## Entry Criteria

1. The Mendix platform skill files exist and contain comprehensive syntax reference.
2. The Mendix Syntax agent and Todo Maker are functional.

## Deliverable

### 1. Create task-type cheat sheets

Create compact, single-page reference cards for each task type. These extract only the syntax patterns needed for that task type, in the exact format the enriched task output uses.

#### `.agents/skills/cheatsheets/ENTITY_SYNTAX.md` (~60 lines)

```markdown
# Cheat Sheet: Entity Syntax

## Entity Definition
```
Entity: Module.EntityName
Persistable: Yes | No
Generalisation: Module.ParentEntity | none

Attributes:
  - Name: String (200)
  - Count: Integer (default: 0)
  - Amount: Decimal (precision: 2)
  - IsActive: Boolean (default: true)
  - CreatedAt: DateTime (default: [%CurrentDateTime%])
  - Status: Module.StatusEnum (default: Open)
  - Sequence: AutoNumber

Associations:
  - Module.Child_Parent: Reference (*/1), owner: Child, delete: Keep | DeleteRefObj | DeleteBoth
  - Module.Tag_Item: ReferenceSet (*/*), owner: Both

Indexes:
  - Status (used in access rule XPath)
  - CreatedAt (used in sorting)

Validation rules:
  - Name: Required, message: "Name is required"
  - Amount: Range (>= 0), message: "Amount must be positive"

Event handlers:
  - Before commit: Module.BCO_EntityName_Validate
  - After commit: Module.ACO_EntityName_Process
```

## Access Rules
```
Access rules:
  - AdminRole: C:Yes R:Yes(all) W:Yes(all) D:Yes, XPath: none
  - UserRole: C:Yes R:Yes(Name,Status) W:Yes(Name) D:No, XPath: [Module.Entity_Owner = '[%CurrentUser%]']
```

## Enumeration
```
Enumeration: Module.StatusEnum
Values:
  - Open (caption: "Open")
  - InProgress (caption: "In Progress")
  - Closed (caption: "Closed")
```
```

#### `.agents/skills/cheatsheets/FLOW_SYNTAX.md` (~80 lines)

Cover: microflow definition, common activities (Create, Change, Commit, Retrieve, Delete, Exclusive Split, Show Page, Close Page, Validation Feedback, Sub-microflow call, Java/JavaScript action), error handling, return types. Use the same `Steps:` format as MENDIX_SYNTAX.md output.

#### `.agents/skills/cheatsheets/PAGE_SYNTAX.md` (~80 lines)

Cover: page definition, data view (context, microflow, nanoflow, listen-to data sources), data grid (XPath, microflow data sources, search bar), list view, template grid, buttons (save, cancel, call microflow, show page), input widgets (text box, text area, drop-down, date picker, checkbox, reference selector, input reference set selector), conditional visibility, navigation.

#### `.agents/skills/cheatsheets/SECURITY_SYNTAX.md` (~40 lines)

Cover: entity access rule syntax, attribute-level CRUD, XPath constraint patterns, page access, microflow access, module role to user role mapping.

### 2. Update MENDIX_SYNTAX.md to use cheat sheets

Replace the "Skills Used" section with:

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

Read the cheat sheet first. Only read the full reference skill if the cheat sheet does not cover the specific syntax needed.
```

### 3. Register cheat sheets in AGENTS.md skills overview

Add under a new "Cheat Sheets" subsection:

```markdown
### Cheat Sheets (Compact Syntax Reference)

- `.agents/skills/cheatsheets/ENTITY_SYNTAX.md` — entity, attribute, association, access rule syntax
- `.agents/skills/cheatsheets/FLOW_SYNTAX.md` — microflow/nanoflow activity and configuration syntax
- `.agents/skills/cheatsheets/PAGE_SYNTAX.md` — page layout, widget, data source, and button syntax
- `.agents/skills/cheatsheets/SECURITY_SYNTAX.md` — security configuration and XPath constraint syntax
```

## Exit Criteria

1. Four cheat sheet files exist under `.agents/skills/cheatsheets/`.
2. Each cheat sheet is under 100 lines and contains only the syntax patterns needed for its task type.
3. MENDIX_SYNTAX.md references cheat sheets as the primary quick reference.
4. A bot enriching a 15-task implementation plan reads 2-3 cheat sheets (~200 lines) instead of 5 full skill files (~800 lines).
5. Full reference skills remain available for edge cases.

## Skills to Use

- Agent: **Developer** (cheat sheet creation, agent updates)
- Agent: **Documenter** (skills overview)

## Notes

- Cheat sheets are **static content** — they do not change per app. They are part of the agent framework (`.agents/skills/`), not the generated KB content.
- The full reference skills remain the authoritative source. Cheat sheets are optimised extracts, not replacements.
- If a new Mendix capability is added to a reference skill, the corresponding cheat sheet should be updated to include the most common pattern.
- The cheat sheet format matches the MENDIX_SYNTAX.md output format exactly — the bot can copy syntax blocks directly from the cheat sheet into the enriched task.
- Consider: if the full reference skills are already compact enough (<100 lines each), cheat sheets may be redundant. Check the actual line counts before proceeding. The value of cheat sheets increases with reference skill size.
