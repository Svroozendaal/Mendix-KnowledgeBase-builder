---
objectType: flow
module: SmartExpenses
qualifiedName: SmartExpenses.SUB_Transaction_CalculateBudgetTerm
stableId: a223d983-c0b3-46d7-baa3-20177c37caec
slug: smartexpenses-sub-transaction-calculatebudgetterm
layer: L1
l0: smartexpenses-sub-transaction-calculatebudgetterm.abstract.md
l2Path: ../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-sub-transaction-calculatebudgetterm.json
l2Logical: flow:SmartExpenses.SUB_Transaction_CalculateBudgetTerm
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: SmartExpenses.SUB_Transaction_CalculateBudgetTerm

## Summary

- Likely orchestrates downstream flow calls without direct UI output.
- L0: [abstract](smartexpenses-sub-transaction-calculatebudgetterm.abstract.md)
- L2: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-sub-transaction-calculatebudgetterm.json)

## Main Steps

- retrieve BudgetTerm over association Transaction_BudgetTerm from Transaction
- $BudgetTerm != empty BudgetTerm exists? expression=$BudgetTerm != empty

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by SmartExpenses.BCO_Transaction, SmartExpenses.BD_Transaction.
- Output/UI context: No page output was exported; this likely delegates work to downstream flows.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: SmartExpenses.SUB_BudgetTerm_Recalculate
- Called by: SmartExpenses.BCO_Transaction, SmartExpenses.BD_Transaction

## Shown Pages

- No ShowPageAction was exported for this flow; it may serve validation, background processing, or delegate work to other flows.

## Important Retrieves/Decisions/Mutations

- nodeId=640705be-33c3-4b1b-a998-52040893afaf; sourceKind=Association; association=Transaction_BudgetTerm; summary=retrieve BudgetTerm over association Transaction_BudgetTerm from Transaction
- nodeId=8465b118-f4b8-462e-94ea-6dcae9af4649; caption=BudgetTerm exists?; expression=$BudgetTerm != empty BudgetTerm exists? expression=$BudgetTerm != empty

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-sub-transaction-calculatebudgetterm.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
