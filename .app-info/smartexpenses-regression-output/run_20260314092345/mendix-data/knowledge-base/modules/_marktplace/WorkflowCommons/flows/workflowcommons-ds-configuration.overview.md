---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.DS_Configuration
stableId: eeeae160-0fc1-46dd-a0c7-8047f80a6d5f
slug: workflowcommons-ds-configuration
layer: L1
l0: workflowcommons-ds-configuration.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ds-configuration.json
l2Logical: flow:WorkflowCommons.DS_Configuration
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.DS_Configuration

## Summary

- Likely orchestrates downstream flow calls without direct UI output.
- L0: [abstract](workflowcommons-ds-configuration.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ds-configuration.json)

## Main Steps

- $Configuration/VerifiedAssigneeMigration Verified assignee migration? expression=$Configuration/VerifiedAssigneeMigration
- $Configuration/VerifiedKeyMigration Verified task key migration? expression=$Configuration/VerifiedKeyMigration

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; this likely delegates work to downstream flows.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: WorkflowCommons.SUB_AssigneeMigration_Verify, WorkflowCommons.SUB_Configuration_FindOrCreate, WorkflowCommons.SUB_KeyMigration_Verify
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it may serve validation, background processing, or delegate work to other flows.

## Important Retrieves/Decisions/Mutations

- nodeId=3bf94522-3dfc-44e1-9701-bf904536a1dc; caption=Verified assignee migration?; expression=$Configuration/VerifiedAssigneeMigration Verified assignee migration? expression=$Configuration/VerifiedAssigneeMigration
- nodeId=1835f557-8a62-47f4-8c15-f9e52c68e17a; caption=Verified task key migration?; expression=$Configuration/VerifiedKeyMigration Verified task key migration? expression=$Configuration/VerifiedKeyMigration

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ds-configuration.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
