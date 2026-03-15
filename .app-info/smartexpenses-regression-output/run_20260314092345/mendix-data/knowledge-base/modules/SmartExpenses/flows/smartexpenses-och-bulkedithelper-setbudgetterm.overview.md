---
objectType: flow
module: SmartExpenses
qualifiedName: SmartExpenses.OCH_BulkEditHelper_setBudgetTerm
stableId: 2953c3a8-6441-4fff-a89b-97d4bdbcb935
slug: smartexpenses-och-bulkedithelper-setbudgetterm
layer: L1
l0: smartexpenses-och-bulkedithelper-setbudgetterm.abstract.md
l2Path: ../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-och-bulkedithelper-setbudgetterm.json
l2Logical: flow:SmartExpenses.OCH_BulkEditHelper_setBudgetTerm
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: SmartExpenses.OCH_BulkEditHelper_setBudgetTerm

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](smartexpenses-och-bulkedithelper-setbudgetterm.abstract.md)
- L2: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-och-bulkedithelper-setbudgetterm.json)

## Main Steps

- ChangeObjectAction: change BulkEditHelper (BulkEditHelper_BudgetTerm=$BudgetTerm; refreshInClient=true) change BulkEditHelper (BulkEditHelper_BudgetTerm=$BudgetTerm; refreshInClient=true)

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

- nodeId=197b5b2a-2983-44d9-a6a1-b237a9c8c7b0; actionKind=Change; members=BulkEditHelper_BudgetTerm=$BudgetTerm; refreshInClient=true; summary=ChangeObjectAction: change BulkEditHelper (BulkEditHelper_BudgetTerm=$BudgetTerm; refreshInClient=true) change BulkEditHelper (BulkEditHelper_BudgetTerm=$BudgetTerm; refreshInClient=true)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-och-bulkedithelper-setbudgetterm.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
