---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.StringToColumnReferenceKeyType
stableId: 30904bae-1393-4167-af1b-5bbbb092835b
slug: excelimporter-stringtocolumnreferencekeytype
layer: L1
l0: excelimporter-stringtocolumnreferencekeytype.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-stringtocolumnreferencekeytype.json
l2Logical: flow:ExcelImporter.StringToColumnReferenceKeyType
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.StringToColumnReferenceKeyType

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](excelimporter-stringtocolumnreferencekeytype.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-stringtocolumnreferencekeytype.json)

## Main Steps

- CreateVariableAction: create variable Enum=if $Input = 'NoKey' then ExcelImporter.ReferenceKeyType.NoKey else if $Input = 'YesMainAndAssociatedObject' then ExcelImporter.ReferenceKeyType.YesMainAndAssociatedObject else if $Input = 'YesOnlyAssociatedObject' then E... create variable Enum=if $Input = 'NoKey' then ExcelImporter.ReferenceKeyType.NoKey else if $Input = 'YesMainAndAssociatedObject' then ExcelImporter.ReferenceKeyType.YesMainAndAssociatedObject else if $Input = 'YesOnlyAssociatedObject' then E...

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

- nodeId=1974ed22-4253-436a-a057-86b7fa62714b; actionKind=Create; entity=ExcelImporter.ReferenceKeyType; summary=CreateVariableAction: create variable Enum=if $Input = 'NoKey' then ExcelImporter.ReferenceKeyType.NoKey else if $Input = 'YesMainAndAssociatedObject' then ExcelImporter.ReferenceKeyType.YesMainAndAssociatedObject else if $Input = 'YesOnlyAssociatedObject' then E... create variable Enum=if $Input = 'NoKey' then ExcelImporter.ReferenceKeyType.NoKey else if $Input = 'YesMainAndAssociatedObject' then ExcelImporter.ReferenceKeyType.YesMainAndAssociatedObject else if $Input = 'YesOnlyAssociatedObject' then E...

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-stringtocolumnreferencekeytype.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
