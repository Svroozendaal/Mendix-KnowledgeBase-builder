---
objectType: flow
module: ImporterHelper
qualifiedName: ImporterHelper.SUB_ImportTemplateDocument
stableId: 2f855460-cdb6-49ec-9d20-67100aea9632
slug: importerhelper-sub-importtemplatedocument
layer: L1
l0: importerhelper-sub-importtemplatedocument.abstract.md
l2Path: ../../../../app-overview/current/modules/ImporterHelper/flows/importerhelper-sub-importtemplatedocument.json
l2Logical: flow:ImporterHelper.SUB_ImportTemplateDocument
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ImporterHelper.SUB_ImportTemplateDocument

## Summary

- Likely serves as a helper flow invoked from ImporterHelper.ACT_ExcelFileImport_ImportToNP.
- L0: [abstract](importerhelper-sub-importtemplatedocument.abstract.md)
- L2: [json](../../../../app-overview/current/modules/ImporterHelper/flows/importerhelper-sub-importtemplatedocument.json)

## Main Steps

- retrieve Template from ExcelImporter.Template
- $Template != empty has a template selected expression=$Template != empty

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by ImporterHelper.ACT_ExcelFileImport_ImportToNP.
- Output/UI context: No page output was exported; check L2 JSON if the exact user-facing effect matters.

## Key Entities Touched

- ExcelImporter.Template

## Called / Called By

- Calls: none
- Called by: ImporterHelper.ACT_ExcelFileImport_ImportToNP

## Shown Pages

- No ShowPageAction was exported for this flow; it may serve validation, background processing, or delegate work to other flows.

## Important Retrieves/Decisions/Mutations

- nodeId=e76d4e90-97ce-4576-85ec-8a0cc76585a7; sourceKind=Database; entity=ExcelImporter.Template; summary=retrieve Template from ExcelImporter.Template
- nodeId=18b83d04-3fe8-4dd7-9fda-cc3bfa7b7fb6; caption=has a template selected; expression=$Template != empty has a template selected expression=$Template != empty

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/ImporterHelper/flows/importerhelper-sub-importtemplatedocument.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/ImporterHelper/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/ImporterHelper/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
