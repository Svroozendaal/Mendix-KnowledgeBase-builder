---
objectType: flow
module: SmartExpenses
qualifiedName: SmartExpenses.ACT_Transaction_BulkEditSave
stableId: dbb0e0a6-970f-4504-8de1-af5510ac7702
slug: smartexpenses-act-transaction-bulkeditsave
layer: L1
l0: smartexpenses-act-transaction-bulkeditsave.abstract.md
l2Path: ../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-transaction-bulkeditsave.json
l2Logical: flow:SmartExpenses.ACT_Transaction_BulkEditSave
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: SmartExpenses.ACT_Transaction_BulkEditSave

## Summary

- Likely acts as a save, process, or background step for SmartExpenses.Transaction because it mutates data without showing a page.
- L0: [abstract](smartexpenses-act-transaction-bulkeditsave.abstract.md)
- L2: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-transaction-bulkeditsave.json)

## Main Steps

- retrieve Balance over association BulkEditHelper_Balance from BulkEditHelper
- retrieve BudgetTerm over association BulkEditHelper_BudgetTerm from BulkEditHelper
- $BudgetTerm != empty BudgetTerm found? expression=$BudgetTerm != empty
- $Balance != empty Found? expression=$Balance != empty
- ChangeObjectAction: change IteratorTransaction (Transaction_Balance=if $BulkEditHelper/SmartExpenses.BulkEditHelper_Balance != empty then $BulkEditHelper/SmartExpenses.BulkEditHelper_Balance else $IteratorTransaction/SmartExpenses.Transaction_Balan..., Transaction_BudgetTerm=if $BulkEditHelper/SmartExpenses.BulkEditHelper_BudgetTerm != empty then $BulkEditHelper/SmartExpenses.BulkEditHelper_BudgetTerm else $IteratorTransaction/SmartExpenses.Transaction..., InOut=if $BulkEditHelper/InOut != empty then $BulkEditHelper/InOut else $IteratorTransaction/InOut; refreshInClient=false) change IteratorTransaction (Transaction_Balance=if $BulkEditHelper/SmartExpenses.BulkEditHelper_Balance != empty then $BulkEditHelper/SmartExpenses.BulkEditHelper_Balance else $IteratorTransaction/SmartExpenses.Transaction_Balan..., Transaction_BudgetTerm=if $BulkEditHelper/SmartExpenses.BulkEditHelper_BudgetTerm != empty then $BulkEditHelper/SmartExpenses.BulkEditHelper_BudgetTerm else $IteratorTransaction/SmartExpenses.Transaction..., InOut=if $BulkEditHelper/InOut != empty then $BulkEditHelper/InOut else $IteratorTransaction/InOut; refreshInClient=false)
- CommitAction: commit TransactionList (refreshInClient=true, withEvents=false) commit TransactionList (refreshInClient=true, withEvents=false)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- SmartExpenses.Transaction

## Called / Called By

- Calls: SmartExpenses.SUB_Balance_Recalculate, SmartExpenses.SUB_BudgetTerm_Recalculate, SmartExpenses.SUB_Transaction_setStatus
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=0cc27fd8-c421-41c4-8aef-a8ba10dfd5a7; sourceKind=Association; association=BulkEditHelper_Balance; summary=retrieve Balance over association BulkEditHelper_Balance from BulkEditHelper
- nodeId=9ff3bfdc-0bc8-40c8-a899-7183f35fa799; sourceKind=Association; association=BulkEditHelper_BudgetTerm; summary=retrieve BudgetTerm over association BulkEditHelper_BudgetTerm from BulkEditHelper
- nodeId=a46689fe-5c30-4d28-a20e-b1b25232c449; sourceKind=Association; association=BulkEditHelper_Transaction; summary=retrieve TransactionList over association BulkEditHelper_Transaction from BulkEditHelper
- nodeId=2754a5a7-bedc-41b0-8912-fed12c3a3bd9; caption=BudgetTerm found?; expression=$BudgetTerm != empty BudgetTerm found? expression=$BudgetTerm != empty
- nodeId=785d2ae8-740a-4ad7-a206-0bc85cb821e1; caption=Found?; expression=$Balance != empty Found? expression=$Balance != empty
- nodeId=e45a8dba-04d8-425a-bc03-68f8988dcdea; actionKind=Change; entity=SmartExpenses.BulkEditHelper_Balance; members=Transaction_Balance=if $BulkEditHelper/SmartExpenses.BulkEditHelper_Balance != empty then $BulkEditHelper/SmartExpenses.BulkEditHelper_Balance else $IteratorTransaction/SmartExpenses.Transaction_Balan..., Transaction_BudgetTerm=if $BulkEditHelper/SmartExpenses.BulkEditHelper_BudgetTerm != empty then $BulkEditHelper/SmartExpenses.BulkEditHelper_BudgetTerm else $IteratorTransaction/SmartExpenses.Transaction..., InOut=if $BulkEditHelper/InOut != empty then $BulkEditHelper/InOut else $IteratorTransaction/InOut; refreshInClient=false; summary=ChangeObjectAction: change IteratorTransaction (Transaction_Balance=if $BulkEditHelper/SmartExpenses.BulkEditHelper_Balance != empty then $BulkEditHelper/SmartExpenses.BulkEditHelper_Balance else $IteratorTransaction/SmartExpenses.Transaction_Balan..., Transaction_BudgetTerm=if $BulkEditHelper/SmartExpenses.BulkEditHelper_BudgetTerm != empty then $BulkEditHelper/SmartExpenses.BulkEditHelper_BudgetTerm else $IteratorTransaction/SmartExpenses.Transaction..., InOut=if $BulkEditHelper/InOut != empty then $BulkEditHelper/InOut else $IteratorTransaction/InOut; refreshInClient=false) change IteratorTransaction (Transaction_Balance=if $BulkEditHelper/SmartExpenses.BulkEditHelper_Balance != empty then $BulkEditHelper/SmartExpenses.BulkEditHelper_Balance else $IteratorTransaction/SmartExpenses.Transaction_Balan..., Transaction_BudgetTerm=if $BulkEditHelper/SmartExpenses.BulkEditHelper_BudgetTerm != empty then $BulkEditHelper/SmartExpenses.BulkEditHelper_BudgetTerm else $IteratorTransaction/SmartExpenses.Transaction..., InOut=if $BulkEditHelper/InOut != empty then $BulkEditHelper/InOut else $IteratorTransaction/InOut; refreshInClient=false)
- nodeId=00e6ba3a-80cc-4b84-b133-b0fc13630ed9; actionKind=Commit; members=refreshInClient=true, withEvents=false; summary=CommitAction: commit TransactionList (refreshInClient=true, withEvents=false) commit TransactionList (refreshInClient=true, withEvents=false)

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-transaction-bulkeditsave.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
