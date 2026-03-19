---
objectType: flow
module: Inspection
qualifiedName: Inspection.SUB_Accessory_Order
stableId: 066fa293-6d5e-44fa-8b35-ff9633fe29d8
slug: inspection-sub-accessory-order
layer: L1
l0: inspection-sub-accessory-order.abstract.md
l2Path: ../../../../app-overview/current/modules/Inspection/flows/inspection-sub-accessory-order.json
l2Logical: flow:Inspection.SUB_Accessory_Order
sourceRun: cli_2026-03-18T20-52-48.461Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Inspection.SUB_Accessory_Order

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](inspection-sub-accessory-order.abstract.md)
- L2: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-sub-accessory-order.json)

## Main Steps

- $IteratorAccessory/AmountInStock = 0 AmountInStock = 0? expression=$IteratorAccessory/AmountInStock = 0
- ChangeObjectAction: change IteratorAccessory (AmountInStock=$IteratorAccessory/AmountInStock + 5, EquipmentStatus=Inspection.ENUM_Accessory_Status.In_Stock; refreshInClient=false) change IteratorAccessory (AmountInStock=...
- ChangeObjectAction: change IteratorAccessory (AmountInStock=10, EquipmentStatus=Inspection.ENUM_Accessory_Status.In_Stock; refreshInClient=false) change IteratorAccessory (AmountInStock=10, EquipmentStatus=Inspection.ENU...

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by Inspection.SE_Equipment_OrderNew.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: Inspection.SE_Equipment_OrderNew

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=1dcf4ec0-9a9b-4cee-9072-566ef5a08285; caption=AmountInStock = 0?; expression=$IteratorAccessory/AmountInStock = 0 AmountInStock = 0? expression=$IteratorAccessory/AmountInStock = 0
- nodeId=2f25875f-2654-4871-8d32-be08fcfb85a8; actionKind=Change; entity=Inspection.ENUM_Accessory_Status; members=AmountInStock=$IteratorAccessory/AmountInStock + 5, EquipmentStatus=Inspection.ENUM_Accessory_Status.In_Stock; refreshInClient=false; summary=ChangeObjectAction: change IteratorAccessory (AmountInStock=$IteratorAccessory/AmountInStock + 5, EquipmentStatus=Inspection.ENUM_Accessory_Status.In_Stock; refreshInClient=false) change IteratorAccessory (AmountInStock=...
- nodeId=799e3dc3-c550-4f7a-94b1-b3526f43b5c3; actionKind=Change; entity=Inspection.ENUM_Accessory_Status; members=AmountInStock=10, EquipmentStatus=Inspection.ENUM_Accessory_Status.In_Stock; refreshInClient=false; summary=ChangeObjectAction: change IteratorAccessory (AmountInStock=10, EquipmentStatus=Inspection.ENUM_Accessory_Status.In_Stock; refreshInClient=false) change IteratorAccessory (AmountInStock=10, EquipmentStatus=Inspection.ENU...

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-sub-accessory-order.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/Inspection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/Inspection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-52-48.461Z
