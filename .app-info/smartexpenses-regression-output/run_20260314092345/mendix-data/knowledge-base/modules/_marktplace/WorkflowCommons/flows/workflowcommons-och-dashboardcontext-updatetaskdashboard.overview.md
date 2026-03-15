---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.OCh_DashboardContext_UpdateTaskDashboard
stableId: 65012e04-2e3b-4119-bb9d-c51b5ebab51d
slug: workflowcommons-och-dashboardcontext-updatetaskdashboard
layer: L1
l0: workflowcommons-och-dashboardcontext-updatetaskdashboard.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-och-dashboardcontext-updatetaskdashboard.json
l2Logical: flow:WorkflowCommons.OCh_DashboardContext_UpdateTaskDashboard
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.OCh_DashboardContext_UpdateTaskDashboard

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](workflowcommons-och-dashboardcontext-updatetaskdashboard.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-och-dashboardcontext-updatetaskdashboard.json)

## Main Steps

- $DashboardContext/WorkflowCommons.DashboardContext_DefinitionHelperTask != empty and $DashboardContext/WorkflowCommons.D... Definition from other Workflow? expression=$DashboardContext/WorkflowCommons.DashboardContext_DefinitionHelperTask != empty and $DashboardContext/WorkflowCommons.D...
- $DashboardContext/WorkflowCommons.DashboardContext_DefinitionHelperWorkflow = empty Not Selected? expression=$DashboardContext/WorkflowCommons.DashboardContext_DefinitionHelperWorkflow = empty
- ChangeObjectAction: change DashboardContext (DashboardContext_DefinitionHelperTask=empty; refreshInClient=false) change DashboardContext (DashboardContext_DefinitionHelperTask=empty; refreshInClient=false)
- ChangeObjectAction: change DashboardContext (refreshInClient=true) change DashboardContext (refreshInClient=true)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: WorkflowCommons.SUB_TaskDashboard_Update
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=4d91394f-f980-4161-81b5-c1701bc7cfb2; caption=Definition from other Workflow?; expression=$DashboardContext/WorkflowCommons.DashboardContext_DefinitionHelperTask != empty and $DashboardContext/WorkflowCommons.D... Definition from other Workflow? expression=$DashboardContext/WorkflowCommons.DashboardContext_DefinitionHelperTask != empty and $DashboardContext/WorkflowCommons.D...
- nodeId=efe933fd-c99b-47f7-b468-3d10308b753a; caption=Not Selected?; expression=$DashboardContext/WorkflowCommons.DashboardContext_DefinitionHelperWorkflow = empty Not Selected? expression=$DashboardContext/WorkflowCommons.DashboardContext_DefinitionHelperWorkflow = empty
- nodeId=a843edd9-fd24-468a-969d-7c118ee26bea; actionKind=Change; members=DashboardContext_DefinitionHelperTask=empty; refreshInClient=false; summary=ChangeObjectAction: change DashboardContext (DashboardContext_DefinitionHelperTask=empty; refreshInClient=false) change DashboardContext (DashboardContext_DefinitionHelperTask=empty; refreshInClient=false)
- nodeId=3bb2d86f-100a-421f-bf8c-c0085e1ef78a; actionKind=Change; members=refreshInClient=true; summary=ChangeObjectAction: change DashboardContext (refreshInClient=true) change DashboardContext (refreshInClient=true)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-och-dashboardcontext-updatetaskdashboard.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
