---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.OCh_CleanupHelper_UpdateCount
stableId: b2495b39-86e4-4d25-90f6-d818d90f6644
slug: workflowcommons-och-cleanuphelper-updatecount
layer: L1
l0: workflowcommons-och-cleanuphelper-updatecount.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-och-cleanuphelper-updatecount.json
l2Logical: flow:WorkflowCommons.OCh_CleanupHelper_UpdateCount
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.OCh_CleanupHelper_UpdateCount

## Summary

- Likely acts as a save, process, or background step for WorkflowCommons.WorkflowView because it mutates data without showing a page.
- L0: [abstract](workflowcommons-och-cleanuphelper-updatecount.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-och-cleanuphelper-updatecount.json)

## Main Steps

- retrieve WorkflowDefinition over association CleanupHelper_WorkflowDefinition from CleanupHelper
- retrieve WorkflowViewList from WorkflowCommons.WorkflowView
- $IsValid Valid expression=$IsValid
- ChangeObjectAction: change CleanupHelper (TotalCount=$TotalCount; refreshInClient=true) change CleanupHelper (TotalCount=$TotalCount; refreshInClient=true)
- ChangeObjectAction: change CleanupHelper (TotalCount=0; refreshInClient=true) change CleanupHelper (TotalCount=0; refreshInClient=true)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.ACT_WorkflowDefinition_CleanUp_Open.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- WorkflowCommons.WorkflowView

## Called / Called By

- Calls: WorkflowCommons.SUB_CleanupHelper_Validate
- Called by: WorkflowCommons.ACT_WorkflowDefinition_CleanUp_Open

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=d6714ac8-3384-4cb0-b151-31741207f33c; sourceKind=Association; association=CleanupHelper_WorkflowDefinition; summary=retrieve WorkflowDefinition over association CleanupHelper_WorkflowDefinition from CleanupHelper
- nodeId=0b681e2a-7e56-4bfc-ac61-0fd16ba9ad5d; sourceKind=Database; entity=WorkflowCommons.WorkflowView; summary=retrieve WorkflowViewList from WorkflowCommons.WorkflowView
- nodeId=2bdc10a4-9f05-4aa7-b842-c948abb9153e; caption=Valid; expression=$IsValid Valid expression=$IsValid
- nodeId=29a81707-b20f-4d53-adcd-c45f11f1c4bf; actionKind=Change; members=TotalCount=$TotalCount; refreshInClient=true; summary=ChangeObjectAction: change CleanupHelper (TotalCount=$TotalCount; refreshInClient=true) change CleanupHelper (TotalCount=$TotalCount; refreshInClient=true)
- nodeId=76f1063c-4f7d-4dee-ba5e-ca2fec7e7b06; actionKind=Change; members=TotalCount=0; refreshInClient=true; summary=ChangeObjectAction: change CleanupHelper (TotalCount=0; refreshInClient=true) change CleanupHelper (TotalCount=0; refreshInClient=true)
- nodeId=449ca50d-449c-497a-aada-5b09650f4ddf; actionKind=Create; summary=CreateVariableAction: create variable IgnoreEndDateEnd=$CleanupHelper/EndDateEnd = empty create variable IgnoreEndDateEnd=$CleanupHelper/EndDateEnd = empty
- nodeId=6e3df3d1-3afc-4583-958a-00e8949a4b8c; actionKind=Create; summary=CreateVariableAction: create variable IgnoreEndDateStart=$CleanupHelper/EndDateStart = empty create variable IgnoreEndDateStart=$CleanupHelper/EndDateStart = empty
- nodeId=ba2cca1d-3e94-4949-bbe1-fd9f6daa88a7; actionKind=Create; summary=CreateVariableAction: create variable IgnoreStartDateEnd=$CleanupHelper/StartDateEnd = empty create variable IgnoreStartDateEnd=$CleanupHelper/StartDateEnd = empty

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-och-cleanuphelper-updatecount.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
