---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.StringToTemplateImportActions
stableId: ffb787ee-af8e-4467-98af-8d8973af6274
slug: excelimporter-stringtotemplateimportactions
layer: L1
l0: excelimporter-stringtotemplateimportactions.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-stringtotemplateimportactions.json
l2Logical: flow:ExcelImporter.StringToTemplateImportActions
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.StringToTemplateImportActions

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](excelimporter-stringtotemplateimportactions.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-stringtotemplateimportactions.json)

## Main Steps

- CreateVariableAction: create variable Enum=if $Input = 'CreateObjects' then ExcelImporter.ImportActions.CreateObjects else if $Input = 'OnlyCreateNewObjects' then ExcelImporter.ImportActions.OnlyCreateNewObjects else if $Input = 'SynchronizeObjects' then ExcelImp... create variable Enum=if $Input = 'CreateObjects' then ExcelImporter.ImportActions.CreateObjects else if $Input = 'OnlyCreateNewObjects' then ExcelImporter.ImportActions.OnlyCreateNewObjects else if $Input = 'SynchronizeObjects' then ExcelImp...

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=6c76a6bf-721a-4da1-b9e8-4765a78f9f66; actionKind=Create; entity=ExcelImporter.ImportActions; summary=CreateVariableAction: create variable Enum=if $Input = 'CreateObjects' then ExcelImporter.ImportActions.CreateObjects else if $Input = 'OnlyCreateNewObjects' then ExcelImporter.ImportActions.OnlyCreateNewObjects else if $Input = 'SynchronizeObjects' then ExcelImp... create variable Enum=if $Input = 'CreateObjects' then ExcelImporter.ImportActions.CreateObjects else if $Input = 'OnlyCreateNewObjects' then ExcelImporter.ImportActions.OnlyCreateNewObjects else if $Input = 'SynchronizeObjects' then ExcelImp...

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-stringtotemplateimportactions.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
