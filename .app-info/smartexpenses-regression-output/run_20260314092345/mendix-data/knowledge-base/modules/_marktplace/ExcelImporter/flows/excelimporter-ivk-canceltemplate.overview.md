---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.IVK_CancelTemplate
stableId: 2804fa6e-7416-41a4-9a41-e186098a2275
slug: excelimporter-ivk-canceltemplate
layer: L1
l0: excelimporter-ivk-canceltemplate.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ivk-canceltemplate.json
l2Logical: flow:ExcelImporter.IVK_CancelTemplate
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.IVK_CancelTemplate

## Summary

- Likely orchestrates downstream flow calls without direct UI output.
- L0: [abstract](excelimporter-ivk-canceltemplate.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ivk-canceltemplate.json)

## Main Steps

- isNew( $Template ) template was new? expression=isNew( $Template )
- $valid valid? expression=$valid

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; this likely delegates work to downstream flows.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: ExcelImporter.ValidateTemplate
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it may serve validation, background processing, or delegate work to other flows.

## Important Retrieves/Decisions/Mutations

- nodeId=bc626e4e-68ce-471f-8253-cee131bf721f; caption=template was new?; expression=isNew( $Template ) template was new? expression=isNew( $Template )
- nodeId=823a06a7-291b-4c0f-b895-195469df75df; caption=valid?; expression=$valid valid? expression=$valid

## Warnings/Unknowns

- Rollback hint detected in node detail.
- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ivk-canceltemplate.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
