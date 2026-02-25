---
name: mendix-model-dump-inspection
description: Retrieve detailed Mendix model changes from `mx dump-mpr` JSON artifacts, including microflow action usage/details and domain model entity attribute additions. Use when analysing `working-dump.json` vs `head-dump.json`, troubleshooting model diff output, or extending model change extraction logic in this repository.
---

# MENDIX MODEL DUMP INSPECTION

## USE THIS WORKFLOW

1. Locate dump artifacts from export payloads:
- Read `modelDumpArtifact.workingDumpPath`.
- Read `modelDumpArtifact.headDumpPath`.
- If missing, trigger export from the extension first so dumps are persisted in `mendix-data/dumps/`.

2. Parse both dump files as JSON:
- Handle UTF-8 BOM if present.
- Expect root shape with `units` and nested Mendix model objects.

3. Build two snapshots (`working`, `head`) using object IDs:
- Index every object by `$ID`.
- Track parent links via `$ContainerID`.
- Register trackable resources when either rule matches:
  - `$ContainerProperty` is `documents` or `projectDocuments`.
  - `$Type` is one of `DomainModels$Entity`, `DomainModels$Association`, `DomainModels$Enumeration`.

4. Compute resource changes:
- `Added`: resource in `working` only.
- `Deleted`: resource in `head` only.
- `Modified`: same resource ID exists in both and JSON differs.

5. Add nested ownership changes:
- For changed non-resource objects, resolve owning resource by climbing parent chain.
- Increment nested added/modified/deleted counters on owner resource.

6. Add resource-specific detail extractors:
- Microflows (`Microflows$Microflow`):
  - Traverse `Microflows$ActionActivity`.
  - Read action object from `action`.
  - Count action types by `$Type` short name (for example `RetrieveAction`, `ChangeObjectAction`).
  - Build action descriptors from action fields:
    - `RetrieveAction`: `retrieveSource.$Type`, `startVariableName`, `association`, `entity`, `outputVariableName`.
    - `RetrieveAction` (second level): add `retrieveType`, `retrieveOverAssociations`, `xPathConstraint`, `range`, `sortExpression`.
    - `ChangeObjectAction`: `changeVariableName` plus changed member assignments from `items[*].attribute|association` and `items[*].value`.
    - `ChangeObjectAction` (second level): include `refreshInClient`, `withEvents`.
    - `CommitAction`: `commitVariableName`.
    - `CommitAction` (second level): include `refreshInClient`, `withEvents`.
    - `CreateObjectAction`: `entity`, `outputVariableName`, and changed member assignments from `items`.
    - Extra actions: `ChangeVariableAction`, `CreateVariableAction`, `DeleteAction`, `MicroflowCallAction`, `JavaActionCallAction`, `JavaScriptActionCallAction`.
- Domain entities (`DomainModels$Entity`):
  - Inspect `attributes` array for `DomainModels$Attribute`.
  - Compare attribute keys between `working` and `head`.
  - Output attribute names added in the working model.

7. Emit final model changes:
- Include `changeType`, `elementType`, `elementName`, and merged detail text.
- Sort by `elementType`, `elementName`, then `changeType`.

## DETAIL STRING CONTRACT (PARSER COUPLING)

Keep emitted detail text parseable by `MendixCommitParser/Services/CommitParserService.cs`.

Required pattern for microflow summary:

- `actions used (<n>): ActionType x#, ActionType x#`

Required pattern for descriptors:

- `action details: ActionType: detail text; ActionType: detail text`

Required pattern for domain attributes:

- `attributes added (<n>): AttributeA, AttributeB`

Do not rename these anchors (`actions used`, `action details`, `attributes added`) unless parser regexes are updated in the same change.

## FIELD MAP FOR ACTION DETAILS

- `Microflows$RetrieveAction`
  - `outputVariableName`
  - `retrieveSource.$Type`
  - `retrieveSource.startVariableName`
  - `retrieveSource.association`
  - `retrieveSource.entity`
  - `retrieveType`
  - `retrieveOverAssociations`
  - `xPathConstraint`
  - `range`
  - `sortExpression`

- `Microflows$ChangeObjectAction`
  - `changeVariableName`
  - `items[*].attribute`
  - `items[*].association`
  - `items[*].value` (expression text)
  - `refreshInClient`
  - `withEvents`

- `Microflows$CommitAction`
  - `commitVariableName`
  - `refreshInClient`
  - `withEvents`

- `Microflows$CreateObjectAction`
  - `entity`
  - `outputVariableName`
  - `items[*].attribute|association`

## REPOSITORY ENTRY POINT

- Use `studio-pro-extension-csharp/MendixModelDiffService.cs`:
  - `CompareDumps(...)` is the main entry point.
  - `BuildMicroflowActionDetails(...)` and `BuildDomainEntityAttributeDetails(...)` implement the specialised detail extraction.
- Use `MendixCommitParser/Services/CommitParserService.cs`:
  - `BuildMicroflowActionSummary(...)` parses `actions used` and `action details`.
  - `BuildDomainModelSummary(...)` parses `attributes added`.

## OUTPUT EXAMPLE STYLE

- `SmartExpenses.NEW_MICROFLOW_test (Added) - actions used (3): ChangeObjectAction x1, CommitAction x1, RetrieveAction x1; action details: RetrieveAction: retrieve CurrentSession over association User_Session from Account (xPath=[%CurrentUser%]); ChangeObjectAction: change CurrentSession (SessionId=$SessionToken); CommitAction: commit CurrentSession (withEvents=true)`
