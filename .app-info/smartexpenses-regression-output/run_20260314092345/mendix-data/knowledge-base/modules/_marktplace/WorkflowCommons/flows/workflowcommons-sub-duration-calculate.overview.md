---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_Duration_Calculate
stableId: d68f6e03-4c06-4ee7-8cf4-63760497f915
slug: workflowcommons-sub-duration-calculate
layer: L1
l0: workflowcommons-sub-duration-calculate.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-duration-calculate.json
l2Logical: flow:WorkflowCommons.SUB_Duration_Calculate
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_Duration_Calculate

## Summary

- Likely acts as a save, process, or background step for WorkflowCommons.DurationHelper because it mutates data without showing a page.
- L0: [abstract](workflowcommons-sub-duration-calculate.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-duration-calculate.json)

## Main Steps

- $DurationInSeconds > (60 * 60 * 24) Days? expression=$DurationInSeconds > (60 * 60 * 24)
- $EndTime != empty End? expression=$EndTime != empty
- ChangeObjectAction: change NewDurationHelper (Duration=$DurationInSeconds + ' ' + getCaption(WorkflowCommons.Enum_DurationUnit.Seconds); refreshInClient=true) change NewDurationHelper (Duration=$DurationInSeconds + ' ' + getCaption(WorkflowCommons.Enum_DurationUnit.Seconds); refreshInClient=true)
- ChangeObjectAction: change NewDurationHelper (Duration=ceil($DurationInSeconds div (60 * 60 * 24)) + ' ' + getCaption(WorkflowCommons.Enum_DurationUnit.Days); refreshInClient=true) change NewDurationHelper (Duration=ceil($DurationInSeconds div (60 * 60 * 24)) + ' ' + getCaption(WorkflowCommons.Enum_DurationUnit.Days); refreshInClient=true)

## Trigger/Input/Output Context

- Kind: Nanoflow
- Entry/call context: Called by WorkflowCommons.DS_WorkflowActivityRecord_ActivityDuration, WorkflowCommons.DS_WorkflowActivityRecord_OverdueTime.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- WorkflowCommons.DurationHelper

## Called / Called By

- Calls: none
- Called by: WorkflowCommons.DS_WorkflowActivityRecord_ActivityDuration, WorkflowCommons.DS_WorkflowActivityRecord_OverdueTime

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=3549e0c6-8f3a-427f-b170-2ae93a71c1b7; caption=Days?; expression=$DurationInSeconds > (60 * 60 * 24) Days? expression=$DurationInSeconds > (60 * 60 * 24)
- nodeId=6c26c1fa-0b65-4757-8016-4dc1270c385c; caption=End?; expression=$EndTime != empty End? expression=$EndTime != empty
- nodeId=b65e8c6f-fc0d-4922-a5d8-d6d49d756ff6; caption=Hours?; expression=$DurationInSeconds > (60 * 60) Hours? expression=$DurationInSeconds > (60 * 60)
- nodeId=738a8cb0-1a33-47b6-9beb-8b414f369f3b; caption=Minutes?; expression=$DurationInSeconds > 60 Minutes? expression=$DurationInSeconds > 60
- nodeId=75a5d7f3-8630-4ce3-b47e-e71e7c11ca32; caption=Start?; expression=$StartTime != empty Start? expression=$StartTime != empty
- nodeId=e63a3fad-ff48-49ce-b327-fb6640f61fad; actionKind=Change; entity=WorkflowCommons.Enum_DurationUnit; members=Duration=$DurationInSeconds + ' ' + getCaption(WorkflowCommons.Enum_DurationUnit.Seconds; summary=ChangeObjectAction: change NewDurationHelper (Duration=$DurationInSeconds + ' ' + getCaption(WorkflowCommons.Enum_DurationUnit.Seconds); refreshInClient=true) change NewDurationHelper (Duration=$DurationInSeconds + ' ' + getCaption(WorkflowCommons.Enum_DurationUnit.Seconds); refreshInClient=true)
- nodeId=cadef8a5-0264-4fa8-960c-4e9b1323150e; actionKind=Change; entity=WorkflowCommons.Enum_DurationUnit; members=Duration=ceil($DurationInSeconds div (60 * 60 * 24; summary=ChangeObjectAction: change NewDurationHelper (Duration=ceil($DurationInSeconds div (60 * 60 * 24)) + ' ' + getCaption(WorkflowCommons.Enum_DurationUnit.Days); refreshInClient=true) change NewDurationHelper (Duration=ceil($DurationInSeconds div (60 * 60 * 24)) + ' ' + getCaption(WorkflowCommons.Enum_DurationUnit.Days); refreshInClient=true)
- nodeId=3594c373-7894-427a-9704-df889a859277; actionKind=Change; entity=WorkflowCommons.Enum_DurationUnit; members=Duration=ceil($DurationInSeconds div (60 * 60; summary=ChangeObjectAction: change NewDurationHelper (Duration=ceil($DurationInSeconds div (60 * 60)) + ' ' + getCaption(WorkflowCommons.Enum_DurationUnit.Hours); refreshInClient=true) change NewDurationHelper (Duration=ceil($DurationInSeconds div (60 * 60)) + ' ' + getCaption(WorkflowCommons.Enum_DurationUnit.Hours); refreshInClient=true)

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-duration-calculate.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
