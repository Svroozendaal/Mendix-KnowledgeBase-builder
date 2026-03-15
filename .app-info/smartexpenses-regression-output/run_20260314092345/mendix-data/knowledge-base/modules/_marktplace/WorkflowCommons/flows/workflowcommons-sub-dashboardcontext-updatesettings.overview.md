---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_DashboardContext_UpdateSettings
stableId: 1942b4fc-8cb1-43b9-afc1-0b7077c5d192
slug: workflowcommons-sub-dashboardcontext-updatesettings
layer: L1
l0: workflowcommons-sub-dashboardcontext-updatesettings.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-dashboardcontext-updatesettings.json
l2Logical: flow:WorkflowCommons.SUB_DashboardContext_UpdateSettings
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_DashboardContext_UpdateSettings

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](workflowcommons-sub-dashboardcontext-updatesettings.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-dashboardcontext-updatesettings.json)

## Main Steps

- ChangeObjectAction: change DashboardContext (TimeFrame=if $DashboardContext/TimeFrame = empty then WorkflowCommons.Enum_DashboardTimeFrame.Last_7_days else $DashboardContext/TimeFrame; refreshInClient=false) change DashboardContext (TimeFrame=if $DashboardContext/TimeFrame = empty then WorkflowCommons.Enum_DashboardTimeFrame.Last_7_days else $DashboardContext/TimeFrame; refreshInClient=false)
- ChangeObjectAction: change DashboardContext (TimeFrameEnd=[%EndOfCurrentDay%], TimeFrameStart=if $DashboardContext/TimeFrame = WorkflowCommons.Enum_DashboardTimeFrame.Last_7_days then addDays([%BeginOfCurrentDay%],-6) else if $DashboardContext/TimeFrame = WorkflowCommons.En..., TimeFrameStepUnit=if $DashboardContext/TimeFrame = WorkflowCommons.Enum_DashboardTimeFrame.Last_7_days then WorkflowCommons.Enum_TimeFrameStepUnit.Day else if $DashboardContext/TimeFrame = WorkflowC..., LastUpdate=[%CurrentDateTime%], DashboardContext_WorkflowTaskDefinition=if $DashboardContext/WorkflowCommons.DashboardContext_WorkflowDefinition = empty then empty else $DashboardContext/WorkflowCommons.DashboardContext_WorkflowTaskDefinition; refreshInClient=false) change DashboardContext (TimeFrameEnd=[%EndOfCurrentDay%], TimeFrameStart=if $DashboardContext/TimeFrame = WorkflowCommons.Enum_DashboardTimeFrame.Last_7_days then addDays([%BeginOfCurrentDay%],-6) else if $DashboardContext/TimeFrame = WorkflowCommons.En..., TimeFrameStepUnit=if $DashboardContext/TimeFrame = WorkflowCommons.Enum_DashboardTimeFrame.Last_7_days then WorkflowCommons.Enum_TimeFrameStepUnit.Day else if $DashboardContext/TimeFrame = WorkflowC..., LastUpdate=[%CurrentDateTime%], DashboardContext_WorkflowTaskDefinition=if $DashboardContext/WorkflowCommons.DashboardContext_WorkflowDefinition = empty then empty else $DashboardContext/WorkflowCommons.DashboardContext_WorkflowTaskDefinition; refreshInClient=false)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.SUB_TaskDashboard_Update, WorkflowCommons.SUB_WorkflowDashboard_Update.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: WorkflowCommons.SUB_TaskDashboard_Update, WorkflowCommons.SUB_WorkflowDashboard_Update

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=429d011c-1a18-421c-869e-fbfe4e6502c1; actionKind=Change; entity=WorkflowCommons.Enum_DashboardTimeFrame; members=TimeFrame=if $DashboardContext/TimeFrame = empty then WorkflowCommons.Enum_DashboardTimeFrame.Last_7_days else $DashboardContext/TimeFrame; refreshInClient=false; summary=ChangeObjectAction: change DashboardContext (TimeFrame=if $DashboardContext/TimeFrame = empty then WorkflowCommons.Enum_DashboardTimeFrame.Last_7_days else $DashboardContext/TimeFrame; refreshInClient=false) change DashboardContext (TimeFrame=if $DashboardContext/TimeFrame = empty then WorkflowCommons.Enum_DashboardTimeFrame.Last_7_days else $DashboardContext/TimeFrame; refreshInClient=false)
- nodeId=5410e67d-6cb8-4034-91b5-4f87f1ee50f0; actionKind=Change; entity=WorkflowCommons.Enum_DashboardTimeFrame; members=TimeFrameEnd=[%EndOfCurrentDay%], TimeFrameStart=if $DashboardContext/TimeFrame = WorkflowCommons.Enum_DashboardTimeFrame.Last_7_days then addDays([%BeginOfCurrentDay%],-6; summary=ChangeObjectAction: change DashboardContext (TimeFrameEnd=[%EndOfCurrentDay%], TimeFrameStart=if $DashboardContext/TimeFrame = WorkflowCommons.Enum_DashboardTimeFrame.Last_7_days then addDays([%BeginOfCurrentDay%],-6) else if $DashboardContext/TimeFrame = WorkflowCommons.En..., TimeFrameStepUnit=if $DashboardContext/TimeFrame = WorkflowCommons.Enum_DashboardTimeFrame.Last_7_days then WorkflowCommons.Enum_TimeFrameStepUnit.Day else if $DashboardContext/TimeFrame = WorkflowC..., LastUpdate=[%CurrentDateTime%], DashboardContext_WorkflowTaskDefinition=if $DashboardContext/WorkflowCommons.DashboardContext_WorkflowDefinition = empty then empty else $DashboardContext/WorkflowCommons.DashboardContext_WorkflowTaskDefinition; refreshInClient=false) change DashboardContext (TimeFrameEnd=[%EndOfCurrentDay%], TimeFrameStart=if $DashboardContext/TimeFrame = WorkflowCommons.Enum_DashboardTimeFrame.Last_7_days then addDays([%BeginOfCurrentDay%],-6) else if $DashboardContext/TimeFrame = WorkflowCommons.En..., TimeFrameStepUnit=if $DashboardContext/TimeFrame = WorkflowCommons.Enum_DashboardTimeFrame.Last_7_days then WorkflowCommons.Enum_TimeFrameStepUnit.Day else if $DashboardContext/TimeFrame = WorkflowC..., LastUpdate=[%CurrentDateTime%], DashboardContext_WorkflowTaskDefinition=if $DashboardContext/WorkflowCommons.DashboardContext_WorkflowDefinition = empty then empty else $DashboardContext/WorkflowCommons.DashboardContext_WorkflowTaskDefinition; refreshInClient=false)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-dashboardcontext-updatesettings.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
