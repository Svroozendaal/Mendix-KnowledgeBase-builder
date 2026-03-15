---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.ACT_Workflow_OpenParentWorkflow
stableId: b3a14c27-72e6-4a60-adba-7a81328c8d1a
slug: workflowcommons-act-workflow-openparentworkflow
layer: L1
l0: workflowcommons-act-workflow-openparentworkflow.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-workflow-openparentworkflow.json
l2Logical: flow:WorkflowCommons.ACT_Workflow_OpenParentWorkflow
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.ACT_Workflow_OpenParentWorkflow

## Summary

- Likely orchestrates downstream flow calls without direct UI output.
- L0: [abstract](workflowcommons-act-workflow-openparentworkflow.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-workflow-openparentworkflow.json)

## Main Steps

- retrieve ParentWorkflow over association Workflow_ParentWorkflow from Workflow

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: No page output was exported; this likely delegates work to downstream flows.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: WorkflowCommons.SUB_Workflow_ShowWorkflowAdminPage
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it may serve validation, background processing, or delegate work to other flows.

## Important Retrieves/Decisions/Mutations

- nodeId=9a9b0e29-563f-406a-bca8-f371b3266f3e; sourceKind=Association; association=Workflow_ParentWorkflow; summary=retrieve ParentWorkflow over association Workflow_ParentWorkflow from Workflow

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-workflow-openparentworkflow.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
