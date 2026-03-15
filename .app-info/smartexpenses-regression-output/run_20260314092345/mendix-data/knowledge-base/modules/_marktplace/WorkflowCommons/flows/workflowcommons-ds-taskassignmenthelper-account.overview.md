---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.DS_TaskAssignmentHelper_Account
stableId: 02798947-fa91-4a80-8e68-d17767781396
slug: workflowcommons-ds-taskassignmenthelper-account
layer: L1
l0: workflowcommons-ds-taskassignmenthelper-account.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ds-taskassignmenthelper-account.json
l2Logical: flow:WorkflowCommons.DS_TaskAssignmentHelper_Account
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.DS_TaskAssignmentHelper_Account

## Summary

- Likely supplies data to callers or pages rather than driving user navigation directly.
- L0: [abstract](workflowcommons-ds-taskassignmenthelper-account.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ds-taskassignmenthelper-account.json)

## Main Steps

- retrieve AccountList from Administration.Account
- retrieve SelectedUser over association TaskAssignmentHelper_Account from TaskAssignmentHelper

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; check L2 JSON if the exact user-facing effect matters.

## Key Entities Touched

- Administration.Account

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it may serve validation, background processing, or delegate work to other flows.

## Important Retrieves/Decisions/Mutations

- nodeId=1ff1db22-0c9e-4c82-b2e0-d3d66e6feb05; sourceKind=Database; entity=Administration.Account; summary=retrieve AccountList from Administration.Account
- nodeId=227848ad-903b-45a1-9758-0ef30b92a88d; sourceKind=Association; association=TaskAssignmentHelper_Account; summary=retrieve SelectedUser over association TaskAssignmentHelper_Account from TaskAssignmentHelper

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ds-taskassignmenthelper-account.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
