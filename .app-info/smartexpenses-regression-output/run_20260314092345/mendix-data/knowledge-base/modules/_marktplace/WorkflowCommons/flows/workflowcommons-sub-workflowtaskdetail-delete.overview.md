---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_WorkflowTaskDetail_Delete
stableId: 4fb01146-5c8d-4728-9928-badaccd0ba01
slug: workflowcommons-sub-workflowtaskdetail-delete
layer: L1
l0: workflowcommons-sub-workflowtaskdetail-delete.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowtaskdetail-delete.json
l2Logical: flow:WorkflowCommons.SUB_WorkflowTaskDetail_Delete
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_WorkflowTaskDetail_Delete

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](workflowcommons-sub-workflowtaskdetail-delete.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowtaskdetail-delete.json)

## Main Steps

- retrieve WorkflowTaskDetailList over association WorkflowTaskDetail_DashboardContext from DashboardContext
- DeleteAction: delete WorkflowTaskDetailList (refreshInClient=false) delete WorkflowTaskDetailList (refreshInClient=false)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.SUB_WorkflowTaskDetail_CreateOrUpdate.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: WorkflowCommons.SUB_WorkflowTaskDetail_CreateOrUpdate

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=98b71cf8-4930-4137-b339-9229f59cd1b4; sourceKind=Association; association=WorkflowTaskDetail_DashboardContext; summary=retrieve WorkflowTaskDetailList over association WorkflowTaskDetail_DashboardContext from DashboardContext
- nodeId=2aaaa5e3-dbef-4dc5-8422-834fcdfe087e; actionKind=Delete; members=refreshInClient=false; summary=DeleteAction: delete WorkflowTaskDetailList (refreshInClient=false) delete WorkflowTaskDetailList (refreshInClient=false)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowtaskdetail-delete.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
