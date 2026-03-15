---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_WorkflowAuditTrailRecord_DeleteByKey
stableId: 872f2688-f1bd-435a-9ffd-baf97e365b53
slug: workflowcommons-sub-workflowaudittrailrecord-deletebykey
layer: L1
l0: workflowcommons-sub-workflowaudittrailrecord-deletebykey.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowaudittrailrecord-deletebykey.json
l2Logical: flow:WorkflowCommons.SUB_WorkflowAuditTrailRecord_DeleteByKey
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_WorkflowAuditTrailRecord_DeleteByKey

## Summary

- Likely acts as a save, process, or background step for WorkflowCommons.WorkflowAuditTrailRecord because it mutates data without showing a page.
- L0: [abstract](workflowcommons-sub-workflowaudittrailrecord-deletebykey.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowaudittrailrecord-deletebykey.json)

## Main Steps

- retrieve WorkflowAuditTrailRecordList from WorkflowCommons.WorkflowAuditTrailRecord
- DeleteAction: delete WorkflowAuditTrailRecordList (refreshInClient=false) delete WorkflowAuditTrailRecordList (refreshInClient=false)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.SUB_WorkflowAuditTrailRecord_CleanUp.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- WorkflowCommons.WorkflowAuditTrailRecord

## Called / Called By

- Calls: none
- Called by: WorkflowCommons.SUB_WorkflowAuditTrailRecord_CleanUp

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=f4e0ccdf-68d0-4695-81e7-a51ad62d48cb; sourceKind=Database; entity=WorkflowCommons.WorkflowAuditTrailRecord; summary=retrieve WorkflowAuditTrailRecordList from WorkflowCommons.WorkflowAuditTrailRecord
- nodeId=cedd7d5a-37dc-402b-a1ef-b61c47208a84; actionKind=Delete; members=refreshInClient=false; summary=DeleteAction: delete WorkflowAuditTrailRecordList (refreshInClient=false) delete WorkflowAuditTrailRecordList (refreshInClient=false)

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowaudittrailrecord-deletebykey.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
