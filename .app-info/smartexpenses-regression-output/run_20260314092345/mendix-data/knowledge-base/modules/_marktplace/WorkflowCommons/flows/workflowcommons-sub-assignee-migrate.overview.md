---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_Assignee_Migrate
stableId: ef82c723-bcc7-4988-a41c-e6ea0b510820
slug: workflowcommons-sub-assignee-migrate
layer: L1
l0: workflowcommons-sub-assignee-migrate.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-assignee-migrate.json
l2Logical: flow:WorkflowCommons.SUB_Assignee_Migrate
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_Assignee_Migrate

## Summary

- Likely acts as a save, process, or background step for WorkflowCommons.UserTaskView because it mutates data without showing a page.
- L0: [abstract](workflowcommons-sub-assignee-migrate.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-assignee-migrate.json)

## Main Steps

- retrieve UserTaskViewList from WorkflowCommons.UserTaskView
- $UserTaskViewList != empty Found? expression=$UserTaskViewList != empty
- ChangeObjectAction: change Configuration (VerifiedAssigneeMigration=true, ShowAssigneeMigration=false; refreshInClient=true) change Configuration (VerifiedAssigneeMigration=true, ShowAssigneeMigration=false; refreshInClient=true)
- ChangeObjectAction: change IteratorUserTaskView (UserTaskView_Assignees=$IteratorUserTaskView/WorkflowCommons.UserTaskView_Assignee, UserTaskView_Assignee=empty; refreshInClient=false) change IteratorUserTaskView (UserTaskView_Assignees=$IteratorUserTaskView/WorkflowCommons.UserTaskView_Assignee, UserTaskView_Assignee=empty; refreshInClient=false)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.ACT_Assignee_Migrate, WorkflowCommons.ASu_Assignee_Migrate.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- WorkflowCommons.UserTaskView

## Called / Called By

- Calls: none
- Called by: WorkflowCommons.ACT_Assignee_Migrate, WorkflowCommons.ASu_Assignee_Migrate

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=16276134-0e30-4f0d-acfe-bff08bf06fc5; sourceKind=Database; entity=WorkflowCommons.UserTaskView; summary=retrieve UserTaskViewList from WorkflowCommons.UserTaskView
- nodeId=43c929a1-30ef-45c1-b28a-35e2bdfdc4aa; caption=Found?; expression=$UserTaskViewList != empty Found? expression=$UserTaskViewList != empty
- nodeId=d421f3ae-30a8-4888-b94a-bf32d0db15a0; actionKind=Change; members=VerifiedAssigneeMigration=true, ShowAssigneeMigration=false; refreshInClient=true; summary=ChangeObjectAction: change Configuration (VerifiedAssigneeMigration=true, ShowAssigneeMigration=false; refreshInClient=true) change Configuration (VerifiedAssigneeMigration=true, ShowAssigneeMigration=false; refreshInClient=true)
- nodeId=d3e37277-0f46-492d-be5c-b78558173416; actionKind=Change; entity=WorkflowCommons.UserTaskView_Assignee; members=UserTaskView_Assignees=$IteratorUserTaskView/WorkflowCommons.UserTaskView_Assignee, UserTaskView_Assignee=empty; refreshInClient=false; summary=ChangeObjectAction: change IteratorUserTaskView (UserTaskView_Assignees=$IteratorUserTaskView/WorkflowCommons.UserTaskView_Assignee, UserTaskView_Assignee=empty; refreshInClient=false) change IteratorUserTaskView (UserTaskView_Assignees=$IteratorUserTaskView/WorkflowCommons.UserTaskView_Assignee, UserTaskView_Assignee=empty; refreshInClient=false)
- nodeId=7c1c3e70-05ed-4d3f-9799-45cebb6b6a60; actionKind=Change; summary=ChangeVariableAction: change variable TotalCount=$TotalCount + $Count change variable TotalCount=$TotalCount + $Count
- nodeId=ab522ab5-159d-4466-9acb-ec3fee3818ed; actionKind=Commit; members=refreshInClient=false, withEvents=true; summary=CommitAction: commit UserTaskViewList (refreshInClient=false, withEvents=true) commit UserTaskViewList (refreshInClient=false, withEvents=true)
- nodeId=b3ee43cf-d75f-469e-ad25-90b8ec4c0a6c; actionKind=Create; summary=CreateVariableAction: create variable TotalCount=0 create variable TotalCount=0

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-assignee-migrate.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
