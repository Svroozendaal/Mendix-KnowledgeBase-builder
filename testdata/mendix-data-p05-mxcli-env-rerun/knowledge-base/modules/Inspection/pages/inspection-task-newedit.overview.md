---
objectType: page
module: Inspection
qualifiedName: Inspection.Task_NewEdit
stableId: Inspection.Task_NewEdit
slug: inspection-task-newedit
layer: L1
l0: inspection-task-newedit.abstract.md
l2Path: ../../../../app-overview/current/modules/Inspection/pages/inspection-task-newedit.json
l2Logical: page:Inspection.Task_NewEdit
sourceRun: cli_2026-03-18T20-54-38.903Z
collectionL0: INDEX.abstract.md
collectionL1: ../PAGES.md
---
# Page Overview: Inspection.Task_NewEdit

## Summary

- Edit Smart Task. Likely supports create/edit interactions for task because it accepts page parameters.
- L0: [abstract](inspection-task-newedit.abstract.md)
- L2: [json](../../../../app-overview/current/modules/Inspection/pages/inspection-task-newedit.json)

## Roles and Entry Provenance

- Roles: Inspection.Inspector, Inspection.Manager
- Entry provenance: ShowPageAction

## Parameters

- Task:Inspection.Task

## Datasource Summary

- sourceId=dataView5; sourceType=Parameter; entity=Inspection.Task; summary=Parameter datasource: $Task
- sourceId=dataView1; sourceType=Microflow; flow=Inspection.DS_UserRole_GetFromCurrentUser; summary=Microflow datasource: Inspection.DS_UserRole_GetFromCurrentUser

## Client Actions

- actionId=actionButton3; actionType=MicroflowClientAction; flow=Inspection.ACT_CoverPhoto_Create; summary=MicroflowClientAction, flow=Inspection.ACT_CoverPhoto_Create
- actionId=actionButton2; actionType=CancelChangesClientAction; summary=CancelChangesClientAction
- actionId=actionButton6; actionType=MicroflowClientAction; flow=Inspection.ACT_Task_SetToDone; summary=MicroflowClientAction, flow=Inspection.ACT_Task_SetToDone
- actionId=actionButton1; actionType=MicroflowClientAction; flow=Inspection.ACT_Task_Save; summary=MicroflowClientAction, flow=Inspection.ACT_Task_Save

## Shown by Flows

- Inspection.ACT_Task_Create

## Navigation/Homepage Provenance

- No navigation or homepage provenance was exported; the clearest exported evidence is the flow link shown above.

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/Inspection/pages/inspection-task-newedit.json)
- Aggregate export: [pages.json](../../../../app-overview/cli_2026-03-18T20-54-38.903Z/modules/Inspection/pages.json)
- Aggregate pseudo: [pages.pseudo.txt](../../../../app-overview/cli_2026-03-18T20-54-38.903Z/modules/Inspection/pages.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-54-38.903Z
