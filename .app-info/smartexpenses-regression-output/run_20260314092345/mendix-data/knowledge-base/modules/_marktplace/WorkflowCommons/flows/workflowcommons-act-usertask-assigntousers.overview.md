---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.ACT_UserTask_AssignToUsers
stableId: 92b08e35-cdef-4308-8b82-e898eb68c2e6
slug: workflowcommons-act-usertask-assigntousers
layer: L1
l0: workflowcommons-act-usertask-assigntousers.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-usertask-assigntousers.json
l2Logical: flow:WorkflowCommons.ACT_UserTask_AssignToUsers
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.ACT_UserTask_AssignToUsers

## Summary

- Likely orchestrates downstream flow calls without direct UI output.
- L0: [abstract](workflowcommons-act-usertask-assigntousers.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-usertask-assigntousers.json)

## Main Steps

- $WorkflowUserTask/CompletionType != System.WorkflowUserTaskCompletionType.Single Multi-user task? expression=$WorkflowUserTask/CompletionType != System.WorkflowUserTaskCompletionType.Single

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: No page output was exported; this likely delegates work to downstream flows.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: WorkflowCommons.SUB_UserTask_Assignees_Add
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it may serve validation, background processing, or delegate work to other flows.

## Important Retrieves/Decisions/Mutations

- nodeId=8fabcdea-1ab5-47d8-883c-d66529b0c38c; caption=Multi-user task?; expression=$WorkflowUserTask/CompletionType != System.WorkflowUserTaskCompletionType.Single Multi-user task? expression=$WorkflowUserTask/CompletionType != System.WorkflowUserTaskCompletionType.Single

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-usertask-assigntousers.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
