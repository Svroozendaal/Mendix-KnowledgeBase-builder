---
objectType: flow
module: SmartExpenses
qualifiedName: SmartExpenses.ACT_BudgetType_New
stableId: cdbb3b80-2f1a-41d7-84bb-e774b818a4d0
slug: smartexpenses-act-budgettype-new
layer: L1
l0: smartexpenses-act-budgettype-new.abstract.md
l2Path: ../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-budgettype-new.json
l2Logical: flow:SmartExpenses.ACT_BudgetType_New
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: SmartExpenses.ACT_BudgetType_New

## Summary

- Likely acts as a UI entry or navigation handler because it shows SmartExpenses.BudgetTerm_NewEdit.
- L0: [abstract](smartexpenses-act-budgettype-new.abstract.md)
- L2: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-budgettype-new.json)

## Main Steps

- ShowPageAction: show page SmartExpenses.BudgetTerm_NewEdit show page SmartExpenses.BudgetTerm_NewEdit
- CreateObjectAction: create SmartExpenses.BudgetTerm as NewBudgetTerm (BudgetTerm_BudgetType=$NewBudgetType, StartDate=[%BeginOfCurrentMonth%], EndDate=[%EndOfCurrentMonth%]) create SmartExpenses.BudgetTerm as NewBudgetTerm (BudgetTerm_BudgetType=$NewBudgetType, StartDate=[%BeginOfCurrentMonth%], EndDate=[%EndOfCurrentMonth%])
- CreateObjectAction: create SmartExpenses.BudgetType as NewBudgetType (BudgetType_FBGProfile=$FBGProfile, Interval=SmartExpenses.ENUM_BudgetInterval.Month, Logo_BudgetType=$NewLogo) create SmartExpenses.BudgetType as NewBudgetType (BudgetType_FBGProfile=$FBGProfile, Interval=SmartExpenses.ENUM_BudgetInterval.Month, Logo_BudgetType=$NewLogo)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: Shows SmartExpenses.BudgetTerm_NewEdit.

## Key Entities Touched

- SmartExpenses.BudgetTerm, SmartExpenses.BudgetType, SmartExpenses.Logo

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- SmartExpenses.BudgetTerm_NewEdit

## Important Retrieves/Decisions/Mutations

- nodeId=aac2221e-706b-4cce-a666-78e11f1cf3a2; actionKind=Create; entity=SmartExpenses.BudgetTerm; members=BudgetTerm_BudgetType=$NewBudgetType, StartDate=[%BeginOfCurrentMonth%], EndDate=[%EndOfCurrentMonth%]; summary=CreateObjectAction: create SmartExpenses.BudgetTerm as NewBudgetTerm (BudgetTerm_BudgetType=$NewBudgetType, StartDate=[%BeginOfCurrentMonth%], EndDate=[%EndOfCurrentMonth%]) create SmartExpenses.BudgetTerm as NewBudgetTerm (BudgetTerm_BudgetType=$NewBudgetType, StartDate=[%BeginOfCurrentMonth%], EndDate=[%EndOfCurrentMonth%])
- nodeId=daabc6b0-d687-49f0-a149-df86e0f34376; actionKind=Create; entity=SmartExpenses.BudgetType; members=BudgetType_FBGProfile=$FBGProfile, Interval=SmartExpenses.ENUM_BudgetInterval.Month, Logo_BudgetType=$NewLogo; summary=CreateObjectAction: create SmartExpenses.BudgetType as NewBudgetType (BudgetType_FBGProfile=$FBGProfile, Interval=SmartExpenses.ENUM_BudgetInterval.Month, Logo_BudgetType=$NewLogo) create SmartExpenses.BudgetType as NewBudgetType (BudgetType_FBGProfile=$FBGProfile, Interval=SmartExpenses.ENUM_BudgetInterval.Month, Logo_BudgetType=$NewLogo)
- nodeId=0b58ea80-c51d-459b-95bc-e87b56d876f7; actionKind=Create; entity=SmartExpenses.Logo; summary=CreateObjectAction: create SmartExpenses.Logo as NewLogo create SmartExpenses.Logo as NewLogo

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-budgettype-new.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
