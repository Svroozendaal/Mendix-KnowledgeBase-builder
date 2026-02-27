# RULE_LIBRARY

This file contains deterministic extraction rules for model diff `details`.
Scope: dump comparison (`working-dump.json` vs `head-dump.json`) and `MendixModelDiffService` detail builders.

## Global Contract

- Each changed element must emit `changeType`, `elementType`, `elementName`.
- `details` should be non-empty when relevant parseable signals exist in dumps.
- Detail text should use stable anchors so downstream formatting/parsing can remain deterministic.
- Do not use AI for raw dump extraction rules unless explicitly approved.

## Rule ID Scheme

- `Dxxx` = deterministic diff extraction rule.
- Reserve IDs and append only; do not renumber existing rules.

## D001 - Resource routing by model type

- Route detail extraction by resource `$Type`.
- Current routes:
  - `Microflows$Microflow -> action delta parser`
  - `DomainModels$Entity -> attribute delta parser`
  - `Pages$Page -> allowedRoles parser`
- Extension routes (required for current known gaps):
  - `Microflows$Nanoflow -> action delta parser`
  - `DomainModels$Enumeration|Enumerations$Enumeration -> enumeration value parser`
  - `Pages$Page -> layout/action/widget parsers (merged with allowedRoles parser)`

## D002 - Change type classification

- `Added`: resource exists only in working snapshot.
- `Deleted`: resource exists only in head snapshot.
- `Modified`: same resource key exists in both and semantic JSON differs.

## D003 - Nested ownership counters

- For non-resource object changes, resolve owner by parent chain.
- Aggregate to owner as:
  - `<n> nested changes (<a> added, <m> modified, <d> deleted)`
- Ignore layout-only noise objects configured by semantic ignore sets.

## D010 - Flow action delta extraction

- Applies to:
  - `Microflows$Microflow`
  - `Microflows$Nanoflow`
- Traverse action activities and nested object collections.
- Compare by action identity (`$ID` when available).
- Emit anchors:
  - `actions delta: added <n>, removed <n>, modified <n>`
  - `actions added (<n>): <ActionType x#>`
  - `actions removed (<n>): <ActionType x#>`
  - `actions modified (<n>): <ActionType x#>`
  - `added action details: <ActionType: detail>`
  - `removed action details: <ActionType: detail>`
  - `modified action details: <ActionType: detail>`

## D011 - Flow action descriptor mapping

- Build detail descriptors per action type when fields are present:
  - `RetrieveAction`: source, entity, association, output, xPath/range/sort
  - `ChangeListAction`: list variable + change type/value
  - `ChangeObjectAction`: target variable + member assignments + refresh/events
  - `CommitAction`: target variable + refresh/events
  - `CreateObjectAction`: entity + output variable + member assignments
  - `MicroflowCallAction` and `NanoflowCallAction`: target flow + output variable
  - `ShowPageAction`: page target from `pageSettings.page`
  - `ShowMessageAction`: message text/type/blocking metadata
  - `CloseFormAction`: page-close settings
  - `ChangeVariableAction`, `CreateVariableAction`, `DeleteAction`, `JavaActionCallAction`, `JavaScriptActionCallAction`
- Fallback detail text:
  - `action payload changed`

## D012 - Flow loop extraction

- Applies to:
  - `Microflows$Microflow`
  - `Microflows$Nanoflow`
- Traverse for `Microflows$LoopedActivity`.
- Parse `loopSource.listVariableName` and `loopSource.variableName`.
- Emit anchors:
  - `loops delta: added <n>, removed <n>, modified <n>`
  - `loops added (<n>): iterate <ListVar> as <IteratorVar>`
  - `loops removed (<n>): ...`
  - `loops modified (<n>): ...`

## D013 - Flow decision extraction

- Applies to:
  - `Microflows$Microflow`
  - `Microflows$Nanoflow`
- Traverse for `Microflows$ExclusiveSplit`.
- Parse:
  - `caption`
  - `splitCondition.expression`
- Emit anchors:
  - `decisions delta: added <n>, removed <n>, modified <n>`
  - `decisions added (<n>): <DecisionDescriptor>`
  - `decisions removed (<n>): ...`
  - `decisions modified (<n>): ...`

## D020 - Domain entity attribute extraction

- Applies to `DomainModels$Entity`.
- Parse `attributes[*]` entries with `$Type=DomainModels$Attribute`.
- Emit:
  - Added entity: `attributes added (<n>): <AttributeList>`
    - Zero-attribute entities must emit `attributes added (0): <none>`
  - Deleted entity: `attributes before deletion (<n>): <AttributeList>`
    - Zero-attribute entities must emit `attributes before deletion (0): <none>`
  - Modified entity: `attributes added (<n>): <AttributeList>` (new only)

## D030 - Enumeration value extraction

- Applies to `DomainModels$Enumeration` and `Enumerations$Enumeration`.
- Parse `values[*]` by `$ID`/`name`.
- Parse value metadata:
  - `name`
  - `caption.translations`
  - `image`
- Emit:
  - Added enumeration: `values added (<n>): <ValueNameList>`
  - Deleted enumeration: `values before deletion (<n>): <ValueNameList>`
  - Modified enumeration: `values delta: added <n>, removed <n>, modified <n>`

## D031 - Enumeration caption mismatch signal

- Optional extension for D030.
- When value `name` differs from primary caption text, append compact signal:
  - `caption mismatch: <name>(caption=<caption>)`
- Cap entries to avoid noisy output.

## D040 - Page role delta extraction

- Applies to `Pages$Page`.
- Parse `allowedRoles` from both snapshots.
- Resolve role IDs to labels via `Security$UserRole`.
- Emit:
  - `allowedRoles count <old>-><new>`
  - Optional kept/removed/added segments.

## D041 - Page layout metadata extraction

- Applies to `Pages$Page`.
- Parse:
  - `layoutCall.layout`
  - `title.translations` (default language first)
  - `url`
  - popup fields (`popupWidth`, `popupHeight`, `popupResizable`)
- Emit:
  - `layout=<layout>; title=<title>; url=<url|empty>; popup=<w>x<h> resizable=<bool>`

## D042 - Page action binding extraction

- Applies to `Pages$Page`.
- Traverse page tree for `Pages$*ClientAction`.
- Count action types and extract targets (`microflow`, `nanoflow`, `page`).
- Emit:
  - `actions used (<n>): <ActionType x#>; action targets: <TargetList>`

## D043 - Page widget summary extraction

- Applies to `Pages$Page`.
- Count significant widget types under layout arguments and nested widgets.
- Emit:
  - `widgets used (<n>): <WidgetType x#>`

## D044 - Domain association metadata extraction

- Applies to `DomainModels$Association`.
- Parse:
  - `type`
  - `owner`
  - `storageFormat`
  - `parent`
  - `child`
- Resolve `parent` and `child` IDs to entity names via snapshot lookup when possible.
- Emit:
  - `parent=<entity>; association=[<cardinality>] <otherEntity>`
  - include metadata suffix only when non-default:
    - `type` when not `Reference`
    - `owner` when not `Default`
    - `storageFormat` when not `Table`
  - cardinality contract:
    - `Reference` (parent perspective): `*-1`
    - `ReferenceSet`: `*-*`
    - fallback/unknown: `1-1`

## D045 - Non-persistent entity typing

- Applies to `DomainModels$Entity`.
- Parse persistability signal from either:
  - `persistable` (direct entity property), or
  - `generalization.persistable`
- Emit element type override:
  - persistent entity -> `Entity`
  - non-persistent entity -> `NonPersistentEntity`

## D050 - Generic property diff fallback

- If no specific rule applies, emit compact property-level diffs:
  - scalar change: `<property> <old>-><new>`
  - array count change: `<property> count <old>-><new>`
  - structural change: `<property> entries updated`
- Respect ignored semantic properties.

## D060 - Null-detail prevention

- If one or more deterministic parser outputs exist for a change, `details` must not be `null`.
- Only allow null when:
  - no parser rule applies, and
  - no generic fallback (D050) yields meaningful output.

## Open Gaps (from 2026-02-26T12-28-22 export)

- `Microflow`/`Nanoflow` details can omit explicit loop context -> apply `D012`.
- `Enumeration` still empty when model type is `Enumerations$Enumeration` -> route via `D001` + `D030`.

## Next rule IDs

- `D046` next available.
