---
objectType: flow
module: SmartExpenses
qualifiedName: SmartExpenses.SUB_Transaction_setStatus
stableId: 48918402-7869-4ba9-b53b-3e4aab9863cf
slug: smartexpenses-sub-transaction-setstatus
layer: L1
l0: smartexpenses-sub-transaction-setstatus.abstract.md
l2Path: ../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-sub-transaction-setstatus.json
l2Logical: flow:SmartExpenses.SUB_Transaction_setStatus
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: SmartExpenses.SUB_Transaction_setStatus

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](smartexpenses-sub-transaction-setstatus.abstract.md)
- L2: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-sub-transaction-setstatus.json)

## Main Steps

- ChangeObjectAction: change Transaction (Status=if $Transaction/SmartExpenses.Transaction_Balance = empty then SmartExpenses.ENUM_TransactionStatus.Pending else if $Transaction/InOut = SmartExpenses.ENUM_TransactionSort.income t...; refreshInClient=false) change Transaction (Status=if $Transaction/SmartExpenses.Transaction_Balance = empty then SmartExpenses.ENUM_TransactionStatus.Pending else if $Transaction/InOut = SmartExpenses.ENUM_TransactionSort.income t...; refreshInClient=false)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by ImporterHelper.ACT_ImportTransaction_AcceptTransactions, SmartExpenses.ACT_Transaction_BulkEditSave, SmartExpenses.ACT_Transaction_NewEdit_Save.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: ImporterHelper.ACT_ImportTransaction_AcceptTransactions, SmartExpenses.ACT_Transaction_BulkEditSave, SmartExpenses.ACT_Transaction_NewEdit_Save

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=deb34574-0bfd-4ec5-8f5e-436eade9f237; actionKind=Change; entity=SmartExpenses.Transaction_Balance; members=Status=if $Transaction/SmartExpenses.Transaction_Balance = empty then SmartExpenses.ENUM_TransactionStatus.Pending else if $Transaction/InOut = SmartExpenses.ENUM_TransactionSort.income t...; refreshInClient=false; summary=ChangeObjectAction: change Transaction (Status=if $Transaction/SmartExpenses.Transaction_Balance = empty then SmartExpenses.ENUM_TransactionStatus.Pending else if $Transaction/InOut = SmartExpenses.ENUM_TransactionSort.income t...; refreshInClient=false) change Transaction (Status=if $Transaction/SmartExpenses.Transaction_Balance = empty then SmartExpenses.ENUM_TransactionStatus.Pending else if $Transaction/InOut = SmartExpenses.ENUM_TransactionSort.income t...; refreshInClient=false)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-sub-transaction-setstatus.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
