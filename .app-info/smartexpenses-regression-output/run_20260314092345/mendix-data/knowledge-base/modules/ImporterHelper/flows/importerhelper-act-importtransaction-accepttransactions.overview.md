---
objectType: flow
module: ImporterHelper
qualifiedName: ImporterHelper.ACT_ImportTransaction_AcceptTransactions
stableId: a4f25624-8ab4-4c64-9c7b-4a96469b77f7
slug: importerhelper-act-importtransaction-accepttransactions
layer: L1
l0: importerhelper-act-importtransaction-accepttransactions.abstract.md
l2Path: ../../../../app-overview/current/modules/ImporterHelper/flows/importerhelper-act-importtransaction-accepttransactions.json
l2Logical: flow:ImporterHelper.ACT_ImportTransaction_AcceptTransactions
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ImporterHelper.ACT_ImportTransaction_AcceptTransactions

## Summary

- Likely acts as a save, process, or background step for SmartExpenses.Transaction because it mutates data without showing a page.
- L0: [abstract](importerhelper-act-importtransaction-accepttransactions.abstract.md)
- L2: [json](../../../../app-overview/current/modules/ImporterHelper/flows/importerhelper-act-importtransaction-accepttransactions.json)

## Main Steps

- retrieve ImportTransactionList over association ImportTransaction_ImportTransactionHelper from ImportTransactionHelper
- ChangeListAction: change ImportTransactionList (type=Remove, value=$IteratorImportTransaction) change ImportTransactionList (type=Remove, value=$IteratorImportTransaction)
- ChangeListAction: change TransactionList (type=Add, value=$Transaction) change TransactionList (type=Add, value=$Transaction)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by ImporterHelper.ACT_ImportTransaction_Refreshpage.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- SmartExpenses.Transaction

## Called / Called By

- Calls: SmartExpenses.SUB_Transaction_setStatus
- Called by: ImporterHelper.ACT_ImportTransaction_Refreshpage

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=e2b2d33d-4ae5-436f-8729-63c684de63cb; sourceKind=Association; association=ImportTransaction_ImportTransactionHelper; summary=retrieve ImportTransactionList over association ImportTransaction_ImportTransactionHelper from ImportTransactionHelper
- nodeId=73f0e6ec-b6aa-4086-837c-b5370771df02; actionKind=Change; members=type=Remove, value=$IteratorImportTransaction; summary=ChangeListAction: change ImportTransactionList (type=Remove, value=$IteratorImportTransaction) change ImportTransactionList (type=Remove, value=$IteratorImportTransaction)
- nodeId=466a807a-57e7-4a45-a7e1-8d26d893f7a1; actionKind=Change; members=type=Add, value=$Transaction; summary=ChangeListAction: change TransactionList (type=Add, value=$Transaction) change TransactionList (type=Add, value=$Transaction)
- nodeId=11ec7fe3-6085-4aa6-bd93-5b9a8ee314fb; actionKind=Commit; members=refreshInClient=true, withEvents=true; summary=CommitAction: commit ImportTransactionList (refreshInClient=true, withEvents=true) commit ImportTransactionList (refreshInClient=true, withEvents=true)
- nodeId=06d548f8-b9a5-4c1d-a854-950be2181115; actionKind=Commit; members=refreshInClient=true, withEvents=true; summary=CommitAction: commit TransactionList (refreshInClient=true, withEvents=true) commit TransactionList (refreshInClient=true, withEvents=true)
- nodeId=14cc6fe7-9ce0-4f3f-8118-ef50169c6877; actionKind=Create; entity=SmartExpenses.Transaction; members=Transaction_FBGProfile=$FBGProfile, TransactionCode=$IteratorImportTransaction/Transactiereferentie, Name=$IteratorImportTransaction/Tegenpartij, Description=$IteratorImportTransaction/Omschrijving, InOut=if $IteratorImportTransaction/Bedrag >= 0 then SmartExpenses.ENUM_TransactionSort.income else SmartExpenses.ENUM_TransactionSort.expenditure, Value=abs($IteratorImportTransaction/Bedrag; summary=CreateObjectAction: create SmartExpenses.Transaction as Transaction (Transaction_FBGProfile=$FBGProfile, TransactionCode=$IteratorImportTransaction/Transactiereferentie, Name=$IteratorImportTransaction/Tegenpartij, Description=$IteratorImportTransaction/Omschrijving, InOut=if $IteratorImportTransaction/Bedrag >= 0 then SmartExpenses.ENUM_TransactionSort.income else SmartExpenses.ENUM_TransactionSort.expenditure, Value=abs($IteratorImportTransaction/Bedrag), TransactionDate=$IteratorImportTransaction/Datum, EntryDate=[%BeginOfCurrentDay%], +2 more) create SmartExpenses.Transaction as Transaction (Transaction_FBGProfile=$FBGProfile, TransactionCode=$IteratorImportTransaction/Transactiereferentie, Name=$IteratorImportTransaction/Tegenpartij, Description=$IteratorImportTransaction/Omschrijving, InOut=if $IteratorImportTransaction/Bedrag >= 0 then SmartExpenses.ENUM_TransactionSort.income else SmartExpenses.ENUM_TransactionSort.expenditure, Value=abs($IteratorImportTransaction/Bedrag), TransactionDate=$IteratorImportTransaction/Datum, EntryDate=[%BeginOfCurrentDay%], +2 more)
- nodeId=5adb021d-8f5d-444c-ba94-25ba33e5c40f; actionKind=Delete; members=refreshInClient=false; summary=DeleteAction: delete IteratorImportTransaction (refreshInClient=false) delete IteratorImportTransaction (refreshInClient=false)

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/ImporterHelper/flows/importerhelper-act-importtransaction-accepttransactions.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/ImporterHelper/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/ImporterHelper/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
