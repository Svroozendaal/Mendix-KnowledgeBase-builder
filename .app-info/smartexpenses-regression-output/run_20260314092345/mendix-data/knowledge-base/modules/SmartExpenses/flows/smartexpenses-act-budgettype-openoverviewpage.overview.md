---
objectType: flow
module: SmartExpenses
qualifiedName: SmartExpenses.ACT_BudgetType_OpenOverviewPAge
stableId: 2471c18d-3ff9-4ed3-8105-0f339f12cdcf
slug: smartexpenses-act-budgettype-openoverviewpage
layer: L1
l0: smartexpenses-act-budgettype-openoverviewpage.abstract.md
l2Path: ../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-budgettype-openoverviewpage.json
l2Logical: flow:SmartExpenses.ACT_BudgetType_OpenOverviewPAge
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: SmartExpenses.ACT_BudgetType_OpenOverviewPAge

## Summary

- Likely acts as a UI entry or navigation handler because it shows SmartExpenses.BudgetType_Overview.
- L0: [abstract](smartexpenses-act-budgettype-openoverviewpage.abstract.md)
- L2: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-budgettype-openoverviewpage.json)

## Main Steps

- ShowPageAction: show page SmartExpenses.BudgetType_Overview show page SmartExpenses.BudgetType_Overview

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: Shows SmartExpenses.BudgetType_Overview.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: SmartExpenses.ACT_DateHelper_Create
- Called by: none

## Shown Pages

- SmartExpenses.BudgetType_Overview

## Important Retrieves/Decisions/Mutations

- No retrieve, decision, or mutation metadata was exported for this flow; inspect L2 JSON if node-level evidence matters.

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-budgettype-openoverviewpage.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
