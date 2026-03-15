---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.DashboardContext_GetSelectedWorkflowTaskDefinition
stableId: 9176fd30-553c-43d0-84db-60889e2a69e2
slug: workflowcommons-dashboardcontext-getselectedworkflowtaskdefinition
layer: L1
l0: workflowcommons-dashboardcontext-getselectedworkflowtaskdefinition.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-dashboardcontext-getselectedworkflowtaskdefinition.json
l2Logical: flow:WorkflowCommons.DashboardContext_GetSelectedWorkflowTaskDefinition
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.DashboardContext_GetSelectedWorkflowTaskDefinition

## Summary

- Likely serves as a helper flow invoked from WorkflowCommons.DS_WorkflowTask_AssignedToUser_Timeline, WorkflowCommons.SUB_TaskDashboard_Update, WorkflowCommons.SUB_WorkflowDashboard_Update.
- L0: [abstract](workflowcommons-dashboardcontext-getselectedworkflowtaskdefinition.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-dashboardcontext-getselectedworkflowtaskdefinition.json)

## Main Steps

- retrieve DefinitionHelper over association DashboardContext_DefinitionHelperTask from DashboardContext
- retrieve WorkflowTaskDefinitionFromHelper from System.WorkflowUserTaskDefinition
- $DashboardContext/WorkflowCommons.DashboardContext_WorkflowTaskDefinition != empty Definition Selected? expression=$DashboardContext/WorkflowCommons.DashboardContext_WorkflowTaskDefinition != empty
- $DashboardContext/WorkflowCommons.DashboardContext_DefinitionHelperTask != empty Helper Selected? expression=$DashboardContext/WorkflowCommons.DashboardContext_DefinitionHelperTask != empty

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.DS_WorkflowTask_AssignedToUser_Timeline, WorkflowCommons.SUB_TaskDashboard_Update, WorkflowCommons.SUB_WorkflowDashboard_Update.
- Output/UI context: No page output was exported; check L2 JSON if the exact user-facing effect matters.

## Key Entities Touched

- System.WorkflowUserTaskDefinition

## Called / Called By

- Calls: none
- Called by: WorkflowCommons.DS_WorkflowTask_AssignedToUser_Timeline, WorkflowCommons.SUB_TaskDashboard_Update, WorkflowCommons.SUB_WorkflowDashboard_Update

## Shown Pages

- No ShowPageAction was exported for this flow; it may serve validation, background processing, or delegate work to other flows.

## Important Retrieves/Decisions/Mutations

- nodeId=d971dad7-ba25-4074-baa2-5c2cc26562e3; sourceKind=Association; association=DashboardContext_DefinitionHelperTask; summary=retrieve DefinitionHelper over association DashboardContext_DefinitionHelperTask from DashboardContext
- nodeId=dded8cad-0c26-4257-8c5a-51392e674461; sourceKind=Database; entity=System.WorkflowUserTaskDefinition; summary=retrieve WorkflowTaskDefinitionFromHelper from System.WorkflowUserTaskDefinition
- nodeId=9f5b7ca0-1942-4203-88fc-58b3be4d6ba6; sourceKind=Association; association=DashboardContext_WorkflowTaskDefinition; summary=retrieve WorkflowUserTaskDefinition over association DashboardContext_WorkflowTaskDefinition from DashboardContext
- nodeId=2f5e0f38-21d7-4070-bc40-4148ac998141; caption=Definition Selected?; expression=$DashboardContext/WorkflowCommons.DashboardContext_WorkflowTaskDefinition != empty Definition Selected? expression=$DashboardContext/WorkflowCommons.DashboardContext_WorkflowTaskDefinition != empty
- nodeId=0b16c6c2-094a-480b-9dc0-21c5a9c34e3c; caption=Helper Selected?; expression=$DashboardContext/WorkflowCommons.DashboardContext_DefinitionHelperTask != empty Helper Selected? expression=$DashboardContext/WorkflowCommons.DashboardContext_DefinitionHelperTask != empty

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-dashboardcontext-getselectedworkflowtaskdefinition.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
