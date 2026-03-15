---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_UserTaskView_UpdateKey
stableId: 36a8dc78-33a9-4d6a-aea8-800198d51f5a
slug: workflowcommons-sub-usertaskview-updatekey
layer: L1
l0: workflowcommons-sub-usertaskview-updatekey.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertaskview-updatekey.json
l2Logical: flow:WorkflowCommons.SUB_UserTaskView_UpdateKey
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_UserTaskView_UpdateKey

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](workflowcommons-sub-usertaskview-updatekey.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertaskview-updatekey.json)

## Main Steps

- retrieve WorkflowUserTask over association UserTaskView_WorkflowUserTask from UserTaskView
- $UserTaskView/WorkflowCommons.UserTaskView_WorkflowUserTask != empty User task? expression=$UserTaskView/WorkflowCommons.UserTaskView_WorkflowUserTask != empty
- ChangeObjectAction: change UserTaskView (TaskKey=$TaskKey; refreshInClient=false) change UserTaskView (TaskKey=$TaskKey; refreshInClient=false)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.SUB_TaskKey_Migrate.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: WorkflowCommons.SUB_TaskKey_Migrate

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=cc6ae12c-3f2d-4caa-8171-d3e8ec1001c2; sourceKind=Association; association=UserTaskView_WorkflowUserTask; summary=retrieve WorkflowUserTask over association UserTaskView_WorkflowUserTask from UserTaskView
- nodeId=b2fb6e30-ba26-4aa0-bed0-6572855e84a5; caption=User task?; expression=$UserTaskView/WorkflowCommons.UserTaskView_WorkflowUserTask != empty User task? expression=$UserTaskView/WorkflowCommons.UserTaskView_WorkflowUserTask != empty
- nodeId=058283a4-78b5-478e-a580-a244ea785f56; actionKind=Change; members=TaskKey=$TaskKey; refreshInClient=false; summary=ChangeObjectAction: change UserTaskView (TaskKey=$TaskKey; refreshInClient=false) change UserTaskView (TaskKey=$TaskKey; refreshInClient=false)

## Warnings/Unknowns

- Rollback hint detected in node detail.
- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-usertaskview-updatekey.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
