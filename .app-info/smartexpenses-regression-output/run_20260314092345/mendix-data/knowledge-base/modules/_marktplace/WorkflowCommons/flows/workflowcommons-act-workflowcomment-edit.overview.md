---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.ACT_WorkflowComment_Edit
stableId: d1b391d2-8d3d-4ade-9b85-c913381b762c
slug: workflowcommons-act-workflowcomment-edit
layer: L1
l0: workflowcommons-act-workflowcomment-edit.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-workflowcomment-edit.json
l2Logical: flow:WorkflowCommons.ACT_WorkflowComment_Edit
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.ACT_WorkflowComment_Edit

## Summary

- Likely acts as a UI entry or navigation handler because it shows WorkflowCommons.WorkflowCommentHelper_Edit.
- L0: [abstract](workflowcommons-act-workflowcomment-edit.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-workflowcomment-edit.json)

## Main Steps

- $WorkflowComment != empty Access? expression=$WorkflowComment != empty
- ShowPageAction: show page WorkflowCommons.WorkflowCommentHelper_Edit show page WorkflowCommons.WorkflowCommentHelper_Edit
- CreateObjectAction: create WorkflowCommons.WorkflowCommentHelper as NewWorkflowCommentHelper (WorkflowCommentHelper_WorkflowComment=$WorkflowComment, Content=$WorkflowComment/Content) create WorkflowCommons.WorkflowCommentHelper as NewWorkflowCommentHelper (WorkflowCommentHelper_WorkflowComment=$WorkflowComment, Content=$WorkflowComment/Content)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: Shows WorkflowCommons.WorkflowCommentHelper_Edit.

## Key Entities Touched

- WorkflowCommons.WorkflowCommentHelper

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- WorkflowCommons.WorkflowCommentHelper_Edit

## Important Retrieves/Decisions/Mutations

- nodeId=8fb49b98-38d6-4789-a6c0-0d02f32c0e5f; caption=Access?; expression=$WorkflowComment != empty Access? expression=$WorkflowComment != empty
- nodeId=4783a1ac-d84f-47fe-9327-56110a04e4e3; actionKind=Create; entity=WorkflowCommons.WorkflowCommentHelper; members=WorkflowCommentHelper_WorkflowComment=$WorkflowComment, Content=$WorkflowComment/Content; summary=CreateObjectAction: create WorkflowCommons.WorkflowCommentHelper as NewWorkflowCommentHelper (WorkflowCommentHelper_WorkflowComment=$WorkflowComment, Content=$WorkflowComment/Content) create WorkflowCommons.WorkflowCommentHelper as NewWorkflowCommentHelper (WorkflowCommentHelper_WorkflowComment=$WorkflowComment, Content=$WorkflowComment/Content)

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-workflowcomment-edit.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
