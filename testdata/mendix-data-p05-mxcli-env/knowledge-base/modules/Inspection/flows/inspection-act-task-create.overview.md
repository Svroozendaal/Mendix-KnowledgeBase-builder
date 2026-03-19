---
objectType: flow
module: Inspection
qualifiedName: Inspection.ACT_Task_Create
stableId: 3c89fd88-4394-4091-aeeb-7a5b0b0c4f5e
slug: inspection-act-task-create
layer: L1
l0: inspection-act-task-create.abstract.md
l2Path: ../../../../app-overview/current/modules/Inspection/flows/inspection-act-task-create.json
l2Logical: flow:Inspection.ACT_Task_Create
sourceRun: cli_2026-03-18T20-49-03.032Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Inspection.ACT_Task_Create

## Summary

- Likely acts as a UI entry or navigation handler because it shows Inspection.Task_NewEdit.
- L0: [abstract](inspection-act-task-create.abstract.md)
- L2: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-act-task-create.json)

## Main Steps

- show page Inspection.Task_NewEdit
- create Inspection.Task (Created = [%CurrentDateTime%], Status = Inspection.Enum_TaskStatus.To_do, Task_InspectionItem = $InspectionItem)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: Shows Inspection.Task_NewEdit.

## Key Entities Touched

- Inspection.Task

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- Inspection.Task_NewEdit

## Important Retrieves/Decisions/Mutations

- nodeId=n002-create; actionKind=Create; entity=Inspection.Task; members=(Created = [%CurrentDateTime%], Status = Inspection.Enum_TaskStatus.To_do, Task_InspectionItem = $InspectionItem); summary=create Inspection.Task (Created = [%CurrentDateTime%], Status = Inspection.Enum_TaskStatus.To_do, Task_InspectionItem = $InspectionItem)

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-act-task-create.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-18T20-49-03.032Z/modules/Inspection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-18T20-49-03.032Z/modules/Inspection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-49-03.032Z
