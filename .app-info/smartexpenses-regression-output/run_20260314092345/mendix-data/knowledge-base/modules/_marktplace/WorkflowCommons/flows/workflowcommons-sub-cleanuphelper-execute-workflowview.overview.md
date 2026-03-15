---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_CleanupHelper_Execute_WorkflowView
stableId: 711d491f-cf52-4e35-82b5-b4837f8914df
slug: workflowcommons-sub-cleanuphelper-execute-workflowview
layer: L1
l0: workflowcommons-sub-cleanuphelper-execute-workflowview.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-cleanuphelper-execute-workflowview.json
l2Logical: flow:WorkflowCommons.SUB_CleanupHelper_Execute_WorkflowView
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_CleanupHelper_Execute_WorkflowView

## Summary

- Likely acts as a save, process, or background step for WorkflowCommons.WorkflowView because it mutates data without showing a page.
- L0: [abstract](workflowcommons-sub-cleanuphelper-execute-workflowview.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-cleanuphelper-execute-workflowview.json)

## Main Steps

- retrieve WorkflowDefinition over association CleanupHelper_WorkflowDefinition from CleanupHelper
- retrieve WorkflowViewList from WorkflowCommons.WorkflowView
- $BatchCount = $BatchSize More? expression=$BatchCount = $BatchSize
- ChangeVariableAction: change variable DeletedCount=$DeletedCount + $BatchCount change variable DeletedCount=$DeletedCount + $BatchCount
- CreateVariableAction: create variable BatchSize=500 create variable BatchSize=500

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.ACT_WorkflowDefinition_CleanUp_Execute.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- WorkflowCommons.WorkflowView

## Called / Called By

- Calls: none
- Called by: WorkflowCommons.ACT_WorkflowDefinition_CleanUp_Execute

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=67ed8db6-02cb-43d1-b62c-6da987c19380; sourceKind=Association; association=CleanupHelper_WorkflowDefinition; summary=retrieve WorkflowDefinition over association CleanupHelper_WorkflowDefinition from CleanupHelper
- nodeId=797f8bc7-75e3-4431-959e-22e015a1e064; sourceKind=Database; entity=WorkflowCommons.WorkflowView; summary=retrieve WorkflowViewList from WorkflowCommons.WorkflowView
- nodeId=1d8a0752-44b8-4c62-affa-23b454bfda2d; sourceKind=Database; entity=WorkflowCommons.WorkflowView; summary=retrieve WorkflowViewList_Total from WorkflowCommons.WorkflowView
- nodeId=becd6bac-e981-4e14-862c-e8dd1be4f407; caption=More?; expression=$BatchCount = $BatchSize More? expression=$BatchCount = $BatchSize
- nodeId=b618c2f1-569b-4841-a4d7-5a7e9632232a; actionKind=Change; summary=ChangeVariableAction: change variable DeletedCount=$DeletedCount + $BatchCount change variable DeletedCount=$DeletedCount + $BatchCount
- nodeId=d9675edf-5f5c-497a-9f49-7e8b05729b5e; actionKind=Create; summary=CreateVariableAction: create variable BatchSize=500 create variable BatchSize=500
- nodeId=42fc61c0-89e4-4cc8-919e-16e2feba6dfb; actionKind=Create; summary=CreateVariableAction: create variable DeletedCount=0 create variable DeletedCount=0
- nodeId=30c1203f-61c3-46a9-a991-8d235465b745; actionKind=Create; summary=CreateVariableAction: create variable IgnoreEndDateEnd=$CleanupHelper/EndDateEnd = empty create variable IgnoreEndDateEnd=$CleanupHelper/EndDateEnd = empty

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-cleanuphelper-execute-workflowview.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
