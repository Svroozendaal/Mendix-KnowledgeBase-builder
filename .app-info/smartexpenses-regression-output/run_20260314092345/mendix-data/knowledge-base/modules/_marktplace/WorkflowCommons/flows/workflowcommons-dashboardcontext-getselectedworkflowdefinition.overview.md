---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.DashboardContext_GetSelectedWorkflowDefinition
stableId: 066bc6a8-a1f6-4dea-994b-c9aab0842cfd
slug: workflowcommons-dashboardcontext-getselectedworkflowdefinition
layer: L1
l0: workflowcommons-dashboardcontext-getselectedworkflowdefinition.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-dashboardcontext-getselectedworkflowdefinition.json
l2Logical: flow:WorkflowCommons.DashboardContext_GetSelectedWorkflowDefinition
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.DashboardContext_GetSelectedWorkflowDefinition

## Summary

- Likely serves as a helper flow invoked from WorkflowCommons.DS_WorkflowTask_AssignedToUser_Timeline, WorkflowCommons.SUB_TaskDashboard_Update, WorkflowCommons.SUB_WorkflowDashboard_Update.
- L0: [abstract](workflowcommons-dashboardcontext-getselectedworkflowdefinition.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-dashboardcontext-getselectedworkflowdefinition.json)

## Main Steps

- retrieve DefinitionHelper over association DashboardContext_DefinitionHelperWorkflow from DashboardContext
- retrieve WorkflowDefinition over association DashboardContext_WorkflowDefinition from DashboardContext
- $DashboardContext/WorkflowCommons.DashboardContext_WorkflowDefinition != empty Definition selected? expression=$DashboardContext/WorkflowCommons.DashboardContext_WorkflowDefinition != empty
- $DashboardContext/WorkflowCommons.DashboardContext_DefinitionHelperWorkflow != empty Helper selected? expression=$DashboardContext/WorkflowCommons.DashboardContext_DefinitionHelperWorkflow != empty

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.DS_WorkflowTask_AssignedToUser_Timeline, WorkflowCommons.SUB_TaskDashboard_Update, WorkflowCommons.SUB_WorkflowDashboard_Update.
- Output/UI context: No page output was exported; check L2 JSON if the exact user-facing effect matters.

## Key Entities Touched

- System.WorkflowDefinition

## Called / Called By

- Calls: none
- Called by: WorkflowCommons.DS_WorkflowTask_AssignedToUser_Timeline, WorkflowCommons.SUB_TaskDashboard_Update, WorkflowCommons.SUB_WorkflowDashboard_Update

## Shown Pages

- No ShowPageAction was exported for this flow; it may serve validation, background processing, or delegate work to other flows.

## Important Retrieves/Decisions/Mutations

- nodeId=82f18170-cd04-477e-b68b-960518051fb1; sourceKind=Association; association=DashboardContext_DefinitionHelperWorkflow; summary=retrieve DefinitionHelper over association DashboardContext_DefinitionHelperWorkflow from DashboardContext
- nodeId=6760d227-bbbb-44d5-9ddd-153ee1f37ac2; sourceKind=Association; association=DashboardContext_WorkflowDefinition; summary=retrieve WorkflowDefinition over association DashboardContext_WorkflowDefinition from DashboardContext
- nodeId=88e0d89d-d6c4-465d-8618-74eb8a9cb44e; sourceKind=Database; entity=System.WorkflowDefinition; summary=retrieve WorkflowDefinitionFromHelper from System.WorkflowDefinition
- nodeId=0d2448a4-82f1-41b6-9815-b5109e4e90b0; caption=Definition selected?; expression=$DashboardContext/WorkflowCommons.DashboardContext_WorkflowDefinition != empty Definition selected? expression=$DashboardContext/WorkflowCommons.DashboardContext_WorkflowDefinition != empty
- nodeId=c7dad4eb-86ef-4c5e-b1da-31af52daa02f; caption=Helper selected?; expression=$DashboardContext/WorkflowCommons.DashboardContext_DefinitionHelperWorkflow != empty Helper selected? expression=$DashboardContext/WorkflowCommons.DashboardContext_DefinitionHelperWorkflow != empty

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-dashboardcontext-getselectedworkflowdefinition.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
