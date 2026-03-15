---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_WorkflowView_CommentAttachment_Validate
stableId: cb31dba3-d4c4-45a2-9fb3-0ba2028eb5ec
slug: workflowcommons-sub-workflowview-commentattachment-validate
layer: L1
l0: workflowcommons-sub-workflowview-commentattachment-validate.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowview-commentattachment-validate.json
l2Logical: flow:WorkflowCommons.SUB_WorkflowView_CommentAttachment_Validate
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_WorkflowView_CommentAttachment_Validate

## Summary

- Likely orchestrates downstream flow calls without direct UI output.
- L0: [abstract](workflowcommons-sub-workflowview-commentattachment-validate.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowview-commentattachment-validate.json)

## Main Steps

- $WorkflowView/State = System.WorkflowState.InProgress In progress? expression=$WorkflowView/State = System.WorkflowState.InProgress
- $CurrentUserIsTargeted Target user? expression=$CurrentUserIsTargeted

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.ACT_Attachment_Save, WorkflowCommons.ACT_WorkflowCommentHelper_Edit_Save, WorkflowCommons.ACT_WorkflowCommentHelper_SaveNew.
- Output/UI context: No page output was exported; this likely delegates work to downstream flows.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: WorkflowCommons.SUB_WorkflowView_CurrentUserIsTargeted
- Called by: WorkflowCommons.ACT_Attachment_Save, WorkflowCommons.ACT_WorkflowCommentHelper_Edit_Save, WorkflowCommons.ACT_WorkflowCommentHelper_SaveNew

## Shown Pages

- No ShowPageAction was exported for this flow; it may serve validation, background processing, or delegate work to other flows.

## Important Retrieves/Decisions/Mutations

- nodeId=9f9257f6-c1a5-4806-8b90-137d95451301; caption=In progress?; expression=$WorkflowView/State = System.WorkflowState.InProgress In progress? expression=$WorkflowView/State = System.WorkflowState.InProgress
- nodeId=23a4e87c-5409-4761-ac85-6a12518ae882; caption=Target user?; expression=$CurrentUserIsTargeted Target user? expression=$CurrentUserIsTargeted

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowview-commentattachment-validate.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
