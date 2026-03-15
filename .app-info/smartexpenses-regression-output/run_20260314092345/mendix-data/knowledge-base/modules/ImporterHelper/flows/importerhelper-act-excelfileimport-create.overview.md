---
objectType: flow
module: ImporterHelper
qualifiedName: ImporterHelper.ACT_ExcelFileImport_Create
stableId: 32a05137-0a26-429b-93a5-adf933050f87
slug: importerhelper-act-excelfileimport-create
layer: L1
l0: importerhelper-act-excelfileimport-create.abstract.md
l2Path: ../../../../app-overview/current/modules/ImporterHelper/flows/importerhelper-act-excelfileimport-create.json
l2Logical: flow:ImporterHelper.ACT_ExcelFileImport_Create
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ImporterHelper.ACT_ExcelFileImport_Create

## Summary

- Likely acts as a UI entry or navigation handler because it shows ImporterHelper.ExcelFileImport_Upload.
- L0: [abstract](importerhelper-act-excelfileimport-create.abstract.md)
- L2: [json](../../../../app-overview/current/modules/ImporterHelper/flows/importerhelper-act-excelfileimport-create.json)

## Main Steps

- ShowPageAction: show page ImporterHelper.ExcelFileImport_Upload show page ImporterHelper.ExcelFileImport_Upload
- ChangeObjectAction: change ImportTransactionHelper (ImportTransactionHelper_ExcelFileImport=$NewExcelFileImport; refreshInClient=false) change ImportTransactionHelper (ImportTransactionHelper_ExcelFileImport=$NewExcelFileImport; refreshInClient=false)
- CreateObjectAction: create ImporterHelper.ExcelFileImport as NewExcelFileImport create ImporterHelper.ExcelFileImport as NewExcelFileImport

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: Shows ImporterHelper.ExcelFileImport_Upload.

## Key Entities Touched

- ImporterHelper.ExcelFileImport

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- ImporterHelper.ExcelFileImport_Upload

## Important Retrieves/Decisions/Mutations

- nodeId=1a403864-9d67-48d7-b38d-66cf5d5220a3; actionKind=Change; members=ImportTransactionHelper_ExcelFileImport=$NewExcelFileImport; refreshInClient=false; summary=ChangeObjectAction: change ImportTransactionHelper (ImportTransactionHelper_ExcelFileImport=$NewExcelFileImport; refreshInClient=false) change ImportTransactionHelper (ImportTransactionHelper_ExcelFileImport=$NewExcelFileImport; refreshInClient=false)
- nodeId=c6b8f4f8-5fc0-492e-8c28-b28cdabee91c; actionKind=Create; entity=ImporterHelper.ExcelFileImport; summary=CreateObjectAction: create ImporterHelper.ExcelFileImport as NewExcelFileImport create ImporterHelper.ExcelFileImport as NewExcelFileImport

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/ImporterHelper/flows/importerhelper-act-excelfileimport-create.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/ImporterHelper/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/ImporterHelper/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
