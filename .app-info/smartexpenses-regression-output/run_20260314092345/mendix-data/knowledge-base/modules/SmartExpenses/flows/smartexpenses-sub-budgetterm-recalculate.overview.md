---
objectType: flow
module: SmartExpenses
qualifiedName: SmartExpenses.SUB_BudgetTerm_Recalculate
stableId: 8c3cbc77-536e-45e6-a450-eea191726b4b
slug: smartexpenses-sub-budgetterm-recalculate
layer: L1
l0: smartexpenses-sub-budgetterm-recalculate.abstract.md
l2Path: ../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-sub-budgetterm-recalculate.json
l2Logical: flow:SmartExpenses.SUB_BudgetTerm_Recalculate
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: SmartExpenses.SUB_BudgetTerm_Recalculate

## Summary

- Likely acts as a save, process, or background step for SmartExpenses.Transaction because it mutates data without showing a page.
- L0: [abstract](smartexpenses-sub-budgetterm-recalculate.abstract.md)
- L2: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-sub-budgetterm-recalculate.json)

## Main Steps

- retrieve Budget_Transactions_expenditure from SmartExpenses.Transaction
- retrieve Budget_Transactions_income from SmartExpenses.Transaction
- ChangeObjectAction: change BudgetTerm (CurrentAmount=$Total; refreshInClient=false) change BudgetTerm (CurrentAmount=$Total; refreshInClient=false)
- CreateVariableAction: create variable Total=$SumValue_BudgetTerm_Expenditure - $SumValue_BudgetTerm_Income create variable Total=$SumValue_BudgetTerm_Expenditure - $SumValue_BudgetTerm_Income

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by SmartExpenses.ACT_Transaction_BulkEditSave, SmartExpenses.ACT_Transaction_Recalculate_all, SmartExpenses.SUB_Transaction_CalculateBudgetTerm.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- SmartExpenses.Transaction

## Called / Called By

- Calls: none
- Called by: SmartExpenses.ACT_Transaction_BulkEditSave, SmartExpenses.ACT_Transaction_Recalculate_all, SmartExpenses.SUB_Transaction_CalculateBudgetTerm

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=c6324d0e-8edc-42b5-aef7-0012249fda07; sourceKind=Database; entity=SmartExpenses.Transaction; summary=retrieve Budget_Transactions_expenditure from SmartExpenses.Transaction
- nodeId=237857a7-a21e-401a-84c3-1c42f97f69ce; sourceKind=Database; entity=SmartExpenses.Transaction; summary=retrieve Budget_Transactions_income from SmartExpenses.Transaction
- nodeId=cf212d26-ca13-470e-a512-9415a5ef2255; actionKind=Change; members=CurrentAmount=$Total; refreshInClient=false; summary=ChangeObjectAction: change BudgetTerm (CurrentAmount=$Total; refreshInClient=false) change BudgetTerm (CurrentAmount=$Total; refreshInClient=false)
- nodeId=eb0cca13-788e-43e9-a6d8-1edf378bb9b0; actionKind=Create; summary=CreateVariableAction: create variable Total=$SumValue_BudgetTerm_Expenditure - $SumValue_BudgetTerm_Income create variable Total=$SumValue_BudgetTerm_Expenditure - $SumValue_BudgetTerm_Income

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-sub-budgetterm-recalculate.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
