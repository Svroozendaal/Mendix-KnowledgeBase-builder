# PARSER_LIBRARY

This library defines parser functions and detail contracts for extracting `details` from Mendix dump diffs (`working-dump.json` vs `head-dump.json`).
Use it as the implementation backlog for `studio-pro-extension-csharp/Processing/ModelDiff/MendixModelDiffService.cs`.

## Evidence Snapshot

Source export:
- `mendix-data/exports/2026-02-26T11-22-20.132Z_testApp-main.json`

Rows with missing `details`:
- `Page` (`Nieuwe_module.Page`)
- `Nanoflow` (`Nieuwe_module.newNanoflow`)
- `Enumeration` (`Nieuwe_module.ENUM_nieuw`)

Observed dump evidence:
- `Pages$Page`: `layoutCall.layout=Atlas_Core.Atlas_Default`, `title=Page`, `MicroflowClientAction -> Nieuwe_module.newMicroflow`
- `Microflows$Nanoflow`: actions present (`RetrieveAction`, `ChangeObjectAction`, `CommitAction`, `ChangeListAction`, `CreateObjectAction`)
- `Microflows$LoopedActivity`: loop metadata present (`loopSource.listVariableName`, `loopSource.variableName`)
- `Enumerations$Enumeration`: values present with `name` and `caption.translations[*].text`

## Function Catalog

## Core snapshot layer

- `BuildSnapshot(JsonElement root) -> DumpSnapshot`
- `CompareDumps(string workingJsonPath, string headJsonPath) -> List<MendixModelChange>`
- `ResolveOwningResourceId(DumpSnapshot snapshot, string objectId) -> string?`
- `BuildModificationDetails(JsonElement previous, JsonElement current) -> string?`

## Flow parsers

- `BuildMicroflowActionDeltaDetails(JsonElement? working, JsonElement? head) -> string?`
  - Status: implemented.
  - Contract anchors:
    - `actions delta: added <n>, removed <n>, modified <n>`
    - `actions added (<n>): <ActionType x#>`
    - `added action details: <ActionType: descriptor>`

- `BuildNanoflowActionDeltaDetails(JsonElement? working, JsonElement? head) -> string?`
  - Status: implemented via shared flow action parser.
  - Reuse strategy:
    - Reuse microflow action diff parser.
    - Traverse nested `objectCollection` recursively (including loop bodies).
  - Contract:
    - Same anchor format as microflow action delta.

- `BuildFlowMetadataDetails(string changeType, string modelType, JsonElement? working, JsonElement? head) -> string?`
  - Status: implemented.
  - Purpose:
    - Baseline details for flow resources when no action/loop/decision deltas exist (for example newly created empty microflows).
  - Contract anchors:
    - `flow structure: ...`
    - `flow metadata: ...`

- `CollectFlowActionsById(JsonElement flow) -> Dictionary<string, FlowActionInfo>`
  - Status: implemented for microflow, reusable for nanoflow.
  - Notes:
    - Prefer `$ID` as identity.
    - Fallback identity from `<ActionType>:<normalized descriptor>`.

- `BuildActionDescriptor(string actionType, JsonElement action) -> string?`
  - Status: implemented for common action types and expanded deterministic flow/UI actions.
  - Coverage highlights:
    - `ChangeListAction`
    - `ShowPageAction` (page target)
    - `ShowMessageAction` (text/type/blocking metadata)
    - `CloseFormAction`
    - `MicroflowCallAction` and `NanoflowCallAction` (nested call target parsing)

- `CollectFlowLoopsById(JsonElement flow) -> Dictionary<string, FlowLoopInfo>`
  - Status: implemented.
  - Parse target:
    - `Microflows$LoopedActivity`
    - `loopSource.listVariableName`
    - `loopSource.variableName`
  - Contract anchors:
    - `loops delta: ...`
    - `loops added/removed/modified (...)`

- `CollectFlowDecisionsById(JsonElement flow) -> Dictionary<string, FlowDecisionInfo>`
  - Status: implemented.
  - Parse target:
    - `Microflows$ExclusiveSplit`
    - `caption`
    - `splitCondition.expression`
  - Contract anchors:
    - `decisions delta: ...`
    - `decisions added/removed/modified (...)`

## Domain model parsers

- `BuildDomainEntityAttributeDetails(string changeType, JsonElement? working, JsonElement? head) -> string?`
  - Status: implemented.
  - Contract anchors:
    - `attributes added (<n>): <AttributeList>`
    - `attributes removed (<n>): <AttributeList>`
    - `attributes renamed (<n>): <OldName->NewNameList>`
  - Zero-attribute contract:
    - Do not emit zero-count attribute sections.
  - Metadata anchors for modified entities:
    - `renamed from <OldEntityName>`
    - `Generalization of <newParent>`
    - `Generalization of <oldParent>-><newParent|<none>>`
    - `before commit=<MicroflowList>`
    - `after commit=<MicroflowList>`
    - `system members: enabled <flagList>`
    - `system members: disabled <flagList>`
  - Baseline fallback:
    - Emits `entity metadata: ...` or deterministic baseline text when attribute/metadata delta anchors are absent.

- `BuildDomainAssociationDetails(JsonElement? working, JsonElement? head, DumpSnapshot workingSnapshot, DumpSnapshot headSnapshot) -> string?`
  - Status: implemented.
  - Parse fields:
    - `type`
    - `owner`
    - `storageFormat`
    - `parent`
    - `child`
  - Contract:
    - `parent=<entity>; association=[<cardinality>] <otherEntity>`
    - include metadata only when non-default (`type!=Reference`, `owner!=Default`, `storageFormat!=Table`)
    - cardinality mapping:
      - `Reference + owner=Both -> 1-1`
      - `Reference + owner=Parent -> 1-*`
      - `Reference + owner=Child|Default -> *-1`
      - `ReferenceSet -> *-*`

- `ResolveElementType(string modelType, JsonElement element) -> string`
  - Status: implemented.
  - Purpose:
    - classify non-persistent entities for display routing.
  - Contract:
    - `DomainModels$Entity` + `persistable=false` or `generalization.persistable=false` -> `NonPersistentEntity`
    - otherwise retain default `Entity` mapping

- `BuildEnumerationValueDetails(string changeType, JsonElement? working, JsonElement? head) -> string?`
  - Status: implemented.
  - Parse fields:
    - `values[*].name`
    - `values[*].caption.translations`
    - `values[*].image`
  - Contract candidates:
    - Added: `values added (<n>): <NameList>`
    - Modified: `values delta: added <n>, removed <n>, modified <n>`
    - Optional caption signal: `caption mismatch: <name>(caption=<caption>)`

## Page/UI parsers

- `BuildPageAllowedRolesDetails(JsonElement? working, JsonElement? head, DumpSnapshot workingSnapshot, DumpSnapshot headSnapshot) -> string?`
  - Status: implemented.
  - Current limitation:
    - Returns `null` when both role sets are empty.

- `BuildPageLayoutSummaryDetails(JsonElement? working, JsonElement? head) -> string?`
  - Status: implemented (`BuildPageLayoutMetadataDetails`).
  - Parse fields:
    - `layoutCall.layout`
    - `url`
    - `title.translations`
    - popup settings (`popupWidth`, `popupHeight`, `popupResizable`)
  - Contract candidate:
    - `layout=<layout>; title=<title>; url=<url|empty>; popup=<w>x<h> resizable=<bool>`

- `BuildPageActionBindingsDetails(JsonElement? working, JsonElement? head) -> string?`
  - Status: implemented.
  - Parse targets:
    - `Pages$*ClientAction` (`MicroflowClientAction`, `NanoflowClientAction`, `PageClientAction`)
    - Extract referenced microflow/nanoflow/page.
  - Contract candidate:
    - `actions used (<n>): <ActionType x#>; action targets: <TargetList>`

- `BuildPageWidgetSummaryDetails(JsonElement? working, JsonElement? head) -> string?`
  - Status: implemented.
  - Parse target:
    - Count significant widget types under `layoutCall` and nested page widget trees.
  - Contract:
    - `widgets delta: added <n>, removed <n>` (when both snapshots exist and counts differ)
    - `widgets added (<n>): <WidgetType x#>`
    - `widgets removed (<n>): <WidgetType x#>`
    - `widgets used (<n>): <WidgetType x#>`

## System configuration parsers

- `BuildConstantDetails(string changeType, JsonElement? working, JsonElement? head) -> string?`
  - Status: implemented.
  - Parse fields:
    - `value` (scalar constant value)
    - `type` (value type string)
  - Contract candidates:
    - Added: `value=<value>; type=<type>`
    - Deleted: `value=<value>; type=<type>`
    - Modified: `value <old>-><new>` and/or `type <oldType>-><newType>`

- `BuildScheduledEventDetails(string changeType, JsonElement? working, JsonElement? head) -> string?`
  - Status: implemented.
  - Parse fields:
    - `enabled` (boolean as string "true"/"false")
    - `interval` (cron expression or duration string)
    - `microflowName` (target microflow identifier)
    - `startTime` (start datetime string)
  - Contract candidates:
    - Added: `enabled=<value>; interval=<value>; microflow=<value>; startTime=<value>`
    - Deleted: same as Added
    - Modified: `enabled <old>-><new>`, `interval <old>-><new>`, `microflow <old>-><new>`, `startTime <old>-><new>`

- `BuildConsumedRestServiceDetails(string changeType, JsonElement? working, JsonElement? head) -> string?`
  - Status: implemented.
  - Parse fields:
    - `baseURL` (endpoint URL string)
    - `authenticationType` (auth method: None, Basic, OAuth, etc.)
    - `operations` (operation array count)
  - Contract candidates:
    - Added: `baseURL=<url>; auth=<type>; operations=<count>`
    - Deleted: same as Added
    - Modified: `baseURL <old>-><new>`, `auth <old>-><new>`, `operations <oldCount>-><newCount>`

- `BuildPublishedRestServiceDetails(string changeType, JsonElement? working, JsonElement? head) -> string?`
  - Status: implemented.
  - Parse fields:
    - `operations` (operation array count)
    - `publicAccessLevel` (API access level)
  - Contract candidates:
    - Added: `operations=<count>; accessLevel=<level>`
    - Deleted: same as Added
    - Modified: `operations <oldCount>-><newCount>`, `accessLevel <old>-><new>`

- `BuildJavaActionDetails(string changeType, JsonElement? working, JsonElement? head) -> string?`
  - Status: implemented.
  - Parse fields:
    - `parameters` (parameter array count)
    - `returnType` (action return type)
    - `publicAccessLevel` (access level)
  - Contract candidates:
    - Added: `parameters=<count>; returnType=<type>; accessLevel=<level>`
    - Deleted: same as Added
    - Modified: `parameters <oldCount>-><newCount>`, `returnType <old>-><new>`, `accessLevel <old>-><new>`

## Generic resource parsers

- `BuildGenericResourceDetails(string changeType, string modelType, JsonElement? working, JsonElement? head) -> string?`
  - Status: implemented.
  - Purpose:
    - Deterministic non-null fallback details for document/resource model types without specialised parsers.
  - Contract anchors:
    - `modelType=<ShortType>`
    - `resource metadata: <key=value,...>` (when present)
    - `nested types (<n>): <Type x#>` (when nested model objects exist)

## Detail text assembly

- `MergeDetailTexts(params string?[] parts) -> string?`
- `NormalizeInlineText(string text, int maxLength) -> string`
- `FormatCounterList(Dictionary<string, int> counts, int maxEntries) -> string`
- `FormatNameList(IEnumerable<string> names, int maxEntries) -> string`

## Recommended router implementation

- `BuildResourceSpecificDetails(...)` should route by model type:
  - `Microflows$Microflow|Microflows$Nanoflow|Nanoflows$Nanoflow|Microflows$Rule -> BuildMicroflowActionDeltaDetails + BuildFlowMetadataDetails`
  - `DomainModels$Entity -> BuildDomainEntityAttributeDetails`
  - `DomainModels$Association -> BuildDomainAssociationDetails`
  - `DomainModels$Enumeration|Enumerations$Enumeration -> BuildEnumerationValueDetails`
  - `Pages$Page -> Merge(BuildPageAllowedRolesDetails, BuildPageLayoutMetadataDetails, BuildPageActionBindingsDetails, BuildPageWidgetSummaryDetails)`
  - `Pages$Snippet|Pages$PageTemplate|Pages$BuildingBlock|Pages$Layout -> Merge(BuildPageLayoutMetadataDetails, BuildPageActionBindingsDetails, BuildPageWidgetSummaryDetails)`
  - `System$Constant -> BuildConstantDetails`
  - `System$ScheduledEvent -> BuildScheduledEventDetails`
  - `System$ConsumedRestService -> BuildConsumedRestServiceDetails`
  - `System$PublishedRestService -> BuildPublishedRestServiceDetails`
  - `System$JavaAction -> BuildJavaActionDetails`
  - all remaining tracked resources -> `BuildGenericResourceDetails`

## Rule linkage

Each function above is mapped in:
- `references/RULE_LIBRARY.md`

Use stable IDs there when adding new parsing behavior, then implement in `MendixModelDiffService.cs` in the same change.
