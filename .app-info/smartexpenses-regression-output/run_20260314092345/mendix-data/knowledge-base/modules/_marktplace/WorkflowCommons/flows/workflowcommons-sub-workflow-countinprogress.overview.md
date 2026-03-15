---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_Workflow_CountInProgress
stableId: 0d3076f4-9045-47a6-bd66-063c9c191ef9
slug: workflowcommons-sub-workflow-countinprogress
layer: L1
l0: workflowcommons-sub-workflow-countinprogress.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflow-countinprogress.json
l2Logical: flow:WorkflowCommons.SUB_Workflow_CountInProgress
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_Workflow_CountInProgress

## Summary

- Likely acts as a save, process, or background step for System.Workflow because it mutates data without showing a page.
- L0: [abstract](workflowcommons-sub-workflow-countinprogress.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflow-countinprogress.json)

## Main Steps

- retrieve Workflow_InProgress from System.Workflow
- CreateVariableAction: create variable IgnoreStartedAfter=$StartedAfter = empty create variable IgnoreStartedAfter=$StartedAfter = empty
- CreateVariableAction: create variable IgnoreStartedBefore=$StartedBefore = empty create variable IgnoreStartedBefore=$StartedBefore = empty

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.SUB_WorkflowSummary_CreateOrUpdate.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- System.Workflow

## Called / Called By

- Calls: none
- Called by: WorkflowCommons.SUB_WorkflowSummary_CreateOrUpdate

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=3f44401f-ea31-4ba2-ae17-750b6c129776; sourceKind=Database; entity=System.Workflow; summary=retrieve Workflow_InProgress from System.Workflow
- nodeId=5460e909-8bd0-4669-9cf9-0fa7c4cd0043; actionKind=Create; summary=CreateVariableAction: create variable IgnoreStartedAfter=$StartedAfter = empty create variable IgnoreStartedAfter=$StartedAfter = empty
- nodeId=b5870ed3-2a2f-4b9c-90c3-475af3340985; actionKind=Create; summary=CreateVariableAction: create variable IgnoreStartedBefore=$StartedBefore = empty create variable IgnoreStartedBefore=$StartedBefore = empty

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflow-countinprogress.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
