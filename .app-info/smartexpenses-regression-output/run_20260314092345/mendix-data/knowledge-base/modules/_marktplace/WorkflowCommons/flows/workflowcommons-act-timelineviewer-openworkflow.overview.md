---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.ACT_TimelineViewer_OpenWorkflow
stableId: 3096373a-721f-49c5-b826-2bebc7221bb4
slug: workflowcommons-act-timelineviewer-openworkflow
layer: L1
l0: workflowcommons-act-timelineviewer-openworkflow.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-timelineviewer-openworkflow.json
l2Logical: flow:WorkflowCommons.ACT_TimelineViewer_OpenWorkflow
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.ACT_TimelineViewer_OpenWorkflow

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](workflowcommons-act-timelineviewer-openworkflow.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-timelineviewer-openworkflow.json)

## Main Steps

- $Workflow != empty Workflow? expression=$Workflow != empty
- ChangeObjectAction: change TimelineViewer (TimelineViewer_Workflow=$Workflow; refreshInClient=true) change TimelineViewer (TimelineViewer_Workflow=$Workflow; refreshInClient=true)

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

- nodeId=37a9747b-f2bb-4e95-8791-ab62babe88c4; caption=Workflow?; expression=$Workflow != empty Workflow? expression=$Workflow != empty
- nodeId=71e29d41-ebe7-4abb-9c97-fac32032b818; actionKind=Change; members=TimelineViewer_Workflow=$Workflow; refreshInClient=true; summary=ChangeObjectAction: change TimelineViewer (TimelineViewer_Workflow=$Workflow; refreshInClient=true) change TimelineViewer (TimelineViewer_Workflow=$Workflow; refreshInClient=true)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-timelineviewer-openworkflow.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
