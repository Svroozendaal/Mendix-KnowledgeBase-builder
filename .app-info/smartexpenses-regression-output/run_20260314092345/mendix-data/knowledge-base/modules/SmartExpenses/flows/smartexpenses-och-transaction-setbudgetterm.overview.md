---
objectType: flow
module: SmartExpenses
qualifiedName: SmartExpenses.OCH_Transaction_setBudgetTerm
stableId: 87fc4034-c50d-4098-a82e-344730237d15
slug: smartexpenses-och-transaction-setbudgetterm
layer: L1
l0: smartexpenses-och-transaction-setbudgetterm.abstract.md
l2Path: ../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-och-transaction-setbudgetterm.json
l2Logical: flow:SmartExpenses.OCH_Transaction_setBudgetTerm
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: SmartExpenses.OCH_Transaction_setBudgetTerm

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](smartexpenses-och-transaction-setbudgetterm.abstract.md)
- L2: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-och-transaction-setbudgetterm.json)

## Main Steps

- ChangeObjectAction: change Transaction (Transaction_BudgetTerm=$BudgetTerm; refreshInClient=true) change Transaction (Transaction_BudgetTerm=$BudgetTerm; refreshInClient=true)

## Trigger/Input/Output Context

- Kind: Nanoflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=c15b31e4-ffe5-4834-b909-db223cb02edd; actionKind=Change; members=Transaction_BudgetTerm=$BudgetTerm; refreshInClient=true; summary=ChangeObjectAction: change Transaction (Transaction_BudgetTerm=$BudgetTerm; refreshInClient=true) change Transaction (Transaction_BudgetTerm=$BudgetTerm; refreshInClient=true)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-och-transaction-setbudgetterm.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
