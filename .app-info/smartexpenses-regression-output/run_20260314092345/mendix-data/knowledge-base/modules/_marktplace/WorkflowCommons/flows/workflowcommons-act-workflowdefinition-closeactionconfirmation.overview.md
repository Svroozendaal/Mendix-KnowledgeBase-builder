---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.ACT_WorkflowDefinition_CloseActionConfirmation
stableId: 100c4427-1ebc-4fae-bc23-70e0e0ebb677
slug: workflowcommons-act-workflowdefinition-closeactionconfirmation
layer: L1
l0: workflowcommons-act-workflowdefinition-closeactionconfirmation.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-workflowdefinition-closeactionconfirmation.json
l2Logical: flow:WorkflowCommons.ACT_WorkflowDefinition_CloseActionConfirmation
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.ACT_WorkflowDefinition_CloseActionConfirmation

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](workflowcommons-act-workflowdefinition-closeactionconfirmation.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-workflowdefinition-closeactionconfirmation.json)

## Main Steps

- ChangeObjectAction: change WorkflowDefinition (refreshInClient=true) change WorkflowDefinition (refreshInClient=true)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=3f3b587f-6ec4-4dea-9f79-b415dc557af8; actionKind=Change; members=refreshInClient=true; summary=ChangeObjectAction: change WorkflowDefinition (refreshInClient=true) change WorkflowDefinition (refreshInClient=true)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-workflowdefinition-closeactionconfirmation.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
