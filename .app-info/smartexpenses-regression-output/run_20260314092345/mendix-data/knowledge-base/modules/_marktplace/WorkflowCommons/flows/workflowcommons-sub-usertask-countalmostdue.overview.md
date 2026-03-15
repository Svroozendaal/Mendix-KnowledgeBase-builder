---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_UserTask_CountAlmostDue
stableId: 31e478d3-fc9a-4c1d-bc18-a59a4aa37f02
slug: workflowcommons-sub-usertask-countalmostdue
layer: L1
l0: workflowcommons-sub-usertask-countalmostdue.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertask-countalmostdue.json
l2Logical: flow:WorkflowCommons.SUB_UserTask_CountAlmostDue
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_UserTask_CountAlmostDue

## Summary

- Likely acts as a save, process, or background step for System.WorkflowUserTask because it mutates data without showing a page.
- L0: [abstract](workflowcommons-sub-usertask-countalmostdue.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertask-countalmostdue.json)

## Main Steps

- retrieve UserTask_InProgress_AlmostDue from System.WorkflowUserTask
- CreateVariableAction: create variable AlmostDueDate=addDays([%CurrentDateTime%], @WorkflowCommons.DueDateExpirationInDays) create variable AlmostDueDate=addDays([%CurrentDateTime%], @WorkflowCommons.DueDateExpirationInDays)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.SUB_TaskSummary_CreateOrUpdate.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- System.WorkflowUserTask

## Called / Called By

- Calls: none
- Called by: WorkflowCommons.SUB_TaskSummary_CreateOrUpdate

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=5dd7eec6-2360-4579-933f-3fcc43f8e78c; sourceKind=Database; entity=System.WorkflowUserTask; summary=retrieve UserTask_InProgress_AlmostDue from System.WorkflowUserTask
- nodeId=4426ea50-cea2-4589-81db-50e5a6fbd26c; actionKind=Create; entity=WorkflowCommons.DueDateExpirationInDays; members=[%CurrentDateTime%], @WorkflowCommons.DueDateExpirationInDays; summary=CreateVariableAction: create variable AlmostDueDate=addDays([%CurrentDateTime%], @WorkflowCommons.DueDateExpirationInDays) create variable AlmostDueDate=addDays([%CurrentDateTime%], @WorkflowCommons.DueDateExpirationInDays)

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertask-countalmostdue.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
