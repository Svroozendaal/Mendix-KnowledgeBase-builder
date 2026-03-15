---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_TaskKey_Migrate
stableId: d14b94f4-a0d9-40cf-8ab7-7a1ee16e1b50
slug: workflowcommons-sub-taskkey-migrate
layer: L1
l0: workflowcommons-sub-taskkey-migrate.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-taskkey-migrate.json
l2Logical: flow:WorkflowCommons.SUB_TaskKey_Migrate
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_TaskKey_Migrate

## Summary

- Likely acts as a save, process, or background step for WorkflowCommons.UserTaskView because it mutates data without showing a page.
- L0: [abstract](workflowcommons-sub-taskkey-migrate.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-taskkey-migrate.json)

## Main Steps

- retrieve UserTaskViewList from WorkflowCommons.UserTaskView
- $UserTaskViewList != empty Found? expression=$UserTaskViewList != empty
- ChangeVariableAction: change variable Offset=$Offset + $Limit change variable Offset=$Offset + $Limit
- ChangeVariableAction: change variable TotalCount=$TotalCount + $Count change variable TotalCount=$TotalCount + $Count

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.ACT_Key_Migrate, WorkflowCommons.ASu_Key_Migrate.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- WorkflowCommons.UserTaskView

## Called / Called By

- Calls: WorkflowCommons.SUB_UserTaskView_UpdateKey
- Called by: WorkflowCommons.ACT_Key_Migrate, WorkflowCommons.ASu_Key_Migrate

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=2509cdc0-9c0e-4f34-a35d-948cf3d60ade; sourceKind=Database; entity=WorkflowCommons.UserTaskView; summary=retrieve UserTaskViewList from WorkflowCommons.UserTaskView
- nodeId=c456340e-26d1-4ae1-97e7-a9c28cdc8216; caption=Found?; expression=$UserTaskViewList != empty Found? expression=$UserTaskViewList != empty
- nodeId=b8ef59e8-1f25-488f-94cc-227956aa92a9; actionKind=Change; summary=ChangeVariableAction: change variable Offset=$Offset + $Limit change variable Offset=$Offset + $Limit
- nodeId=dfd2877c-2e02-4a95-8919-71e81065a131; actionKind=Change; summary=ChangeVariableAction: change variable TotalCount=$TotalCount + $Count change variable TotalCount=$TotalCount + $Count
- nodeId=f5e985c4-f78e-43bd-85d4-b79d1f4c1b1e; actionKind=Commit; members=refreshInClient=false, withEvents=true; summary=CommitAction: commit UserTaskViewList (refreshInClient=false, withEvents=true) commit UserTaskViewList (refreshInClient=false, withEvents=true)
- nodeId=9232999c-67ec-4e80-9163-4d74a408c6e8; actionKind=Create; summary=CreateVariableAction: create variable Limit=50 create variable Limit=50
- nodeId=367b86e1-60ea-47b5-bfb1-598d0d1d2746; actionKind=Create; summary=CreateVariableAction: create variable Offset=0 create variable Offset=0
- nodeId=051cf7b5-e556-41f4-b449-1acf6fd42ba5; actionKind=Create; summary=CreateVariableAction: create variable TotalCount=0 create variable TotalCount=0

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-taskkey-migrate.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
