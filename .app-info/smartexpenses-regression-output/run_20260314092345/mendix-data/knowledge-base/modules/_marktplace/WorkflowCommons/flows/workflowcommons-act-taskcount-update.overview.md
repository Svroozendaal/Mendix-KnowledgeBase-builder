---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.ACT_TaskCount_Update
stableId: f1dfd09d-c00f-4001-9d23-52fad68f25fc
slug: workflowcommons-act-taskcount-update
layer: L1
l0: workflowcommons-act-taskcount-update.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-taskcount-update.json
l2Logical: flow:WorkflowCommons.ACT_TaskCount_Update
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.ACT_TaskCount_Update

## Summary

- Likely orchestrates downstream flow calls without direct UI output.
- L0: [abstract](workflowcommons-act-taskcount-update.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-taskcount-update.json)

## Main Steps

- No compact step summary was derivable from the exported flow actions.

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.ACT_TaskCount_Refresh.
- Output/UI context: No page output was exported; this likely delegates work to downstream flows.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: WorkflowCommons.SUB_TaskCount_Update
- Called by: WorkflowCommons.ACT_TaskCount_Refresh

## Shown Pages

- No ShowPageAction was exported for this flow; it may serve validation, background processing, or delegate work to other flows.

## Important Retrieves/Decisions/Mutations

- No retrieve, decision, or mutation metadata was exported for this flow; inspect L2 JSON if node-level evidence matters.

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-taskcount-update.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
