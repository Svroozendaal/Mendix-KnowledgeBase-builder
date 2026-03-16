# PROMPT 02: Entity Attribute Details in DOMAIN.md

## Priority

Critical — unblocks development planning by making attribute-level detail available without reading L2 JSON.

## Context

Read before starting:

1. `.agents/AGENTS.md`
2. `.app-info/development/prompts/copilot improvement/INDEX.md`
3. `KnowledgeBase-Creator/artifacts/templates/MODULE_DOMAIN_TEMPLATE.md` — current domain template
4. `KnowledgeBase-Creator/artifacts/templates/ROUTE_BY_ENTITY_TEMPLATE.md` — current entity route template
5. `KnowledgeBase-Creator/wizard/run-kb-compose.ps1` — compose script
6. `KnowledgeBase-Creator/wizard/run-kb-quality-gate.ps1` — quality gate script
7. Model overview export JSON structure in `mendix-data/app-overview/current/` — specifically the entity/attribute data

## Problem Statement

The current `MODULE_DOMAIN_TEMPLATE.md` generates DOMAIN.md files that show entity names, associations, enumerations, and access rules — but **not attribute names, types, or constraints**. Only attribute counts are shown (e.g., "6 attributes").

When a bot plans development work (e.g., "add a status field to Registration"), it cannot check whether `Status` already exists, what type it is, or whether there are validation rules — without dropping to L2 JSON. This breaks the KB's value proposition of being self-contained for AI reasoning.

This is deterministic data already in the model-overview export. It just needs to be surfaced.

## Entry Criteria

1. The compose script generates DOMAIN.md files from the domain template.
2. The model-overview export JSON contains entity attribute data (names, types, lengths, defaults, validation rules).

## Deliverable

### 1. Update domain template

In `KnowledgeBase-Creator/artifacts/templates/MODULE_DOMAIN_TEMPLATE.md`, add an **Attributes** table to each entity section:

```markdown
### {{EntityName}}

| Attribute | Type | Length/Precision | Default | Validation |
|---|---|---|---|---|
{{#each attributes}}
| {{Name}} | {{Type}} | {{LengthOrPrecision}} | {{DefaultValue}} | {{ValidationSummary}} |
{{/each}}

Associations: ...
```

**Column definitions:**
- **Attribute**: The attribute name as in Studio Pro.
- **Type**: Mendix type — `String`, `Integer`, `Long`, `Decimal`, `Boolean`, `DateTime`, `AutoNumber`, `Binary`, `HashString`, or qualified enumeration name (e.g., `MyFirstModule.CourseCategory`).
- **Length/Precision**: String max length, decimal precision, or `—` for types without length.
- **Default**: Default value if set, or `—`.
- **Validation**: `Required` if a validation rule enforces non-empty, or the validation rule summary, or `—`.

### 2. Update compose script

In `KnowledgeBase-Creator/wizard/run-kb-compose.ps1`, update the DOMAIN.md generation logic to:

1. Read attribute data from the model-overview export JSON for each entity.
2. Map each attribute to the table columns.
3. Exclude system attributes (`createdDate`, `changedDate`, `owner`, `changedBy`) unless the entity explicitly overrides their visibility or has custom logic on them.
4. Fill the template and write to `{KB}/modules/<Module>/DOMAIN.md`.

### 3. Extend the Entity Lifecycle Matrix

In the same domain template, add attribute-level detail to the **Update** column where the export provides member-set information:

```markdown
| Entity | Create | Update | Delete | Read |
|---|---|---|---|---|
| Course | ACT_Course_Create (Title, Description, Duration) | ACT_Course_Save (Title, Description, Duration, IsActive) | — | DS_Course_All |
```

Only include attribute lists when the export data provides member-set information. If not available, keep the current flow-name-only format and mark with `[members unknown]`.

### 4. Update entity route template

In `KnowledgeBase-Creator/artifacts/templates/ROUTE_BY_ENTITY_TEMPLATE.md`, add an **Attributes** column showing attribute count and a comma-separated list of attribute names (first 5, then `+ N more` if >5):

```markdown
| Entity | Module | Attributes | Create | Update | Delete | Read | Pages |
|---|---|---|---|---|---|---|---|
| Course | MyFirstModule | Title, Description, Duration, Category, StartDate, IsActive (6) | ... | ... | ... | ... | ... |
```

### 5. Add quality gate checks

In `KnowledgeBase-Creator/wizard/run-kb-quality-gate.ps1`, add validation rules:
- Every entity section in DOMAIN.md has an attribute table with at least one row.
- Attribute type values are from the allowed set (`String`, `Integer`, `Long`, `Decimal`, `Boolean`, `DateTime`, `AutoNumber`, `Binary`, `HashString`, or a qualified enumeration name).
- Attribute count in the table matches the count in the entity summary.

## Files Changed (all under `KnowledgeBase-Creator/`)

| File | Change |
|---|---|
| `artifacts/templates/MODULE_DOMAIN_TEMPLATE.md` | Add attribute table to entity sections, extend lifecycle matrix |
| `artifacts/templates/ROUTE_BY_ENTITY_TEMPLATE.md` | Add Attributes column |
| `wizard/run-kb-compose.ps1` | Extract attribute data from export, fill template columns |
| `wizard/run-kb-quality-gate.ps1` | Add attribute table validation rules |

## Exit Criteria

1. Generated DOMAIN.md files include attribute tables for every entity.
2. A bot can answer "Does Registration have a Status attribute?" by reading DOMAIN.md alone.
3. A bot planning "add a Priority field to Course" can see the current attribute list and types without L2 JSON.
4. Quality gate passes with the new checks.
5. Regenerating any KB produces attribute tables automatically.

## Skills to Use

- Agent: **Developer** (compose script, quality gate, template changes)

## Notes

- This is 100% deterministic — no AI enrichment needed.
- For marketplace modules, include the same attribute tables. Even though developers don't modify marketplace entities, knowing their shape is essential for association and XPath work.
- Enumeration values should be listed in the existing Enumerations section of DOMAIN.md (they already are). The attribute table just references the enum name.
- Keep tables compact. One row per attribute, no nested detail.
