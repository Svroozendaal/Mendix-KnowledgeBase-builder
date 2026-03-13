---
name: mendix-overview-general-interpretation
description: Enrich app-level KB docs with business narratives after pipeline compose.
---

# MENDIX OVERVIEW GENERAL INTERPRETATION

## Context

The pipeline has already composed these files with export-backed data (tables, counts, roles, flow lists). This skill guides the AI to add semantic narratives on top.

## Source data to read

From the source run folder (`mendix-data/app-overview/<run-folder>/`):
- `general/app-info.pseudo.txt` - app metadata, module counts, security config
- `general/user-roles.pseudo.txt` - role definitions and permissions
- `general/all-modules.pseudo.txt` - module inventory with categories
- `general/marketplace-modules.pseudo.txt` - marketplace module versions

## Files to enrich

### `app/APP_OVERVIEW.md`
- **Mission Summary**: Rewrite the generic compose output with a specific business description. Infer from custom module names, entity names, and flow patterns what the app actually does.
- **Core Business Capabilities**: Add a narrative paragraph before the table explaining the app's main capabilities in plain language.
- Mark added content as `Confidence: Inferred`

### `app/MODULE_LANDSCAPE.md`
- Add a "Module Relationships" section explaining how custom modules relate to each other.
- Add a one-sentence purpose for each custom module.
- Mark added content as `Confidence: Inferred`

### `app/SECURITY.md`
- Add a "Role Descriptions" section with plain-language descriptions of what each role can do and why.
- Explain XPath constraints in business terms (e.g., "Trainees can only see their own registrations").
- Mark added content as `Confidence: Inferred`

### `app/CALL_GRAPH.md`
- If cross-module dependencies exist, add an architecture narrative.
- If no cross-module calls exist, note that the modules are self-contained.
- Mark added content as `Confidence: Inferred`

## Rules

- Never remove existing export-backed content
- Never change table structures or required headings
- Always mark AI-added content with confidence level
- Be specific: "manages training course registrations" not "handles business logic"
