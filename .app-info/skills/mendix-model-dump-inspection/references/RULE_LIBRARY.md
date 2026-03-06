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
  - and `changeType` is `Added` or `Deleted`.
- Emit:
  - `flow structure: ...`
  - `flow metadata: ...`
- Suppression:
  - Do not include `exportLevel` in emitted flow metadata.
  - Do not emit baseline flow structure/metadata for `Modified` flows; rely on deterministic delta/property-change anchors.

## D015 - Flow annotation extraction and ownership fallback

- Applies to:
  - `Microflows$Microflow`
  - `Microflows$Nanoflow`
- Parse:
  - `Microflows$Annotation` objects anywhere in the flow object graph (`objectCollection` traversal).
  - Annotation descriptor text from caption/text/content payload when available.
- Emit anchors:
  - `annotations delta: added <n>, removed <n>, modified <n>`
  - `annotations added (<n>): <AnnotationDescriptor>`
  - `annotations removed (<n>): <AnnotationDescriptor>`
  - `annotations modified (<n>): <OldDescriptor -> NewDescriptor>`
- Ownership fallback:
  - If flow-level semantic diff is equal (for example because `objectCollection` is ignored for noise suppression), still mark the flow `Modified` when deterministic flow delta anchors exist (actions/loops/decisions/annotations).
  - This ensures annotation changes without `$ContainerID` are still attached to the owning flow.

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
- Baseline suppression:
  - Do not include entity `exportLevel` in baseline metadata output.

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

## D075 - Page layout metadata delta extraction

- Applies to:
  - `Pages$Page`
- Parse:
  - `layoutCall.layout`
  - `title.translations`
  - `url`
  - popup fields (`popupWidth`, `popupHeight`, `popupResizable`)
- Emit:
  - Added/Deleted:
    - `layout=<layout>; title=<title>; url=<url|empty>; popup=<w>x<h> resizable=<bool>`
  - Modified:
    - only changed fields, each as `<field> <old|empty>-><new|empty>`
    - supported fields: `layout`, `title`, `url`, `popup`

## D076 - Page-like action binding delta extraction

- Applies to:
  - `Pages$Page`
  - `Pages$Snippet`
  - `Pages$PageTemplate`
  - `Pages$BuildingBlock`
  - `Pages$Layout`
- Parse targets:
  - widget deltas by widget `$ID` + widget type
  - widget action binding fields (`action`, `onChangeAction`, `onClickAction`, `onEnterAction`, `onLeaveAction`, ...)
  - client-action targets (`page`, `microflow`, `nanoflow`)
  - source bindings from `dataSource` / `selectorSource`
- Emit:
  - Added:
    - `actions used (<n>): <ActionType x#>; action targets: <TargetList>`
  - Deleted:
    - `actions before deletion (<n>): <ActionType x#>; action targets before deletion: <TargetList>`
  - Modified:
    - one or more widget-level rows:
    - `added <WidgetType>(<optionalName>) (<bindingKey=value,...>)`
    - `modified <WidgetType>(<optionalName>) (<bindingKey old->new | property-change summary>)`
    - `removed <WidgetType>(<optionalName>) (<bindingKey=value,...>)`

## D077 - Page-like widget delta-only rendering for modified rows

- Applies to:
  - `Pages$Page`
  - `Pages$Snippet`
  - `Pages$PageTemplate`
  - `Pages$BuildingBlock`
  - `Pages$Layout`
- Parse:
  - significant widget type counts under layout trees
- Emit:
  - Added:
    - `widgets used (<n>): <WidgetType x#>`
  - Deleted:
    - `widgets before deletion (<n>): <WidgetType x#>`
  - Modified:
    - suppress aggregate widget count sections when widget-level delta rows are emitted by D076
    - do not emit full `widgets used` inventory for modified rows

## D078 - Page-like generic-noise suppression

- Applies to:
  - `Pages$Page`
  - `Pages$Snippet`
  - `Pages$PageTemplate`
  - `Pages$BuildingBlock`
  - `Pages$Layout`
- Rule:
  - when deterministic page/UI parser anchors are available, prefer page-specific detail output and do not merge generic modification fragments such as:
    - `layoutCall updated`
    - `widgets entries updated`
    - other generic property-summary noise from `BuildModificationDetails(...)`

## D079 - Page functional widget summary extraction

- Applies to:
  - `Pages$Page`
  - `Pages$Snippet`
  - `Pages$PageTemplate`
  - `Pages$BuildingBlock`
  - `Pages$Layout`
- Parse:
  - full widget-type counts from layout tree traversal output (before any `+N more` truncation)
  - functional widget subset:
    - `ActionButton`
    - `DataView`
    - `DataGrid`
    - `DataGrid2`
    - `Snippet` (including `SnippetCallWidget` mapped to `Snippet`)
- Emit:
  - Added/Modified-with-single-snapshot:
    - `functional widgets (<n>): <WidgetType x# list>`
  - Deleted:
    - `functional widgets before deletion (<n>): <WidgetType x# list>`
- Example evidence:
  - `New_Module.Pagina_test` (`Pages$Page`, Added) produced a broad `widgets used (...)` inventory where functional widget types can be hidden by `+N more`; this rule guarantees explicit functional-widget anchors for downstream converter formatting.

## D080 - Page requested-widget converter anchor preservation

- Applies to:
  - `Pages$Page`
  - `Pages$Snippet`
  - `Pages$PageTemplate`
  - `Pages$BuildingBlock`
  - `Pages$Layout`
- Purpose:
  - preserve deterministic parser anchors required by converter rule `C016` to build requested widget summaries and widget details.
- Required anchors:
  - functional widget inventory:
    - `functional widgets (<n>): <WidgetType x# list>` (or before-deletion variant)
  - lifecycle action targets on added/deleted rows:
    - `action targets: <kind=target list>`
    - `action targets before deletion: <kind=target list>`
  - widget delta lines on modified rows:
    - `added <WidgetType>(<optionalName>) (<bindingKey=value,...>)`
    - `modified <WidgetType>(<optionalName>) (<bindingKey old->new | property-change summary>)`
    - `removed <WidgetType>(<optionalName>) (<bindingKey=value,...>)`
- Rule:
  - do not rename these anchors without same-change converter-rule updates.
  - keep target kinds deterministic (`page`, `microflow`, `nanoflow`) for button-detail synthesis.

## D081 - Modified flow generic-fallback suppression

- Applies to:
  - `Microflows$Microflow`
  - `Microflows$Nanoflow`
  - `Nanoflows$Nanoflow`
  - `Microflows$Rule`
- Trigger:
  - `changeType = Modified`
  - flow parser output is empty after applying flow-specific rules (D010-D015 and D014 scope).
- Rule:
  - Do not append generic fallback inventory details (`modelType=...`, `resource metadata: ...`, `nested types (...)`) for modified flows.
  - Preserve direct property-delta details emitted by generic modification diff (for example `allowedModuleRoles count <old>-><new>`).
- Purpose:
  - avoid low-signal inventory noise in commit message generation for role-only flow permission changes.

## Open Gaps

- Full single-dump inventory is still out of scope for diff-only extraction.

## Next rule IDs

- `D082` next available.
