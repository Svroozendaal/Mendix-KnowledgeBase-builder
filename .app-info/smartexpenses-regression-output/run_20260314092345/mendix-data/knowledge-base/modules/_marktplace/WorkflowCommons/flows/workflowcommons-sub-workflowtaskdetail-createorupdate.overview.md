---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_WorkflowTaskDetail_CreateOrUpdate
stableId: d1ae28a8-c553-4c56-8119-bc611bc7c005
slug: workflowcommons-sub-workflowtaskdetail-createorupdate
layer: L1
l0: workflowcommons-sub-workflowtaskdetail-createorupdate.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowtaskdetail-createorupdate.json
l2Logical: flow:WorkflowCommons.SUB_WorkflowTaskDetail_CreateOrUpdate
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_WorkflowTaskDetail_CreateOrUpdate

## Summary

- Likely acts as a save, process, or background step for System.WorkflowUserTaskDefinition, WorkflowCommons.WorkflowTaskDetail because it mutates data without showing a page.
- L0: [abstract](workflowcommons-sub-workflowtaskdetail-createorupdate.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowtaskdetail-createorupdate.json)

## Main Steps

- retrieve TaskDefinitionList from System.WorkflowUserTaskDefinition
- $WorkflowDefinition_Selected != empty WorkflowDefinition Selected? expression=$WorkflowDefinition_Selected != empty
- CreateObjectAction: create WorkflowCommons.WorkflowTaskDetail as NewWorkflowTaskDetail (TaskName=$IteratorTaskDefinition/Name, TaskAverageHandlingTime=$WorkflowActivity_AverageHandlingTime, WorkflowTaskDetail_DashboardContext=$DashboardContext) create WorkflowCommons.WorkflowTaskDetail as NewWorkflowTaskDetail (TaskName=$IteratorTaskDefinition/Name, TaskAverageHandlingTime=$WorkflowActivity_AverageHandlingTime, WorkflowTaskDetail_DashboardContext=$DashboardContext)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.SUB_WorkflowDashboard_Update.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- System.WorkflowUserTaskDefinition, WorkflowCommons.WorkflowTaskDetail

## Called / Called By

- Calls: WorkflowCommons.SUB_WorkflowTask_AverageHandlingTime, WorkflowCommons.SUB_WorkflowTaskDetail_Delete
- Called by: WorkflowCommons.SUB_WorkflowDashboard_Update

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=2adbf22c-1aa8-4beb-8ff8-0b3a2b03db41; sourceKind=Database; entity=System.WorkflowUserTaskDefinition; summary=retrieve TaskDefinitionList from System.WorkflowUserTaskDefinition
- nodeId=3e49fa73-d462-4a2b-8e3e-2ab098d79a81; caption=WorkflowDefinition Selected?; expression=$WorkflowDefinition_Selected != empty WorkflowDefinition Selected? expression=$WorkflowDefinition_Selected != empty
- nodeId=05153d76-19f6-467c-a5be-48d87e02a7a8; actionKind=Create; entity=WorkflowCommons.WorkflowTaskDetail; members=TaskName=$IteratorTaskDefinition/Name, TaskAverageHandlingTime=$WorkflowActivity_AverageHandlingTime, WorkflowTaskDetail_DashboardContext=$DashboardContext; summary=CreateObjectAction: create WorkflowCommons.WorkflowTaskDetail as NewWorkflowTaskDetail (TaskName=$IteratorTaskDefinition/Name, TaskAverageHandlingTime=$WorkflowActivity_AverageHandlingTime, WorkflowTaskDetail_DashboardContext=$DashboardContext) create WorkflowCommons.WorkflowTaskDetail as NewWorkflowTaskDetail (TaskName=$IteratorTaskDefinition/Name, TaskAverageHandlingTime=$WorkflowActivity_AverageHandlingTime, WorkflowTaskDetail_DashboardContext=$DashboardContext)

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowtaskdetail-createorupdate.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
