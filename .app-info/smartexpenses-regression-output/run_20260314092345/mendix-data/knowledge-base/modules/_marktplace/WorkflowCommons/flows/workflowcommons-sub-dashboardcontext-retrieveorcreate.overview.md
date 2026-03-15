---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_DashboardContext_RetrieveOrCreate
stableId: d8f1d624-3153-48a1-8241-7daae61c3ce8
slug: workflowcommons-sub-dashboardcontext-retrieveorcreate
layer: L1
l0: workflowcommons-sub-dashboardcontext-retrieveorcreate.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-dashboardcontext-retrieveorcreate.json
l2Logical: flow:WorkflowCommons.SUB_DashboardContext_RetrieveOrCreate
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_DashboardContext_RetrieveOrCreate

## Summary

- Likely acts as a save, process, or background step for WorkflowCommons.DashboardContext because it mutates data without showing a page.
- L0: [abstract](workflowcommons-sub-dashboardcontext-retrieveorcreate.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-dashboardcontext-retrieveorcreate.json)

## Main Steps

- retrieve DashboardContextList over association DashboardContext_Session from currentSession
- $DashboardContextList != empty != empty expression=$DashboardContextList != empty
- CreateObjectAction: create WorkflowCommons.DashboardContext as NewDashboardContext (DashboardContext_Session=$currentSession) create WorkflowCommons.DashboardContext as NewDashboardContext (DashboardContext_Session=$currentSession)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.DS_TaskDashboard, WorkflowCommons.DS_WorkflowDashboard.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- WorkflowCommons.DashboardContext

## Called / Called By

- Calls: none
- Called by: WorkflowCommons.DS_TaskDashboard, WorkflowCommons.DS_WorkflowDashboard

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=f44f94a5-bba1-4dfe-aad1-aaa57b4deb1f; sourceKind=Association; association=DashboardContext_Session; summary=retrieve DashboardContextList over association DashboardContext_Session from currentSession
- nodeId=4216d55f-9bc3-4005-a910-8e392fa70a07; caption=!= empty; expression=$DashboardContextList != empty != empty expression=$DashboardContextList != empty
- nodeId=535e3b9d-bd53-4b00-a46f-a7a125c249a6; actionKind=Create; entity=WorkflowCommons.DashboardContext; members=DashboardContext_Session=$currentSession; summary=CreateObjectAction: create WorkflowCommons.DashboardContext as NewDashboardContext (DashboardContext_Session=$currentSession) create WorkflowCommons.DashboardContext as NewDashboardContext (DashboardContext_Session=$currentSession)

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-dashboardcontext-retrieveorcreate.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
