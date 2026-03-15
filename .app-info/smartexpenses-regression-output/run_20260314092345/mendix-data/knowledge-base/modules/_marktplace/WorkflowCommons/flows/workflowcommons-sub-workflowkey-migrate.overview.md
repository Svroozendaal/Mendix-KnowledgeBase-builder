---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_WorkflowKey_Migrate
stableId: 747436d3-facc-43d2-8bc9-4d1e26f416d9
slug: workflowcommons-sub-workflowkey-migrate
layer: L1
l0: workflowcommons-sub-workflowkey-migrate.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowkey-migrate.json
l2Logical: flow:WorkflowCommons.SUB_WorkflowKey_Migrate
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_WorkflowKey_Migrate

## Summary

- Likely acts as a save, process, or background step for WorkflowCommons.WorkflowView because it mutates data without showing a page.
- L0: [abstract](workflowcommons-sub-workflowkey-migrate.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowkey-migrate.json)

## Main Steps

- retrieve WorkflowViewList from WorkflowCommons.WorkflowView
- $WorkflowViewList != empty Found? expression=$WorkflowViewList != empty
- ChangeVariableAction: change variable Offset=$Offset + $Limit change variable Offset=$Offset + $Limit
- ChangeVariableAction: change variable TotalCount=$TotalCount + $Count change variable TotalCount=$TotalCount + $Count

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.ACT_Key_Migrate, WorkflowCommons.ASu_Key_Migrate.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- WorkflowCommons.WorkflowView

## Called / Called By

- Calls: WorkflowCommons.SUB_WorkflowView_UpdateKey
- Called by: WorkflowCommons.ACT_Key_Migrate, WorkflowCommons.ASu_Key_Migrate

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=52fd024d-7240-40d1-97ac-55db614aaf18; sourceKind=Database; entity=WorkflowCommons.WorkflowView; summary=retrieve WorkflowViewList from WorkflowCommons.WorkflowView
- nodeId=a9d84b00-3626-4f8a-b941-fc24a24de156; caption=Found?; expression=$WorkflowViewList != empty Found? expression=$WorkflowViewList != empty
- nodeId=459fc6b0-f2fb-442a-a472-122042d0815d; actionKind=Change; summary=ChangeVariableAction: change variable Offset=$Offset + $Limit change variable Offset=$Offset + $Limit
- nodeId=3ab35570-ac79-44be-8c92-6b866f616ed7; actionKind=Change; summary=ChangeVariableAction: change variable TotalCount=$TotalCount + $Count change variable TotalCount=$TotalCount + $Count
- nodeId=e1cb97f6-82b8-4364-929c-eca6f5b9b41b; actionKind=Commit; members=refreshInClient=false, withEvents=true; summary=CommitAction: commit WorkflowViewList (refreshInClient=false, withEvents=true) commit WorkflowViewList (refreshInClient=false, withEvents=true)
- nodeId=46812df7-1ffe-4177-93e4-fb263fa7233b; actionKind=Create; summary=CreateVariableAction: create variable Limit=50 create variable Limit=50
- nodeId=f064e834-d0c8-4f8c-b1df-9452bb45523c; actionKind=Create; summary=CreateVariableAction: create variable Offset=0 create variable Offset=0
- nodeId=a7411a8d-a7a8-4d25-9494-cc6670f4c384; actionKind=Create; summary=CreateVariableAction: create variable TotalCount=0 create variable TotalCount=0

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowkey-migrate.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
