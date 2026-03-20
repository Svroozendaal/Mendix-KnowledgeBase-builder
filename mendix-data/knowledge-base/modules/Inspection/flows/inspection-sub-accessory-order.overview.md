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
sourceRun: cli_2026-03-19T15-48-55.594Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Inspection.SUB_Accessory_Order

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](inspection-sub-accessory-order.abstract.md)
- L2: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-sub-accessory-order.json)

## Main Steps

- $IteratorAccessory/AmountInStock = 0
- change $IteratorAccessory (AmountInStock = 10, EquipmentStatus = Inspection.ENUM_Accessory_Status.In_Stock)
- change $IteratorAccessory (AmountInStock = $IteratorAccessory/AmountInStock + 5, EquipmentStatus = Inspection.ENUM_Accessory_Status.In_Stock)

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

- nodeId=n004-decision; caption=IF; expression=$IteratorAccessory/AmountInStock = 0
- nodeId=n005-change; actionKind=Change; members=AmountInStock = 10, EquipmentStatus = Inspection.ENUM_Accessory_Status.In_Stock; summary=change $IteratorAccessory (AmountInStock = 10, EquipmentStatus = Inspection.ENUM_Accessory_Status.In_Stock)
- nodeId=n006-change; actionKind=Change; members=AmountInStock = $IteratorAccessory/AmountInStock + 5, EquipmentStatus = Inspection.ENUM_Accessory_Status.In_Stock; summary=change $IteratorAccessory (AmountInStock = $IteratorAccessory/AmountInStock + 5, EquipmentStatus = Inspection.ENUM_Accessory_Status.In_Stock)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-sub-accessory-order.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-19T15-48-55.594Z/modules/Inspection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-19T15-48-55.594Z/modules/Inspection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-19T15-48-55.594Z
