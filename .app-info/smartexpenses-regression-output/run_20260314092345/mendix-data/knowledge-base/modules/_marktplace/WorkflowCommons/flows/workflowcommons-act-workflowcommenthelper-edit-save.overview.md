---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.ACT_WorkflowCommentHelper_Edit_Save
stableId: 1026d263-04d8-4b50-a6f6-9d0c10a3ab1a
slug: workflowcommons-act-workflowcommenthelper-edit-save
layer: L1
l0: workflowcommons-act-workflowcommenthelper-edit-save.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-workflowcommenthelper-edit-save.json
l2Logical: flow:WorkflowCommons.ACT_WorkflowCommentHelper_Edit_Save
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.ACT_WorkflowCommentHelper_Edit_Save

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](workflowcommons-act-workflowcommenthelper-edit-save.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-workflowcommenthelper-edit-save.json)

## Main Steps

- retrieve WorkflowComment over association WorkflowCommentHelper_WorkflowComment from WorkflowCommentHelper
- retrieve WorkflowView over association WorkflowComment_WorkflowView from WorkflowComment
- $WorkflowCommentHelper/Content != empty and trim($WorkflowCommentHelper/Content) != '' Has content? expression=$WorkflowCommentHelper/Content != empty and trim($WorkflowCommentHelper/Content) != ''
- $Valid Valid? expression=$Valid
- ChangeObjectAction: change WorkflowComment (Content=$WorkflowCommentHelper/Content; refreshInClient=true) change WorkflowComment (Content=$WorkflowCommentHelper/Content; refreshInClient=true)

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

- nodeId=4d280a79-2d18-46dd-9102-395de344676a; sourceKind=Association; association=WorkflowCommentHelper_WorkflowComment; summary=retrieve WorkflowComment over association WorkflowCommentHelper_WorkflowComment from WorkflowCommentHelper
- nodeId=95f8b86a-b3cb-4094-8b4c-91c0d7fa4f94; sourceKind=Association; association=WorkflowComment_WorkflowView; summary=retrieve WorkflowView over association WorkflowComment_WorkflowView from WorkflowComment
- nodeId=717fe0b5-c4b0-4cf4-9391-f4e7d4f8d5fa; caption=Has content?; expression=$WorkflowCommentHelper/Content != empty and trim($WorkflowCommentHelper/Content) != '' Has content? expression=$WorkflowCommentHelper/Content != empty and trim($WorkflowCommentHelper/Content) != ''
- nodeId=e4bab920-108e-485e-bce8-8e559312b783; caption=Valid?; expression=$Valid Valid? expression=$Valid
- nodeId=c35780dd-75a5-48cc-b5ae-b965418761b8; actionKind=Change; members=Content=$WorkflowCommentHelper/Content; refreshInClient=true; summary=ChangeObjectAction: change WorkflowComment (Content=$WorkflowCommentHelper/Content; refreshInClient=true) change WorkflowComment (Content=$WorkflowCommentHelper/Content; refreshInClient=true)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-workflowcommenthelper-edit-save.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
