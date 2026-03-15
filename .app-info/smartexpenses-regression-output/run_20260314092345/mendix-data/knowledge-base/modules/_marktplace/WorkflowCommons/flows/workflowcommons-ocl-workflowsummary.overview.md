---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.OCl_WorkflowSummary
stableId: a687d3d8-af7e-45b7-a367-97fd422ed364
slug: workflowcommons-ocl-workflowsummary
layer: L1
l0: workflowcommons-ocl-workflowsummary.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ocl-workflowsummary.json
l2Logical: flow:WorkflowCommons.OCl_WorkflowSummary
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.OCl_WorkflowSummary

## Summary

- Likely acts as a UI entry or navigation handler because it shows WorkflowCommons.WorkflowDefinition_View.
- L0: [abstract](workflowcommons-ocl-workflowsummary.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ocl-workflowsummary.json)

## Main Steps

- retrieve WorkflowDefinition over association WorkflowSummary_WorkflowDefinition from WorkflowSummary
- ShowPageAction: show page WorkflowCommons.WorkflowDefinition_View show page WorkflowCommons.WorkflowDefinition_View

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: Shows WorkflowCommons.WorkflowDefinition_View.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- WorkflowCommons.WorkflowDefinition_View

## Important Retrieves/Decisions/Mutations

- nodeId=20ed5387-1e8f-49b9-b3b9-3d21459fe917; sourceKind=Association; association=WorkflowSummary_WorkflowDefinition; summary=retrieve WorkflowDefinition over association WorkflowSummary_WorkflowDefinition from WorkflowSummary

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ocl-workflowsummary.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
