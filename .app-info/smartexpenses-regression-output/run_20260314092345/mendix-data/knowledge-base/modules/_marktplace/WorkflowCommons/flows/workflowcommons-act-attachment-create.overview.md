---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.ACT_Attachment_Create
stableId: 5833c0aa-604a-4c39-8f7c-6470caddc317
slug: workflowcommons-act-attachment-create
layer: L1
l0: workflowcommons-act-attachment-create.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-attachment-create.json
l2Logical: flow:WorkflowCommons.ACT_Attachment_Create
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.ACT_Attachment_Create

## Summary

- Likely acts as a UI entry or navigation handler because it shows WorkflowCommons.WorkflowAttachment_New.
- L0: [abstract](workflowcommons-act-attachment-create.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-attachment-create.json)

## Main Steps

- ShowPageAction: show page WorkflowCommons.WorkflowAttachment_New show page WorkflowCommons.WorkflowAttachment_New
- CreateObjectAction: create WorkflowCommons.WorkflowAttachment as NewWorkflowAttachment (WorkflowAttachment_WorkflowComment=$WorkflowComment) create WorkflowCommons.WorkflowAttachment as NewWorkflowAttachment (WorkflowAttachment_WorkflowComment=$WorkflowComment)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: Shows WorkflowCommons.WorkflowAttachment_New.

## Key Entities Touched

- WorkflowCommons.WorkflowAttachment

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- WorkflowCommons.WorkflowAttachment_New

## Important Retrieves/Decisions/Mutations

- nodeId=83ea947a-24b7-4097-ba76-74422a4944ca; actionKind=Create; entity=WorkflowCommons.WorkflowAttachment; members=WorkflowAttachment_WorkflowComment=$WorkflowComment; summary=CreateObjectAction: create WorkflowCommons.WorkflowAttachment as NewWorkflowAttachment (WorkflowAttachment_WorkflowComment=$WorkflowComment) create WorkflowCommons.WorkflowAttachment as NewWorkflowAttachment (WorkflowAttachment_WorkflowComment=$WorkflowComment)

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-attachment-create.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
