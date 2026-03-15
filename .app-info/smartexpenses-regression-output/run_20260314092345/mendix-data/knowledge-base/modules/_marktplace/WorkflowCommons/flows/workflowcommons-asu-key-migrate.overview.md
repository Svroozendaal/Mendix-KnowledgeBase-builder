---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.ASu_Key_Migrate
stableId: 2acca671-7284-4ae0-824f-69c06a583493
slug: workflowcommons-asu-key-migrate
layer: L1
l0: workflowcommons-asu-key-migrate.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-asu-key-migrate.json
l2Logical: flow:WorkflowCommons.ASu_Key_Migrate
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.ASu_Key_Migrate

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](workflowcommons-asu-key-migrate.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-asu-key-migrate.json)

## Main Steps

- $MigrationRequired Migration required? expression=$MigrationRequired
- ChangeObjectAction: change Configuration (VerifiedKeyMigration=true, ShowKeyMigration=false; refreshInClient=true) change Configuration (VerifiedKeyMigration=true, ShowKeyMigration=false; refreshInClient=true)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: WorkflowCommons.SUB_Configuration_FindOrCreate, WorkflowCommons.SUB_KeyMigration_Verify, WorkflowCommons.SUB_TaskKey_Migrate, WorkflowCommons.SUB_WorkflowKey_Migrate
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=b772b10a-7e93-429f-8f10-95d2841320b9; caption=Migration required?; expression=$MigrationRequired Migration required? expression=$MigrationRequired
- nodeId=65155a17-94ac-4c82-b911-91db2eaebe7a; actionKind=Change; members=VerifiedKeyMigration=true, ShowKeyMigration=false; refreshInClient=true; summary=ChangeObjectAction: change Configuration (VerifiedKeyMigration=true, ShowKeyMigration=false; refreshInClient=true) change Configuration (VerifiedKeyMigration=true, ShowKeyMigration=false; refreshInClient=true)

## Warnings/Unknowns

- Rollback hint detected in node detail.
- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-asu-key-migrate.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
