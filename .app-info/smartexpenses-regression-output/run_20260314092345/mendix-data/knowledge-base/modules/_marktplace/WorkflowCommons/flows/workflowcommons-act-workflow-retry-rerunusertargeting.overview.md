---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.ACT_Workflow_Retry_RerunUserTargeting
stableId: b0674f54-f00c-45fc-adf3-ea69975cb664
slug: workflowcommons-act-workflow-retry-rerunusertargeting
layer: L1
l0: workflowcommons-act-workflow-retry-rerunusertargeting.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-workflow-retry-rerunusertargeting.json
l2Logical: flow:WorkflowCommons.ACT_Workflow_Retry_RerunUserTargeting
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.ACT_Workflow_Retry_RerunUserTargeting

## Summary

- Likely acts as a save, process, or background step for System.WorkflowUserTask because it mutates data without showing a page.
- L0: [abstract](workflowcommons-act-workflow-retry-rerunusertargeting.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-workflow-retry-rerunusertargeting.json)

## Main Steps

- retrieve WorkflowUserTaskList from System.WorkflowUserTask
- ChangeObjectAction: change IteratorWorkflowUserTask (WorkflowUserTask_TargetUsers=empty; refreshInClient=false) change IteratorWorkflowUserTask (WorkflowUserTask_TargetUsers=empty; refreshInClient=false)
- CommitAction: commit WorkflowUserTaskList (refreshInClient=false, withEvents=true) commit WorkflowUserTaskList (refreshInClient=false, withEvents=true)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- System.WorkflowUserTask

## Called / Called By

- Calls: WorkflowCommons.SUB_Workflow_Retry
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=1511fa1d-bcd8-4422-88aa-a32e979c6dd2; sourceKind=Database; entity=System.WorkflowUserTask; summary=retrieve WorkflowUserTaskList from System.WorkflowUserTask
- nodeId=10e54d73-b045-48bd-a53b-2b7805f2e294; actionKind=Change; members=WorkflowUserTask_TargetUsers=empty; refreshInClient=false; summary=ChangeObjectAction: change IteratorWorkflowUserTask (WorkflowUserTask_TargetUsers=empty; refreshInClient=false) change IteratorWorkflowUserTask (WorkflowUserTask_TargetUsers=empty; refreshInClient=false)
- nodeId=11d650dc-0b11-42cc-ae0d-3cac19afdcd7; actionKind=Commit; members=refreshInClient=false, withEvents=true; summary=CommitAction: commit WorkflowUserTaskList (refreshInClient=false, withEvents=true) commit WorkflowUserTaskList (refreshInClient=false, withEvents=true)

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-workflow-retry-rerunusertargeting.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
