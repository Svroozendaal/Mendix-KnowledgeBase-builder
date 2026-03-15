---
objectType: flow
module: SmartExpenses
qualifiedName: SmartExpenses.ACT_BudgetTerm_New
stableId: b632c2ed-6801-42ea-aadd-c55ae7b8f570
slug: smartexpenses-act-budgetterm-new
layer: L1
l0: smartexpenses-act-budgetterm-new.abstract.md
l2Path: ../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-budgetterm-new.json
l2Logical: flow:SmartExpenses.ACT_BudgetTerm_New
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: SmartExpenses.ACT_BudgetTerm_New

## Summary

- Likely acts as a save, process, or background step for SmartExpenses.BudgetTerm because it mutates data without showing a page.
- L0: [abstract](smartexpenses-act-budgetterm-new.abstract.md)
- L2: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-budgetterm-new.json)

## Main Steps

- retrieve BudgetTypeList over association BudgetType_FBGProfile from FBGProfile
- ChangeListAction: change BudgetTermList (type=Add, value=$BudgetTerm) change BudgetTermList (type=Add, value=$BudgetTerm)
- CommitAction: commit BudgetTermList (refreshInClient=true, withEvents=true) commit BudgetTermList (refreshInClient=true, withEvents=true)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- SmartExpenses.BudgetTerm

## Called / Called By

- Calls: SmartExpenses.DS_BudgetTerm_New
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=50d1fa35-0ec6-4992-8f13-8aac89d68df0; sourceKind=Association; association=BudgetType_FBGProfile; summary=retrieve BudgetTypeList over association BudgetType_FBGProfile from FBGProfile
- nodeId=4269a8f0-075d-468b-a826-39eb81b49960; actionKind=Change; members=type=Add, value=$BudgetTerm; summary=ChangeListAction: change BudgetTermList (type=Add, value=$BudgetTerm) change BudgetTermList (type=Add, value=$BudgetTerm)
- nodeId=77da3e95-48c2-4697-99fe-40f4a57e57d4; actionKind=Commit; members=refreshInClient=true, withEvents=true; summary=CommitAction: commit BudgetTermList (refreshInClient=true, withEvents=true) commit BudgetTermList (refreshInClient=true, withEvents=true)
- nodeId=458e7675-e71a-4d29-bb81-bf4322674321; actionKind=Commit; members=refreshInClient=true, withEvents=true; summary=CommitAction: commit BudgetTypeList (refreshInClient=true, withEvents=true) commit BudgetTypeList (refreshInClient=true, withEvents=true)

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-budgetterm-new.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
