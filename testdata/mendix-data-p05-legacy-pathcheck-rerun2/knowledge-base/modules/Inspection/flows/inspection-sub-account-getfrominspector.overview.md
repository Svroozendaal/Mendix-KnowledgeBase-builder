---
objectType: flow
module: Inspection
qualifiedName: Inspection.SUB_Account_GetFromInspector
stableId: bd0d867e-42f7-4673-b7d3-a8f98a0e686d
slug: inspection-sub-account-getfrominspector
layer: L1
l0: inspection-sub-account-getfrominspector.abstract.md
l2Path: ../../../../app-overview/current/modules/Inspection/flows/inspection-sub-account-getfrominspector.json
l2Logical: flow:Inspection.SUB_Account_GetFromInspector
sourceRun: cli_2026-03-18T20-56-46.385Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Inspection.SUB_Account_GetFromInspector

## Summary

- Likely serves as a helper flow invoked from Notification.SE_Notification_SendToInspectors, Notification.SUB_Notification_SendToInspector.
- L0: [abstract](inspection-sub-account-getfrominspector.abstract.md)
- L2: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-sub-account-getfrominspector.json)

## Main Steps

- RetrieveAction: retrieve Account_Inspector over association Inspector_Account from Inspector retrieve Account_Inspector over association Inspector_Account from Inspector

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by Notification.SE_Notification_SendToInspectors, Notification.SUB_Notification_SendToInspector.
- Output/UI context: No page output was exported; check L2 JSON if the exact user-facing effect matters.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: Notification.SE_Notification_SendToInspectors, Notification.SUB_Notification_SendToInspector

## Shown Pages

- No ShowPageAction was exported for this flow; it may serve validation, background processing, or delegate work to other flows.

## Important Retrieves/Decisions/Mutations

- nodeId=366e83be-f561-41a3-802d-8fa1874312cc; sourceKind=Association; association=Inspector_Account; summary=RetrieveAction: retrieve Account_Inspector over association Inspector_Account from Inspector retrieve Account_Inspector over association Inspector_Account from Inspector

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-sub-account-getfrominspector.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-18T20-56-46.385Z/modules/Inspection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-18T20-56-46.385Z/modules/Inspection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-56-46.385Z
