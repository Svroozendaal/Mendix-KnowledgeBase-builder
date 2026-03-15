---
objectType: flow
module: SmartExpenses
qualifiedName: SmartExpenses.ACT_Transaction_Create
stableId: 742012e9-f6e5-4025-9e8c-93479de74d7a
slug: smartexpenses-act-transaction-create
layer: L1
l0: smartexpenses-act-transaction-create.abstract.md
l2Path: ../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-transaction-create.json
l2Logical: flow:SmartExpenses.ACT_Transaction_Create
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: SmartExpenses.ACT_Transaction_Create

## Summary

- Likely acts as a UI entry or navigation handler because it shows SmartExpenses.Transaction_New.
- L0: [abstract](smartexpenses-act-transaction-create.abstract.md)
- L2: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-transaction-create.json)

## Main Steps

- ShowPageAction: show page SmartExpenses.Transaction_New show page SmartExpenses.Transaction_New
- CreateObjectAction: create SmartExpenses.Transaction as NewTransaction (EntryDate=[%BeginOfCurrentDay%], TransactionDate=[%BeginOfCurrentDay%], Status=SmartExpenses.ENUM_TransactionStatus.Pending, Transaction_FBGProfile=$FBGProfile, TransactionCode=formatDateTime([%CurrentDateTime%], 'dmmyyyyHHmmss'), InOut=$TransactionSort) create SmartExpenses.Transaction as NewTransaction (EntryDate=[%BeginOfCurrentDay%], TransactionDate=[%BeginOfCurrentDay%], Status=SmartExpenses.ENUM_TransactionStatus.Pending, Transaction_FBGProfile=$FBGProfile, TransactionCode=formatDateTime([%CurrentDateTime%], 'dmmyyyyHHmmss'), InOut=$TransactionSort)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: Shows SmartExpenses.Transaction_New.

## Key Entities Touched

- SmartExpenses.Transaction

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- SmartExpenses.Transaction_New

## Important Retrieves/Decisions/Mutations

- nodeId=e4b9bfec-f39a-443c-8ef5-64dc25960ddb; actionKind=Create; entity=SmartExpenses.Transaction; members=EntryDate=[%BeginOfCurrentDay%], TransactionDate=[%BeginOfCurrentDay%], Status=SmartExpenses.ENUM_TransactionStatus.Pending, Transaction_FBGProfile=$FBGProfile, TransactionCode=formatDateTime([%CurrentDateTime%], 'dmmyyyyHHmmss'; summary=CreateObjectAction: create SmartExpenses.Transaction as NewTransaction (EntryDate=[%BeginOfCurrentDay%], TransactionDate=[%BeginOfCurrentDay%], Status=SmartExpenses.ENUM_TransactionStatus.Pending, Transaction_FBGProfile=$FBGProfile, TransactionCode=formatDateTime([%CurrentDateTime%], 'dmmyyyyHHmmss'), InOut=$TransactionSort) create SmartExpenses.Transaction as NewTransaction (EntryDate=[%BeginOfCurrentDay%], TransactionDate=[%BeginOfCurrentDay%], Status=SmartExpenses.ENUM_TransactionStatus.Pending, Transaction_FBGProfile=$FBGProfile, TransactionCode=formatDateTime([%CurrentDateTime%], 'dmmyyyyHHmmss'), InOut=$TransactionSort)

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-transaction-create.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
