---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.ACT_TaskAssignmentHelper_Retarget
stableId: 6f947cb8-c0ba-4ff8-ba45-bc8f3a396dc3
slug: workflowcommons-act-taskassignmenthelper-retarget
layer: L1
l0: workflowcommons-act-taskassignmenthelper-retarget.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-taskassignmenthelper-retarget.json
l2Logical: flow:WorkflowCommons.ACT_TaskAssignmentHelper_Retarget
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.ACT_TaskAssignmentHelper_Retarget

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](workflowcommons-act-taskassignmenthelper-retarget.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-taskassignmenthelper-retarget.json)

## Main Steps

- ChangeObjectAction: change NewTargetUser (refreshInClient=true) change NewTargetUser (refreshInClient=true)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: WorkflowCommons.SUB_TaskAssignmentHelper_Retarget, WorkflowCommons.SUB_TaskAssignmentHelper_TaskCount
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=703b92d5-9dcf-4db5-b67f-09c06925687b; actionKind=Change; members=refreshInClient=true; summary=ChangeObjectAction: change NewTargetUser (refreshInClient=true) change NewTargetUser (refreshInClient=true)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-taskassignmenthelper-retarget.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
