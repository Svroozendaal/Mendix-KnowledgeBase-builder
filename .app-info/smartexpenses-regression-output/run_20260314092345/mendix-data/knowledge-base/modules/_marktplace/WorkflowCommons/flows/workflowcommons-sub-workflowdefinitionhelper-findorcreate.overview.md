---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_WorkflowDefinitionHelper_FindOrCreate
stableId: f1c9a16c-67ed-469b-83e9-9239f7bfe932
slug: workflowcommons-sub-workflowdefinitionhelper-findorcreate
layer: L1
l0: workflowcommons-sub-workflowdefinitionhelper-findorcreate.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowdefinitionhelper-findorcreate.json
l2Logical: flow:WorkflowCommons.SUB_WorkflowDefinitionHelper_FindOrCreate
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_WorkflowDefinitionHelper_FindOrCreate

## Summary

- Likely acts as a save, process, or background step for WorkflowCommons.WorkflowDefinitionHelper because it mutates data without showing a page.
- L0: [abstract](workflowcommons-sub-workflowdefinitionhelper-findorcreate.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowdefinitionhelper-findorcreate.json)

## Main Steps

- retrieve WorkflowDefinitionHelperList over association WorkflowDefinitionHelper_WorkflowDefinition from WorkflowDefinition
- $WorkflowDefinitionHelperList != empty Exist? expression=$WorkflowDefinitionHelperList != empty
- ChangeObjectAction: change WorkflowDefinitionHelperHead (UpdateInstances=false; refreshInClient=false) change WorkflowDefinitionHelperHead (UpdateInstances=false; refreshInClient=false)
- CreateObjectAction: create WorkflowCommons.WorkflowDefinitionHelper as NewWorkflowDefinitionHelper (WorkflowDefinitionHelper_WorkflowDefinition=$WorkflowDefinition) create WorkflowCommons.WorkflowDefinitionHelper as NewWorkflowDefinitionHelper (WorkflowDefinitionHelper_WorkflowDefinition=$WorkflowDefinition)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.ACT_WorkflowDefinitionHelper_ShowLockPage, WorkflowCommons.ACT_WorkflowDefinitionHelper_ShowUnlockPage.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- WorkflowCommons.WorkflowDefinitionHelper

## Called / Called By

- Calls: none
- Called by: WorkflowCommons.ACT_WorkflowDefinitionHelper_ShowLockPage, WorkflowCommons.ACT_WorkflowDefinitionHelper_ShowUnlockPage

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=be279a96-d218-4a84-b28b-b96f341a16e4; sourceKind=Association; association=WorkflowDefinitionHelper_WorkflowDefinition; summary=retrieve WorkflowDefinitionHelperList over association WorkflowDefinitionHelper_WorkflowDefinition from WorkflowDefinition
- nodeId=44169b8d-2721-48c2-b6b5-f16926ecfa47; caption=Exist?; expression=$WorkflowDefinitionHelperList != empty Exist? expression=$WorkflowDefinitionHelperList != empty
- nodeId=6839768b-e560-49ec-a2b9-40639dfdb730; actionKind=Change; members=UpdateInstances=false; refreshInClient=false; summary=ChangeObjectAction: change WorkflowDefinitionHelperHead (UpdateInstances=false; refreshInClient=false) change WorkflowDefinitionHelperHead (UpdateInstances=false; refreshInClient=false)
- nodeId=4c9b0167-2b29-4b0a-88f5-6aca8b4538e2; actionKind=Create; entity=WorkflowCommons.WorkflowDefinitionHelper; members=WorkflowDefinitionHelper_WorkflowDefinition=$WorkflowDefinition; summary=CreateObjectAction: create WorkflowCommons.WorkflowDefinitionHelper as NewWorkflowDefinitionHelper (WorkflowDefinitionHelper_WorkflowDefinition=$WorkflowDefinition) create WorkflowCommons.WorkflowDefinitionHelper as NewWorkflowDefinitionHelper (WorkflowDefinitionHelper_WorkflowDefinition=$WorkflowDefinition)

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowdefinitionhelper-findorcreate.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
