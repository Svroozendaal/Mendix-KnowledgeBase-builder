---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_Configuration_FindOrCreate
stableId: ba2d3cf5-26c4-4cf8-bcfa-6d3fa9a18c39
slug: workflowcommons-sub-configuration-findorcreate
layer: L1
l0: workflowcommons-sub-configuration-findorcreate.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-configuration-findorcreate.json
l2Logical: flow:WorkflowCommons.SUB_Configuration_FindOrCreate
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_Configuration_FindOrCreate

## Summary

- Likely acts as a save, process, or background step for WorkflowCommons.Configuration because it mutates data without showing a page.
- L0: [abstract](workflowcommons-sub-configuration-findorcreate.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-configuration-findorcreate.json)

## Main Steps

- retrieve Configuration from WorkflowCommons.Configuration
- $Configuration != empty Found? expression=$Configuration != empty
- CreateObjectAction: create WorkflowCommons.Configuration as NewConfiguration create WorkflowCommons.Configuration as NewConfiguration

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.ACT_Assignee_Migrate, WorkflowCommons.ACT_Key_Migrate, WorkflowCommons.ASu_Assignee_Migrate, WorkflowCommons.ASu_Key_Migrate, WorkflowCommons.DS_Configuration.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- WorkflowCommons.Configuration

## Called / Called By

- Calls: none
- Called by: WorkflowCommons.ACT_Assignee_Migrate, WorkflowCommons.ACT_Key_Migrate, WorkflowCommons.ASu_Assignee_Migrate, WorkflowCommons.ASu_Key_Migrate, WorkflowCommons.DS_Configuration

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=d9e61a93-88cf-4a42-a12e-6030f29ee533; sourceKind=Database; entity=WorkflowCommons.Configuration; summary=retrieve Configuration from WorkflowCommons.Configuration
- nodeId=0913292d-0fe4-4f3e-a9cf-5c35e33e2c21; caption=Found?; expression=$Configuration != empty Found? expression=$Configuration != empty
- nodeId=26afa49e-b585-45c9-924b-e1408cfc48eb; actionKind=Create; entity=WorkflowCommons.Configuration; summary=CreateObjectAction: create WorkflowCommons.Configuration as NewConfiguration create WorkflowCommons.Configuration as NewConfiguration

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-configuration-findorcreate.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
