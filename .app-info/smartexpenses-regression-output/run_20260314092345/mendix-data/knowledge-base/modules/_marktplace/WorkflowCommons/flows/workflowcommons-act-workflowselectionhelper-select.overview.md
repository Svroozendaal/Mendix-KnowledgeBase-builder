---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.ACT_WorkflowSelectionHelper_Select
stableId: 11815f82-2b69-41d5-90b2-71cc0bcd2d6d
slug: workflowcommons-act-workflowselectionhelper-select
layer: L1
l0: workflowcommons-act-workflowselectionhelper-select.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-workflowselectionhelper-select.json
l2Logical: flow:WorkflowCommons.ACT_WorkflowSelectionHelper_Select
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.ACT_WorkflowSelectionHelper_Select

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](workflowcommons-act-workflowselectionhelper-select.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-workflowselectionhelper-select.json)

## Main Steps

- ChangeObjectAction: change WorkflowSelectionHelper (WorkflowSelectionHelper_WorkflowView=$WorkflowView; refreshInClient=true) change WorkflowSelectionHelper (WorkflowSelectionHelper_WorkflowView=$WorkflowView; refreshInClient=true)

## Trigger/Input/Output Context

- Kind: Nanoflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=feef7048-e579-48bb-9db4-2672651072de; actionKind=Change; members=WorkflowSelectionHelper_WorkflowView=$WorkflowView; refreshInClient=true; summary=ChangeObjectAction: change WorkflowSelectionHelper (WorkflowSelectionHelper_WorkflowView=$WorkflowView; refreshInClient=true) change WorkflowSelectionHelper (WorkflowSelectionHelper_WorkflowView=$WorkflowView; refreshInClient=true)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-workflowselectionhelper-select.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
