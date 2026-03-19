---
objectType: flow
module: Inspection
qualifiedName: Inspection.DS_Booking_RetrieveUpcomming
stableId: 1fa008c0-9989-4f08-9bf9-4192f50a3dd9
slug: inspection-ds-booking-retrieveupcomming
layer: L1
l0: inspection-ds-booking-retrieveupcomming.abstract.md
l2Path: ../../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-ds-booking-retrieveupcomming.json
l2Logical: flow:Inspection.DS_Booking_RetrieveUpcomming
sourceRun: cli_2026-03-18T20-44-56.522Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Inspection.DS_Booking_RetrieveUpcomming

## Summary

- Likely supplies data to callers or pages rather than driving user navigation directly.
- L0: [abstract](inspection-ds-booking-retrieveupcomming.abstract.md)
- L2: [json](../../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-ds-booking-retrieveupcomming.json)

## Main Steps

- RetrieveAction: retrieve Booking over association Booking_Equipment from Tool retrieve Booking over association Booking_Equipment from Tool
- Every day at 2:00AM a scheduled event clears all bookings < currentdatetime, so only bookings of today > will be retrieved

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

- nodeId=e07dcea6-a0ce-4de6-ba89-8f381a76cec9; sourceKind=Association; association=Booking_Equipment; summary=RetrieveAction: retrieve Booking over association Booking_Equipment from Tool retrieve Booking over association Booking_Equipment from Tool
- nodeId=ea208cc9-dcb1-4405-9b04-2ffb8827f0dd; sourceKind=Unknown; summary=Every day at 2:00AM a scheduled event clears all bookings < currentdatetime, so only bookings of today > will be retrieved

## Warnings/Unknowns

- Rollback hint detected in node detail.
- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-ds-booking-retrieveupcomming.json)
- Aggregate export: [flows.json](../../../../../mendix-data-p05-legacy/app-overview/cli_2026-03-18T20-44-56.522Z/modules/Inspection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../mendix-data-p05-legacy/app-overview/cli_2026-03-18T20-44-56.522Z/modules/Inspection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-44-56.522Z
