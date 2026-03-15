---
objectType: flow
module: SmartExpenses
qualifiedName: SmartExpenses.DS_BudgetTerm_Retrieve_current
stableId: 6838d14d-700e-4fc5-a9ea-3c6f59303ad5
slug: smartexpenses-ds-budgetterm-retrieve-current
layer: L1
l0: smartexpenses-ds-budgetterm-retrieve-current.abstract.md
l2Path: ../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-ds-budgetterm-retrieve-current.json
l2Logical: flow:SmartExpenses.DS_BudgetTerm_Retrieve_current
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: SmartExpenses.DS_BudgetTerm_Retrieve_current

## Summary

- Likely supplies data to callers or pages rather than driving user navigation directly.
- L0: [abstract](smartexpenses-ds-budgetterm-retrieve-current.abstract.md)
- L2: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-ds-budgetterm-retrieve-current.json)

## Main Steps

- retrieve BudgetTerm from SmartExpenses.BudgetTerm

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; check L2 JSON if the exact user-facing effect matters.

## Key Entities Touched

- SmartExpenses.BudgetTerm

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it may serve validation, background processing, or delegate work to other flows.

## Important Retrieves/Decisions/Mutations

- nodeId=e4d5a5a0-a19f-4465-813c-aea56c205a86; sourceKind=Database; entity=SmartExpenses.BudgetTerm; summary=retrieve BudgetTerm from SmartExpenses.BudgetTerm

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-ds-budgetterm-retrieve-current.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
