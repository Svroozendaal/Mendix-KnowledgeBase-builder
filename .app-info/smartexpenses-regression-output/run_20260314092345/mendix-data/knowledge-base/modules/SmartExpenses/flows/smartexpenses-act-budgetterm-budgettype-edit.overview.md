---
objectType: flow
module: SmartExpenses
qualifiedName: SmartExpenses.ACT_BudgetTerm_BudgetType_Edit
stableId: 9f1ed935-2a42-4f4d-b600-a4b12d7c3fb0
slug: smartexpenses-act-budgetterm-budgettype-edit
layer: L1
l0: smartexpenses-act-budgetterm-budgettype-edit.abstract.md
l2Path: ../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-budgetterm-budgettype-edit.json
l2Logical: flow:SmartExpenses.ACT_BudgetTerm_BudgetType_Edit
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: SmartExpenses.ACT_BudgetTerm_BudgetType_Edit

## Summary

- Likely acts as a UI entry or navigation handler because it shows SmartExpenses.BudgetTerm_NewEdit.
- L0: [abstract](smartexpenses-act-budgetterm-budgettype-edit.abstract.md)
- L2: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-budgetterm-budgettype-edit.json)

## Main Steps

- retrieve BudgetType over association BudgetTerm_BudgetType from BudgetTerm
- $BudgetType != empty BudgetType exists? expression=$BudgetType != empty
- $BudgetType/SmartExpenses.Logo_BudgetType/SmartExpenses.Logo != empty logo object excist? expression=$BudgetType/SmartExpenses.Logo_BudgetType/SmartExpenses.Logo != empty
- ShowPageAction: show page SmartExpenses.BudgetTerm_NewEdit show page SmartExpenses.BudgetTerm_NewEdit
- ChangeObjectAction: change BudgetType (Logo_BudgetType=$NewLogo; refreshInClient=false) change BudgetType (Logo_BudgetType=$NewLogo; refreshInClient=false)
- CreateObjectAction: create SmartExpenses.Logo as NewLogo create SmartExpenses.Logo as NewLogo

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: Shows SmartExpenses.BudgetTerm_NewEdit.

## Key Entities Touched

- SmartExpenses.Logo

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- SmartExpenses.BudgetTerm_NewEdit

## Important Retrieves/Decisions/Mutations

- nodeId=3fef9ee6-1603-4a67-9bdb-27d62bce58d4; sourceKind=Association; association=BudgetTerm_BudgetType; summary=retrieve BudgetType over association BudgetTerm_BudgetType from BudgetTerm
- nodeId=0eb8b835-ce4a-4124-be51-d99956fda575; caption=BudgetType exists?; expression=$BudgetType != empty BudgetType exists? expression=$BudgetType != empty
- nodeId=c8f80b11-8a10-42d8-bb18-c74ddd4fab81; caption=logo object excist?; expression=$BudgetType/SmartExpenses.Logo_BudgetType/SmartExpenses.Logo != empty logo object excist? expression=$BudgetType/SmartExpenses.Logo_BudgetType/SmartExpenses.Logo != empty
- nodeId=e9e2d682-ff1a-444c-bd0e-c64e56872b52; actionKind=Change; members=Logo_BudgetType=$NewLogo; refreshInClient=false; summary=ChangeObjectAction: change BudgetType (Logo_BudgetType=$NewLogo; refreshInClient=false) change BudgetType (Logo_BudgetType=$NewLogo; refreshInClient=false)
- nodeId=a47ee51c-422a-407c-9268-153a4e5bae6e; actionKind=Create; entity=SmartExpenses.Logo; summary=CreateObjectAction: create SmartExpenses.Logo as NewLogo create SmartExpenses.Logo as NewLogo

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-budgetterm-budgettype-edit.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
