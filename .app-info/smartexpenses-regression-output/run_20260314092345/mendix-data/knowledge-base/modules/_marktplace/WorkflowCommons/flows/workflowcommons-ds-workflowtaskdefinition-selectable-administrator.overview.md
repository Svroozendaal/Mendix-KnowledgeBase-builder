---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.DS_WorkflowTaskDefinition_Selectable_Administrator
stableId: 31d11c42-f2a1-404b-881b-1a431055e86b
slug: workflowcommons-ds-workflowtaskdefinition-selectable-administrator
layer: L1
l0: workflowcommons-ds-workflowtaskdefinition-selectable-administrator.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ds-workflowtaskdefinition-selectable-administrator.json
l2Logical: flow:WorkflowCommons.DS_WorkflowTaskDefinition_Selectable_Administrator
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.DS_WorkflowTaskDefinition_Selectable_Administrator

## Summary

- Likely supplies data to callers or pages rather than driving user navigation directly.
- L0: [abstract](workflowcommons-ds-workflowtaskdefinition-selectable-administrator.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ds-workflowtaskdefinition-selectable-administrator.json)

## Main Steps

- retrieve WorkflowDefinition_Selected over association DashboardContext_WorkflowDefinition from DashboardContext
- retrieve WorkflowTaskDefinition from System.WorkflowUserTaskDefinition
- $WorkflowDefinition_Selected != empty != empty? expression=$WorkflowDefinition_Selected != empty

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; check L2 JSON if the exact user-facing effect matters.

## Key Entities Touched

- System.WorkflowUserTaskDefinition

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it may serve validation, background processing, or delegate work to other flows.

## Important Retrieves/Decisions/Mutations

- nodeId=0a075f3d-0691-4f81-a149-8defb3bf6b26; sourceKind=Association; association=DashboardContext_WorkflowDefinition; summary=retrieve WorkflowDefinition_Selected over association DashboardContext_WorkflowDefinition from DashboardContext
- nodeId=b18812b2-60d5-4541-84af-34490c9648f0; sourceKind=Database; entity=System.WorkflowUserTaskDefinition; summary=retrieve WorkflowTaskDefinition from System.WorkflowUserTaskDefinition
- nodeId=40037f94-23bc-4c64-90a8-2caf47c2977f; caption=!= empty?; expression=$WorkflowDefinition_Selected != empty != empty? expression=$WorkflowDefinition_Selected != empty

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ds-workflowtaskdefinition-selectable-administrator.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
