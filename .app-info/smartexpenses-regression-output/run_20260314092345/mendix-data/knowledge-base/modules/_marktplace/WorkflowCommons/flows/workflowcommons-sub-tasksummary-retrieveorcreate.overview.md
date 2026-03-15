---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_TaskSummary_RetrieveOrCreate
stableId: 85d4763b-eb58-4083-9ae2-48ffa0761a8e
slug: workflowcommons-sub-tasksummary-retrieveorcreate
layer: L1
l0: workflowcommons-sub-tasksummary-retrieveorcreate.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-tasksummary-retrieveorcreate.json
l2Logical: flow:WorkflowCommons.SUB_TaskSummary_RetrieveOrCreate
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_TaskSummary_RetrieveOrCreate

## Summary

- Likely acts as a save, process, or background step for WorkflowCommons.TaskSummary because it mutates data without showing a page.
- L0: [abstract](workflowcommons-sub-tasksummary-retrieveorcreate.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-tasksummary-retrieveorcreate.json)

## Main Steps

- retrieve TaskSummary over association DashboardContext_TaskSummary from DashboardContext
- $TaskSummary != empty != empty expression=$TaskSummary != empty
- CreateObjectAction: create WorkflowCommons.TaskSummary as NewTaskSummary (DashboardContext_TaskSummary=$DashboardContext) create WorkflowCommons.TaskSummary as NewTaskSummary (DashboardContext_TaskSummary=$DashboardContext)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.SUB_TaskSummary_CreateOrUpdate.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- WorkflowCommons.TaskSummary

## Called / Called By

- Calls: none
- Called by: WorkflowCommons.SUB_TaskSummary_CreateOrUpdate

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=373df17f-ab71-4af5-8523-131084d879a5; sourceKind=Association; association=DashboardContext_TaskSummary; summary=retrieve TaskSummary over association DashboardContext_TaskSummary from DashboardContext
- nodeId=527c77f0-a1a9-49f8-8f75-9e1ccd47a133; caption=!= empty; expression=$TaskSummary != empty != empty expression=$TaskSummary != empty
- nodeId=2177eb53-c4f0-4fdf-b7c7-3f4a4cfbfc80; actionKind=Create; entity=WorkflowCommons.TaskSummary; members=DashboardContext_TaskSummary=$DashboardContext; summary=CreateObjectAction: create WorkflowCommons.TaskSummary as NewTaskSummary (DashboardContext_TaskSummary=$DashboardContext) create WorkflowCommons.TaskSummary as NewTaskSummary (DashboardContext_TaskSummary=$DashboardContext)

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-tasksummary-retrieveorcreate.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
