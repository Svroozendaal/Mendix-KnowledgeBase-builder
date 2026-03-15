---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.ACT_WorkflowDefinition_CleanUp_Open
stableId: 585fdd22-1769-4f04-962d-c7f0e8c02584
slug: workflowcommons-act-workflowdefinition-cleanup-open
layer: L1
l0: workflowcommons-act-workflowdefinition-cleanup-open.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-workflowdefinition-cleanup-open.json
l2Logical: flow:WorkflowCommons.ACT_WorkflowDefinition_CleanUp_Open
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.ACT_WorkflowDefinition_CleanUp_Open

## Summary

- Likely acts as a UI entry or navigation handler because it shows WorkflowCommons.WorkflowDefinition_CleanUp.
- L0: [abstract](workflowcommons-act-workflowdefinition-cleanup-open.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-workflowdefinition-cleanup-open.json)

## Main Steps

- ShowPageAction: show page WorkflowCommons.WorkflowDefinition_CleanUp show page WorkflowCommons.WorkflowDefinition_CleanUp
- CreateObjectAction: create WorkflowCommons.CleanupHelper as NewCleanupHelper (CleanupHelper_WorkflowDefinition=$WorkflowDefinition) create WorkflowCommons.CleanupHelper as NewCleanupHelper (CleanupHelper_WorkflowDefinition=$WorkflowDefinition)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: Shows WorkflowCommons.WorkflowDefinition_CleanUp.

## Key Entities Touched

- WorkflowCommons.CleanupHelper

## Called / Called By

- Calls: WorkflowCommons.OCh_CleanupHelper_UpdateCount
- Called by: none

## Shown Pages

- WorkflowCommons.WorkflowDefinition_CleanUp

## Important Retrieves/Decisions/Mutations

- nodeId=d071ec41-fa71-495b-9cd5-45b9563dad02; actionKind=Create; entity=WorkflowCommons.CleanupHelper; members=CleanupHelper_WorkflowDefinition=$WorkflowDefinition; summary=CreateObjectAction: create WorkflowCommons.CleanupHelper as NewCleanupHelper (CleanupHelper_WorkflowDefinition=$WorkflowDefinition) create WorkflowCommons.CleanupHelper as NewCleanupHelper (CleanupHelper_WorkflowDefinition=$WorkflowDefinition)

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-workflowdefinition-cleanup-open.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
