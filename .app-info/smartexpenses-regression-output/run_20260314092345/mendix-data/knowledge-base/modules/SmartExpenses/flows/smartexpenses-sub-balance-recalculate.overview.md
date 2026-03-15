---
objectType: flow
module: SmartExpenses
qualifiedName: SmartExpenses.SUB_Balance_Recalculate
stableId: 85f15da8-3182-4584-82fc-0af091cea484
slug: smartexpenses-sub-balance-recalculate
layer: L1
l0: smartexpenses-sub-balance-recalculate.abstract.md
l2Path: ../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-sub-balance-recalculate.json
l2Logical: flow:SmartExpenses.SUB_Balance_Recalculate
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: SmartExpenses.SUB_Balance_Recalculate

## Summary

- Likely acts as a save, process, or background step for SmartExpenses.Transaction because it mutates data without showing a page.
- L0: [abstract](smartexpenses-sub-balance-recalculate.abstract.md)
- L2: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-sub-balance-recalculate.json)

## Main Steps

- retrieve Balance_Transactions_expenditure from SmartExpenses.Transaction
- retrieve Balance_Transactions_income from SmartExpenses.Transaction
- ChangeObjectAction: change BalanceType (CurrentAmount=$Total; refreshInClient=false) change BalanceType (CurrentAmount=$Total; refreshInClient=false)
- CreateVariableAction: create variable Total=$SumValue_Balance_income - $SumValue_Balance_expenditures create variable Total=$SumValue_Balance_income - $SumValue_Balance_expenditures

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by SmartExpenses.ACT_Transaction_BulkEditSave, SmartExpenses.ACT_Transaction_Recalculate_all, SmartExpenses.SUB_Transaction_CalculateBalance.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- SmartExpenses.Transaction

## Called / Called By

- Calls: none
- Called by: SmartExpenses.ACT_Transaction_BulkEditSave, SmartExpenses.ACT_Transaction_Recalculate_all, SmartExpenses.SUB_Transaction_CalculateBalance

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=af4c6474-36b1-4c88-9517-d4a7200a47d4; sourceKind=Database; entity=SmartExpenses.Transaction; summary=retrieve Balance_Transactions_expenditure from SmartExpenses.Transaction
- nodeId=4ee9c549-1897-4839-ac11-2403c129caf4; sourceKind=Database; entity=SmartExpenses.Transaction; summary=retrieve Balance_Transactions_income from SmartExpenses.Transaction
- nodeId=cc7d3c3d-573f-45fb-b117-795f9c6fdffc; actionKind=Change; members=CurrentAmount=$Total; refreshInClient=false; summary=ChangeObjectAction: change BalanceType (CurrentAmount=$Total; refreshInClient=false) change BalanceType (CurrentAmount=$Total; refreshInClient=false)
- nodeId=c2d74af2-2959-418b-8c3b-b64995079a75; actionKind=Create; summary=CreateVariableAction: create variable Total=$SumValue_Balance_income - $SumValue_Balance_expenditures create variable Total=$SumValue_Balance_income - $SumValue_Balance_expenditures

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-sub-balance-recalculate.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
