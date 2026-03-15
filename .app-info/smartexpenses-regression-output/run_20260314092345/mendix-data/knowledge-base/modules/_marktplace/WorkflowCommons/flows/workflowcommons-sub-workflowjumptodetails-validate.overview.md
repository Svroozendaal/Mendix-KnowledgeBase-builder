---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_WorkflowJumpToDetails_Validate
stableId: f2f8659b-3e4b-4e23-9931-2970a6fdfc2c
slug: workflowcommons-sub-workflowjumptodetails-validate
layer: L1
l0: workflowcommons-sub-workflowjumptodetails-validate.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowjumptodetails-validate.json
l2Logical: flow:WorkflowCommons.SUB_WorkflowJumpToDetails_Validate
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_WorkflowJumpToDetails_Validate

## Summary

- Likely serves as a helper flow invoked from WorkflowCommons.ACT_WorkflowJumpToDetails_Apply.
- L0: [abstract](workflowcommons-sub-workflowjumptodetails-validate.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowjumptodetails-validate.json)

## Main Steps

- retrieve WorkflowCurrentActivityList over association WorkflowJumpToDetails_CurrentActivities from WorkflowJumpToDetails
- $ActivityWithTarget != empty Found? expression=$ActivityWithTarget != empty

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.ACT_WorkflowJumpToDetails_Apply.
- Output/UI context: No page output was exported; check L2 JSON if the exact user-facing effect matters.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: WorkflowCommons.ACT_WorkflowJumpToDetails_Apply

## Shown Pages

- No ShowPageAction was exported for this flow; it may serve validation, background processing, or delegate work to other flows.

## Important Retrieves/Decisions/Mutations

- nodeId=284ecc05-652a-47de-8935-5feae2d4214c; sourceKind=Association; association=WorkflowJumpToDetails_CurrentActivities; summary=retrieve WorkflowCurrentActivityList over association WorkflowJumpToDetails_CurrentActivities from WorkflowJumpToDetails
- nodeId=fb5f2120-b6b1-47ac-aaf3-676e3de17eb2; caption=Found?; expression=$ActivityWithTarget != empty Found? expression=$ActivityWithTarget != empty

## Warnings/Unknowns

- Rollback hint detected in node detail.
- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowjumptodetails-validate.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
