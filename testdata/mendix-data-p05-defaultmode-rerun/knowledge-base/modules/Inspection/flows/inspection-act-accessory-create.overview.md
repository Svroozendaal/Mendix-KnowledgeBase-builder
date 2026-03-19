---
objectType: flow
module: Inspection
qualifiedName: Inspection.ACT_Accessory_Create
stableId: a1550071-ee71-4910-b9fb-294f095fd3b8
slug: inspection-act-accessory-create
layer: L1
l0: inspection-act-accessory-create.abstract.md
l2Path: ../../../../../mendix-data-p05-mxcli-rerun/app-overview/current/modules/Inspection/flows/inspection-act-accessory-create.json
l2Logical: flow:Inspection.ACT_Accessory_Create
sourceRun: cli_2026-03-18T20-53-14.243Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Inspection.ACT_Accessory_Create

## Summary

- Likely acts as a UI entry or navigation handler because it shows Inspection.Assessory_NewEdit.
- L0: [abstract](inspection-act-accessory-create.abstract.md)
- L2: [json](../../../../../mendix-data-p05-mxcli-rerun/app-overview/current/modules/Inspection/flows/inspection-act-accessory-create.json)

## Main Steps

- show page Inspection.Assessory_NewEdit
- create Inspection.Accessory

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: Shows Inspection.Assessory_NewEdit.

## Key Entities Touched

- Inspection.Accessory

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- Inspection.Assessory_NewEdit

## Important Retrieves/Decisions/Mutations

- nodeId=n002-create; actionKind=Create; entity=Inspection.Accessory; summary=create Inspection.Accessory

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../mendix-data-p05-mxcli-rerun/app-overview/current/modules/Inspection/flows/inspection-act-accessory-create.json)
- Aggregate export: [flows.json](../../../../../mendix-data-p05-mxcli-rerun/app-overview/cli_2026-03-18T20-53-14.243Z/modules/Inspection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../mendix-data-p05-mxcli-rerun/app-overview/cli_2026-03-18T20-53-14.243Z/modules/Inspection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-53-14.243Z
