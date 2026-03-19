---
objectType: flow
module: Inspection
qualifiedName: Inspection.DS_Task_GetFromNotification
stableId: 06f8894c-c88c-4ff9-be18-3f7386ec0a5f
slug: inspection-ds-task-getfromnotification
layer: L1
l0: inspection-ds-task-getfromnotification.abstract.md
l2Path: ../../../../app-overview/current/modules/Inspection/flows/inspection-ds-task-getfromnotification.json
l2Logical: flow:Inspection.DS_Task_GetFromNotification
sourceRun: cli_2026-03-18T20-49-03.032Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Inspection.DS_Task_GetFromNotification

## Summary

- Likely supplies data to callers or pages rather than driving user navigation directly.
- L0: [abstract](inspection-ds-task-getfromnotification.abstract.md)
- L2: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-ds-task-getfromnotification.json)

## Main Steps

- retrieve from Inspection.Task WHERE TaskID = $Notification/AssociatedObject LIMIT 1

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; check L2 JSON if the exact user-facing effect matters.

## Key Entities Touched

- Inspection.Task

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it may serve validation, background processing, or delegate work to other flows.

## Important Retrieves/Decisions/Mutations

- nodeId=n002-retrieve; sourceKind=Database; entity=Inspection.Task; xPath=TaskID = $Notification/AssociatedObject; summary=retrieve from Inspection.Task WHERE TaskID = $Notification/AssociatedObject LIMIT 1

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-ds-task-getfromnotification.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-18T20-49-03.032Z/modules/Inspection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-18T20-49-03.032Z/modules/Inspection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-49-03.032Z
