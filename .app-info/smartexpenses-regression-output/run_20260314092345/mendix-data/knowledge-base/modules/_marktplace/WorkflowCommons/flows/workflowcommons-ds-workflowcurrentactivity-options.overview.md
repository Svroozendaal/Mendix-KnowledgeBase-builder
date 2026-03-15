---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.DS_WorkflowCurrentActivity_Options
stableId: f95b49b6-8986-4313-95c5-a82dd46287f6
slug: workflowcommons-ds-workflowcurrentactivity-options
layer: L1
l0: workflowcommons-ds-workflowcurrentactivity-options.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ds-workflowcurrentactivity-options.json
l2Logical: flow:WorkflowCommons.DS_WorkflowCurrentActivity_Options
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.DS_WorkflowCurrentActivity_Options

## Summary

- Likely supplies data to callers or pages rather than driving user navigation directly.
- L0: [abstract](workflowcommons-ds-workflowcurrentactivity-options.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ds-workflowcurrentactivity-options.json)

## Main Steps

- retrieve WorkflowActivityDetailsList over association WorkflowCurrentActivity_ApplicableTargets from WorkflowCurrentActivity

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; check L2 JSON if the exact user-facing effect matters.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it may serve validation, background processing, or delegate work to other flows.

## Important Retrieves/Decisions/Mutations

- nodeId=f4da2085-33fc-407a-a7f4-b42b9e9bd025; sourceKind=Association; association=WorkflowCurrentActivity_ApplicableTargets; summary=retrieve WorkflowActivityDetailsList over association WorkflowCurrentActivity_ApplicableTargets from WorkflowCurrentActivity

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ds-workflowcurrentactivity-options.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
