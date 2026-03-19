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
sourceRun: cli_2026-03-18T21-10-02.160Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Inspection.SE_Equipment_OrderNew

## Summary

- Likely acts as a save, process, or background step for Inspection.Accessory, Inspection.Equipment because it mutates data without showing a page.
- L0: [abstract](inspection-se-equipment-ordernew.abstract.md)
- L2: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-se-equipment-ordernew.json)

## Main Steps

- retrieve from Inspection.Equipment
- create list of Inspection.Accessory
- commit $NewAccessoryListToOrder WITH EVENTS ON ERROR ROLLBACK

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

- nodeId=n002-retrieve; sourceKind=Database; entity=Inspection.Equipment; summary=retrieve from Inspection.Equipment
- nodeId=n003-create; actionKind=Create; entity=Inspection.Accessory; summary=create list of Inspection.Accessory
- nodeId=n008-commit; actionKind=Commit; summary=commit $NewAccessoryListToOrder WITH EVENTS ON ERROR ROLLBACK

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-se-equipment-ordernew.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-18T21-10-02.160Z/modules/Inspection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-18T21-10-02.160Z/modules/Inspection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T21-10-02.160Z
