---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.ACT_Attachment_Save_Admin
stableId: 7bc14ed0-b9c3-4dbf-a8b8-c4d0dc3d6e7c
slug: workflowcommons-act-attachment-save-admin
layer: L1
l0: workflowcommons-act-attachment-save-admin.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-attachment-save-admin.json
l2Logical: flow:WorkflowCommons.ACT_Attachment_Save_Admin
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.ACT_Attachment_Save_Admin

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](workflowcommons-act-attachment-save-admin.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-attachment-save-admin.json)

## Main Steps

- $WorkflowAttachment/HasContents Has content? expression=$WorkflowAttachment/HasContents
- CommitAction: commit WorkflowAttachment (refreshInClient=true, withEvents=true) commit WorkflowAttachment (refreshInClient=true, withEvents=true)

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

- nodeId=a8647ed7-623a-4caf-b001-a9797678e0fa; caption=Has content?; expression=$WorkflowAttachment/HasContents Has content? expression=$WorkflowAttachment/HasContents
- nodeId=f6579b63-d525-47a0-bdea-7e434fcf946b; actionKind=Commit; members=refreshInClient=true, withEvents=true; summary=CommitAction: commit WorkflowAttachment (refreshInClient=true, withEvents=true) commit WorkflowAttachment (refreshInClient=true, withEvents=true)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-attachment-save-admin.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
