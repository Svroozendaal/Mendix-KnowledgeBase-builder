---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.ACT_TaskAssignmentHelper_Reassign
stableId: ed95987f-f8aa-4850-a8d9-b43062419943
slug: workflowcommons-act-taskassignmenthelper-reassign
layer: L1
l0: workflowcommons-act-taskassignmenthelper-reassign.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-taskassignmenthelper-reassign.json
l2Logical: flow:WorkflowCommons.ACT_TaskAssignmentHelper_Reassign
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.ACT_TaskAssignmentHelper_Reassign

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](workflowcommons-act-taskassignmenthelper-reassign.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-taskassignmenthelper-reassign.json)

## Main Steps

- ChangeObjectAction: change NewAssignee (refreshInClient=true) change NewAssignee (refreshInClient=true)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: WorkflowCommons.SUB_TaskAssignmentHelper_Reassign, WorkflowCommons.SUB_TaskAssignmentHelper_TaskCount
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=1b034477-2ffd-42d7-9ae9-d666203a8e5b; actionKind=Change; members=refreshInClient=true; summary=ChangeObjectAction: change NewAssignee (refreshInClient=true) change NewAssignee (refreshInClient=true)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-taskassignmenthelper-reassign.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
