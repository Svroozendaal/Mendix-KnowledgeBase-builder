---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.DS_TimelineViewer_WorkflowActivityRecords_Full
stableId: 84948658-5887-41a7-92c1-2439a5f44312
slug: workflowcommons-ds-timelineviewer-workflowactivityrecords-full
layer: L1
l0: workflowcommons-ds-timelineviewer-workflowactivityrecords-full.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ds-timelineviewer-workflowactivityrecords-full.json
l2Logical: flow:WorkflowCommons.DS_TimelineViewer_WorkflowActivityRecords_Full
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.DS_TimelineViewer_WorkflowActivityRecords_Full

## Summary

- Likely supplies data to callers or pages rather than driving user navigation directly.
- L0: [abstract](workflowcommons-ds-timelineviewer-workflowactivityrecords-full.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ds-timelineviewer-workflowactivityrecords-full.json)

## Main Steps

- retrieve Workflow over association TimelineViewer_Workflow from TimelineViewer
- $TimelineViewer/WorkflowCommons.TimelineViewer_Workflow != empty Workflow? expression=$TimelineViewer/WorkflowCommons.TimelineViewer_Workflow != empty

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

- nodeId=ceb03d3c-1e48-463a-bba5-ac069624dc09; sourceKind=Association; association=TimelineViewer_Workflow; summary=retrieve Workflow over association TimelineViewer_Workflow from TimelineViewer
- nodeId=ba4653cb-1dab-4345-9e03-7cf3a1a1a04d; caption=Workflow?; expression=$TimelineViewer/WorkflowCommons.TimelineViewer_Workflow != empty Workflow? expression=$TimelineViewer/WorkflowCommons.TimelineViewer_Workflow != empty

## Warnings/Unknowns

- Rollback hint detected in node detail.
- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-ds-timelineviewer-workflowactivityrecords-full.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
