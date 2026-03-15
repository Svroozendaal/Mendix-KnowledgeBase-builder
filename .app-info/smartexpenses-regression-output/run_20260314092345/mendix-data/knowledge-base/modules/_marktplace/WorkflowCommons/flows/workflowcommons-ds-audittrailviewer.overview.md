---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.DS_AuditTrailViewer
stableId: 28010f5b-2674-4cea-a0e1-c0513cd34b9c
slug: workflowcommons-ds-audittrailviewer
layer: L1
l0: workflowcommons-ds-audittrailviewer.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ds-audittrailviewer.json
l2Logical: flow:WorkflowCommons.DS_AuditTrailViewer
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.DS_AuditTrailViewer

## Summary

- Likely acts as a save, process, or background step for WorkflowCommons.AuditTrailViewer because it mutates data without showing a page.
- L0: [abstract](workflowcommons-ds-audittrailviewer.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ds-audittrailviewer.json)

## Main Steps

- CreateObjectAction: create WorkflowCommons.AuditTrailViewer as NewAuditTrailViewer create WorkflowCommons.AuditTrailViewer as NewAuditTrailViewer

## Trigger/Input/Output Context

- Kind: Nanoflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- WorkflowCommons.AuditTrailViewer

## Called / Called By

- Calls: WorkflowCommons.SUB_AuditTrailViewer_Default
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=a9721078-9249-40ea-b544-c647bb01901d; actionKind=Create; entity=WorkflowCommons.AuditTrailViewer; summary=CreateObjectAction: create WorkflowCommons.AuditTrailViewer as NewAuditTrailViewer create WorkflowCommons.AuditTrailViewer as NewAuditTrailViewer

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ds-audittrailviewer.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
