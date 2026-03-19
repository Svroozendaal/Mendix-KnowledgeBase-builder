---
objectType: flow
module: Inspection
qualifiedName: Inspection.ACT_Registration_Create
stableId: e8c69001-be3e-4ea4-b744-d5c1fd2a49f8
slug: inspection-act-registration-create
layer: L1
l0: inspection-act-registration-create.abstract.md
l2Path: ../../../../app-overview/current/modules/Inspection/flows/inspection-act-registration-create.json
l2Logical: flow:Inspection.ACT_Registration_Create
sourceRun: cli_2026-03-18T20-54-38.903Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Inspection.ACT_Registration_Create

## Summary

- Likely acts as a UI entry or navigation handler because it shows Inspection.Registration_NewEdit.
- L0: [abstract](inspection-act-registration-create.abstract.md)
- L2: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-act-registration-create.json)

## Main Steps

- show page Inspection.Registration_NewEdit
- create Inspection.Registration

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: Shows Inspection.Registration_NewEdit.

## Key Entities Touched

- Inspection.Registration

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- Inspection.Registration_NewEdit

## Important Retrieves/Decisions/Mutations

- nodeId=n002-create; actionKind=Create; entity=Inspection.Registration; summary=create Inspection.Registration

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-act-registration-create.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-18T20-54-38.903Z/modules/Inspection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-18T20-54-38.903Z/modules/Inspection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-54-38.903Z
