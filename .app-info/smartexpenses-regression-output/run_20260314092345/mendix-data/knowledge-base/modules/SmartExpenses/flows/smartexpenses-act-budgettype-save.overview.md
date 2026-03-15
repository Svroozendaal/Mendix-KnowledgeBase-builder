---
objectType: flow
module: SmartExpenses
qualifiedName: SmartExpenses.ACT_BudgetType_Save
stableId: 621eb618-3710-4675-aa8e-e10a7cfdb1e6
slug: smartexpenses-act-budgettype-save
layer: L1
l0: smartexpenses-act-budgettype-save.abstract.md
l2Path: ../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-budgettype-save.json
l2Logical: flow:SmartExpenses.ACT_BudgetType_Save
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: SmartExpenses.ACT_BudgetType_Save

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](smartexpenses-act-budgettype-save.abstract.md)
- L2: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-budgettype-save.json)

## Main Steps

- $IsValid IsValid? expression=$IsValid
- ChangeObjectAction: change BudgetTerm (Name=if ($BudgetType/Interval = SmartExpenses.ENUM_BudgetInterval.Week) then 'weekbudget' else if ($BudgetType/Interval = SmartExpenses.ENUM_BudgetInterval.Month) then formatDateTime($B...; refreshInClient=false) change BudgetTerm (Name=if ($BudgetType/Interval = SmartExpenses.ENUM_BudgetInterval.Week) then 'weekbudget' else if ($BudgetType/Interval = SmartExpenses.ENUM_BudgetInterval.Month) then formatDateTime($B...; refreshInClient=false)
- CommitAction: commit BudgetTerm (refreshInClient=true, withEvents=true) commit BudgetTerm (refreshInClient=true, withEvents=true)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: SmartExpenses.VAL_BudgetTypeTerm_New
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=8b4e3dec-a2f2-4099-bb79-512063581127; caption=IsValid?; expression=$IsValid IsValid? expression=$IsValid
- nodeId=1083357c-52f7-4f83-9b17-a2007009f261; actionKind=Change; entity=SmartExpenses.ENUM_BudgetInterval; members=Name=if ($BudgetType/Interval = SmartExpenses.ENUM_BudgetInterval.Week; summary=ChangeObjectAction: change BudgetTerm (Name=if ($BudgetType/Interval = SmartExpenses.ENUM_BudgetInterval.Week) then 'weekbudget' else if ($BudgetType/Interval = SmartExpenses.ENUM_BudgetInterval.Month) then formatDateTime($B...; refreshInClient=false) change BudgetTerm (Name=if ($BudgetType/Interval = SmartExpenses.ENUM_BudgetInterval.Week) then 'weekbudget' else if ($BudgetType/Interval = SmartExpenses.ENUM_BudgetInterval.Month) then formatDateTime($B...; refreshInClient=false)
- nodeId=52282e29-e4ed-4678-9bd4-ad7ea9894181; actionKind=Commit; members=refreshInClient=true, withEvents=true; summary=CommitAction: commit BudgetTerm (refreshInClient=true, withEvents=true) commit BudgetTerm (refreshInClient=true, withEvents=true)
- nodeId=ea8192ac-43e2-44d5-822a-8d417a36c962; actionKind=Commit; members=refreshInClient=true, withEvents=true; summary=CommitAction: commit BudgetType (refreshInClient=true, withEvents=true) commit BudgetType (refreshInClient=true, withEvents=true)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-budgettype-save.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
