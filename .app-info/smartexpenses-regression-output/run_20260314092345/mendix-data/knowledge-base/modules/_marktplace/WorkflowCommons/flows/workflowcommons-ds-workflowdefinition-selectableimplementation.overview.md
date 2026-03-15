---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.DS_WorkflowDefinition_SelectableImplementation
stableId: 6f16af59-651a-45c3-85b3-f52b1e3a5bb3
slug: workflowcommons-ds-workflowdefinition-selectableimplementation
layer: L1
l0: workflowcommons-ds-workflowdefinition-selectableimplementation.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ds-workflowdefinition-selectableimplementation.json
l2Logical: flow:WorkflowCommons.DS_WorkflowDefinition_SelectableImplementation
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.DS_WorkflowDefinition_SelectableImplementation

## Summary

- Likely acts as a save, process, or background step for System.WorkflowDefinition, WorkflowCommons.DefinitionHelper because it mutates data without showing a page.
- L0: [abstract](workflowcommons-ds-workflowdefinition-selectableimplementation.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ds-workflowdefinition-selectableimplementation.json)

## Main Steps

- retrieve DefinitionHelperList over association DefinitionHelper_DashboardContext from DashboardContext
- retrieve WorkflowDefinitionList from System.WorkflowDefinition
- $DefinitionHelperList != empty Has NPE? expression=$DefinitionHelperList != empty
- ChangeListAction: change NewWorkflowDefinitionHelperList (type=Add, value=$NewDefinitionHelper) change NewWorkflowDefinitionHelperList (type=Add, value=$NewDefinitionHelper)
- CreateObjectAction: create WorkflowCommons.DefinitionHelper as NewDefinitionHelper (DisplayText=$IteratorWorkflowDefinition/Title, Key=$IteratorWorkflowDefinition/Name, DefinitionHelper_DashboardContext=$DashboardContext) create WorkflowCommons.DefinitionHelper as NewDefinitionHelper (DisplayText=$IteratorWorkflowDefinition/Title, Key=$IteratorWorkflowDefinition/Name, DefinitionHelper_DashboardContext=$DashboardContext)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- System.WorkflowDefinition, WorkflowCommons.DefinitionHelper

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=72a7740d-bc0a-4ee9-a168-c886f07b2f98; sourceKind=Association; association=DefinitionHelper_DashboardContext; summary=retrieve DefinitionHelperList over association DefinitionHelper_DashboardContext from DashboardContext
- nodeId=043218c1-b7d9-45f0-8187-674dcadc6888; sourceKind=Database; entity=System.WorkflowDefinition; summary=retrieve WorkflowDefinitionList from System.WorkflowDefinition
- nodeId=cb5d61e4-6951-4f8f-a2d8-3887c500cbb2; caption=Has NPE?; expression=$DefinitionHelperList != empty Has NPE? expression=$DefinitionHelperList != empty
- nodeId=0ad1c1d5-271e-4fdc-91c2-3fb058cb0485; actionKind=Change; members=type=Add, value=$NewDefinitionHelper; summary=ChangeListAction: change NewWorkflowDefinitionHelperList (type=Add, value=$NewDefinitionHelper) change NewWorkflowDefinitionHelperList (type=Add, value=$NewDefinitionHelper)
- nodeId=5693b946-61d8-49fb-8418-e41fa781661f; actionKind=Create; entity=WorkflowCommons.DefinitionHelper; members=DisplayText=$IteratorWorkflowDefinition/Title, Key=$IteratorWorkflowDefinition/Name, DefinitionHelper_DashboardContext=$DashboardContext; summary=CreateObjectAction: create WorkflowCommons.DefinitionHelper as NewDefinitionHelper (DisplayText=$IteratorWorkflowDefinition/Title, Key=$IteratorWorkflowDefinition/Name, DefinitionHelper_DashboardContext=$DashboardContext) create WorkflowCommons.DefinitionHelper as NewDefinitionHelper (DisplayText=$IteratorWorkflowDefinition/Title, Key=$IteratorWorkflowDefinition/Name, DefinitionHelper_DashboardContext=$DashboardContext)

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ds-workflowdefinition-selectableimplementation.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
