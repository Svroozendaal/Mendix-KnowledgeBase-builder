---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.ACT_Key_Migrate
stableId: 2a135322-1c33-48b6-9b8d-52460dff8735
slug: workflowcommons-act-key-migrate
layer: L1
l0: workflowcommons-act-key-migrate.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-key-migrate.json
l2Logical: flow:WorkflowCommons.ACT_Key_Migrate
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.ACT_Key_Migrate

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](workflowcommons-act-key-migrate.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-key-migrate.json)

## Main Steps

- ChangeObjectAction: change Configuration (VerifiedKeyMigration=true, ShowKeyMigration=false; refreshInClient=true) change Configuration (VerifiedKeyMigration=true, ShowKeyMigration=false; refreshInClient=true)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: WorkflowCommons.SUB_Configuration_FindOrCreate, WorkflowCommons.SUB_TaskKey_Migrate, WorkflowCommons.SUB_WorkflowKey_Migrate
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=a6dbd95e-0541-44e3-964e-f61d36edd66d; actionKind=Change; members=VerifiedKeyMigration=true, ShowKeyMigration=false; refreshInClient=true; summary=ChangeObjectAction: change Configuration (VerifiedKeyMigration=true, ShowKeyMigration=false; refreshInClient=true) change Configuration (VerifiedKeyMigration=true, ShowKeyMigration=false; refreshInClient=true)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-key-migrate.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
