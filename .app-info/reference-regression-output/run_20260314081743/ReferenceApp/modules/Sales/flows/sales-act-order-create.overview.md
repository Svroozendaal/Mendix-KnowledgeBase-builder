---
objectType: flow
module: Sales
qualifiedName: Sales.ACT_Order_Create
stableId: Sales.ACT_Order_Create
slug: sales-act-order-create
layer: L1
l0: sales-act-order-create.abstract.md
l2Path: ../../../../../../../tests/reference/app-overview/current/modules/Sales/flows/sales-act-order-create.json
l2Logical: flow:Sales.ACT_Order_Create
sourceRun: cli_reference_minimal
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Sales.ACT_Order_Create

## Summary

- Action-oriented flow.
- L0: [abstract](sales-act-order-create.abstract.md)
- L2: [json](../../../../../../../tests/reference/app-overview/current/modules/Sales/flows/sales-act-order-create.json)

## Main Steps

- ShowPageAction show page Sales.Order_NewEdit
- CreateObjectAction create Sales.Order create Sales.Order
- CommitAction commit Sales.Order commit Sales.Order

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: called by none
- Output/UI context: shown pages Sales.Order_NewEdit

## Key Entities Touched

- Sales.Order

## Called / Called By

- Calls: Support.SUB_HandleOrder
- Called by: none

## Shown Pages

- Sales.Order_NewEdit

## Important Retrieves/Decisions/Mutations

- none
- none
- nodeId=; actionKind=Create; entity=Sales.Order; summary=CreateObjectAction create Sales.Order create Sales.Order
- nodeId=; actionKind=Commit; entity=Sales.Order; summary=CommitAction commit Sales.Order commit Sales.Order

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../../../tests/reference/app-overview/current/modules/Sales/flows/sales-act-order-create.json)
- Aggregate export: [flows.json](../../../../../../../tests/reference/app-overview/cli_reference_minimal/modules/Sales/flows.json)
- Aggregate pseudo: none
- Traceability: sourceRun=cli_reference_minimal
