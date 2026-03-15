---
objectType: flow
module: Support
qualifiedName: Support.SUB_HandleOrder
stableId: Support.SUB_HandleOrder
slug: support-sub-handleorder
layer: L1
l0: support-sub-handleorder.abstract.md
l2Path: ../../../../../../../../tests/reference/app-overview/current/modules/Support/flows/support-sub-handleorder.json
l2Logical: flow:Support.SUB_HandleOrder
sourceRun: cli_reference_minimal
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Support.SUB_HandleOrder

## Summary

- Deterministic overview derived from exported flow structure.
- L0: [abstract](support-sub-handleorder.abstract.md)
- L2: [json](../../../../../../../../tests/reference/app-overview/current/modules/Support/flows/support-sub-handleorder.json)

## Main Steps

- ChangeObjectAction change object Support.Ticket
- CommitAction commit Support.Ticket

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: called by Sales.ACT_Order_Create
- Output/UI context: shown pages none

## Key Entities Touched

- Support.Ticket

## Called / Called By

- Calls: none
- Called by: Sales.ACT_Order_Create

## Shown Pages

- none

## Important Retrieves/Decisions/Mutations

- none
- none
- nodeId=; actionKind=Change; entity=Support.Ticket; summary=ChangeObjectAction change object Support.Ticket
- nodeId=; actionKind=Commit; entity=Support.Ticket; summary=CommitAction commit Support.Ticket

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../../../../tests/reference/app-overview/current/modules/Support/flows/support-sub-handleorder.json)
- Aggregate export: [flows.json](../../../../../../../../tests/reference/app-overview/cli_reference_minimal/modules/Support/flows.json)
- Aggregate pseudo: none
- Traceability: sourceRun=cli_reference_minimal
