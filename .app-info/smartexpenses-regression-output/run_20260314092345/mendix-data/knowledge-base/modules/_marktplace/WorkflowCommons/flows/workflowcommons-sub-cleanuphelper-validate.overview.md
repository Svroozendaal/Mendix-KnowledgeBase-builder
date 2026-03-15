---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_CleanupHelper_Validate
stableId: 0498b543-0857-445c-ab45-3d865928e816
slug: workflowcommons-sub-cleanuphelper-validate
layer: L1
l0: workflowcommons-sub-cleanuphelper-validate.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-cleanuphelper-validate.json
l2Logical: flow:WorkflowCommons.SUB_CleanupHelper_Validate
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_CleanupHelper_Validate

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](workflowcommons-sub-cleanuphelper-validate.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-cleanuphelper-validate.json)

## Main Steps

- $CleanupHelper/EndDateStart != empty and $CleanupHelper/EndDateEnd != empty End Dates expression=$CleanupHelper/EndDateStart != empty and $CleanupHelper/EndDateEnd != empty
- $CleanupHelper/EndDateStart < $CleanupHelper/EndDateEnd expression=$CleanupHelper/EndDateStart < $CleanupHelper/EndDateEnd
- ChangeVariableAction: change variable IsValid=false change variable IsValid=false

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.OCh_CleanupHelper_UpdateCount.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: WorkflowCommons.OCh_CleanupHelper_UpdateCount

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=67255c4d-a679-4f34-bddd-76c6ad3a4e77; caption=End Dates; expression=$CleanupHelper/EndDateStart != empty and $CleanupHelper/EndDateEnd != empty End Dates expression=$CleanupHelper/EndDateStart != empty and $CleanupHelper/EndDateEnd != empty
- nodeId=f0dd0b68-c23b-4577-8d3c-0dd05891c872; caption=none; expression=$CleanupHelper/EndDateStart < $CleanupHelper/EndDateEnd expression=$CleanupHelper/EndDateStart < $CleanupHelper/EndDateEnd
- nodeId=c989725c-63c1-43e0-92f0-b66f45e5425e; caption=none; expression=$CleanupHelper/StartDateStart < $CleanupHelper/StartDateEnd expression=$CleanupHelper/StartDateStart < $CleanupHelper/StartDateEnd
- nodeId=bc2a60f0-8c5d-4ed3-bb5a-d27f1da6cf54; caption=Start Dates; expression=$CleanupHelper/StartDateStart != empty and $CleanupHelper/StartDateEnd != empty Start Dates expression=$CleanupHelper/StartDateStart != empty and $CleanupHelper/StartDateEnd != empty
- nodeId=88f267a4-36db-40e7-a1fb-2a93f33a9cd9; actionKind=Change; summary=ChangeVariableAction: change variable IsValid=false change variable IsValid=false
- nodeId=cf3fc3a5-3841-4fa3-83f8-3dcccdee6c99; actionKind=Change; summary=ChangeVariableAction: change variable IsValid=false change variable IsValid=false
- nodeId=d108a3f1-8b37-44af-91e0-616368f475e6; actionKind=Create; summary=CreateVariableAction: create variable IsValid=true create variable IsValid=true

## Warnings/Unknowns

- Rollback hint detected in node detail.
- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-cleanuphelper-validate.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
