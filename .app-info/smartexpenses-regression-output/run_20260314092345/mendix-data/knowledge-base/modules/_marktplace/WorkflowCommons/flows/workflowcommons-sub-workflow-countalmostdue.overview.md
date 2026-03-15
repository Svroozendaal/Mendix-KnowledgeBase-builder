---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_Workflow_CountAlmostDue
stableId: c4513fe1-0115-4671-8123-6ad54922b4c3
slug: workflowcommons-sub-workflow-countalmostdue
layer: L1
l0: workflowcommons-sub-workflow-countalmostdue.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflow-countalmostdue.json
l2Logical: flow:WorkflowCommons.SUB_Workflow_CountAlmostDue
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_Workflow_CountAlmostDue

## Summary

- Likely acts as a save, process, or background step for System.Workflow because it mutates data without showing a page.
- L0: [abstract](workflowcommons-sub-workflow-countalmostdue.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflow-countalmostdue.json)

## Main Steps

- retrieve Workflow_InProgress_AlmostDue from System.Workflow
- CreateVariableAction: create variable AlmostDueDate=addDays([%CurrentDateTime%], @WorkflowCommons.DueDateExpirationInDays) create variable AlmostDueDate=addDays([%CurrentDateTime%], @WorkflowCommons.DueDateExpirationInDays)
- CreateVariableAction: create variable IgnoreStartedAfter=$StartedAfter = empty create variable IgnoreStartedAfter=$StartedAfter = empty

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

- nodeId=260875e1-b63e-4c4c-8b99-3fa60e8eb608; sourceKind=Database; entity=System.Workflow; summary=retrieve Workflow_InProgress_AlmostDue from System.Workflow
- nodeId=7f612c85-57ea-46e3-90d2-12a8e5080912; actionKind=Create; entity=WorkflowCommons.DueDateExpirationInDays; members=[%CurrentDateTime%], @WorkflowCommons.DueDateExpirationInDays; summary=CreateVariableAction: create variable AlmostDueDate=addDays([%CurrentDateTime%], @WorkflowCommons.DueDateExpirationInDays) create variable AlmostDueDate=addDays([%CurrentDateTime%], @WorkflowCommons.DueDateExpirationInDays)
- nodeId=5b3ffc66-fd40-48e1-b1d0-28e3a5a47609; actionKind=Create; summary=CreateVariableAction: create variable IgnoreStartedAfter=$StartedAfter = empty create variable IgnoreStartedAfter=$StartedAfter = empty
- nodeId=8b0062f3-9070-4b18-a600-31a1c91033ec; actionKind=Create; summary=CreateVariableAction: create variable IgnoreStartedBefore=$StartedBefore = empty create variable IgnoreStartedBefore=$StartedBefore = empty

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflow-countalmostdue.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
