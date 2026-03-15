---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.ACT_WorkflowCommentHelper_SaveNew
stableId: 9ef58118-d00f-4358-ab6f-d8fd859126bd
slug: workflowcommons-act-workflowcommenthelper-savenew
layer: L1
l0: workflowcommons-act-workflowcommenthelper-savenew.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-workflowcommenthelper-savenew.json
l2Logical: flow:WorkflowCommons.ACT_WorkflowCommentHelper_SaveNew
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.ACT_WorkflowCommentHelper_SaveNew

## Summary

- Likely acts as a save, process, or background step for WorkflowCommons.WorkflowComment because it mutates data without showing a page.
- L0: [abstract](workflowcommons-act-workflowcommenthelper-savenew.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-workflowcommenthelper-savenew.json)

## Main Steps

- $WorkflowCommentHelper/Content != empty and trim($WorkflowCommentHelper/Content) != '' Has content? expression=$WorkflowCommentHelper/Content != empty and trim($WorkflowCommentHelper/Content) != ''
- $Valid Valid? expression=$Valid
- ChangeObjectAction: change WorkflowCommentHelper (Content=empty; refreshInClient=false) change WorkflowCommentHelper (Content=empty; refreshInClient=false)
- CreateObjectAction: create WorkflowCommons.WorkflowComment as NewWorkflowComment (Content=$WorkflowCommentHelper/Content, WorkflowComment_WorkflowView=$WorkflowView, WorkflowComment_Workflow=$WorkflowView/WorkflowCommons.WorkflowView_Workflow) create WorkflowCommons.WorkflowComment as NewWorkflowComment (Content=$WorkflowCommentHelper/Content, WorkflowComment_WorkflowView=$WorkflowView, WorkflowComment_Workflow=$WorkflowView/WorkflowCommons.WorkflowView_Workflow)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- WorkflowCommons.WorkflowComment

## Called / Called By

- Calls: WorkflowCommons.SUB_WorkflowView_CommentAttachment_Validate
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=1b6555b8-10f1-41a8-9b59-13bd1fe368a2; caption=Has content?; expression=$WorkflowCommentHelper/Content != empty and trim($WorkflowCommentHelper/Content) != '' Has content? expression=$WorkflowCommentHelper/Content != empty and trim($WorkflowCommentHelper/Content) != ''
- nodeId=df4ab71f-e7af-4234-821e-c9b680555d6d; caption=Valid?; expression=$Valid Valid? expression=$Valid
- nodeId=7b0d6a1b-596f-4c82-8044-52bc4418e8f5; actionKind=Change; members=Content=empty; refreshInClient=false; summary=ChangeObjectAction: change WorkflowCommentHelper (Content=empty; refreshInClient=false) change WorkflowCommentHelper (Content=empty; refreshInClient=false)
- nodeId=2480f892-f523-46db-a305-a87e93eac96e; actionKind=Create; entity=WorkflowCommons.WorkflowComment; members=Content=$WorkflowCommentHelper/Content, WorkflowComment_WorkflowView=$WorkflowView, WorkflowComment_Workflow=$WorkflowView/WorkflowCommons.WorkflowView_Workflow; summary=CreateObjectAction: create WorkflowCommons.WorkflowComment as NewWorkflowComment (Content=$WorkflowCommentHelper/Content, WorkflowComment_WorkflowView=$WorkflowView, WorkflowComment_Workflow=$WorkflowView/WorkflowCommons.WorkflowView_Workflow) create WorkflowCommons.WorkflowComment as NewWorkflowComment (Content=$WorkflowCommentHelper/Content, WorkflowComment_WorkflowView=$WorkflowView, WorkflowComment_Workflow=$WorkflowView/WorkflowCommons.WorkflowView_Workflow)

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-workflowcommenthelper-savenew.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
