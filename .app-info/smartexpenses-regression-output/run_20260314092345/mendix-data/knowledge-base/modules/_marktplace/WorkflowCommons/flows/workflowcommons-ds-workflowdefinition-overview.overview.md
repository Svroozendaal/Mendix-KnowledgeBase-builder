---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.DS_WorkflowDefinition_Overview
stableId: fa98109f-7173-42ec-a012-6c84851321ad
slug: workflowcommons-ds-workflowdefinition-overview
layer: L1
l0: workflowcommons-ds-workflowdefinition-overview.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ds-workflowdefinition-overview.json
l2Logical: flow:WorkflowCommons.DS_WorkflowDefinition_Overview
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.DS_WorkflowDefinition_Overview

## Summary

- Likely acts as a save, process, or background step for System.WorkflowDefinition, WorkflowCommons.WorkflowSummary because it mutates data without showing a page.
- L0: [abstract](workflowcommons-ds-workflowdefinition-overview.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ds-workflowdefinition-overview.json)

## Main Steps

- retrieve WorkflowDefinitionList from System.WorkflowDefinition
- ChangeListAction: change WorkflowSummaryList (type=Add, value=$WorkflowSummary) change WorkflowSummaryList (type=Add, value=$WorkflowSummary)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- System.WorkflowDefinition, WorkflowCommons.WorkflowSummary

## Called / Called By

- Calls: WorkflowCommons.SUB_WorkflowSummary_CreateOrUpdate
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=f7fc79b4-a469-45f4-94da-13b146c06ced; sourceKind=Database; entity=System.WorkflowDefinition; summary=retrieve WorkflowDefinitionList from System.WorkflowDefinition
- nodeId=6bc9ceff-d13d-47fb-a46a-1ce1b773b192; actionKind=Change; members=type=Add, value=$WorkflowSummary; summary=ChangeListAction: change WorkflowSummaryList (type=Add, value=$WorkflowSummary) change WorkflowSummaryList (type=Add, value=$WorkflowSummary)

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ds-workflowdefinition-overview.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
