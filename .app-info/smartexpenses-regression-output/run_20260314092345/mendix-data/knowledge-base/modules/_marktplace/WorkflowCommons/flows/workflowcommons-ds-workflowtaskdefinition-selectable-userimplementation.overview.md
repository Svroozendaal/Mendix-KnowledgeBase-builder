---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.DS_WorkflowTaskDefinition_Selectable_UserImplementation
stableId: 7364d192-390f-43b1-b53a-bd825dacd0a0
slug: workflowcommons-ds-workflowtaskdefinition-selectable-userimplementation
layer: L1
l0: workflowcommons-ds-workflowtaskdefinition-selectable-userimplementation.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ds-workflowtaskdefinition-selectable-userimplementation.json
l2Logical: flow:WorkflowCommons.DS_WorkflowTaskDefinition_Selectable_UserImplementation
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.DS_WorkflowTaskDefinition_Selectable_UserImplementation

## Summary

- Likely acts as a save, process, or background step for System.WorkflowUserTaskDefinition, WorkflowCommons.DefinitionHelper because it mutates data without showing a page.
- L0: [abstract](workflowcommons-ds-workflowtaskdefinition-selectable-userimplementation.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ds-workflowtaskdefinition-selectable-userimplementation.json)

## Main Steps

- retrieve DefinitionHelperList over association DefinitionHelper_DashboardContext from DashboardContext
- retrieve DefinitionHelperWorkflow over association DashboardContext_DefinitionHelperWorkflow from DashboardContext
- $DashboardContext/WorkflowCommons.DashboardContext_DefinitionHelperWorkflow != empty != empty? expression=$DashboardContext/WorkflowCommons.DashboardContext_DefinitionHelperWorkflow != empty
- $DefinitionHelperList != empty Has NPE? expression=$DefinitionHelperList != empty
- ChangeListAction: change NewWorkflowDefinitionHelperList (type=Add, value=$NewDefinitionHelper) change NewWorkflowDefinitionHelperList (type=Add, value=$NewDefinitionHelper)
- CreateObjectAction: create WorkflowCommons.DefinitionHelper as NewDefinitionHelper (DisplayText=$IteratorWorkflowTaskDefinition/Name, Key=$IteratorWorkflowTaskDefinition/Name, DefinitionHelper_DashboardContext=$DashboardContext, DefinitionHelper_DefinitionHelperParent=$DefinitionHelperWorkflow) create WorkflowCommons.DefinitionHelper as NewDefinitionHelper (DisplayText=$IteratorWorkflowTaskDefinition/Name, Key=$IteratorWorkflowTaskDefinition/Name, DefinitionHelper_DashboardContext=$DashboardContext, DefinitionHelper_DefinitionHelperParent=$DefinitionHelperWorkflow)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- System.WorkflowUserTaskDefinition, WorkflowCommons.DefinitionHelper

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=8eca5706-075b-47cf-b187-1113de9d415c; sourceKind=Association; association=DefinitionHelper_DashboardContext; summary=retrieve DefinitionHelperList over association DefinitionHelper_DashboardContext from DashboardContext
- nodeId=5d429e7f-f9f1-4a70-bfbd-57d6c9b570dd; sourceKind=Association; association=DashboardContext_DefinitionHelperWorkflow; summary=retrieve DefinitionHelperWorkflow over association DashboardContext_DefinitionHelperWorkflow from DashboardContext
- nodeId=b92d6265-5cf1-4598-9082-d4f4f022bf20; sourceKind=Database; entity=System.WorkflowUserTaskDefinition; summary=retrieve WorkflowTaskDefinitionList from System.WorkflowUserTaskDefinition
- nodeId=e84b260f-5225-4f5d-8184-892a4f6f31fc; caption=!= empty?; expression=$DashboardContext/WorkflowCommons.DashboardContext_DefinitionHelperWorkflow != empty != empty? expression=$DashboardContext/WorkflowCommons.DashboardContext_DefinitionHelperWorkflow != empty
- nodeId=f31c022f-de60-423b-b89c-56a27272c49d; caption=Has NPE?; expression=$DefinitionHelperList != empty Has NPE? expression=$DefinitionHelperList != empty
- nodeId=f7fe1f55-9b38-4c91-824d-7955022d3053; caption=None for this workflow?; expression=$TaskDefinitionHelperList != empty None for this workflow? expression=$TaskDefinitionHelperList != empty
- nodeId=e9afdc50-ca6c-4feb-931d-6d05367d5c20; actionKind=Change; members=type=Add, value=$NewDefinitionHelper; summary=ChangeListAction: change NewWorkflowDefinitionHelperList (type=Add, value=$NewDefinitionHelper) change NewWorkflowDefinitionHelperList (type=Add, value=$NewDefinitionHelper)
- nodeId=ef78ba72-9cd7-4338-b3b2-bc3547b87055; actionKind=Create; entity=WorkflowCommons.DefinitionHelper; members=DisplayText=$IteratorWorkflowTaskDefinition/Name, Key=$IteratorWorkflowTaskDefinition/Name, DefinitionHelper_DashboardContext=$DashboardContext, DefinitionHelper_DefinitionHelperParent=$DefinitionHelperWorkflow; summary=CreateObjectAction: create WorkflowCommons.DefinitionHelper as NewDefinitionHelper (DisplayText=$IteratorWorkflowTaskDefinition/Name, Key=$IteratorWorkflowTaskDefinition/Name, DefinitionHelper_DashboardContext=$DashboardContext, DefinitionHelper_DefinitionHelperParent=$DefinitionHelperWorkflow) create WorkflowCommons.DefinitionHelper as NewDefinitionHelper (DisplayText=$IteratorWorkflowTaskDefinition/Name, Key=$IteratorWorkflowTaskDefinition/Name, DefinitionHelper_DashboardContext=$DashboardContext, DefinitionHelper_DefinitionHelperParent=$DefinitionHelperWorkflow)

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ds-workflowtaskdefinition-selectable-userimplementation.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
