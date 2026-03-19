---
objectType: flow
module: Inspection
qualifiedName: Inspection.SUB_Booking_Delete
stableId: 0787625d-8f0f-407a-b62a-5cba6ad16f9e
slug: inspection-sub-booking-delete
layer: L1
l0: inspection-sub-booking-delete.abstract.md
l2Path: ../../../../app-overview/current/modules/Inspection/flows/inspection-sub-booking-delete.json
l2Logical: flow:Inspection.SUB_Booking_Delete
sourceRun: cli_2026-03-18T20-53-14.243Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Inspection.SUB_Booking_Delete

## Summary

- Likely acts as a save, process, or background step for Inspection.Booking because it mutates data without showing a page.
- L0: [abstract](inspection-sub-booking-delete.abstract.md)
- L2: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-sub-booking-delete.json)

## Main Steps

- retrieve from Inspection.Booking WHERE Date < '[%CurrentDateTime%]'
- delete $BookingList

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by Inspection.SE_Booking_DeleteOlderThenToday.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- Inspection.Booking

## Called / Called By

- Calls: none
- Called by: Inspection.SE_Booking_DeleteOlderThenToday

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=n002-retrieve; sourceKind=Database; entity=Inspection.Booking; xPath=Date < '[%CurrentDateTime%]'; summary=retrieve from Inspection.Booking WHERE Date < '[%CurrentDateTime%]'
- nodeId=n003-delete; actionKind=Delete; entity=Inspection.Booking; summary=delete $BookingList

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-sub-booking-delete.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-18T20-53-14.243Z/modules/Inspection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-18T20-53-14.243Z/modules/Inspection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-53-14.243Z
