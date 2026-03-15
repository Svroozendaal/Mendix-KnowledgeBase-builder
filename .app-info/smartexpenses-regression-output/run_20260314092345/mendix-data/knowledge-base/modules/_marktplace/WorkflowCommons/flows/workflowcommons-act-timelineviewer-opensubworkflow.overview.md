---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.ACT_TimelineViewer_OpenSubWorkflow
stableId: 20820f3d-60fa-4cb8-8a08-b21a8f1731a4
slug: workflowcommons-act-timelineviewer-opensubworkflow
layer: L1
l0: workflowcommons-act-timelineviewer-opensubworkflow.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-timelineviewer-opensubworkflow.json
l2Logical: flow:WorkflowCommons.ACT_TimelineViewer_OpenSubWorkflow
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.ACT_TimelineViewer_OpenSubWorkflow

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](workflowcommons-act-timelineviewer-opensubworkflow.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-timelineviewer-opensubworkflow.json)

## Main Steps

- retrieve Workflow over association WorkflowRecord_Workflow from WorkflowRecordForSubWorkflow
- retrieve WorkflowRecordForSubWorkflow over association WorkflowActivityRecord_SubWorkflow from WorkflowActivityRecord
- $WorkflowActivityRecord != empty and $WorkflowActivityRecord/System.WorkflowActivityRecord_SubWorkflow != empty Sub workflow? expression=$WorkflowActivityRecord != empty and $WorkflowActivityRecord/System.WorkflowActivityRecord_SubWorkflow != empty
- $WorkflowRecordForSubWorkflow != empty and $WorkflowRecordForSubWorkflow/System.WorkflowRecord_Workflow != empty Workflow? expression=$WorkflowRecordForSubWorkflow != empty and $WorkflowRecordForSubWorkflow/System.WorkflowRecord_Workflow != empty
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

- nodeId=ae211024-514b-48f7-945a-d50744b42e11; sourceKind=Association; association=WorkflowRecord_Workflow; summary=retrieve Workflow over association WorkflowRecord_Workflow from WorkflowRecordForSubWorkflow
- nodeId=df326991-5456-473f-8b50-162a3ee1ddac; sourceKind=Association; association=WorkflowActivityRecord_SubWorkflow; summary=retrieve WorkflowRecordForSubWorkflow over association WorkflowActivityRecord_SubWorkflow from WorkflowActivityRecord
- nodeId=0e273e99-3e2d-4e04-8267-7706727d680e; caption=Sub workflow?; expression=$WorkflowActivityRecord != empty and $WorkflowActivityRecord/System.WorkflowActivityRecord_SubWorkflow != empty Sub workflow? expression=$WorkflowActivityRecord != empty and $WorkflowActivityRecord/System.WorkflowActivityRecord_SubWorkflow != empty
- nodeId=0980d936-96bc-4c32-8108-ac33d45ee603; caption=Workflow?; expression=$WorkflowRecordForSubWorkflow != empty and $WorkflowRecordForSubWorkflow/System.WorkflowRecord_Workflow != empty Workflow? expression=$WorkflowRecordForSubWorkflow != empty and $WorkflowRecordForSubWorkflow/System.WorkflowRecord_Workflow != empty
- nodeId=5a695fa3-576b-4988-b53b-167e303644c9; actionKind=Change; members=TimelineViewer_Workflow=$Workflow; refreshInClient=true; summary=ChangeObjectAction: change TimelineViewer (TimelineViewer_Workflow=$Workflow; refreshInClient=true) change TimelineViewer (TimelineViewer_Workflow=$Workflow; refreshInClient=true)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-timelineviewer-opensubworkflow.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
