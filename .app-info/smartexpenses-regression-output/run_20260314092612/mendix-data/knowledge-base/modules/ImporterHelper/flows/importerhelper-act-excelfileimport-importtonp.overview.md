---
objectType: flow
module: ImporterHelper
qualifiedName: ImporterHelper.ACT_ExcelFileImport_ImportToNP
stableId: a6a14a02-b6ef-4069-94cf-efc8ac4b46f7
slug: importerhelper-act-excelfileimport-importtonp
layer: L1
l0: importerhelper-act-excelfileimport-importtonp.abstract.md
l2Path: ../../../../app-overview/current/modules/ImporterHelper/flows/importerhelper-act-excelfileimport-importtonp.json
l2Logical: flow:ImporterHelper.ACT_ExcelFileImport_ImportToNP
sourceRun: cli_2026-03-14T09-26-12.835Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ImporterHelper.ACT_ExcelFileImport_ImportToNP

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](importerhelper-act-excelfileimport-importtonp.abstract.md)
- L2: [json](../../../../app-overview/current/modules/ImporterHelper/flows/importerhelper-act-excelfileimport-importtonp.json)

## Main Steps

- retrieve ImportTransactionHelperList over association ImportTransactionHelper_ExcelFileImport from ExcelFileImport
- $Imported = true Is Variable? expression=$Imported = true
- CommitAction: commit ExcelFileImport (refreshInClient=true, withEvents=true) commit ExcelFileImport (refreshInClient=true, withEvents=true)
- CommitAction: commit ImportTransactionHelper (refreshInClient=true, withEvents=true) commit ImportTransactionHelper (refreshInClient=true, withEvents=true)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: ImporterHelper.SUB_ImportTemplateDocument
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=b42e4622-c81f-4972-afca-79d377edf291; sourceKind=Association; association=ImportTransactionHelper_ExcelFileImport; summary=retrieve ImportTransactionHelperList over association ImportTransactionHelper_ExcelFileImport from ExcelFileImport
- nodeId=e2240b71-ceeb-4d1e-827b-2e9502318174; caption=Is Variable?; expression=$Imported = true Is Variable? expression=$Imported = true
- nodeId=30aa60df-2aea-4df9-b6dc-f3946b51ca23; actionKind=Commit; members=refreshInClient=true, withEvents=true; summary=CommitAction: commit ExcelFileImport (refreshInClient=true, withEvents=true) commit ExcelFileImport (refreshInClient=true, withEvents=true)
- nodeId=1775bb55-8bd8-4d48-925d-fd1d5dade241; actionKind=Commit; members=refreshInClient=true, withEvents=true; summary=CommitAction: commit ImportTransactionHelper (refreshInClient=true, withEvents=true) commit ImportTransactionHelper (refreshInClient=true, withEvents=true)

## Warnings/Unknowns

- Rollback hint detected in node detail.
- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/ImporterHelper/flows/importerhelper-act-excelfileimport-importtonp.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-14T09-26-12.835Z/modules/ImporterHelper/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-26-12.835Z/modules/ImporterHelper/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-26-12.835Z
