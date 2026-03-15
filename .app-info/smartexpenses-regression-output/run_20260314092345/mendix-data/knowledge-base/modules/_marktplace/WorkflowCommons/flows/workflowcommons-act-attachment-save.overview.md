---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.ACT_Attachment_Save
stableId: 0e026326-bc8b-4e9c-b976-d1cb6236442e
slug: workflowcommons-act-attachment-save
layer: L1
l0: workflowcommons-act-attachment-save.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-attachment-save.json
l2Logical: flow:WorkflowCommons.ACT_Attachment_Save
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.ACT_Attachment_Save

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](workflowcommons-act-attachment-save.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-attachment-save.json)

## Main Steps

- retrieve WorkflowComment over association WorkflowAttachment_WorkflowComment from WorkflowAttachment
- retrieve WorkflowView over association WorkflowComment_WorkflowView from WorkflowComment
- $WorkflowAttachment/HasContents Has content? expression=$WorkflowAttachment/HasContents
- $Valid Valid? expression=$Valid
- CommitAction: commit WorkflowAttachment (refreshInClient=true, withEvents=true) commit WorkflowAttachment (refreshInClient=true, withEvents=true)
- DeleteAction: delete WorkflowAttachment (refreshInClient=true) delete WorkflowAttachment (refreshInClient=true)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: WorkflowCommons.SUB_WorkflowView_CommentAttachment_Validate
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=c311cd47-5aa6-482e-9fc6-1b01707e6651; sourceKind=Association; association=WorkflowAttachment_WorkflowComment; summary=retrieve WorkflowComment over association WorkflowAttachment_WorkflowComment from WorkflowAttachment
- nodeId=6769cb27-0cf0-4534-8ed7-71ad74265898; sourceKind=Association; association=WorkflowComment_WorkflowView; summary=retrieve WorkflowView over association WorkflowComment_WorkflowView from WorkflowComment
- nodeId=3acaac26-4ede-4df2-b67a-fb0ecab0d02b; caption=Has content?; expression=$WorkflowAttachment/HasContents Has content? expression=$WorkflowAttachment/HasContents
- nodeId=78623a72-6e8b-4355-9706-4b83ea37bbd0; caption=Valid?; expression=$Valid Valid? expression=$Valid
- nodeId=c461e03c-581c-481b-96c8-5e5cb30b40e6; actionKind=Commit; members=refreshInClient=true, withEvents=true; summary=CommitAction: commit WorkflowAttachment (refreshInClient=true, withEvents=true) commit WorkflowAttachment (refreshInClient=true, withEvents=true)
- nodeId=8425dddf-6313-4473-a1d3-a6814589a121; actionKind=Delete; members=refreshInClient=true; summary=DeleteAction: delete WorkflowAttachment (refreshInClient=true) delete WorkflowAttachment (refreshInClient=true)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-attachment-save.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
