---
objectType: flow
module: Sales
qualifiedName: Sales.VAL_Order_Check
stableId: Sales.VAL_Order_Check
slug: sales-val-order-check
layer: L1
l0: sales-val-order-check.abstract.md
l2Path: ../../../../../../../tests/reference/app-overview/current/modules/Sales/flows/sales-val-order-check.json
l2Logical: flow:Sales.VAL_Order_Check
sourceRun: cli_reference_minimal
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Sales.VAL_Order_Check

## Summary

- Validation-oriented flow.
- L0: [abstract](sales-val-order-check.abstract.md)
- L2: [json](../../../../../../../tests/reference/app-overview/current/modules/Sales/flows/sales-val-order-check.json)

## Main Steps

- retrieve object from Sales.Order

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: called by none
- Output/UI context: shown pages none

## Key Entities Touched

- Sales.Order

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- none

## Important Retrieves/Decisions/Mutations

- nodeId=; sourceKind=Database; entity=Sales.Order; summary=retrieve object from Sales.Order
- none
- none

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../../../tests/reference/app-overview/current/modules/Sales/flows/sales-val-order-check.json)
- Aggregate export: [flows.json](../../../../../../../tests/reference/app-overview/cli_reference_minimal/modules/Sales/flows.json)
- Aggregate pseudo: none
- Traceability: sourceRun=cli_reference_minimal
