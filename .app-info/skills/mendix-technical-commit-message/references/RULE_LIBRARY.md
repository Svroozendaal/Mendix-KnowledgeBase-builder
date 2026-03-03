# RULE_LIBRARY

This file contains general rendering rules for technical commit messages.
The rules are split into two parts:

1. Converter rules: deterministic formatting and mapping rules (no AI needed).
2. AI rules: interpretation rules for `details` text when semantic summarisation is needed.

## Global Output Contract

Every rendered element row MUST follow this shape:

- `<NEW|DEL|empty> <ABBR|empty> <ElementName> : <Details>`

Formatting constraints:

- `NEW` is used when `changeType = Added`.
- `DEL` is used when `changeType = Deleted` for flow elements (`Microflow`, `Nanoflow`).
- Abbreviation is optional and comes from the dictionary below.
- `ElementName` is technical and explicit.
- `Details` is required except for entity rows covered by `C011` (intentional empty details).
- Collapse duplicate spaces after optional parts.

## Abbreviation Dictionary

Use this dictionary for the optional abbreviation slot:

- `Entity ->` (empty)
- `NonPersistentEntity -> NP`
- `Microflow -> MF`
- `Nanoflow -> NF`
- `Page -> PG`
- `Snippet ->` (empty)
- `Constant -> Constant`
- `Queue -> TQ`
- `Enumeration -> ENUM`
- `ExportMapping -> EM`
- `ImportMapping -> IM`
- `Workflow -> WF`

If `elementType` is not in the dictionary, leave abbreviation empty.

## Part 1: Converter Rules (Deterministic)

### C001 - Element Name Normalisation

- Rule ID: `C001`
- Purpose: remove module prefix from `elementName`.
- Logic:
  - If `elementName` matches `<Module>.<Name>`, use `<Name>`.
  - Otherwise, use `elementName` unchanged.
- Example:
  - Input: `Projects.SCRIPTS_Projects`
  - Output name: `SCRIPTS_Projects`

### C002 - Change Marker

- Rule ID: `C002`
- Purpose: derive the optional change prefix.
- Logic:
  - If `changeType = Added`, prefix is `NEW`.
  - If `changeType = Deleted` and `elementType = Microflow|Nanoflow`, prefix is `DEL`.
  - Otherwise, prefix is empty.

### C003 - Abbreviation Lookup

- Rule ID: `C003`
- Purpose: map `elementType` to optional abbreviation.
- Logic:
  - Use the abbreviation dictionary.
  - If no match, use empty abbreviation.

### C004 - Base Details Fallback

- Rule ID: `C004`
- Purpose: guarantee `Details` is always present.
- Logic:
  - If interpreted details exist from Part 2, use those.
  - Else if raw `details` is non-empty, use raw `details`.
  - Else use fallback by change type:
    - Added -> `added`
    - Modified -> `modified`
    - Deleted -> `deleted`

### C005 - Final Row Assembly

- Rule ID: `C005`
- Purpose: build final row.
- Output template:
  - `<NEW|DEL|empty> <ABBR|empty> <ElementName> : <Details>`
- Post-process:
  - Remove duplicate spaces caused by empty optional tokens.

### C006 - Stable Ordering

- Rule ID: `C006`
- Purpose: deterministic output order.
- Logic:
  - Sort modules alphabetically.
  - Process categories in this fixed order:
    - `domainModel`
    - `microflows`
    - `pages`
    - `nanoflows`
    - `resources`

### C007 - Missing AI Rule Handling

- Rule ID: `C007`
- Purpose: prevent silent guessing for uncovered detail patterns.
- Logic:
  - If a row needs semantic detail interpretation and no AI rule matches, add it to `Missing Rules`.
  - Ask for a new AI rule (`Axxx`) with module, category, element type, change type, and raw details.

### C008 - Flow Details Compaction

- Rule ID: `C008`
- Purpose: deterministically normalize verbose flow `details` into stable, simple action phrases.
- Applies to:
  - `elementType = Microflow|Nanoflow`
  - `details` contains `actions delta:` or `decisions delta:`
- Output style:
  - `added: <ActionPhraseList>; modified: <ActionPhraseList>; removed: <ActionPhraseList>; loops: <LoopDescriptorList>; decisions: <DecisionCaptionList>; return: <ReturnChangeSummary>`
- Parsing notes:
  - Parse action details from `added/removed/modified action details` and use action-type list as deterministic fallback.
  - Prefer simple phrase format: `<action> <main object>`.
  - Examples:
    - `show page Page`
    - `create list Entity2`
    - `delete object Entity2`
    - `delete list Entity2`
  - Flow call actions:
    - `MicroflowCallAction -> call MF <MicroflowName>`
    - `NanoflowCallAction -> call NF <NanoflowName>`
    - When descriptor has both call target and output variable (`call ... <Target> -> <Output>`), prefer `<Target>`.
  - Retrieve rendering:
    - Render `retrieve list <Entity>` only when list signals exist (for example `_List`, `retrieveType=List|All`).
    - Render `retrieve object <Entity>` for non-list retrieve signals.
  - Loop rendering:
    - Include loop descriptors from `loops added/removed/modified` as `loops: ...`.
  - Return rendering:
    - Include `microflowReturnType` and `returnVariableName` changes as a `return: ...` segment.
  - Decision rendering:
    - always show decision captions (from `decisions ...` segments), not expressions.
  - For `changeType = Deleted` on flow rows (`DEL` marker), hide all bucket sections and render `deleted`.
  - Omit empty buckets.

### C009 - Flow Signal Preservation

- Rule ID: `C009`
- Purpose: prevent loss of deterministic flow metadata during display compaction.
- Applies to:
  - `elementType = Microflow|Nanoflow`
  - `details` contains one or more of:
    - `loops delta:`
    - `microflowReturnType`
    - `returnVariableName`
- Output style:
  - Preserve flow metadata as explicit compact sections (`loops:` and/or `return:`).
- Example input:
  - `...; loops added (1): iterate Entity_List as IteratorEntity; ...; microflowReturnType updated; returnVariableName ->Variable; ...`
- Example output:
  - `...; loops: iterate Entity_List as IteratorEntity; return: type changed, variable Variable`

### C010 - Domain Association Attachment

- Rule ID: `C010`
- Purpose: keep association changes in `domainModel` by attaching them to the parent entity row.
- Logic:
  - Parse association details for:
    - `parent=<Entity>`
    - association descriptor (`[<cardinality>] <OtherEntity>`)
  - Aggregate by parent entity with change buckets:
    - `associations added (<n>): ...`
    - `associations modified (<n>): ...`
    - `associations removed (<n>): ...`
  - Merge aggregated association details into the parent entity `details`.
  - If parent entity has no row yet, create a synthetic `Modified Entity` row for that parent.
  - Keep unparseable association rows in `resources` as fallback.

### C011 - Entity Empty-Details Rendering

- Rule ID: `C011`
- Purpose: avoid noisy fallback words on entity rows when deterministic details are absent.
- Applies to:
  - `elementType = Entity|NonPersistentEntity`
- Logic:
  - If `details` is empty after deterministic parsing, render an empty details segment.
  - Keep row shape: `<prefix> <abbr> <name> :`

### C012 - Zero-Value Detail Suppression

- Rule ID: `C012`
- Purpose: suppress noisy zero-only detail sections.
- Logic:
  - Split detail text on `;`.
  - Drop segments where every parsed numeric value is `0`.
  - Keep remaining segments in the original order.
  - If all segments are dropped for entity rows, keep empty details.

### C013 - Flow Decision Bucket Alignment

- Rule ID: `C013`
- Purpose: keep decision deltas inside action buckets so flow output stays grouped by `added/modified/removed`.
- Applies to:
  - `elementType = Microflow|Nanoflow`
  - compacted flow details built from `actions delta` and `decisions delta` anchors
- Logic:
  - Parse decision captions per bucket:
    - `decisions added (...)` -> `added`
    - `decisions modified (...)` -> `modified`
    - `decisions removed (...)` -> `removed`
  - Render each decision as `decision <Caption>` and append to the matching bucket list.
  - Do not emit a standalone `decisions:` section.
- Example input:
  - `...; actions removed (1): ValidationFeedbackAction x1; ...; decisions removed (1): FTE >=0 expression=...; decisions modified (1): is TWK? expression=... -> is TWK? expression=...`
- Example output:
  - `removed: validation feedback, decision FTE >=0; modified: decision is TWK?`

### C014 - Flow Annotation Bucket Alignment

- Rule ID: `C014`
- Purpose: keep annotation deltas inside action buckets so flow output stays grouped by `added/modified/removed`.
- Applies to:
  - `elementType = Microflow|Nanoflow`
  - compacted flow details built from `annotations delta` anchors
- Logic:
  - Parse annotation labels per bucket:
    - `annotations added (...)` -> `added`
    - `annotations modified (...)` -> `modified`
    - `annotations removed (...)` -> `removed`
  - Render each entry as `annotation <label>` and append to the matching bucket list.
  - If no label can be derived, use `annotation updated`.
  - Do not emit a standalone `annotations:` section.
- Example input:
  - `annotations delta: added 1, removed 0, modified 0; annotations added (1): text=Need validation`
- Example output:
  - `added: annotation Need validation`

### C015 - Page Functional Widget-Only Rendering

- Rule ID: `C015`
- Purpose: keep page/snippet `displayText` focused on functional UI change signals and suppress layout/action metadata noise.
- Applies to:
  - `elementType = Page|Snippet|PageTemplate|BuildingBlock|Layout`
- Logic:
  - Prefer deterministic functional widget anchors when present:
    - `functional widgets (...)`
    - `functional widgets before deletion (...)`
  - Parse and render only these functional widget groups:
    - `ActionButton -> buttons`
    - `DataView -> dataview`
    - `DataGrid -> datagrid`
    - `DataGrid2 -> datagrid2`
    - `Snippet|SnippetCallWidget -> snippet`
  - For widget delta lines, keep only functional widget types and render in bucket form:
    - `added: ...`
    - `modified: ...`
    - `removed: ...`
  - Suppress page metadata/action inventory sections in `displayText`:
    - `layout=...`
    - `title=...`
    - `url=...`
    - `popup=...`
    - `actions used (...)`
    - `action targets: ...`
    - full `widgets used (...)` inventory
- Example input:
  - `layout=Atlas_Core.Atlas_Default; title=Pagina test; ...; widgets used (18): ActionButton x4, ...; functional widgets (8): ActionButton x4, DataView x1, DataGrid x1, DataGrid2 x1, Snippet x1`
- Example output:
  - `functional widgets: buttons x4, dataview x1, datagrid x1, datagrid2 x1, snippet x1`

### C016 - Page Requested Widget Summary Rendering

- Rule ID: `C016`
- Purpose: render page/snippet `displayText` as requested-functional widget summaries with explicit widget behaviour details.
- Applies to:
  - `elementType = Page|Snippet|PageTemplate|BuildingBlock|Layout`
- Match anchors:
  - One or more of:
    - `functional widgets (...)`
    - `added <WidgetType>(...) ...`
    - `action targets: ...`
- Logic:
  - Build requested widget summary labels in deterministic order from functional widget types:
    - `ActionButton -> button`
    - `DataView -> list`
    - `DataGrid -> DG`
    - `DataGrid2 -> DG2`
    - `Snippet|SnippetCallWidget -> snippet`
  - Prefer `added <WidgetType>(...)` widget delta rows when available to derive widget behaviour details.
  - If only lifecycle anchors are available (for example Added pages), derive details from:
    - `functional widgets (...)`
    - `action targets: <kind=target list>`
  - Render shape:
    - `added: <RequestedWidgetList>; widget details: <WidgetDetailList>`
  - Widget detail contracts:
    - `ActionButton`:
      - `button show page <PageName>` when page targets are present
      - `button call MF <MicroflowName>` for microflow targets
      - `button call nanoflow <NanoflowName>` for nanoflow targets
      - fallback: `button <action unknown>`
    - `DataGrid`:
      - `DG <SourceName>` when source binding is present
      - fallback: `DG <unknown source>`
    - `DataGrid2`:
      - `DG2 <SourceName>` when source binding is present
      - fallback: `DG2 <unknown source>`
    - `DataView`:
      - `list <SourceName>` when source binding is present
      - fallback: `list <unknown source>`
    - `Snippet|SnippetCallWidget`:
      - `snippet`
  - Continue suppressing page metadata/action inventory noise in final `displayText`:
    - `layout=...`, `title=...`, `url=...`, `popup=...`, `actions used (...)`, `widgets used (...)`, `functional widgets (...)`
- Example input:
  - `layout=Atlas_Core.Atlas_Default; ...; action targets: microflow=SmartExpenses.ACT_Balance_NewEdit, page=SmartExpenses.Balance_NewEdit; functional widgets (8): ActionButton x4, DataView x1, DataGrid x1, DataGrid2 x1, Snippet x1`
- Example output:
  - `added: button, list, DG, DG2, snippet; widget details: button call MF ACT_Balance_NewEdit, button show page Balance_NewEdit, list <unknown source>, DG <unknown source>, DG2 <unknown source>, snippet`







## Part 2: AI Rules (Details Interpretation)

AI rules only produce the `<Details>` segment. Converter rules handle the full row.

## AI Rule Schema

Use this schema for each AI rule:

- `Rule ID`: Stable identifier (`A001`, `A002`, ...)
- `Applies to`: category + element type + change type
- `Match condition`: pattern in `details`
- `Output details template`: exact details fragment only
- `Example input`
- `Example output details`

### A001 - Flow Action Summary (Retrieve/Change/Commit)

- Rule ID: `A001`
- Applies to: `microflows|nanoflows`, `elementType = Microflow|Nanoflow`, `changeType = Added|Modified`
- Match condition:
  - `details` contains one or more of:
    - `RetrieveAction:`
    - `ChangeObjectAction:`
    - `CommitAction:`
- Output details template:
  - `retrieve <RetrieveSummary>, change <ChangeSummary>, commit <CommitSummary>`
- Parsing notes:
  - Keep action order: retrieve -> change -> commit.
  - Include only actions present.
  - For `ChangeObjectAction`, prefer object and key field names.
- Example input:
  - `ChangeObjectAction: change IteratorMonthlyCosts (StartDate=..., EndDate=...)`
  - `CommitAction: commit MonthlyCostsList_toBeChanged (...)`
- Example output details:
  - `change IteratorMonthlyCosts (StartDate, EndDate), commit MonthlyCostsList_toBeChanged`

### A002 - Flow Action Delta Summary

- Rule ID: `A002`
- Applies to: `microflows|nanoflows`, `elementType = Microflow|Nanoflow`, `changeType = Added|Modified`
- Match condition:
  - `details` contains `actions delta:` and action count blocks.
- Output details template:
  - `actions delta: added <A>, removed <R>, modified <M>; actions <ActionTypeCountList>`
- Parsing notes:
  - Use compact action-type counts from the payload.
  - Do not include low-value repeated `action payload changed` fragments.
- Example input:
  - `actions delta: added 2, removed 0, modified 0; actions added (2): LogMessageAction x1, MicroflowCallAction x1; ...`
- Example output details:
  - `actions delta: added 2, removed 0, modified 0; actions LogMessageAction x1, MicroflowCallAction x1`

### A003 - Domain Entity Attribute Change Summary

- Rule ID: `A003`
- Applies to: `domainModel`, `elementType = Entity`, `changeType = Added|Modified`
- Match condition:
  - `details` contains attribute change markers (for example `attributes added`).
- Output details template:
  - `added with attributes '<AttributeList>'`
- Example input:
  - `attributes added (1): newAttribute`
- Example output details:
  - `added with attributes 'newAttribute'`

### A004 - UI/Resource Text Passthrough

- Rule ID: `A004`
- Applies to: `resources|pages`, `changeType = Added|Modified|Deleted`
- Match condition:
  - `details` is already concise technical text and no richer parser is needed.
- Output details template:
  - `<details>`
- Example input:
  - `widgets entries updated`
- Example output details:
  - `widgets entries updated`

### A005 - Generic Semantic Fallback

- Rule ID: `A005`
- Applies to: `all categories`, `changeType = Added|Modified|Deleted`
- Match condition:
  - A higher-priority AI rule does not match.
- Output details template:
  - `<details>`
- Safety:
  - If raw `details` is ambiguous/noisy, do not guess; route to `Missing Rules` via `C007`.

### A006 - Iterator Loop Heuristic Fallback

- Rule ID: `A006`
- Applies to: `microflows|nanoflows`, `elementType = Microflow|Nanoflow`, `changeType = Added|Modified`
- Match condition:
  - No explicit loop detail anchor available, and `ChangeObjectAction` variable or descriptor contains `iterator` (case-insensitive).
- Output details template:
  - include `iterate and update` phrasing for the change segment.
- Rationale:
  - Pragmatic fallback for legacy/noisy payloads where loop objects are not explicitly summarized.

## Pending Rule Slots

- Converter rules: `C017` next available
- AI rules: `A007` next available
