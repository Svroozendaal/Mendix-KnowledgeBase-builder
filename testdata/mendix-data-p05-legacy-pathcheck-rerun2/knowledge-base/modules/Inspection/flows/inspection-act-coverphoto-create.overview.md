---
objectType: flow
module: Inspection
qualifiedName: Inspection.ACT_CoverPhoto_Create
stableId: 0a219153-da4e-4dc9-a00d-b445796ebdaf
slug: inspection-act-coverphoto-create
layer: L1
l0: inspection-act-coverphoto-create.abstract.md
l2Path: ../../../../app-overview/current/modules/Inspection/flows/inspection-act-coverphoto-create.json
l2Logical: flow:Inspection.ACT_CoverPhoto_Create
sourceRun: cli_2026-03-18T20-56-46.385Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Inspection.ACT_CoverPhoto_Create

## Summary

- Likely acts as a UI entry or navigation handler because it shows Inspection.CoverPhoto_NewEdit.
- L0: [abstract](inspection-act-coverphoto-create.abstract.md)
- L2: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-act-coverphoto-create.json)

## Main Steps

- ShowPageAction: show page Inspection.CoverPhoto_NewEdit show page Inspection.CoverPhoto_NewEdit
- CreateObjectAction: create Inspection.CoverPhoto as NewInspectorPhoto (Task_CoverPhoto=$Task) create Inspection.CoverPhoto as NewInspectorPhoto (Task_CoverPhoto=$Task)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: Shows Inspection.CoverPhoto_NewEdit.

## Key Entities Touched

- Inspection.CoverPhoto

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- Inspection.CoverPhoto_NewEdit

## Important Retrieves/Decisions/Mutations

- nodeId=432e963a-8f07-4582-bd35-8e9d7021a8fb; actionKind=Create; entity=Inspection.CoverPhoto; members=Task_CoverPhoto=$Task; summary=CreateObjectAction: create Inspection.CoverPhoto as NewInspectorPhoto (Task_CoverPhoto=$Task) create Inspection.CoverPhoto as NewInspectorPhoto (Task_CoverPhoto=$Task)

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-act-coverphoto-create.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-18T20-56-46.385Z/modules/Inspection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-18T20-56-46.385Z/modules/Inspection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-56-46.385Z
