---
objectType: flow
module: SmartExpenses
qualifiedName: SmartExpenses.OCH_Transaction_setBudgetTerm_och_BudgetType
stableId: 99c39dc3-904a-44cf-ab56-85d1043625a2
slug: smartexpenses-och-transaction-setbudgetterm-och-budgettype
layer: L1
l0: smartexpenses-och-transaction-setbudgetterm-och-budgettype.abstract.md
l2Path: ../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-och-transaction-setbudgetterm-och-budgettype.json
l2Logical: flow:SmartExpenses.OCH_Transaction_setBudgetTerm_och_BudgetType
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: SmartExpenses.OCH_Transaction_setBudgetTerm_och_BudgetType

## Summary

- Likely acts as a save, process, or background step for SmartExpenses.BudgetTerm because it mutates data without showing a page.
- L0: [abstract](smartexpenses-och-transaction-setbudgetterm-och-budgettype.abstract.md)
- L2: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-och-transaction-setbudgetterm-och-budgettype.json)

## Main Steps

- retrieve BudgetTerm from SmartExpenses.BudgetTerm
- ChangeObjectAction: change Transaction (Transaction_BudgetTerm=$BudgetTerm; refreshInClient=true) change Transaction (Transaction_BudgetTerm=$BudgetTerm; refreshInClient=true)

## Trigger/Input/Output Context

- Kind: Nanoflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- SmartExpenses.BudgetTerm

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=03c20d86-e44e-4b7f-819b-f8b7fb35796a; sourceKind=Database; entity=SmartExpenses.BudgetTerm; summary=retrieve BudgetTerm from SmartExpenses.BudgetTerm
- nodeId=1457580e-236c-44cf-b262-3d01542e47f8; actionKind=Change; members=Transaction_BudgetTerm=$BudgetTerm; refreshInClient=true; summary=ChangeObjectAction: change Transaction (Transaction_BudgetTerm=$BudgetTerm; refreshInClient=true) change Transaction (Transaction_BudgetTerm=$BudgetTerm; refreshInClient=true)

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-och-transaction-setbudgetterm-och-budgettype.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
