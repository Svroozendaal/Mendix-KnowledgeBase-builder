---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.GetCorrectString
stableId: 0dd8b283-ba33-46da-8827-81d70829a3c4
slug: excelimporter-getcorrectstring
layer: L1
l0: excelimporter-getcorrectstring.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-getcorrectstring.json
l2Logical: flow:ExcelImporter.GetCorrectString
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.GetCorrectString

## Summary

- Likely serves as a helper flow invoked from ExcelImporter.ValidateTemplate.
- L0: [abstract](excelimporter-getcorrectstring.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-getcorrectstring.json)

## Main Steps

- ( $CurLanguage != empty and $CurLanguage/Code = 'nl_NL' ) use NL expression=( $CurLanguage != empty and $CurLanguage/Code = 'nl_NL' )

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by ExcelImporter.ValidateTemplate.
- Output/UI context: No page output was exported; check L2 JSON if the exact user-facing effect matters.

## Key Entities Touched

- No entity evidence was exported for this flow.

## Called / Called By

- Calls: none
- Called by: ExcelImporter.ValidateTemplate

## Shown Pages

- No ShowPageAction was exported for this flow; it may serve validation, background processing, or delegate work to other flows.

## Important Retrieves/Decisions/Mutations

- nodeId=22ea0c4a-cc2d-48c2-b9b1-84391c66bd1c; caption=use NL; expression=( $CurLanguage != empty and $CurLanguage/Code = 'nl_NL' ) use NL expression=( $CurLanguage != empty and $CurLanguage/Code = 'nl_NL' )

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-getcorrectstring.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
