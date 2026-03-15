---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_WorkflowAuditTrailRecord_CleanUp
stableId: cbe7c8ec-4cf5-4af6-9c83-c90f92f56f1e
slug: workflowcommons-sub-workflowaudittrailrecord-cleanup
layer: L1
l0: workflowcommons-sub-workflowaudittrailrecord-cleanup.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowaudittrailrecord-cleanup.json
l2Logical: flow:WorkflowCommons.SUB_WorkflowAuditTrailRecord_CleanUp
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_WorkflowAuditTrailRecord_CleanUp

## Summary

- Likely acts as a save, process, or background step for WorkflowCommons.WorkflowAuditTrailRecord because it mutates data without showing a page.
- L0: [abstract](workflowcommons-sub-workflowaudittrailrecord-cleanup.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowaudittrailrecord-cleanup.json)

## Main Steps

- retrieve WorkflowAuditTrailRecordList from WorkflowCommons.WorkflowAuditTrailRecord
- $WorkflowInstanceCount = $Amount More? expression=$WorkflowInstanceCount = $Amount
- ChangeVariableAction: change variable TotalRecordCount=$TotalRecordCount + $RecordCount change variable TotalRecordCount=$TotalRecordCount + $RecordCount
- ChangeVariableAction: change variable TotalWorkflowInstanceCount=$TotalWorkflowInstanceCount + $WorkflowInstanceCount change variable TotalWorkflowInstanceCount=$TotalWorkflowInstanceCount + $WorkflowInstanceCount

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.SE_WorkflowAuditTrailRecord_CleanUp.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- WorkflowCommons.WorkflowAuditTrailRecord

## Called / Called By

- Calls: WorkflowCommons.SUB_WorkflowAuditTrailRecord_DeleteByKey
- Called by: WorkflowCommons.SE_WorkflowAuditTrailRecord_CleanUp

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=b10a031c-1802-4b5e-9862-b09ec59b2e05; sourceKind=Database; entity=WorkflowCommons.WorkflowAuditTrailRecord; summary=retrieve WorkflowAuditTrailRecordList from WorkflowCommons.WorkflowAuditTrailRecord
- nodeId=076b5ee0-ec03-4327-876b-2023d73e41d1; caption=More?; expression=$WorkflowInstanceCount = $Amount More? expression=$WorkflowInstanceCount = $Amount
- nodeId=71a6e4af-8d1d-45c7-a2fa-e54302b4e92a; actionKind=Change; summary=ChangeVariableAction: change variable TotalRecordCount=$TotalRecordCount + $RecordCount change variable TotalRecordCount=$TotalRecordCount + $RecordCount
- nodeId=e0d0bf8b-e4f7-4f11-88ec-4aba3083f326; actionKind=Change; summary=ChangeVariableAction: change variable TotalWorkflowInstanceCount=$TotalWorkflowInstanceCount + $WorkflowInstanceCount change variable TotalWorkflowInstanceCount=$TotalWorkflowInstanceCount + $WorkflowInstanceCount
- nodeId=ee27d6e8-ca40-4e2f-8f0d-c3860b428b33; actionKind=Create; summary=CreateVariableAction: create variable Amount=100 create variable Amount=100
- nodeId=bb716691-7a1f-4c3a-9646-1682ef6d8666; actionKind=Create; members=[%CurrentDateTime%],-$RetentionInDays; summary=CreateVariableAction: create variable RetentionPeriod=addDays([%CurrentDateTime%],-$RetentionInDays) create variable RetentionPeriod=addDays([%CurrentDateTime%],-$RetentionInDays)
- nodeId=62014544-fb2f-4b23-9eba-79edc0854f83; actionKind=Create; summary=CreateVariableAction: create variable TotalRecordCount=0 create variable TotalRecordCount=0
- nodeId=26a1bce0-9a4b-4a97-b8ad-2af714e5ed6b; actionKind=Create; summary=CreateVariableAction: create variable TotalWorkflowInstanceCount=0 create variable TotalWorkflowInstanceCount=0

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowaudittrailrecord-cleanup.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
