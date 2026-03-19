---
objectType: flow
module: Inspection
qualifiedName: Inspection.ACT_InspectorPhoto_Create
stableId: ac8e86cf-445a-4435-8b38-cc62dd938c7f
slug: inspection-act-inspectorphoto-create
layer: L1
l0: inspection-act-inspectorphoto-create.abstract.md
l2Path: ../../../../app-overview/current/modules/Inspection/flows/inspection-act-inspectorphoto-create.json
l2Logical: flow:Inspection.ACT_InspectorPhoto_Create
sourceRun: cli_2026-03-18T21-15-38.461Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Inspection.ACT_InspectorPhoto_Create

## Summary

- Likely acts as a UI entry or navigation handler because it shows Inspection.InspectorPhoto_NewEdit.
- L0: [abstract](inspection-act-inspectorphoto-create.abstract.md)
- L2: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-act-inspectorphoto-create.json)

## Main Steps

- show page Inspection.InspectorPhoto_NewEdit
- create Inspection.InspectorPhoto (InspectorPhoto_Inspector = $Inspector)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: Shows Inspection.InspectorPhoto_NewEdit.

## Key Entities Touched

- Inspection.InspectorPhoto

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- Inspection.InspectorPhoto_NewEdit

## Important Retrieves/Decisions/Mutations

- nodeId=n002-create; actionKind=Create; entity=Inspection.InspectorPhoto; members=(InspectorPhoto_Inspector = $Inspector); summary=create Inspection.InspectorPhoto (InspectorPhoto_Inspector = $Inspector)

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-act-inspectorphoto-create.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-18T21-15-38.461Z/modules/Inspection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-18T21-15-38.461Z/modules/Inspection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T21-15-38.461Z
