---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.ACT_WorkflowCommentHelper_SaveNew_Admin
stableId: 9120be37-1470-4299-a26a-e9a56f9e7bbf
slug: workflowcommons-act-workflowcommenthelper-savenew-admin
layer: L1
l0: workflowcommons-act-workflowcommenthelper-savenew-admin.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-workflowcommenthelper-savenew-admin.json
l2Logical: flow:WorkflowCommons.ACT_WorkflowCommentHelper_SaveNew_Admin
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.ACT_WorkflowCommentHelper_SaveNew_Admin

## Summary

- Likely acts as a save, process, or background step for WorkflowCommons.WorkflowComment because it mutates data without showing a page.
- L0: [abstract](workflowcommons-act-workflowcommenthelper-savenew-admin.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-workflowcommenthelper-savenew-admin.json)

## Main Steps

- $WorkflowCommentHelper/Content != empty and trim($WorkflowCommentHelper/Content) != '' Has content? expression=$WorkflowCommentHelper/Content != empty and trim($WorkflowCommentHelper/Content) != ''
- ChangeObjectAction: change WorkflowCommentHelper (Content=empty; refreshInClient=false) change WorkflowCommentHelper (Content=empty; refreshInClient=false)
- CreateObjectAction: create WorkflowCommons.WorkflowComment as NewWorkflowComment (Content=$WorkflowCommentHelper/Content, WorkflowComment_WorkflowView=$WorkflowView, WorkflowComment_Workflow=$WorkflowView/WorkflowCommons.WorkflowView_Workflow) create WorkflowCommons.WorkflowComment as NewWorkflowComment (Content=$WorkflowCommentHelper/Content, WorkflowComment_WorkflowView=$WorkflowView, WorkflowComment_Workflow=$WorkflowView/WorkflowCommons.WorkflowView_Workflow)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- WorkflowCommons.WorkflowComment

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=88cd5965-800d-4700-beba-1e8767f5224d; caption=Has content?; expression=$WorkflowCommentHelper/Content != empty and trim($WorkflowCommentHelper/Content) != '' Has content? expression=$WorkflowCommentHelper/Content != empty and trim($WorkflowCommentHelper/Content) != ''
- nodeId=a85857ab-2570-4713-af18-656288ff2200; actionKind=Change; members=Content=empty; refreshInClient=false; summary=ChangeObjectAction: change WorkflowCommentHelper (Content=empty; refreshInClient=false) change WorkflowCommentHelper (Content=empty; refreshInClient=false)
- nodeId=27d8e3f9-1ad1-4c69-b7ec-075fbc9f0fed; actionKind=Create; entity=WorkflowCommons.WorkflowComment; members=Content=$WorkflowCommentHelper/Content, WorkflowComment_WorkflowView=$WorkflowView, WorkflowComment_Workflow=$WorkflowView/WorkflowCommons.WorkflowView_Workflow; summary=CreateObjectAction: create WorkflowCommons.WorkflowComment as NewWorkflowComment (Content=$WorkflowCommentHelper/Content, WorkflowComment_WorkflowView=$WorkflowView, WorkflowComment_Workflow=$WorkflowView/WorkflowCommons.WorkflowView_Workflow) create WorkflowCommons.WorkflowComment as NewWorkflowComment (Content=$WorkflowCommentHelper/Content, WorkflowComment_WorkflowView=$WorkflowView, WorkflowComment_Workflow=$WorkflowView/WorkflowCommons.WorkflowView_Workflow)

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-workflowcommenthelper-savenew-admin.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
