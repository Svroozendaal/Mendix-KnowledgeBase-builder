---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_WorkflowView_UpdateKey
stableId: 25923e9c-286c-4fcf-93f6-56f70140ffd2
slug: workflowcommons-sub-workflowview-updatekey
layer: L1
l0: workflowcommons-sub-workflowview-updatekey.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowview-updatekey.json
l2Logical: flow:WorkflowCommons.SUB_WorkflowView_UpdateKey
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_WorkflowView_UpdateKey

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](workflowcommons-sub-workflowview-updatekey.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowview-updatekey.json)

## Main Steps

- retrieve Workflow over association WorkflowView_Workflow from WorkflowView
- $WorkflowView/WorkflowCommons.WorkflowView_Workflow != empty Workflow? expression=$WorkflowView/WorkflowCommons.WorkflowView_Workflow != empty
- ChangeObjectAction: change WorkflowView (WorkflowKey=$WorkflowKey; refreshInClient=false) change WorkflowView (WorkflowKey=$WorkflowKey; refreshInClient=false)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.SUB_WorkflowKey_Migrate.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: WorkflowCommons.SUB_WorkflowKey_Migrate

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=9cfa2359-0596-476a-8554-71fa5ebd44a7; sourceKind=Association; association=WorkflowView_Workflow; summary=retrieve Workflow over association WorkflowView_Workflow from WorkflowView
- nodeId=d115be80-51f9-48cd-b0d3-1aaac1a439c5; caption=Workflow?; expression=$WorkflowView/WorkflowCommons.WorkflowView_Workflow != empty Workflow? expression=$WorkflowView/WorkflowCommons.WorkflowView_Workflow != empty
- nodeId=5767c6c9-2bcd-48d9-935c-dcc3a0362f2d; actionKind=Change; members=WorkflowKey=$WorkflowKey; refreshInClient=false; summary=ChangeObjectAction: change WorkflowView (WorkflowKey=$WorkflowKey; refreshInClient=false) change WorkflowView (WorkflowKey=$WorkflowKey; refreshInClient=false)

## Warnings/Unknowns

- Rollback hint detected in node detail.
- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowview-updatekey.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
