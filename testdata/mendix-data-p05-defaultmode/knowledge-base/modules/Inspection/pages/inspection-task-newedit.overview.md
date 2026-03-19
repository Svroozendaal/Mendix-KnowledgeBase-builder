---
objectType: page
module: Inspection
qualifiedName: Inspection.Task_NewEdit
stableId: Inspection.Task_NewEdit
slug: inspection-task-newedit
layer: L1
l0: inspection-task-newedit.abstract.md
l2Path: ../../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/pages/inspection-task-newedit.json
l2Logical: page:Inspection.Task_NewEdit
sourceRun: cli_2026-03-18T20-44-56.522Z
collectionL0: INDEX.abstract.md
collectionL1: ../PAGES.md
---
# Page Overview: Inspection.Task_NewEdit

## Summary

- Edit Smart Task. Likely supports create/edit interactions for task because it accepts page parameters.
- L0: [abstract](inspection-task-newedit.abstract.md)
- L2: [json](../../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/pages/inspection-task-newedit.json)

## Roles and Entry Provenance

- Roles: Inspection.Inspector, Inspection.Manager
- Entry provenance: ShowPageAction

## Parameters

- Task:Inspection.Task

## Datasource Summary

- No datasource metadata was exported for this page; it may rely on parameter-driven context rather than a standalone datasource. Check L2 JSON if exact binding matters.

## Client Actions

- actionId=a28944c6-6641-4921-b770-7522750607fe; actionType=CancelChangesClientAction; summary=CancelChangesClientAction
- actionId=0e863539-aeff-434f-b92c-e4002a2f7062; actionType=MicroflowClientAction; flow=Inspection.ACT_Task_SetToDone; summary=MicroflowClientAction, flow=Inspection.ACT_Task_SetToDone
- actionId=30b3a9d7-14d7-4a4c-a64b-5518c77c829d; actionType=MicroflowClientAction; flow=Inspection.ACT_Task_Save; summary=MicroflowClientAction, flow=Inspection.ACT_Task_Save
- actionId=d1cc8ba5-98f2-4ad5-a730-bc5bf6940a5c; actionType=MicroflowClientAction; flow=Inspection.ACT_CoverPhoto_Create; summary=MicroflowClientAction, flow=Inspection.ACT_CoverPhoto_Create
- actionId=02c65030-b82f-4c1b-a262-8528bcdbfaf3; actionType=NoClientAction; summary=NoClientAction

## Shown by Flows

- Inspection.ACT_Task_Create

## Navigation/Homepage Provenance

- No navigation or homepage provenance was exported; the clearest exported evidence is the flow link shown above.

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/pages/inspection-task-newedit.json)
- Aggregate export: [pages.json](../../../../../mendix-data-p05-legacy/app-overview/cli_2026-03-18T20-44-56.522Z/modules/Inspection/pages.json)
- Aggregate pseudo: [pages.pseudo.txt](../../../../../mendix-data-p05-legacy/app-overview/cli_2026-03-18T20-44-56.522Z/modules/Inspection/pages.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-44-56.522Z
