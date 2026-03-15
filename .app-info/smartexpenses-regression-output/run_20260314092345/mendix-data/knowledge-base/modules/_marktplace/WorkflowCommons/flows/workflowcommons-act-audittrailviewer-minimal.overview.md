---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.ACT_AuditTrailViewer_Minimal
stableId: d98723c6-d5e7-4b8a-963d-b5489e0970d2
slug: workflowcommons-act-audittrailviewer-minimal
layer: L1
l0: workflowcommons-act-audittrailviewer-minimal.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-audittrailviewer-minimal.json
l2Logical: flow:WorkflowCommons.ACT_AuditTrailViewer_Minimal
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.ACT_AuditTrailViewer_Minimal

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](workflowcommons-act-audittrailviewer-minimal.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-audittrailviewer-minimal.json)

## Main Steps

- ChangeObjectAction: change AuditTrailViewer (Configuration='{ "name": "dataGrid2_auditTrail", "schemaVersion": 2, "settingsHash": "4081041333", "columns": [ { "columnId": "0", "hidden": false }, { "columnId": "1", "hidden": false }, { "col..., ActiveView=WorkflowCommons.Enum_AuditTrail_View.Minimal; refreshInClient=true) change AuditTrailViewer (Configuration='{ "name": "dataGrid2_auditTrail", "schemaVersion": 2, "settingsHash": "4081041333", "columns": [ { "columnId": "0", "hidden": false }, { "columnId": "1", "hidden": false }, { "col..., ActiveView=WorkflowCommons.Enum_AuditTrail_View.Minimal; refreshInClient=true)

## Trigger/Input/Output Context

- Kind: Nanoflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=1c9878ba-b00c-4cfd-8aa3-4cbef671e26f; actionKind=Change; entity=WorkflowCommons.Enum_AuditTrail_View; members=Configuration='{ "name": "dataGrid2_auditTrail", "schemaVersion": 2, "settingsHash": "4081041333", "columns": [ { "columnId": "0", "hidden": false }, { "columnId": "1", "hidden": false }, { "col..., ActiveView=WorkflowCommons.Enum_AuditTrail_View.Minimal; refreshInClient=true; summary=ChangeObjectAction: change AuditTrailViewer (Configuration='{ "name": "dataGrid2_auditTrail", "schemaVersion": 2, "settingsHash": "4081041333", "columns": [ { "columnId": "0", "hidden": false }, { "columnId": "1", "hidden": false }, { "col..., ActiveView=WorkflowCommons.Enum_AuditTrail_View.Minimal; refreshInClient=true) change AuditTrailViewer (Configuration='{ "name": "dataGrid2_auditTrail", "schemaVersion": 2, "settingsHash": "4081041333", "columns": [ { "columnId": "0", "hidden": false }, { "columnId": "1", "hidden": false }, { "col..., ActiveView=WorkflowCommons.Enum_AuditTrail_View.Minimal; refreshInClient=true)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-audittrailviewer-minimal.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
