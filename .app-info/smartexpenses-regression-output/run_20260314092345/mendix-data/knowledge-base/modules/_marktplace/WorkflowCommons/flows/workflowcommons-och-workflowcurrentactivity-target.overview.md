---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.OCh_WorkflowCurrentActivity_Target
stableId: 7065b674-ae63-4245-98f1-c2dbb2aa810c
slug: workflowcommons-och-workflowcurrentactivity-target
layer: L1
l0: workflowcommons-och-workflowcurrentactivity-target.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-och-workflowcurrentactivity-target.json
l2Logical: flow:WorkflowCommons.OCh_WorkflowCurrentActivity_Target
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.OCh_WorkflowCurrentActivity_Target

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](workflowcommons-och-workflowcurrentactivity-target.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-och-workflowcurrentactivity-target.json)

## Main Steps

- $WorkflowCurrentActivity/System.WorkflowCurrentActivity_JumpToTarget != empty Target? expression=$WorkflowCurrentActivity/System.WorkflowCurrentActivity_JumpToTarget != empty
- ChangeObjectAction: change WorkflowCurrentActivity (Action=System.WorkflowCurrentActivityAction.DoNothing; refreshInClient=true) change WorkflowCurrentActivity (Action=System.WorkflowCurrentActivityAction.DoNothing; refreshInClient=true)
- ChangeObjectAction: change WorkflowCurrentActivity (Action=System.WorkflowCurrentActivityAction.JumpTo; refreshInClient=true) change WorkflowCurrentActivity (Action=System.WorkflowCurrentActivityAction.JumpTo; refreshInClient=true)

## Trigger/Input/Output Context

- Kind: Nanoflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=dd8a616f-e9f4-4237-b180-c925b40a5e81; caption=Target?; expression=$WorkflowCurrentActivity/System.WorkflowCurrentActivity_JumpToTarget != empty Target? expression=$WorkflowCurrentActivity/System.WorkflowCurrentActivity_JumpToTarget != empty
- nodeId=cee3659c-9cff-4431-a934-2116f9238ea8; actionKind=Change; entity=System.WorkflowCurrentActivityAction; members=Action=System.WorkflowCurrentActivityAction.DoNothing; refreshInClient=true; summary=ChangeObjectAction: change WorkflowCurrentActivity (Action=System.WorkflowCurrentActivityAction.DoNothing; refreshInClient=true) change WorkflowCurrentActivity (Action=System.WorkflowCurrentActivityAction.DoNothing; refreshInClient=true)
- nodeId=b9a9965f-84e9-4e48-a75d-71a615079c7b; actionKind=Change; entity=System.WorkflowCurrentActivityAction; members=Action=System.WorkflowCurrentActivityAction.JumpTo; refreshInClient=true; summary=ChangeObjectAction: change WorkflowCurrentActivity (Action=System.WorkflowCurrentActivityAction.JumpTo; refreshInClient=true) change WorkflowCurrentActivity (Action=System.WorkflowCurrentActivityAction.JumpTo; refreshInClient=true)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-och-workflowcurrentactivity-target.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
