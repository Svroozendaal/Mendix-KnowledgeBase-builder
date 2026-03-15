---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.DS_TaskCount
stableId: 29ed64fd-c239-4d28-a0db-8bbcc346ae1f
slug: workflowcommons-ds-taskcount
layer: L1
l0: workflowcommons-ds-taskcount.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ds-taskcount.json
l2Logical: flow:WorkflowCommons.DS_TaskCount
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.DS_TaskCount

## Summary

- Likely acts as a save, process, or background step for WorkflowCommons.TaskCount because it mutates data without showing a page.
- L0: [abstract](workflowcommons-ds-taskcount.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ds-taskcount.json)

## Main Steps

- CreateObjectAction: create WorkflowCommons.TaskCount as NewTaskCount create WorkflowCommons.TaskCount as NewTaskCount

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- WorkflowCommons.TaskCount

## Called / Called By

- Calls: WorkflowCommons.SUB_TaskCount_Update
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=a7803836-978a-4cf7-965b-1cac115d09eb; actionKind=Create; entity=WorkflowCommons.TaskCount; summary=CreateObjectAction: create WorkflowCommons.TaskCount as NewTaskCount create WorkflowCommons.TaskCount as NewTaskCount

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ds-taskcount.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
