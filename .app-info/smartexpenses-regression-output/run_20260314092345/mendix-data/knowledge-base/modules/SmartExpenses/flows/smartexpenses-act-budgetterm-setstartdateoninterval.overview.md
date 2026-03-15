---
objectType: flow
module: SmartExpenses
qualifiedName: SmartExpenses.ACT_BudgetTerm_setStartdateOnInterval
stableId: ac64fb2e-18bf-4d31-aada-cbbbc9ca0f25
slug: smartexpenses-act-budgetterm-setstartdateoninterval
layer: L1
l0: smartexpenses-act-budgetterm-setstartdateoninterval.abstract.md
l2Path: ../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-budgetterm-setstartdateoninterval.json
l2Logical: flow:SmartExpenses.ACT_BudgetTerm_setStartdateOnInterval
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: SmartExpenses.ACT_BudgetTerm_setStartdateOnInterval

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](smartexpenses-act-budgetterm-setstartdateoninterval.abstract.md)
- L2: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-budgetterm-setstartdateoninterval.json)

## Main Steps

- ChangeObjectAction: change BudgetTerm (EndDate=if ($BudgetType/Interval = SmartExpenses.ENUM_BudgetInterval.Week) then [%EndOfCurrentWeek%] else if ($BudgetType/Interval = SmartExpenses.ENUM_BudgetInterval.Month) then [%EndOfCu...; refreshInClient=true) change BudgetTerm (EndDate=if ($BudgetType/Interval = SmartExpenses.ENUM_BudgetInterval.Week) then [%EndOfCurrentWeek%] else if ($BudgetType/Interval = SmartExpenses.ENUM_BudgetInterval.Month) then [%EndOfCu...; refreshInClient=true)
- ChangeObjectAction: change BudgetTerm (StartDate=if ($BudgetType/Interval = SmartExpenses.ENUM_BudgetInterval.Week) then [%BeginOfCurrentWeek%] else if ($BudgetType/Interval = SmartExpenses.ENUM_BudgetInterval.Month) then [%Begin...; refreshInClient=false) change BudgetTerm (StartDate=if ($BudgetType/Interval = SmartExpenses.ENUM_BudgetInterval.Week) then [%BeginOfCurrentWeek%] else if ($BudgetType/Interval = SmartExpenses.ENUM_BudgetInterval.Month) then [%Begin...; refreshInClient=false)

## Trigger/Input/Output Context

- Kind: Nanoflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=e42bcab0-97a8-4151-925b-9f40d48f15e2; actionKind=Change; entity=SmartExpenses.ENUM_BudgetInterval; members=EndDate=if ($BudgetType/Interval = SmartExpenses.ENUM_BudgetInterval.Week; summary=ChangeObjectAction: change BudgetTerm (EndDate=if ($BudgetType/Interval = SmartExpenses.ENUM_BudgetInterval.Week) then [%EndOfCurrentWeek%] else if ($BudgetType/Interval = SmartExpenses.ENUM_BudgetInterval.Month) then [%EndOfCu...; refreshInClient=true) change BudgetTerm (EndDate=if ($BudgetType/Interval = SmartExpenses.ENUM_BudgetInterval.Week) then [%EndOfCurrentWeek%] else if ($BudgetType/Interval = SmartExpenses.ENUM_BudgetInterval.Month) then [%EndOfCu...; refreshInClient=true)
- nodeId=caf63012-7721-4635-817f-ff58de112a1e; actionKind=Change; entity=SmartExpenses.ENUM_BudgetInterval; members=StartDate=if ($BudgetType/Interval = SmartExpenses.ENUM_BudgetInterval.Week; summary=ChangeObjectAction: change BudgetTerm (StartDate=if ($BudgetType/Interval = SmartExpenses.ENUM_BudgetInterval.Week) then [%BeginOfCurrentWeek%] else if ($BudgetType/Interval = SmartExpenses.ENUM_BudgetInterval.Month) then [%Begin...; refreshInClient=false) change BudgetTerm (StartDate=if ($BudgetType/Interval = SmartExpenses.ENUM_BudgetInterval.Week) then [%BeginOfCurrentWeek%] else if ($BudgetType/Interval = SmartExpenses.ENUM_BudgetInterval.Month) then [%Begin...; refreshInClient=false)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-budgetterm-setstartdateoninterval.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
