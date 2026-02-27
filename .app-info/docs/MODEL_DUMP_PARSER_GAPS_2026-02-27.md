# Model Dump Parser Gaps - 27 February 2026

## Scope

Dump set analysed:

- `mendix-data/dumps/2026-02-27T16-27-28.940Z_App.mpr_d6359d2cdcae4079b57d872df6876dfb/working-dump.json`
- `mendix-data/dumps/2026-02-27T16-27-28.940Z_App.mpr_d6359d2cdcae4079b57d872df6876dfb/head-dump.json`

Objective:

- Identify what the current diff parser cannot parse well yet.
- Focus on parser coverage gaps (no fixes in this pass).
- Document what is missing to reach a complete single-dump application overview.

## Evidence Summary

From current `MendixModelDiffService.CompareDumps(...)` output on this dump pair:

- Total detected changes: `9`
- Module-level grouped output:
  - `New_Module` domain model: `5`
  - `New_Module` microflows: `2`
  - `Pages/Nanoflows/Resources`: `0`
- Null-detail changed elements:
  - `New_Module.Entity2` (`Entity`, Added)
  - `New_Module.Entity3assossiatatedwithEntity2` (`Entity`, Added; association summary added later by structurer)
  - `New_Module.ACO_new` (`Microflow`, Added)
  - `New_Module.BCO_new` (`Microflow`, Added)

Working dump inventory:

- Total distinct `$Type` values in dump: `360`
- Trackable resources by current snapshot indexing rules: `1096`

Current trackable resource types present in this app dump include:

- Covered by specialised detail parsers:
  - `DomainModels$Entity` (`109`)
  - `DomainModels$Association` (`97`)
  - `Enumerations$Enumeration` (`54`)
  - `Microflows$Microflow` (`333`)
  - `Microflows$Nanoflow` (`42`)
  - `Pages$Page` (`110`)
- Not covered by specialised detail parsers (see gap list below):
  - `Pages$Snippet` (`95`)
  - `JavaScriptActions$JavaScriptAction` (`64`)
  - `Pages$PageTemplate` (`58`)
  - `Pages$BuildingBlock` (`46`)
  - `Pages$Layout` (`25`)
  - `JavaActions$JavaAction` (`15`)
  - `Images$ImageCollection` (`12`)
  - `CustomIcons$CustomIconCollection` (`6`)
  - `Constants$Constant` (`6`)
  - `ImportMappings$ImportMapping` (`4`)
  - `ExportMappings$ExportMapping` (`3`)
  - `JsonStructures$JsonStructure` (`3`)
  - `Microflows$Rule` (`3`)
  - `Menus$MenuDocument` (`2`)
  - `Workflows$Workflow` (`1`)
  - `RegularExpressions$RegularExpression` (`1`)
  - `ScheduledEvents$ScheduledEvent` (`1`)
  - `XmlSchemas$XmlSchema` (`1`)
  - `WebServices$PublishedWebService` (`1`)
  - `Security$ProjectSecurity` (`1`)
  - `Texts$SystemTextCollection` (`1`)
  - `Navigation$NavigationDocument` (`1`)
  - `Settings$ProjectSettings` (`1`)

## Gap Report

- [DIFF_GAP] `New_Module / DomainModel / Entity / New_Module.Entity2`
  - Current: `details=null`
  - Cause: entity detail extraction only emits when attributes or selected metadata exist; this entity has no attributes and no emitted metadata.
  - Parseable signals present but unused in summary: `accessRules`, `indexes`, `validationRules`, `exportLevel`, `documentation`, `image/imageData`, baseline structural fields.
  - Impact: Added entities can become detail-less rows, reducing traceability.

- [DIFF_GAP] `New_Module / DomainModel / Entity / New_Module.Entity3assossiatatedwithEntity2`
  - Current: raw entity row has `details=null`; grouped output later receives `associations added (1): [*-1] Entity2`.
  - Cause: same entity baseline issue as above; association context is recovered only during structuring.
  - Impact: entity-level detail depends on post-parse association promotion, not direct entity parsing.

- [DIFF_GAP] `New_Module / Microflows / Microflow / New_Module.ACO_new`
  - Current: `details=null`
  - Cause: flow detail parser emits only action/loop/decision deltas; this added microflow has `ActionActivity=0`, `LoopedActivity=0`, `ExclusiveSplit=0`, so parser returns null.
  - Parseable signals present but unused in summary: `applyEntityAccess`, `allowConcurrentExecution`, `microflowReturnType`, `url`, `allowedModuleRoles`, `exportLevel`.
  - Impact: structurally meaningful but action-empty microflows are reported as low-signal.

- [DIFF_GAP] `New_Module / Microflows / Microflow / New_Module.BCO_new`
  - Current: `details=null`
  - Cause and impact: same as `ACO_new`.

- [DIFF_GAP] `All modules / Resources / Association visibility`
  - Current: association changes are parsed, then moved into domain entity details by `MendixModelChangeStructurer.PromoteAssociationsToDomainModel(...)`; resources bucket no longer contains those association elements.
  - Cause: structuring behaviour is optimised for concise domain summaries.
  - Impact: complete element-level overview is reduced because explicit association rows disappear from grouped output.

- [DIFF_GAP] `All modules / Resources / Non-specialised resource types`
  - Current: types listed in Evidence Summary are indexed as resources but have no specialised detail parsers.
  - Cause: `BuildResourceSpecificDetails(...)` currently routes only flow/entity/association/enumeration/page.
  - Impact:
    - Added/Deleted resources of these types usually produce `details=null`.
    - Modified resources fall back to generic property diffs, not type-aware semantic summaries.

- [DIFF_GAP] `Pages / Page / Widget-level signal`
  - Current: page detail routing includes allowed roles, layout metadata, and client action bindings; widget summary parser is still missing.
  - Cause: `BuildPageWidgetSummaryDetails(...)` remains a candidate in parser library, not implemented in diff service routing.
  - Impact: page/widget-heavy changes can still be under-described.

## Full Overview Blockers (Single-Dump Goal)

- [DIFF_GAP] Diff-only architecture
  - Current pipeline requires `working + head` and emits changed resources only.
  - Impact: unchanged resources are invisible in output, so this cannot produce a complete app overview from one dump.

- [DIFF_GAP] No dedicated dump inventory model
  - Current output model is `MendixModelChange` (change-centric), not `MendixModelElementSnapshot` (inventory-centric).
  - Impact: there is no deterministic full listing of all resources/elements in a single application state.

- [DIFF_GAP] Nested type coverage not represented as standalone elements
  - Dump contains `360` object types (many nested), but current parser emits resource-level changes and selected nested summaries only.
  - Impact: no comprehensive map of nested model constructs for full-app introspection.

## Recommended Parser Backlog (Analysis Only)

1. Add baseline detail contracts for Added/Deleted entities and microflows even when action/attribute deltas are empty.
2. Add specialised parsers for high-volume uncovered resource types in this dump:
   - `Pages$Snippet`, `Pages$PageTemplate`, `Pages$BuildingBlock`, `Pages$Layout`
   - `JavaScriptActions$JavaScriptAction`, `JavaActions$JavaAction`
   - `Constants$Constant`, `Navigation$NavigationDocument`, `Security$ProjectSecurity`
3. Implement page widget summary parsing (`D043` candidate in rule library).
4. Add an opt-in "preserve association rows" mode in structuring for full-overview exports.
5. Add a new single-dump inventory pipeline (not diff) that enumerates all trackable resources and selected nested summaries.

## Applied Rule Changes

- Diff rules: none (analysis-only pass)
- Commit/converter rules: none
