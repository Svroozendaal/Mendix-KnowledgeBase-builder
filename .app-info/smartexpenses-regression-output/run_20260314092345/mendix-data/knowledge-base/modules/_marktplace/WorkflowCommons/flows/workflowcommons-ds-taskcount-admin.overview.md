---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.DS_TaskCount_Admin
stableId: 550f838f-fd89-4f58-a301-219e4ef15b0f
slug: workflowcommons-ds-taskcount-admin
layer: L1
l0: workflowcommons-ds-taskcount-admin.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ds-taskcount-admin.json
l2Logical: flow:WorkflowCommons.DS_TaskCount_Admin
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.DS_TaskCount_Admin

## Summary

- Likely acts as a save, process, or background step for WorkflowCommons.TaskCount because it mutates data without showing a page.
- L0: [abstract](workflowcommons-ds-taskcount-admin.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ds-taskcount-admin.json)

## Main Steps

- CreateObjectAction: create WorkflowCommons.TaskCount as NewTaskCount create WorkflowCommons.TaskCount as NewTaskCount

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- WorkflowCommons.TaskCount

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=e006ed4f-d0da-4551-a0ec-db79742b3b9b; actionKind=Create; entity=WorkflowCommons.TaskCount; summary=CreateObjectAction: create WorkflowCommons.TaskCount as NewTaskCount create WorkflowCommons.TaskCount as NewTaskCount

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ds-taskcount-admin.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
