---
objectType: flow
module: SmartExpenses
qualifiedName: SmartExpenses.ACR_FBGProfile_setStandardBudgets
stableId: 8283736d-2bf5-4623-a06f-f2491eef9e93
slug: smartexpenses-acr-fbgprofile-setstandardbudgets
layer: L1
l0: smartexpenses-acr-fbgprofile-setstandardbudgets.abstract.md
l2Path: ../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-acr-fbgprofile-setstandardbudgets.json
l2Logical: flow:SmartExpenses.ACR_FBGProfile_setStandardBudgets
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: SmartExpenses.ACR_FBGProfile_setStandardBudgets

## Summary

- Likely acts as a save, process, or background step for SmartExpenses.BudgetTerm, SmartExpenses.BudgetType, SmartExpenses.StandardBudget because it mutates data without showing a page.
- L0: [abstract](smartexpenses-acr-fbgprofile-setstandardbudgets.abstract.md)
- L2: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-acr-fbgprofile-setstandardbudgets.json)

## Main Steps

- retrieve CurrentBudgetTypeList over association BudgetType_FBGProfile from FBGProfile
- retrieve StandardBudgetsList from SmartExpenses.StandardBudget
- ChangeListAction: change BudgetTermList (type=Add, value=$BudgetTerm) change BudgetTermList (type=Add, value=$BudgetTerm)
- ChangeListAction: change CurrentBudgetTypeList (type=Add, value=$NewBudgetType) change CurrentBudgetTypeList (type=Add, value=$NewBudgetType)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- SmartExpenses.BudgetTerm, SmartExpenses.BudgetType, SmartExpenses.StandardBudget

## Called / Called By

- Calls: SmartExpenses.DS_BudgetTerm_New
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=58497883-b335-45b1-ae89-21885b56fe6a; sourceKind=Association; association=BudgetType_FBGProfile; summary=retrieve CurrentBudgetTypeList over association BudgetType_FBGProfile from FBGProfile
- nodeId=a788a580-eaea-4dfc-9792-70ff7cca81d5; sourceKind=Database; entity=SmartExpenses.StandardBudget; summary=retrieve StandardBudgetsList from SmartExpenses.StandardBudget
- nodeId=5fc20d22-94cb-4569-8210-0b5df4a8d188; actionKind=Change; members=type=Add, value=$BudgetTerm; summary=ChangeListAction: change BudgetTermList (type=Add, value=$BudgetTerm) change BudgetTermList (type=Add, value=$BudgetTerm)
- nodeId=53f008b6-a88b-4849-a030-9293d3d2ddae; actionKind=Change; members=type=Add, value=$NewBudgetType; summary=ChangeListAction: change CurrentBudgetTypeList (type=Add, value=$NewBudgetType) change CurrentBudgetTypeList (type=Add, value=$NewBudgetType)
- nodeId=35463e86-a67f-4674-9815-26a4f4f01e5b; actionKind=Commit; members=refreshInClient=true, withEvents=true; summary=CommitAction: commit BudgetTermList (refreshInClient=true, withEvents=true) commit BudgetTermList (refreshInClient=true, withEvents=true)
- nodeId=8e52fba2-01ce-4c30-9558-4cafecd2f448; actionKind=Commit; members=refreshInClient=true, withEvents=true; summary=CommitAction: commit CurrentBudgetTypeList (refreshInClient=true, withEvents=true) commit CurrentBudgetTypeList (refreshInClient=true, withEvents=true)
- nodeId=51805881-3793-48f6-82c9-bbd7adfdac5a; actionKind=Create; entity=SmartExpenses.BudgetType; members=Name=$IteratorStandardBudgets/Name, Description=$IteratorStandardBudgets/Description, Interval=$IteratorStandardBudgets/Interval, BudgetType_FBGProfile=$FBGProfile, Logo_BudgetType=$IteratorStandardBudgets/SmartExpenses.Logo_StandardBudget; summary=CreateObjectAction: create SmartExpenses.BudgetType as NewBudgetType (Name=$IteratorStandardBudgets/Name, Description=$IteratorStandardBudgets/Description, Interval=$IteratorStandardBudgets/Interval, BudgetType_FBGProfile=$FBGProfile, Logo_BudgetType=$IteratorStandardBudgets/SmartExpenses.Logo_StandardBudget) create SmartExpenses.BudgetType as NewBudgetType (Name=$IteratorStandardBudgets/Name, Description=$IteratorStandardBudgets/Description, Interval=$IteratorStandardBudgets/Interval, BudgetType_FBGProfile=$FBGProfile, Logo_BudgetType=$IteratorStandardBudgets/SmartExpenses.Logo_StandardBudget)
- nodeId=e31b9bba-5d65-4194-aed8-ac22db8be1db; actionKind=Create; summary=Create new BudgetTypes to new FBGProfile accounts, based on the StandaardBudgets created by the admin,

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-acr-fbgprofile-setstandardbudgets.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
