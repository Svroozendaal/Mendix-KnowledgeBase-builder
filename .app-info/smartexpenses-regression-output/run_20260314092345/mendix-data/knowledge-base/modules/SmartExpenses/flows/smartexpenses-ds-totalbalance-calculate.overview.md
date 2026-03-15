---
objectType: flow
module: SmartExpenses
qualifiedName: SmartExpenses.DS_TotalBalance_Calculate
stableId: 6f12428b-8afd-49e9-a855-cee6ba15f805
slug: smartexpenses-ds-totalbalance-calculate
layer: L1
l0: smartexpenses-ds-totalbalance-calculate.abstract.md
l2Path: ../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-ds-totalbalance-calculate.json
l2Logical: flow:SmartExpenses.DS_TotalBalance_Calculate
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: SmartExpenses.DS_TotalBalance_Calculate

## Summary

- Likely supplies data to callers or pages rather than driving user navigation directly.
- L0: [abstract](smartexpenses-ds-totalbalance-calculate.abstract.md)
- L2: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-ds-totalbalance-calculate.json)

## Main Steps

- retrieve BalanceList from SmartExpenses.Balance

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by SmartExpenses.ACT_Transaction_Recalculate_all.
- Output/UI context: No page output was exported; check L2 JSON if the exact user-facing effect matters.

## Key Entities Touched

- SmartExpenses.Balance

## Called / Called By

- Calls: none
- Called by: SmartExpenses.ACT_Transaction_Recalculate_all

## Shown Pages

- No ShowPageAction was exported for this flow; it may serve validation, background processing, or delegate work to other flows.

## Important Retrieves/Decisions/Mutations

- nodeId=b181957b-d9e6-43d9-9ac4-344894efcd91; sourceKind=Database; entity=SmartExpenses.Balance; summary=retrieve BalanceList from SmartExpenses.Balance

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-ds-totalbalance-calculate.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
