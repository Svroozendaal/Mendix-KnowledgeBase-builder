---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.DS_WorkflowActivityRecord_OverdueTime
stableId: 556d6121-ee05-4a2e-9019-2102663c3990
slug: workflowcommons-ds-workflowactivityrecord-overduetime
layer: L1
l0: workflowcommons-ds-workflowactivityrecord-overduetime.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ds-workflowactivityrecord-overduetime.json
l2Logical: flow:WorkflowCommons.DS_WorkflowActivityRecord_OverdueTime
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.DS_WorkflowActivityRecord_OverdueTime

## Summary

- Likely orchestrates downstream flow calls without direct UI output.
- L0: [abstract](workflowcommons-ds-workflowactivityrecord-overduetime.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ds-workflowactivityrecord-overduetime.json)

## Main Steps

- $WorkflowActivityRecord/TaskDueDate != empty and $WorkflowActivityRecord/TaskDueDate < [%CurrentDateTime%] Overdue? expression=$WorkflowActivityRecord/TaskDueDate != empty and $WorkflowActivityRecord/TaskDueDate < [%CurrentDateTime%]

## Trigger/Input/Output Context

- Kind: Nanoflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; this likely delegates work to downstream flows.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: WorkflowCommons.SUB_Duration_Calculate
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it may serve validation, background processing, or delegate work to other flows.

## Important Retrieves/Decisions/Mutations

- nodeId=5c19aeb1-7846-460f-8c5a-571234214566; caption=Overdue?; expression=$WorkflowActivityRecord/TaskDueDate != empty and $WorkflowActivityRecord/TaskDueDate < [%CurrentDateTime%] Overdue? expression=$WorkflowActivityRecord/TaskDueDate != empty and $WorkflowActivityRecord/TaskDueDate < [%CurrentDateTime%]

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ds-workflowactivityrecord-overduetime.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
