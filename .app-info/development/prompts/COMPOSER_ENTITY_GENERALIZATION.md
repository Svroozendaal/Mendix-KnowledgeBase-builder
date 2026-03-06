# PROMPT 04: Surface Entity Generalization Chains

## Priority

High — inheritance chains hide attributes and behaviour from AI consumers.

## Context

Read before starting:

1. `.agents/AGENTS.md` and `.agents/FRAMEWORK.md`
2. `.app-info/product-plan/01-END_STATE_KB_SPEC.md` — mandatory module-level content for DOMAIN.md.
3. `.app-info/product-plan/02-CONTENT_MODEL_CUSTOM_DEPTH.md` — entity lifecycle model.

## Problem Statement

Mendix entities can inherit from other entities (generalisation). For example, `SmartExpenses.Logo` has `"generalization": "System.Image"`, which means Logo inherits all attributes from `System.Image` (which itself inherits from `System.FileDocument`): `Name`, `Size`, `Contents`, `HasContents`, `DeleteAfterDownload`, `FileID`, `PublicThumbnailPath`, `EnableCaching`.

The composer currently ignores the `generalization` field completely. In the generated DOMAIN.md:

- `SmartExpenses.Logo` shows `0` attributes — because it has no locally-declared attributes.
- There is no mention that Logo inherits from System.Image.
- An AI reading the KB would conclude Logo has no attributes and no meaningful structure.

This is misleading. The generalization chain determines:

1. What attributes are actually available on the entity.
2. What operations are possible (e.g. file upload/download for Image-derived entities).
3. Cross-module structural dependencies (Logo depends on System.Image).

## Entry Criteria

1. Composer script exists at `KnowledgeBase-Creator/run-kb-compose.ps1`.
2. The `generalization` field is present on entity objects in `domain-model.json` (value is either a qualified entity name string or `null`).

## Acceptance Criteria

1. DOMAIN.md entity table includes a "Generalises" column showing the parent entity when non-null.
2. A new "Inherited Attributes" note appears below the entity table for entities with generalisation, explaining that attributes from the parent entity are available but not locally declared.
3. The entity lifecycle matrix is unaffected (it correctly tracks direct flow evidence only).
4. The `routes/by-entity.md` entity index includes a note about generalisation where applicable.
5. Quality gate and benchmark still pass.
6. Deterministic output preserved.

## Scope

### Files to Modify

1. `KnowledgeBase-Creator/run-kb-compose.ps1`
2. `KnowledgeBase-Creator/artifacts/MODULE_DOMAIN_TEMPLATE.md` — update table header.

### Specific Code Locations and Changes

#### Step 1: Capture `generalization` during entity loading

When building `$entityLookup` and related structures (approximately lines 229-260), add a new lookup:

```powershell
$entityGeneralization = @{}  # entityQualifiedName -> parent entity qualified name or $null
```

For each entity in each module's `domain-model.json`:

```json
{
  "name": "SmartExpenses.Logo",
  "isPersistable": true,
  "generalization": "System.Image",
  "attributes": [],
  "accessRules": [...]
}
```

Store: `$entityGeneralization["SmartExpenses.Logo"] = "System.Image"`

#### Step 2: Add "Generalises" column to entity summary table

Currently the entity table in DOMAIN.md is:

```markdown
| Entity | Persistable | Attributes | Access Rules |
```

Change to:

```markdown
| Entity | Persistable | Generalises | Attributes (local) | Access Rules |
```

In the rendering loop for entity rows, add:

```powershell
$gen = if ($entityGeneralization[$entity.name]) { $entityGeneralization[$entity.name] } else { "—" }
```

Clarify the attribute count is "local" attributes (not inherited).

#### Step 3: Add inheritance notes section

After the entity table, add a conditional section when any entity in the module has a generalisation:

```markdown
## Inheritance Notes

| Entity | Parent | Implication |
|---|---|---|
| SmartExpenses.Logo | System.Image | Inherits file-handling attributes (Name, Size, Contents, etc.) from System.Image → System.FileDocument. Entity supports binary file storage. |
```

Build the "Implication" text deterministically based on well-known Mendix parent entities:

| Parent | Implication text |
|---|---|
| `System.Image` | "Inherits file-handling attributes (Name, Size, Contents, etc.) from System.Image -> System.FileDocument. Entity supports binary file/image storage." |
| `System.FileDocument` | "Inherits file-handling attributes (Name, Size, Contents, etc.). Entity supports binary file storage." |
| Any other | "Inherits attributes from [parent]. Locally declared attributes: [count]." |

If no entities in the module have generalisation, omit this section entirely (do not show an empty table).

#### Step 4: Add generalisation note to `routes/by-entity.md`

In the entity route index, add a "Generalises" column or inline note for entities with non-null generalisation. This helps AI consumers understand cross-module structural dependencies at the index level.

#### Step 5: Update the template

Update `KnowledgeBase-Creator/artifacts/MODULE_DOMAIN_TEMPLATE.md` to include the new table headers so the quality gate heading contract stays consistent.

### What NOT to Change

1. Do not attempt to resolve the full inheritance chain (e.g. Image -> FileDocument -> object). Only show the direct parent.
2. Do not list inherited attributes individually (the parent entity's attributes are defined in the parent module's DOMAIN.md — keep the indirection).
3. Do not change the entity lifecycle matrix.
4. Do not change the access rules / role impacts section.

## Verification Steps

After implementing:

1. Run the full pipeline.
2. Open `mendix-data/knowledge-base/SmartExpenses/modules/SmartExpenses/DOMAIN.md`.
3. Verify that `SmartExpenses.Logo` shows `System.Image` in the Generalises column.
4. Verify that the "Inheritance Notes" section appears and explains the Image inheritance.
5. Verify that entities without generalisation (e.g. `SmartExpenses.Transaction`) show "—" in the Generalises column.
6. Verify that modules without any generalised entities do not show the Inheritance Notes section.
7. Open `mendix-data/knowledge-base/SmartExpenses/routes/by-entity.md` and verify Logo has a generalisation note.
8. Verify quality gate passes.
9. Verify benchmark score >= 85.

## Exit Criteria

1. Generalisation column present in entity tables for all modules.
2. Inheritance notes section present when applicable.
3. Entity route index includes generalisation information.
4. Template file updated.
5. Quality gate passes.
6. Benchmark score >= 85.

## Estimated Scope

- Add 1 new lookup hash (`$entityGeneralization`) during loading (~5 lines).
- Modify entity table rendering to add 1 column (~3 lines per module).
- Add conditional inheritance notes section (~20 lines).
- Modify entity route index rendering (~5 lines).
- Update 1 template file.
