---
objectType: flow
module: SmartExpenses
qualifiedName: SmartExpenses.SUB_Transaction_CalculateBalance
stableId: 01df8be1-53ff-4958-8f8d-628f4f0848f4
slug: smartexpenses-sub-transaction-calculatebalance
layer: L1
l0: smartexpenses-sub-transaction-calculatebalance.abstract.md
l2Path: ../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-sub-transaction-calculatebalance.json
l2Logical: flow:SmartExpenses.SUB_Transaction_CalculateBalance
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: SmartExpenses.SUB_Transaction_CalculateBalance

## Summary

- Likely orchestrates downstream flow calls without direct UI output.
- L0: [abstract](smartexpenses-sub-transaction-calculatebalance.abstract.md)
- L2: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-sub-transaction-calculatebalance.json)

## Main Steps

- retrieve Balance over association Transaction_Balance from Transaction
- $Balance != empty Balance exists? expression=$Balance != empty

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by SmartExpenses.BCO_Transaction, SmartExpenses.BD_Transaction.
- Output/UI context: No page output was exported; this likely delegates work to downstream flows.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: SmartExpenses.SUB_Balance_Recalculate
- Called by: SmartExpenses.BCO_Transaction, SmartExpenses.BD_Transaction

## Shown Pages

- No ShowPageAction was exported for this flow; it may serve validation, background processing, or delegate work to other flows.

## Important Retrieves/Decisions/Mutations

- nodeId=1535863c-40cb-4c53-bab4-9932be2566f8; sourceKind=Association; association=Transaction_Balance; summary=retrieve Balance over association Transaction_Balance from Transaction
- nodeId=07343a48-9815-46e1-893c-33c79b695974; caption=Balance exists?; expression=$Balance != empty Balance exists? expression=$Balance != empty

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-sub-transaction-calculatebalance.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
