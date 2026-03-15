---
objectType: flow
module: SmartExpenses
qualifiedName: SmartExpenses.DS_BudgetTerm_New
stableId: 838bf9bd-e643-4780-86fa-6fc6be26648e
slug: smartexpenses-ds-budgetterm-new
layer: L1
l0: smartexpenses-ds-budgetterm-new.abstract.md
l2Path: ../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-ds-budgetterm-new.json
l2Logical: flow:SmartExpenses.DS_BudgetTerm_New
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: SmartExpenses.DS_BudgetTerm_New

## Summary

- Likely acts as a save, process, or background step for SmartExpenses.BudgetTerm because it mutates data without showing a page.
- L0: [abstract](smartexpenses-ds-budgetterm-new.abstract.md)
- L2: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-ds-budgetterm-new.json)

## Main Steps

- retrieve BudgetTermList from SmartExpenses.BudgetTerm
- retrieve OldBudgetTerm from SmartExpenses.BudgetTerm
- $BudgetTermList = empty Is Term empty? expression=$BudgetTermList = empty
- CreateObjectAction: create SmartExpenses.BudgetTerm as NewBudgetTerm (BudgetTerm_BudgetType=$BudgetType, Name=if ($BudgetType/Interval = SmartExpenses.ENUM_BudgetInterval.Week) then 'weekbudget' else if ($BudgetType/Interval = SmartExpenses.ENUM_BudgetInterval.Month) then formatDateTime($D..., BudgetAmount=$OldBudgetTerm/BudgetAmount, StartDate=if ($BudgetType/Interval = SmartExpenses.ENUM_BudgetInterval.Week) then beginOfWeek($Date) else if ($BudgetType/Interval = SmartExpenses.ENUM_BudgetInterval.Month) then beginOfMont..., EndDate=if ($BudgetType/Interval = SmartExpenses.ENUM_BudgetInterval.Week) then endOfWeek($Date) else if ($BudgetType/Interval = SmartExpenses.ENUM_BudgetInterval.Month) then endOfMonth($D...) create SmartExpenses.BudgetTerm as NewBudgetTerm (BudgetTerm_BudgetType=$BudgetType, Name=if ($BudgetType/Interval = SmartExpenses.ENUM_BudgetInterval.Week) then 'weekbudget' else if ($BudgetType/Interval = SmartExpenses.ENUM_BudgetInterval.Month) then formatDateTime($D..., BudgetAmount=$OldBudgetTerm/BudgetAmount, StartDate=if ($BudgetType/Interval = SmartExpenses.ENUM_BudgetInterval.Week) then beginOfWeek($Date) else if ($BudgetType/Interval = SmartExpenses.ENUM_BudgetInterval.Month) then beginOfMont..., EndDate=if ($BudgetType/Interval = SmartExpenses.ENUM_BudgetInterval.Week) then endOfWeek($Date) else if ($BudgetType/Interval = SmartExpenses.ENUM_BudgetInterval.Month) then endOfMonth($D...)
- Flow to create BudgetTerm based on the BudgetType, if not exsisting for the given date

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by SmartExpenses.ACR_FBGProfile_setStandardBudgets, SmartExpenses.ACT_BudgetTerm_New.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- SmartExpenses.BudgetTerm

## Called / Called By

- Calls: none
- Called by: SmartExpenses.ACR_FBGProfile_setStandardBudgets, SmartExpenses.ACT_BudgetTerm_New

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=b4544f6a-f43a-4fcc-baaf-be4465befed6; sourceKind=Database; entity=SmartExpenses.BudgetTerm; summary=retrieve BudgetTermList from SmartExpenses.BudgetTerm
- nodeId=8320ccf4-5815-4f64-9ef8-2470e227ad18; sourceKind=Database; entity=SmartExpenses.BudgetTerm; summary=retrieve OldBudgetTerm from SmartExpenses.BudgetTerm
- nodeId=f760cbf4-3b4a-45de-b6a8-92a17cec7888; caption=Is Term empty?; expression=$BudgetTermList = empty Is Term empty? expression=$BudgetTermList = empty
- nodeId=94e61a3d-7e6e-44bb-bab7-48ac0773c43c; actionKind=Create; entity=SmartExpenses.BudgetTerm; members=BudgetTerm_BudgetType=$BudgetType, Name=if ($BudgetType/Interval = SmartExpenses.ENUM_BudgetInterval.Week; summary=CreateObjectAction: create SmartExpenses.BudgetTerm as NewBudgetTerm (BudgetTerm_BudgetType=$BudgetType, Name=if ($BudgetType/Interval = SmartExpenses.ENUM_BudgetInterval.Week) then 'weekbudget' else if ($BudgetType/Interval = SmartExpenses.ENUM_BudgetInterval.Month) then formatDateTime($D..., BudgetAmount=$OldBudgetTerm/BudgetAmount, StartDate=if ($BudgetType/Interval = SmartExpenses.ENUM_BudgetInterval.Week) then beginOfWeek($Date) else if ($BudgetType/Interval = SmartExpenses.ENUM_BudgetInterval.Month) then beginOfMont..., EndDate=if ($BudgetType/Interval = SmartExpenses.ENUM_BudgetInterval.Week) then endOfWeek($Date) else if ($BudgetType/Interval = SmartExpenses.ENUM_BudgetInterval.Month) then endOfMonth($D...) create SmartExpenses.BudgetTerm as NewBudgetTerm (BudgetTerm_BudgetType=$BudgetType, Name=if ($BudgetType/Interval = SmartExpenses.ENUM_BudgetInterval.Week) then 'weekbudget' else if ($BudgetType/Interval = SmartExpenses.ENUM_BudgetInterval.Month) then formatDateTime($D..., BudgetAmount=$OldBudgetTerm/BudgetAmount, StartDate=if ($BudgetType/Interval = SmartExpenses.ENUM_BudgetInterval.Week) then beginOfWeek($Date) else if ($BudgetType/Interval = SmartExpenses.ENUM_BudgetInterval.Month) then beginOfMont..., EndDate=if ($BudgetType/Interval = SmartExpenses.ENUM_BudgetInterval.Week) then endOfWeek($Date) else if ($BudgetType/Interval = SmartExpenses.ENUM_BudgetInterval.Month) then endOfMonth($D...)
- nodeId=4f29cf6f-8e7d-41a9-93c4-80baf70a50cc; actionKind=Create; summary=Flow to create BudgetTerm based on the BudgetType, if not exsisting for the given date

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-ds-budgetterm-new.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
