---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_AssigneeMigration_Verify
stableId: 75d1a505-2de9-41ef-90a8-d927742f8a4c
slug: workflowcommons-sub-assigneemigration-verify
layer: L1
l0: workflowcommons-sub-assigneemigration-verify.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-assigneemigration-verify.json
l2Logical: flow:WorkflowCommons.SUB_AssigneeMigration_Verify
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_AssigneeMigration_Verify

## Summary

- Likely acts as a save, process, or background step for WorkflowCommons.UserTaskView because it mutates data without showing a page.
- L0: [abstract](workflowcommons-sub-assigneemigration-verify.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-assigneemigration-verify.json)

## Main Steps

- retrieve UserTaskViewList from WorkflowCommons.UserTaskView
- ChangeObjectAction: change Configuration (ShowAssigneeMigration=$MigrationRequired, VerifiedAssigneeMigration=true; refreshInClient=false) change Configuration (ShowAssigneeMigration=$MigrationRequired, VerifiedAssigneeMigration=true; refreshInClient=false)
- CreateVariableAction: create variable MigrationRequired=$CountUserTaskView > 0 create variable MigrationRequired=$CountUserTaskView > 0

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.ASu_Assignee_Migrate, WorkflowCommons.DS_Configuration.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- WorkflowCommons.UserTaskView

## Called / Called By

- Calls: none
- Called by: WorkflowCommons.ASu_Assignee_Migrate, WorkflowCommons.DS_Configuration

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=21b7bd0f-da7f-4016-ab26-f92e0a46b02e; sourceKind=Database; entity=WorkflowCommons.UserTaskView; summary=retrieve UserTaskViewList from WorkflowCommons.UserTaskView
- nodeId=4006fcb9-d89f-4a37-a8e4-5e30545c7a4a; actionKind=Change; members=ShowAssigneeMigration=$MigrationRequired, VerifiedAssigneeMigration=true; refreshInClient=false; summary=ChangeObjectAction: change Configuration (ShowAssigneeMigration=$MigrationRequired, VerifiedAssigneeMigration=true; refreshInClient=false) change Configuration (ShowAssigneeMigration=$MigrationRequired, VerifiedAssigneeMigration=true; refreshInClient=false)
- nodeId=2a3bc113-73fb-4d74-afcb-d69cdb3ead3c; actionKind=Create; summary=CreateVariableAction: create variable MigrationRequired=$CountUserTaskView > 0 create variable MigrationRequired=$CountUserTaskView > 0

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-assigneemigration-verify.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
