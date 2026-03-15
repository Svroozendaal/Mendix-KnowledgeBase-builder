---
objectType: flow
module: SmartExpenses
qualifiedName: SmartExpenses.ACT_Transaction_Recalculate_all
stableId: e044acf5-79db-4524-96d5-9ebecef0c332
slug: smartexpenses-act-transaction-recalculate-all
layer: L1
l0: smartexpenses-act-transaction-recalculate-all.abstract.md
l2Path: ../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-transaction-recalculate-all.json
l2Logical: flow:SmartExpenses.ACT_Transaction_Recalculate_all
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: SmartExpenses.ACT_Transaction_Recalculate_all

## Summary

- Likely acts as a save, process, or background step for SmartExpenses.Balance, SmartExpenses.BudgetType because it mutates data without showing a page.
- L0: [abstract](smartexpenses-act-transaction-recalculate-all.abstract.md)
- L2: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-transaction-recalculate-all.json)

## Main Steps

- retrieve BalanceList from SmartExpenses.Balance
- retrieve BudgetTermList over association BudgetTerm_BudgetType from IteratorBudgetType
- ChangeObjectAction: change FBGProfile (BalanceTotal=$NewTotalBalance; refreshInClient=true) change FBGProfile (BalanceTotal=$NewTotalBalance; refreshInClient=true)
- CommitAction: commit BalanceList (refreshInClient=true, withEvents=true) commit BalanceList (refreshInClient=true, withEvents=true)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- SmartExpenses.Balance, SmartExpenses.BudgetType

## Called / Called By

- Calls: SmartExpenses.DS_TotalBalance_Calculate, SmartExpenses.SUB_Balance_Recalculate, SmartExpenses.SUB_BudgetTerm_Recalculate
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=15fecd29-f24e-4e9b-8fbe-baf3488239b8; sourceKind=Database; entity=SmartExpenses.Balance; summary=retrieve BalanceList from SmartExpenses.Balance
- nodeId=42445d64-65d6-4e32-97cf-aa5fa95c8424; sourceKind=Association; association=BudgetTerm_BudgetType; summary=retrieve BudgetTermList over association BudgetTerm_BudgetType from IteratorBudgetType
- nodeId=ab87837d-e280-4e09-a3dd-974fde6186e0; sourceKind=Database; entity=SmartExpenses.BudgetType; summary=retrieve BudgetTypeList from SmartExpenses.BudgetType
- nodeId=bb306f6d-2057-486f-a56e-7705da9eb864; actionKind=Change; members=BalanceTotal=$NewTotalBalance; refreshInClient=true; summary=ChangeObjectAction: change FBGProfile (BalanceTotal=$NewTotalBalance; refreshInClient=true) change FBGProfile (BalanceTotal=$NewTotalBalance; refreshInClient=true)
- nodeId=4dce5504-9db6-43fd-9b07-f4731fd85cc9; actionKind=Commit; members=refreshInClient=true, withEvents=true; summary=CommitAction: commit BalanceList (refreshInClient=true, withEvents=true) commit BalanceList (refreshInClient=true, withEvents=true)
- nodeId=7f6886b3-276d-4c75-b7b8-9ac4d17370d6; actionKind=Commit; members=refreshInClient=false, withEvents=false; summary=CommitAction: commit BudgetTermList (refreshInClient=false, withEvents=false) commit BudgetTermList (refreshInClient=false, withEvents=false)
- nodeId=9c587bdc-818e-471f-a221-06d242c39196; actionKind=Commit; members=refreshInClient=true, withEvents=true; summary=CommitAction: commit BudgetTypeList (refreshInClient=true, withEvents=true) commit BudgetTypeList (refreshInClient=true, withEvents=true)

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-transaction-recalculate-all.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
