---
objectType: flow
module: Inspection
qualifiedName: Inspection.ACT_Tool_Create
stableId: f7557a9f-8f21-48f0-bf51-829753587468
slug: inspection-act-tool-create
layer: L1
l0: inspection-act-tool-create.abstract.md
l2Path: ../../../../app-overview/current/modules/Inspection/flows/inspection-act-tool-create.json
l2Logical: flow:Inspection.ACT_Tool_Create
sourceRun: cli_2026-03-18T21-10-02.160Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Inspection.ACT_Tool_Create

## Summary

- Likely acts as a UI entry or navigation handler because it shows Inspection.Tool_NewEdit.
- L0: [abstract](inspection-act-tool-create.abstract.md)
- L2: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-act-tool-create.json)

## Main Steps

- show page Inspection.Tool_NewEdit
- create Inspection.Tool

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: Shows Inspection.Tool_NewEdit.

## Key Entities Touched

- Inspection.Tool

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- Inspection.Tool_NewEdit

## Important Retrieves/Decisions/Mutations

- nodeId=n002-create; actionKind=Create; entity=Inspection.Tool; summary=create Inspection.Tool

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-act-tool-create.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-18T21-10-02.160Z/modules/Inspection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-18T21-10-02.160Z/modules/Inspection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T21-10-02.160Z
