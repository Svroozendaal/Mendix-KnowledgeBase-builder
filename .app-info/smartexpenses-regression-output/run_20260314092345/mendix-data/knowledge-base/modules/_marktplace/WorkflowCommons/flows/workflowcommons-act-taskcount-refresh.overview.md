---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.ACT_TaskCount_Refresh
stableId: c4ecee06-6d1f-420c-863c-a678f08f7932
slug: workflowcommons-act-taskcount-refresh
layer: L1
l0: workflowcommons-act-taskcount-refresh.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-taskcount-refresh.json
l2Logical: flow:WorkflowCommons.ACT_TaskCount_Refresh
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.ACT_TaskCount_Refresh

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](workflowcommons-act-taskcount-refresh.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-taskcount-refresh.json)

## Main Steps

- ChangeObjectAction: change TaskCount (refreshInClient=true) change TaskCount (refreshInClient=true)

## Trigger/Input/Output Context

- Kind: Nanoflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: WorkflowCommons.ACT_TaskCount_Update
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=a45dadfa-3ffe-42f4-9cda-8ee4876165ce; actionKind=Change; members=refreshInClient=true; summary=ChangeObjectAction: change TaskCount (refreshInClient=true) change TaskCount (refreshInClient=true)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-taskcount-refresh.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
