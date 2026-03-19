---
objectType: flow
module: Inspection
qualifiedName: Inspection.SE_Equipment_OrderNew
stableId: 854d1c7c-d256-40fe-ab0e-cb4c32885470
slug: inspection-se-equipment-ordernew
layer: L1
l0: inspection-se-equipment-ordernew.abstract.md
l2Path: ../../../../app-overview/current/modules/Inspection/flows/inspection-se-equipment-ordernew.json
l2Logical: flow:Inspection.SE_Equipment_OrderNew
sourceRun: cli_2026-03-18T20-56-46.385Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Inspection.SE_Equipment_OrderNew

## Summary

- Likely acts as a save, process, or background step for Inspection.Accessory, Inspection.Equipment because it mutates data without showing a page.
- L0: [abstract](inspection-se-equipment-ordernew.abstract.md)
- L2: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-se-equipment-ordernew.json)

## Main Steps

- RetrieveAction: retrieve EquipmentList from Inspection.Equipment retrieve EquipmentList from Inspection.Equipment
- CommitAction: commit NewAccessoryListToOrder (refreshInClient=false, withEvents=true) commit NewAccessoryListToOrder (refreshInClient=false, withEvents=true)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- Inspection.Accessory, Inspection.Equipment

## Called / Called By

- Calls: Inspection.SUB_Accessory_Order, Inspection.SUB_Equipment_Cast
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=519425d4-7d2c-4359-a2a8-1400b4fe903c; sourceKind=Database; entity=Inspection.Equipment; summary=RetrieveAction: retrieve EquipmentList from Inspection.Equipment retrieve EquipmentList from Inspection.Equipment
- nodeId=6982e963-d5c0-4ecc-81d2-63e00f960529; actionKind=Commit; members=refreshInClient=false, withEvents=true; summary=CommitAction: commit NewAccessoryListToOrder (refreshInClient=false, withEvents=true) commit NewAccessoryListToOrder (refreshInClient=false, withEvents=true)

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-se-equipment-ordernew.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-18T20-56-46.385Z/modules/Inspection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-18T20-56-46.385Z/modules/Inspection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-56-46.385Z
