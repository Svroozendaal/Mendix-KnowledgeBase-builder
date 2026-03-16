# PROMPT 02: Entity Attribute Details in DOMAIN.md

## Priority

Critical — unblocks development planning by making attribute-level detail available without reading L2 JSON.

## Context

Read before starting:

1. `.agents/AGENTS.md`
2. `.app-info/development/prompts/copilot improvement/INDEX.md`
3. Generated KB: `mendix-data/knowledge-base/modules/MyFirstModule/DOMAIN.md`
4. Generated KB: `mendix-data/knowledge-base/_artifacts/MODULE_DOMAIN_TEMPLATE.md`
5. Model overview export JSON in `mendix-data/app-overview/current/` — specifically the entity/attribute data structure.

## Problem Statement

The current `DOMAIN.md` for each module shows entity names, association names, enumeration definitions, and access rules — but **not attribute names, types, or constraints**. It only shows attribute counts (e.g., "6 attributes").

When a bot is planning development work (e.g., "add a status field to Registration"), it cannot check whether `Status` already exists, what type it is, or whether there are validation rules on it — without dropping down to L2 JSON in `app-overview/current/`. This breaks the KB's value proposition of being self-contained for AI reasoning.

This is deterministic data that already exists in the model-overview export. It just needs to be surfaced in DOMAIN.md.

## Entry Criteria

1. The KB Creator pipeline compose step generates DOMAIN.md files.
2. The model-overview export JSON contains entity attribute data (names, types, lengths, defaults, validation rules).
3. The `MODULE_DOMAIN_TEMPLATE.md` artefact exists.

## Deliverable

### 1. Extend the DOMAIN.md compose output

For each entity section in DOMAIN.md, add an **Attributes** table after the entity summary line:

```markdown
### Course

| Attribute | Type | Length/Precision | Default | Validation |
|---|---|---|---|---|
| Title | String | 200 | — | Required |
| Description | String | Unlimited | — | — |
| Duration | Integer | — | 0 | — |
| Category | MyFirstModule.CourseCategory | — | General | — |
| StartDate | DateTime | — | — | — |
| IsActive | Boolean | — | true | — |

Associations: ...
```

**Column definitions:**
- **Attribute**: The attribute name as it appears in Studio Pro.
- **Type**: The Mendix type (`String`, `Integer`, `Long`, `Decimal`, `Boolean`, `DateTime`, `Enumeration` with qualified enum name, `AutoNumber`, `Binary`, `HashString`).
- **Length/Precision**: String max length, decimal precision, or `—` for types without length.
- **Default**: Default value if set, or `—`.
- **Validation**: `Required` if a validation rule enforces non-empty, or the validation rule summary, or `—`.

### 2. Extend the Entity Lifecycle Matrix

The existing lifecycle matrix shows which flows create/update/delete/read each entity. Add attribute-level detail to the **Update** column where the export provides it:

```markdown
| Entity | Create | Update | Delete | Read |
|---|---|---|---|---|
| Course | ACT_Course_Create (Title, Description, Duration) | ACT_Course_Save (Title, Description, Duration, IsActive) | — | DS_Course_All |
```

Only include attribute lists in Create/Update when the export data provides the member-set information. If not available, keep the current flow-name-only format and mark with `[members unknown]`.

### 3. Update the DOMAIN template

Modify `_artifacts/MODULE_DOMAIN_TEMPLATE.md` to include the attribute table skeleton:

```markdown
### {{EntityName}}

| Attribute | Type | Length/Precision | Default | Validation |
|---|---|---|---|---|
{{#each attributes}}
| {{Name}} | {{Type}} | {{LengthOrPrecision}} | {{DefaultValue}} | {{ValidationSummary}} |
{{/each}}
```

### 4. Update routes/by-entity.md

Add an **Attributes** column to the entity route table showing the attribute count and a comma-separated list of attribute names (first 5, then `+ N more` if >5):

```markdown
| Entity | Module | Attributes | Create | Update | Delete | Read | Pages |
|---|---|---|---|---|---|---|---|
| Course | MyFirstModule | Title, Description, Duration, Category, StartDate, IsActive (6) | ... | ... | ... | ... | ... |
| Registration | MyFirstModule | RegistrationDate, Status, + 2 more (4) | ... | ... | ... | ... | ... |
```

### 5. Quality gate check

Add quality gate rules:
- Every entity in DOMAIN.md has an attribute table with at least one row.
- Attribute type values are from the allowed set (`String`, `Integer`, `Long`, `Decimal`, `Boolean`, `DateTime`, `AutoNumber`, `Binary`, `HashString`, or a qualified enumeration name).
- Attribute count in the table matches the count in the entity summary.

## Exit Criteria

1. DOMAIN.md files include attribute tables for every entity.
2. A bot can answer "Does Registration have a Status attribute?" by reading DOMAIN.md alone.
3. A bot planning "add a Priority field to Course" can see the current attribute list and types without L2 JSON.
4. Quality gate passes with the new checks.

## Skills to Use

- Agent: **Developer** (compose step code changes)
- Agent: **Documenter** (template updates)

## Notes

- This is 100% deterministic — no AI enrichment needed. The data comes directly from the model-overview export.
- For marketplace modules, include the same attribute tables. Even though developers don't modify marketplace entities, knowing their shape is essential for association and XPath work.
- Enumeration values should be listed in the existing Enumerations section of DOMAIN.md (they already are in most cases). The attribute table just references the enum name.
- Keep the attribute table compact. Do not include system attributes (`createdDate`, `changedDate`, `owner`, `changedBy`) unless the entity explicitly overrides their visibility or has custom logic on them.
