---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_AuditTrailViewer_Default
stableId: 95babfa3-c852-4ad9-bf6e-7d284563c4e6
slug: workflowcommons-sub-audittrailviewer-default
layer: L1
l0: workflowcommons-sub-audittrailviewer-default.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-audittrailviewer-default.json
l2Logical: flow:WorkflowCommons.SUB_AuditTrailViewer_Default
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_AuditTrailViewer_Default

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](workflowcommons-sub-audittrailviewer-default.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-audittrailviewer-default.json)

## Main Steps

- ChangeObjectAction: change AuditTrailViewer (Configuration='{ "name": "dataGrid2_auditTrail", "schemaVersion": 2, "settingsHash": "4081041333", "columns": [ { "columnId": "0", "hidden": false }, { "columnId": "1", "hidden": false }, { "col..., ActiveView=WorkflowCommons.Enum_AuditTrail_View._Default; refreshInClient=true) change AuditTrailViewer (Configuration='{ "name": "dataGrid2_auditTrail", "schemaVersion": 2, "settingsHash": "4081041333", "columns": [ { "columnId": "0", "hidden": false }, { "columnId": "1", "hidden": false }, { "col..., ActiveView=WorkflowCommons.Enum_AuditTrail_View._Default; refreshInClient=true)

## Trigger/Input/Output Context

- Kind: Nanoflow
- Entry/call context: Called by WorkflowCommons.ACT_AuditTrailViewer_Default, WorkflowCommons.DS_AuditTrailViewer.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: WorkflowCommons.ACT_AuditTrailViewer_Default, WorkflowCommons.DS_AuditTrailViewer

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=06672cc3-9b18-4057-a29a-f5d354c89361; actionKind=Change; entity=WorkflowCommons.Enum_AuditTrail_View; members=Configuration='{ "name": "dataGrid2_auditTrail", "schemaVersion": 2, "settingsHash": "4081041333", "columns": [ { "columnId": "0", "hidden": false }, { "columnId": "1", "hidden": false }, { "col..., ActiveView=WorkflowCommons.Enum_AuditTrail_View._Default; refreshInClient=true; summary=ChangeObjectAction: change AuditTrailViewer (Configuration='{ "name": "dataGrid2_auditTrail", "schemaVersion": 2, "settingsHash": "4081041333", "columns": [ { "columnId": "0", "hidden": false }, { "columnId": "1", "hidden": false }, { "col..., ActiveView=WorkflowCommons.Enum_AuditTrail_View._Default; refreshInClient=true) change AuditTrailViewer (Configuration='{ "name": "dataGrid2_auditTrail", "schemaVersion": 2, "settingsHash": "4081041333", "columns": [ { "columnId": "0", "hidden": false }, { "columnId": "1", "hidden": false }, { "col..., ActiveView=WorkflowCommons.Enum_AuditTrail_View._Default; refreshInClient=true)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-audittrailviewer-default.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
