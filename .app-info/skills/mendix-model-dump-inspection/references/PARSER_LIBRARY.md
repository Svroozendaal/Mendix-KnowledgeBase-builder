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
  - Contract anchor:
    - `attributes added (<n>): <AttributeList>`
  - Zero-attribute contract:
    - Added: `attributes added (0): <none>`
    - Deleted: `attributes before deletion (0): <none>`

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
  - Status: missing (candidate).
  - Parse target:
    - Count significant widget types under `layoutCall.arguments[*].widgets`.
  - Contract candidate:
    - `widgets used (<n>): <WidgetType x#>`

## Detail text assembly

- `MergeDetailTexts(params string?[] parts) -> string?`
- `NormalizeInlineText(string text, int maxLength) -> string`
- `FormatCounterList(Dictionary<string, int> counts, int maxEntries) -> string`
- `FormatNameList(IEnumerable<string> names, int maxEntries) -> string`

## Recommended router implementation

- `BuildResourceSpecificDetails(...)` should route by model type:
  - `Microflows$Microflow -> BuildMicroflowActionDeltaDetails`
  - `Microflows$Nanoflow -> BuildMicroflowActionDeltaDetails (shared flow parser)`
  - `DomainModels$Entity -> BuildDomainEntityAttributeDetails`
  - `DomainModels$Association -> BuildDomainAssociationDetails`
  - `DomainModels$Enumeration|Enumerations$Enumeration -> BuildEnumerationValueDetails`
  - `Pages$Page -> Merge(BuildPageAllowedRolesDetails, BuildPageLayoutMetadataDetails, BuildPageActionBindingsDetails, BuildPageWidgetSummaryDetails)`

## Rule linkage

Each function above is mapped in:
- `references/RULE_LIBRARY.md`

Use stable IDs there when adding new parsing behavior, then implement in `MendixModelDiffService.cs` in the same change.
