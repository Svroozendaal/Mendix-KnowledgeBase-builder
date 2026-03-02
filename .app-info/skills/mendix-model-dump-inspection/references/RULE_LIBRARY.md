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
  - `Microflows$Microflow|Microflows$Nanoflow|Nanoflows$Nanoflow|Microflows$Rule -> flow parser`
  - `DomainModels$Entity -> entity attribute/metadata parser`
  - `DomainModels$Association -> association parser`
  - `DomainModels$Enumeration|Enumerations$Enumeration -> enumeration parser`
  - `Pages$Page -> role/layout/action/widget parsers`
  - `Pages$Snippet|Pages$PageTemplate|Pages$BuildingBlock|Pages$Layout -> layout/action/widget parsers`
  - all remaining tracked resource types -> generic resource metadata parser

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

## D014 - Flow baseline metadata extraction

- Applies to:
  - `Microflows$Microflow`
  - `Microflows$Nanoflow`
  - `Nanoflows$Nanoflow`
  - `Microflows$Rule`
- Trigger:
  - when action/loop/decision delta anchors are absent.
- Emit:
  - `flow structure: ...`
  - `flow metadata: ...`

## D020 - Domain entity attribute extraction

- Applies to `DomainModels$Entity`.
- Parse `attributes[*]` entries with `$Type=DomainModels$Attribute`.
- Emit:
  - Added entity: `attributes added (<n>): <AttributeList>` only when `<n> > 0`
  - Deleted entity: `attributes before deletion (<n>): <AttributeList>` only when `<n> > 0`
  - Modified entity:
    - `attributes added (<n>): <AttributeList>`
    - `attributes removed (<n>): <AttributeList>`
    - `attributes renamed (<n>): <OldName->NewName list>`
  - If none of the attribute deltas are present, emit baseline entity metadata detail instead of null.

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

- Applies to:
  - `Pages$Page`
  - `Pages$Snippet`
  - `Pages$PageTemplate`
  - `Pages$BuildingBlock`
  - `Pages$Layout`
- Count significant widget types under layout trees.
- Emit:
  - `widgets delta: added <n>, removed <n>` (when both snapshots exist and counts differ)
  - `widgets added (<n>): <WidgetType x#>`
  - `widgets removed (<n>): <WidgetType x#>`
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
    - `Reference` + `owner=Both`: `1-1`
    - `Reference` + `owner=Parent`: `1-*`
    - `Reference` + `owner=Child|Default`: `*-1`
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

## D046 - Domain entity metadata extraction

- Applies to `DomainModels$Entity` on `Added|Modified|Deleted`.
- Parse and emit semantic entity metadata changes:
  - rename signal: `renamed from <oldEntityName>`
  - generalization signal:
    - `Generalization of <newParent>` (added or newly set)
    - `Generalization of <oldParent>-><newParent|<none>>` (changed/removed)
  - commit event handlers:
    - `before commit=<MicroflowList>`
    - `after commit=<MicroflowList>`
    - `before/after commit removed` when handlers were removed
  - system member toggles from `generalization` flags (`hasOwner`, `hasChangedBy`, `hasCreatedDate`, `hasChangedDate`):
    - `system members: enabled <flagList>`
    - `system members: disabled <flagList>`
- If no metadata signals exist, emit no metadata section.

## D050 - Generic property diff fallback

- If no specific rule applies, emit compact property-level diffs:
  - scalar change: `<property> <old>-><new>`
  - array count change: `<property> count <old>-><new>`
  - structural change: `<property> entries updated`
- Respect ignored semantic properties.

## D051 - Generic resource metadata fallback

- Applies to tracked resource types without specialised parsers, and as safety fallback when specialised parser output is empty.
- Emit deterministic baseline anchors:
  - `modelType=<ShortType>`
  - `resource metadata: <key=value,...>` when parseable metadata exists
  - `nested types (<n>): <Type x#>` when nested object types are present
- Purpose:
  - eliminate null `details` for changed resources with parseable dump signals.

## D060 - Null-detail prevention

- If one or more deterministic parser outputs exist for a change, `details` must not be `null`.
- Only allow null when:
  - no parser rule applies, and
  - no generic fallback (D050) yields meaningful output.

## D070 - Constant value and type extraction

- Applies to `System$Constant`.
- Parse:
  - `value` (scalar constant value)
  - `type` (value type, e.g., "String", "Integer", "Boolean")
- Emit:
  - Added: `value=<value>; type=<type>` (when present)
  - Deleted: `value=<value>; type=<type>` (when present)
  - Modified:
    - `value <oldValue>-><newValue>` (when value differs)
    - `type <oldType>-><newType>` (when type differs)
  - Fallback to generic parser if no meaningful value/type fields found

## D071 - Scheduled event configuration extraction

- Applies to `System$ScheduledEvent`.
- Parse:
  - `enabled` (boolean, as string: "true" or "false")
  - `interval` (cron expression or duration string)
  - `microflowName` (target microflow identifier)
  - `startTime` (start time/date if applicable)
- Emit:
  - Added: `enabled=<value>; interval=<value>; microflow=<value>; startTime=<value>`
  - Deleted: same as Added (shows previous state)
  - Modified:
    - `enabled <oldValue>-><newValue>` (when state toggled)
    - `interval <oldCron>-><newCron>` (when schedule changed)
    - `microflow <oldMF>-><newMF>` (when target changed)
    - `startTime <oldTime>-><newTime>` (when start changed)
  - Fallback to generic parser if no meaningful event fields found

## D072 - Consumed REST Service configuration extraction

- Applies to `System$ConsumedRestService`.
- Parse:
  - `baseURL` (endpoint URL)
  - `authenticationType` (auth method: None, Basic, OAuth, etc.)
  - `operations` (operation count)
- Emit:
  - Added: `baseURL=<url>; auth=<type>; operations=<count>`
  - Deleted: same as Added (shows previous state)
  - Modified:
    - `baseURL <oldUrl>-><newUrl>` (when endpoint changed)
    - `auth <oldType>-><newType>` (when auth method changed)
    - `operations <oldCount>-><newCount>` (when operations count changed)
  - Fallback to generic parser if no meaningful service fields found

## D073 - Published REST Service configuration extraction

- Applies to `System$PublishedRestService`.
- Parse:
  - `operations` (operation count)
  - `publicAccessLevel` (access level for API)
- Emit:
  - Added: `operations=<count>; accessLevel=<level>`
  - Deleted: same as Added (shows previous state)
  - Modified:
    - `operations <oldCount>-><newCount>` (when operations count changed)
    - `accessLevel <oldLevel>-><newLevel>` (when access level changed)
  - Fallback to generic parser if no meaningful service fields found

## D074 - Java Action configuration extraction

- Applies to `System$JavaAction`.
- Parse:
  - `parameters` (parameter count)
  - `returnType` (action return type)
  - `publicAccessLevel` (access level)
- Emit:
  - Added: `parameters=<count>; returnType=<type>; accessLevel=<level>`
  - Deleted: same as Added (shows previous state)
  - Modified:
    - `parameters <oldCount>-><newCount>` (when parameter count changed)
    - `returnType <oldType>-><newType>` (when return type changed)
    - `accessLevel <oldLevel>-><newLevel>` (when access level changed)
  - Fallback to generic parser if no meaningful action fields found

## Open Gaps

- Full single-dump inventory is still out of scope for diff-only extraction.

## Next rule IDs

- `D075` next available.
