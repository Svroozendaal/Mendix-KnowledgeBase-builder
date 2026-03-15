---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_CleanupHelper_Execute_Workflow
stableId: 170014d6-d272-4a05-9b39-323b25061103
slug: workflowcommons-sub-cleanuphelper-execute-workflow
layer: L1
l0: workflowcommons-sub-cleanuphelper-execute-workflow.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-cleanuphelper-execute-workflow.json
l2Logical: flow:WorkflowCommons.SUB_CleanupHelper_Execute_Workflow
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_CleanupHelper_Execute_Workflow

## Summary

- Likely acts as a save, process, or background step for System.Workflow because it mutates data without showing a page.
- L0: [abstract](workflowcommons-sub-cleanuphelper-execute-workflow.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-cleanuphelper-execute-workflow.json)

## Main Steps

- retrieve WorkflowDefinition over association CleanupHelper_WorkflowDefinition from CleanupHelper
- retrieve WorkflowList from System.Workflow
- $BatchCount = $BatchSize More? expression=$BatchCount = $BatchSize
- ChangeVariableAction: change variable DeletedCount=$DeletedCount + $BatchCount change variable DeletedCount=$DeletedCount + $BatchCount
- CreateVariableAction: create variable BatchSize=500 create variable BatchSize=500

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.ACT_WorkflowDefinition_CleanUp_Execute.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- System.Workflow

## Called / Called By

- Calls: none
- Called by: WorkflowCommons.ACT_WorkflowDefinition_CleanUp_Execute

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=d5ca895d-8424-4db5-9118-cf5ab3413cf7; sourceKind=Association; association=CleanupHelper_WorkflowDefinition; summary=retrieve WorkflowDefinition over association CleanupHelper_WorkflowDefinition from CleanupHelper
- nodeId=38075ebb-6d47-4b14-b0f6-a0f40996e799; sourceKind=Database; entity=System.Workflow; summary=retrieve WorkflowList from System.Workflow
- nodeId=af09ade7-a8b4-43ea-817c-846fc03ae888; sourceKind=Database; entity=System.Workflow; summary=retrieve WorkflowList_Total from System.Workflow
- nodeId=cf57d2ef-5b0a-4708-9b2c-8d3f11df0e83; caption=More?; expression=$BatchCount = $BatchSize More? expression=$BatchCount = $BatchSize
- nodeId=898a14d7-90a0-4b75-842d-72540a8ee1a1; actionKind=Change; summary=ChangeVariableAction: change variable DeletedCount=$DeletedCount + $BatchCount change variable DeletedCount=$DeletedCount + $BatchCount
- nodeId=36ca1cf4-3355-4a6f-a50e-d63567f7c868; actionKind=Create; summary=CreateVariableAction: create variable BatchSize=500 create variable BatchSize=500
- nodeId=34bb97eb-8ff7-40fd-8f93-75f2cc213a7f; actionKind=Create; summary=CreateVariableAction: create variable DeletedCount=0 create variable DeletedCount=0
- nodeId=57df26e9-bbd6-4197-b5c4-3332d17df59a; actionKind=Create; summary=CreateVariableAction: create variable IgnoreEndDateEnd=$CleanupHelper/EndDateEnd = empty create variable IgnoreEndDateEnd=$CleanupHelper/EndDateEnd = empty

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-cleanuphelper-execute-workflow.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
