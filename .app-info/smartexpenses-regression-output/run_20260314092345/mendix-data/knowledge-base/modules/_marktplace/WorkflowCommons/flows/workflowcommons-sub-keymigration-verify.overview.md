---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_KeyMigration_Verify
stableId: 83fec17a-0e04-4581-96e6-e3ebe8e807ad
slug: workflowcommons-sub-keymigration-verify
layer: L1
l0: workflowcommons-sub-keymigration-verify.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-keymigration-verify.json
l2Logical: flow:WorkflowCommons.SUB_KeyMigration_Verify
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_KeyMigration_Verify

## Summary

- Likely acts as a save, process, or background step for WorkflowCommons.UserTaskView, WorkflowCommons.WorkflowView because it mutates data without showing a page.
- L0: [abstract](workflowcommons-sub-keymigration-verify.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-keymigration-verify.json)

## Main Steps

- retrieve UserTaskViewList from WorkflowCommons.UserTaskView
- retrieve WorkflowViewList from WorkflowCommons.WorkflowView
- ChangeObjectAction: change Configuration (ShowKeyMigration=$MigrationRequired, VerifiedKeyMigration=true; refreshInClient=false) change Configuration (ShowKeyMigration=$MigrationRequired, VerifiedKeyMigration=true; refreshInClient=false)
- CreateVariableAction: create variable MigrationRequired=$CountUserTaskView > 0 or $CountWorkflowView > 0 create variable MigrationRequired=$CountUserTaskView > 0 or $CountWorkflowView > 0

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.ASu_Key_Migrate, WorkflowCommons.DS_Configuration.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- WorkflowCommons.UserTaskView, WorkflowCommons.WorkflowView

## Called / Called By

- Calls: none
- Called by: WorkflowCommons.ASu_Key_Migrate, WorkflowCommons.DS_Configuration

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=8b852229-55a3-49fd-9daf-251f9154f46c; sourceKind=Database; entity=WorkflowCommons.UserTaskView; summary=retrieve UserTaskViewList from WorkflowCommons.UserTaskView
- nodeId=2aa06b87-c46c-43db-a381-2d52c4fd8fe4; sourceKind=Database; entity=WorkflowCommons.WorkflowView; summary=retrieve WorkflowViewList from WorkflowCommons.WorkflowView
- nodeId=75a977d9-783d-4e88-b94b-d4a85ad3e3fb; actionKind=Change; members=ShowKeyMigration=$MigrationRequired, VerifiedKeyMigration=true; refreshInClient=false; summary=ChangeObjectAction: change Configuration (ShowKeyMigration=$MigrationRequired, VerifiedKeyMigration=true; refreshInClient=false) change Configuration (ShowKeyMigration=$MigrationRequired, VerifiedKeyMigration=true; refreshInClient=false)
- nodeId=cb853a47-730c-45f9-85e0-b6d08c19a7a7; actionKind=Create; summary=CreateVariableAction: create variable MigrationRequired=$CountUserTaskView > 0 or $CountWorkflowView > 0 create variable MigrationRequired=$CountUserTaskView > 0 or $CountWorkflowView > 0

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-keymigration-verify.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
