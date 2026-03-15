---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.ACT_Workflow_JumpTo
stableId: 4511a334-a9eb-4565-b221-5eaec9e1e137
slug: workflowcommons-act-workflow-jumpto
layer: L1
l0: workflowcommons-act-workflow-jumpto.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-workflow-jumpto.json
l2Logical: flow:WorkflowCommons.ACT_Workflow_JumpTo
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.ACT_Workflow_JumpTo

## Summary

- Likely acts as a UI entry or navigation handler because it shows WorkflowCommons.Workflow_JumpTo_Options.
- L0: [abstract](workflowcommons-act-workflow-jumpto.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-workflow-jumpto.json)

## Main Steps

- $Workflow/CanApplyJumpTo CanApplyJumpTo expression=$Workflow/CanApplyJumpTo
- ShowPageAction: show page WorkflowCommons.Workflow_JumpTo_Options show page WorkflowCommons.Workflow_JumpTo_Options

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: Shows WorkflowCommons.Workflow_JumpTo_Options.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- WorkflowCommons.Workflow_JumpTo_Options

## Important Retrieves/Decisions/Mutations

- nodeId=5dfc2b82-bdf8-420a-891f-6c2a73f52d34; caption=CanApplyJumpTo; expression=$Workflow/CanApplyJumpTo CanApplyJumpTo expression=$Workflow/CanApplyJumpTo

## Warnings/Unknowns

- Rollback hint detected in node detail.
- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-workflow-jumpto.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
