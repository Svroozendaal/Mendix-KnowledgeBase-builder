---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.ACT_WorkflowDefinition_Lock
stableId: 3c1375f3-afaa-455b-9ed0-be19d4b8f9b4
slug: workflowcommons-act-workflowdefinition-lock
layer: L1
l0: workflowcommons-act-workflowdefinition-lock.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-workflowdefinition-lock.json
l2Logical: flow:WorkflowCommons.ACT_WorkflowDefinition_Lock
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.ACT_WorkflowDefinition_Lock

## Summary

- Likely acts as a UI entry or navigation handler because it shows WorkflowCommons.WorkflowDefinition_ActionConfirmation.
- L0: [abstract](workflowcommons-act-workflowdefinition-lock.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-workflowdefinition-lock.json)

## Main Steps

- retrieve WorkflowDefinition over association WorkflowDefinitionHelper_WorkflowDefinition from WorkflowDefinitionHelper
- $WorkflowDefinitionHelper/UpdateInstances Pause instances? expression=$WorkflowDefinitionHelper/UpdateInstances
- ShowPageAction: show page WorkflowCommons.WorkflowDefinition_ActionConfirmation show page WorkflowCommons.WorkflowDefinition_ActionConfirmation

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: Shows WorkflowCommons.WorkflowDefinition_ActionConfirmation.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- WorkflowCommons.WorkflowDefinition_ActionConfirmation

## Important Retrieves/Decisions/Mutations

- nodeId=85f3b93c-9099-40f6-8181-ad6175c86f5c; sourceKind=Association; association=WorkflowDefinitionHelper_WorkflowDefinition; summary=retrieve WorkflowDefinition over association WorkflowDefinitionHelper_WorkflowDefinition from WorkflowDefinitionHelper
- nodeId=2a6a8dcb-e5a9-40a8-bbbd-369aa3cbbcd3; caption=Pause instances?; expression=$WorkflowDefinitionHelper/UpdateInstances Pause instances? expression=$WorkflowDefinitionHelper/UpdateInstances

## Warnings/Unknowns

- Rollback hint detected in node detail.
- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-workflowdefinition-lock.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
