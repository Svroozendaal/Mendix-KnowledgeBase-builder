# B1 Implementation Plan - Parser Coverage for Missing Resource Types

**Session**: DEVELOPER agent implementing PROMPT_B1_PARSER_COVERAGE
**Status**: Planning phase
**Complexity**: Medium per resource type (incremental)

---

## Objectives

Expand semantic diff coverage for five Mendix resource types (Constants, ScheduledEvents, Consumed REST Services, Published REST Services, Java Actions) by implementing type-specific detail extractors in the diff service, structurer, and formatter layers.

---

## Architecture Overview

### Current Pattern (from code inspection)

1. **Diff Engine** (`MendixModelDiffService.cs`):
   - `CompareDumps()` → builds two snapshots (working vs head)
   - Detects added/deleted/modified resources
   - Calls `AddResourceSpecificDetails()` to populate change details

2. **Resource-Specific Router** (`BuildResourceSpecificDetails()`):
   - Routes by `modelType` to specialized detail builders
   - Current routes:
     - Flows (Microflow, Nanoflow, Rule) → `BuildMicroflowActionDetails()`
     - Entities → `BuildDomainEntityAttributeDetails()`
     - Associations → `BuildDomainAssociationDetails()`
     - Enumerations → `BuildEnumerationValueDetails()`
     - Pages → composite (roles + layout + actions + widgets)
     - Fallback → `BuildGenericResourceDetails()`

3. **Detail Text Formatting** (`MendixModelChangeDisplayTextFormatter.cs`):
   - Applies display rules and styling per element type
   - Must preserve detail anchors (e.g., `actions used`, `attributes added`) for downstream parsing

4. **Element Type Mapping** (`ElementTypeOverrides` dict):
   - Maps dump `$Type` to display element type (e.g., `DomainModels$Entity` → `Entity`)

---

## Implementation Strategy (Per Resource Type)

### Phase 1: Research & Verification

Before any code changes:

1. **Inspect dump samples** to verify:
   - Exact `$Type` discriminator value
   - Field names and nesting structure
   - Identify which fields represent "meaningful" changes
   - Check parent/container relationships

2. **Register rules** in `.app-info/skills/mendix-model-dump-inspection/references/`:
   - Add rule IDs `D070`, `D071`, `D072`, `D073`, `D074` (or next available)
   - Document field mappings and change signal strategy
   - Update PARSER_LIBRARY.md with function signatures

3. **Design detail anchors** (deterministic output format):
   - Define how each change type (Added, Deleted, Modified) will emit details
   - Ensure text is sortable and parseable by downstream converters

### Phase 2: Implementation (Per Type)

For each resource type, modify:

1. **MendixModelDiffService.cs**:
   - Add new private constants for resource type strings
   - Extend `BuildResourceSpecificDetails()` with new conditional branch
   - Implement specialized detail builder method
   - Add to `ElementTypeOverrides` if custom display type is needed

2. **MendixModelChangeStructurer.cs** (if needed):
   - Verify grouping behaviour for new type
   - Add module-level routing if not already inherited

3. **MendixModelChangeDisplayTextFormatter.cs** (if needed):
   - Add styling/formatting rules for new element type
   - Ensure detail anchors are preserved

4. **Unit tests** (`studio-pro-extension-csharp-tests/`):
   - Create test class with anonymised dump samples
   - Test Added, Modified, Deleted scenarios
   - Verify detail text determinism and null safety
   - Verify fallback to generic parser when needed

---

## Resource Types & Implementation Order

### Priority 1: Constants (`System$Constant`)

**Meaningful changes**:
- Value changed (scalar property change)
- Type changed (e.g., Integer → String)
- Added/Removed

**Detail anchors**:
- `value <old>-><new>` (for Modified)
- `type <oldType>-><newType>` (for Modified)
- `values(<n>): ConstantName1, ConstantName2` (for Added/Deleted lists)

**Expected fields in dump**:
- `$Type = System$Constant`
- `name` (constant name)
- `value` (scalar value)
- `type` (value type, e.g., "Integer")

**Tests**:
- Modified: value changed
- Modified: type changed
- Added: new constant
- Deleted: removed constant

---

### Priority 2: Scheduled Events (`System$ScheduledEvent`)

**Meaningful changes**:
- Enabled/Disabled
- Interval changed (cron expression or duration)
- Target microflow changed
- Added/Removed

**Detail anchors**:
- `enabled <old>-><new>` (for state change)
- `interval <oldCron>-><newCron>` (or duration field)
- `target microflow <oldMF>-><newMF>` (if reference field exists)
- `startTime`, `timezone` (metadata on create/delete)

**Expected fields in dump**:
- `$Type = System$ScheduledEvent`
- `name`
- `enabled` (boolean)
- `interval` (cron string or duration)
- `microflowTarget` or similar (reference to microflow)
- `startTime`, `timezone` (optional metadata)

**Tests**:
- Modified: enabled toggled
- Modified: interval changed
- Modified: target microflow changed
- Added: new scheduled event
- Deleted: removed scheduled event

---

### Priority 3: Consumed REST Services

**Meaningful changes**:
- Base URL changed
- Operations added/removed
- Authentication changed
- Added/Removed

**Detail anchors**:
- `baseUrl <old>-><new>`
- `operations delta: added <n>, removed <n>`
- `operations added(<n>): OperationName1, OperationName2`
- `authentication <oldType>-><newType>` (e.g., Basic → None)

**Expected fields in dump**:
- `$Type` = (to be verified, e.g., `RestServices$ConsumedRestService`)
- `name`
- `baseUrl`
- `operations` (array of operation objects)
- `authentication` or similar (auth method)

**Tests**:
- Modified: baseUrl changed
- Modified: operations delta
- Modified: authentication changed
- Added: new consumed service
- Deleted: removed service

---

### Priority 4: Published REST Services

**Meaningful changes**:
- Operations added/removed
- Microflow mapping changed (microflow target for operation)
- Security changed (allowed roles)
- Added/Removed

**Detail anchors**:
- `operations delta: added <n>, removed <n>`
- `operations added(<n>): OperationName1, OperationName2`
- `microflow mapping <oldMF>-><newMF>` (per operation if trackable)
- `allowedRoles <old>-><new>`

**Expected fields in dump**:
- `$Type` = (to be verified, e.g., `RestServices$PublishedRestService`)
- `name`
- `operations` (array of operation objects with microflow references)
- `allowedRoles` (array of role IDs, similar to Page)
- `published` (boolean flag)

**Tests**:
- Modified: operations delta
- Modified: role-based security changed
- Added: new published service
- Deleted: removed service

---

### Priority 5: Java Actions

**Meaningful changes**:
- Parameters added/removed/type changed
- Return type changed
- Added/Removed

**Detail anchors**:
- `parameters delta: added <n>, removed <n>`
- `parameters added(<n>): ParamName1: Type1, ParamName2: Type2`
- `parameters removed(<n>): ParamName1: Type1`
- `return type <oldType>-><newType>`

**Expected fields in dump**:
- `$Type` = (to be verified, e.g., `JavaActions$JavaAction`)
- `name`
- `parameters` (array of parameter objects with name and type)
- `returnType` (scalar type)
- `implementation` (method body, likely ignored for diff)

**Tests**:
- Modified: parameter added
- Modified: parameter type changed
- Modified: return type changed
- Added: new Java action
- Deleted: removed action

---

## Dump Exploration Tasks (Blocking)

Before implementing each type, must verify in actual dumps:

- [ ] Locate dump sample with `System$Constant`
- [ ] Locate dump sample with `System$ScheduledEvent`
- [ ] Verify exact `$Type` for Consumed REST Service
- [ ] Verify exact `$Type` for Published REST Service
- [ ] Verify exact `$Type` for Java Action
- [ ] Confirm field names and nesting (e.g., `microflowTarget` vs `microflow` vs nested reference)
- [ ] Check if resources are at module level or app level
- [ ] Identify how to resolve microflow/entity reference IDs to names (if applicable)

---

## Code Changes Checklist (Per Type)

When implementing resource type `<ResourceType>`:

- [ ] **Research phase complete**: verified dump `$Type`, fields, and detail anchors
- [ ] **MendixModelDiffService.cs**:
  - [ ] Added constants for type strings
  - [ ] Added routing conditional in `BuildResourceSpecificDetails()`
  - [ ] Implemented `Build<ResourceType>Details(...)` method
  - [ ] Added element type override if needed
- [ ] **MendixModelChangeStructurer.cs**:
  - [ ] Verified grouping logic (usually inherited)
- [ ] **MendixModelChangeDisplayTextFormatter.cs**:
  - [ ] Added styling rules if custom formatting needed
- [ ] **Unit tests**:
  - [ ] Test Added scenario
  - [ ] Test Modified scenario (at least one field change)
  - [ ] Test Deleted scenario
  - [ ] Test determinism (same input → same output)
  - [ ] Test null/empty handling
- [ ] **Documentation**:
  - [ ] Added rule ID to RULE_LIBRARY.md
  - [ ] Added parser function to PARSER_LIBRARY.md
  - [ ] Added short verification note (fields confirmed, any unknowns, fallback behaviour)
- [ ] **Acceptance criteria**:
  - [ ] No more generic fallback output for this type
  - [ ] Detail text is meaningful and deterministic
  - [ ] Grouping is correct
  - [ ] Tests pass
  - [ ] Generic fallback still works for other types

---

## Constraints & Safety

1. **Do NOT change** `MendixModelChange` record signature
2. **Do NOT change** export schema or API contract
3. **Keep generic fallback** operational for unknown types
4. **One resource type per PR** (merge one type, then start next)
5. **If ambiguous**, add explicit TODO and use safe fallback
6. **Determinism first**: detail text must be sortable and consistent

---

## Next Steps

1. **Approve this plan**
2. **Explore dumps** to verify resource types and field names
3. **Implement Priority 1 (Constants)** as proof of concept
4. **Get feedback** on detail text format and structure
5. **Implement Priorities 2–5** in sequence

---

## References

- `.app-info/skills/mendix-model-dump-inspection/SKILL.md` — dump inspection conventions
- `.app-info/skills/mendix-model-dump-inspection/references/RULE_LIBRARY.md` — rule registry
- `.app-info/skills/mendix-model-dump-inspection/references/PARSER_LIBRARY.md` — parser function catalog
- `studio-pro-extension-csharp/Processing/ModelDiff/MendixModelDiffService.cs` — implementation target
- Dump samples: `mendix-data/dumps/2026-02-*/working-dump.json`
