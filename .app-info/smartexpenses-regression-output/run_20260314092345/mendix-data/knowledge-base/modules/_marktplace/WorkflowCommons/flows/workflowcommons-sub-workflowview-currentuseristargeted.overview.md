---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_WorkflowView_CurrentUserIsTargeted
stableId: 2e475b1a-fad4-463b-aab8-0bbd2158be1f
slug: workflowcommons-sub-workflowview-currentuseristargeted
layer: L1
l0: workflowcommons-sub-workflowview-currentuseristargeted.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowview-currentuseristargeted.json
l2Logical: flow:WorkflowCommons.SUB_WorkflowView_CurrentUserIsTargeted
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_WorkflowView_CurrentUserIsTargeted

## Summary

- Likely acts as a save, process, or background step for WorkflowCommons.UserTaskView because it mutates data without showing a page.
- L0: [abstract](workflowcommons-sub-workflowview-currentuseristargeted.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowview-currentuseristargeted.json)

## Main Steps

- retrieve UserTaskViewList from WorkflowCommons.UserTaskView
- CreateVariableAction: create variable InTargetUsers=$TaskCount >= 1 create variable InTargetUsers=$TaskCount >= 1

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.SUB_WorkflowView_CommentAttachment_Validate.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- WorkflowCommons.UserTaskView

## Called / Called By

- Calls: none
- Called by: WorkflowCommons.SUB_WorkflowView_CommentAttachment_Validate

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=b150fbc0-2138-4ee6-93c5-f3d4d3d8ce95; sourceKind=Database; entity=WorkflowCommons.UserTaskView; summary=retrieve UserTaskViewList from WorkflowCommons.UserTaskView
- nodeId=a605eecc-af60-4035-84e2-e2f6f7c263f8; actionKind=Create; summary=CreateVariableAction: create variable InTargetUsers=$TaskCount >= 1 create variable InTargetUsers=$TaskCount >= 1

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowview-currentuseristargeted.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
