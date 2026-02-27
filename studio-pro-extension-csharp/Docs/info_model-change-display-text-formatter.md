# info_model-change-display-text-formatter

## Purpose

Documents the converter-rule implementation used by:

- `Processing/Formatting/MendixModelChangeDisplayTextFormatter.cs`

The formatter creates deterministic `displayText` rows for model changes:

- `<NEW|DEL|empty> <ABBR|empty> <ElementName> : <Details>`

## Where it is used

- Right before export JSON serialization in `Processing/Services/AutoCommitMessageExportService.cs`.
- As the computed `DisplayText` property in `Processing/Contracts/MendixModelChange.cs`.
- In UI row rendering via `UI/Web/AutoCommitMessagePanelHtml.cs`.

## Implemented converter rules

### C001 - Element Name normalisation

- If `elementName` matches `Module.Name`, keep `Name`.
- Otherwise keep original `elementName`.
- Empty fallback: `<unnamed>`.

### C002 - Change marker

- If `changeType` is `Added` (case-insensitive), prefix `NEW`.
- If `changeType` is `Deleted` and `elementType` is `Microflow` or `Nanoflow`, prefix `DEL`.
- Otherwise keep marker empty.

### C003 - Abbreviation dictionary

- `Entity -> (empty)`
- `NonPersistentEntity -> NP`
- `Microflow -> MF`
- `Nanoflow -> NF`
- `Page -> PG`
- `Snippet -> (empty)`
- `Constant -> Constant`
- `Queue -> TQ`
- `Enumeration -> ENUM`
- `ExportMapping -> EM`
- `ImportMapping -> IM`
- `Workflow -> WF`
- Unknown types -> `(empty)`

### C004 - Details fallback

- Use trimmed `details` when available.
- If `elementType` is `Entity` or `NonPersistentEntity` and details are missing, keep details empty.
- If missing:
  - `Added -> added`
  - `Modified -> modified`
  - `Deleted -> deleted`
  - Other -> `changed`

### C005 - Final row assembly

- Build `<NEW|DEL|empty> <ABBR|empty> <ElementName> : <Details>`.
- Collapse repeated whitespace created by empty optional segments.

### C012 - Zero-Value Segment Suppression

- Removes detail segments where all numeric counters are `0`.
- If all detail segments are suppressed for `Entity`/`NonPersistentEntity`, details remain empty.

### C008 - Flow details compaction

- Applies to `Microflow` and `Nanoflow` rows with verbose `actions delta` or `decisions delta` payloads.
- Compacts flow content into deterministic sections:
  - `added: <ActionPhraseList>`
  - `modified: <ActionPhraseList>`
  - `removed: <ActionPhraseList>`
  - `decisions: <DecisionCaptionList>`
- Action phrases prefer `<action> <main object>` (for example `show page Page`, `create list Entity2`).
- Call actions render as:
  - `call MF <name>`
  - `call NF <name>`
- Decision summaries render captions only (expression text suppressed).
- For deleted flow rows (`DEL`), all sections are hidden and details render as `deleted`.

## Out of scope

- Semantic interpretation/compression of verbose `details` payloads.
- Module/category ordering logic.
