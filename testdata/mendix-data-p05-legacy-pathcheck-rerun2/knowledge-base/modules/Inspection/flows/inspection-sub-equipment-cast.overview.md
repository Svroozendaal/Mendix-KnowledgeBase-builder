---
objectType: flow
module: Inspection
qualifiedName: Inspection.SUB_Equipment_Cast
stableId: 5a631376-c575-4fcc-a851-c633040dd279
slug: inspection-sub-equipment-cast
layer: L1
l0: inspection-sub-equipment-cast.abstract.md
l2Path: ../../../../app-overview/current/modules/Inspection/flows/inspection-sub-equipment-cast.json
l2Logical: flow:Inspection.SUB_Equipment_Cast
sourceRun: cli_2026-03-18T20-56-46.385Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Inspection.SUB_Equipment_Cast

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](inspection-sub-equipment-cast.abstract.md)
- L2: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-sub-equipment-cast.json)

## Main Steps

- split IteratorEquipment split IteratorEquipment
- ChangeListAction: change AccessoryList (type=Add, value=$Accessory) change AccessoryList (type=Add, value=$Accessory)

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

- nodeId=6ecd7a7d-4da8-480f-a90b-63a3777c2444; actionKind=Change; members=type=Add, value=$Accessory; summary=ChangeListAction: change AccessoryList (type=Add, value=$Accessory) change AccessoryList (type=Add, value=$Accessory)

## Warnings/Unknowns

- Rollback hint detected in node detail.
- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-sub-equipment-cast.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-18T20-56-46.385Z/modules/Inspection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-18T20-56-46.385Z/modules/Inspection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-56-46.385Z
