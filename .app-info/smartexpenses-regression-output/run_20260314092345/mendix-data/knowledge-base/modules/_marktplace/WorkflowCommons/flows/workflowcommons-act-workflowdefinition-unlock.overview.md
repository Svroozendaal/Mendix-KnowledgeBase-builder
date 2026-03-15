---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.ACT_WorkflowDefinition_Unlock
stableId: 55f79c88-5f7a-43cd-86f6-2b89bf493f9f
slug: workflowcommons-act-workflowdefinition-unlock
layer: L1
l0: workflowcommons-act-workflowdefinition-unlock.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-workflowdefinition-unlock.json
l2Logical: flow:WorkflowCommons.ACT_WorkflowDefinition_Unlock
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.ACT_WorkflowDefinition_Unlock

## Summary

- Likely acts as a UI entry or navigation handler because it shows WorkflowCommons.WorkflowDefinition_ActionConfirmation.
- L0: [abstract](workflowcommons-act-workflowdefinition-unlock.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-workflowdefinition-unlock.json)

## Main Steps

- retrieve WorkflowDefinition over association WorkflowDefinitionHelper_WorkflowDefinition from WorkflowDefinitionHelper
- $WorkflowDefinitionHelper/UpdateInstances Resume instances? expression=$WorkflowDefinitionHelper/UpdateInstances
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

- nodeId=34cb24f4-a612-486f-99c1-23e9c9fb3bd7; sourceKind=Association; association=WorkflowDefinitionHelper_WorkflowDefinition; summary=retrieve WorkflowDefinition over association WorkflowDefinitionHelper_WorkflowDefinition from WorkflowDefinitionHelper
- nodeId=e3c359c6-3e88-4f01-af6f-42edf1b4e52f; caption=Resume instances?; expression=$WorkflowDefinitionHelper/UpdateInstances Resume instances? expression=$WorkflowDefinitionHelper/UpdateInstances

## Warnings/Unknowns

- Rollback hint detected in node detail.
- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-workflowdefinition-unlock.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
