---
objectType: flow
module: SmartExpenses
qualifiedName: SmartExpenses.ACT_Transaction_BulkEditCreate
stableId: dc256d76-4fe1-46a0-ac10-4c8cb281a2b0
slug: smartexpenses-act-transaction-bulkeditcreate
layer: L1
l0: smartexpenses-act-transaction-bulkeditcreate.abstract.md
l2Path: ../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-transaction-bulkeditcreate.json
l2Logical: flow:SmartExpenses.ACT_Transaction_BulkEditCreate
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: SmartExpenses.ACT_Transaction_BulkEditCreate

## Summary

- Likely acts as a UI entry or navigation handler because it shows SmartExpenses.Transaction_BulkEdit.
- L0: [abstract](smartexpenses-act-transaction-bulkeditcreate.abstract.md)
- L2: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-transaction-bulkeditcreate.json)

## Main Steps

- ShowPageAction: show page SmartExpenses.Transaction_BulkEdit show page SmartExpenses.Transaction_BulkEdit
- CreateObjectAction: create SmartExpenses.BulkEditHelper as NewBulkEditHelper (BulkEditHelper_Transaction=$TransactionList) create SmartExpenses.BulkEditHelper as NewBulkEditHelper (BulkEditHelper_Transaction=$TransactionList)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: Shows SmartExpenses.Transaction_BulkEdit.

## Key Entities Touched

- SmartExpenses.BulkEditHelper

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- SmartExpenses.Transaction_BulkEdit

## Important Retrieves/Decisions/Mutations

- nodeId=1da8aa19-f3ee-4a30-9386-09b98c5964e3; actionKind=Create; entity=SmartExpenses.BulkEditHelper; members=BulkEditHelper_Transaction=$TransactionList; summary=CreateObjectAction: create SmartExpenses.BulkEditHelper as NewBulkEditHelper (BulkEditHelper_Transaction=$TransactionList) create SmartExpenses.BulkEditHelper as NewBulkEditHelper (BulkEditHelper_Transaction=$TransactionList)

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-transaction-bulkeditcreate.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
