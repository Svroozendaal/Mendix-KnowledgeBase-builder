---
objectType: flow
module: Inspection
qualifiedName: Inspection.ACT_Tool_Validate
stableId: 5081f960-a45e-4f9b-b57d-7a87b0d8a26c
slug: inspection-act-tool-validate
layer: L1
l0: inspection-act-tool-validate.abstract.md
l2Path: ../../../../app-overview/current/modules/Inspection/flows/inspection-act-tool-validate.json
l2Logical: flow:Inspection.ACT_Tool_Validate
sourceRun: cli_2026-03-18T20-49-03.032Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Inspection.ACT_Tool_Validate

## Summary

- Likely acts as a save, process, or background step for Inspection.Booking because it mutates data without showing a page.
- L0: [abstract](inspection-act-tool-validate.abstract.md)
- L2: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-act-tool-validate.json)

## Main Steps

- retrieve from Inspection.Booking WHERE Inspection.Booking_Equipment = $Tool] [Date = $Tool/ReservationDate LIMIT 1
- $Booking = empty
- $IsValid
- @color Purple $NewBooking = CREATE Inspection.Booking (Booking_Equipment = $Tool, Date = $Tool/ReservationDate) @color Purple $NewBooking = CREATE Inspection.Booking (Booking_Equipment = $Tool, Date = $Tool/ReservationDate)
- @annotation 'Refresh to trigger DS microflow' CHANGE $Tool @annotation 'Refresh to trigger DS microflow' CHANGE $Tool

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- Inspection.Booking

## Called / Called By

- Calls: Inspection.VAL_Tool_Validate
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=n002-retrieve; sourceKind=Database; entity=Inspection.Booking; xPath=Inspection.Booking_Equipment = $Tool] [Date = $Tool/ReservationDate; summary=retrieve from Inspection.Booking WHERE Inspection.Booking_Equipment = $Tool] [Date = $Tool/ReservationDate LIMIT 1
- nodeId=n003-decision; caption=IF; expression=$Booking = empty
- nodeId=n005-decision; caption=IF; expression=$IsValid
- nodeId=n006-action; actionKind=Create; entity=Inspection.Booking; members=Booking_Equipment = $Tool, Date = $Tool/ReservationDate; summary=@color Purple $NewBooking = CREATE Inspection.Booking (Booking_Equipment = $Tool, Date = $Tool/ReservationDate) @color Purple $NewBooking = CREATE Inspection.Booking (Booking_Equipment = $Tool, Date = $Tool/ReservationDate)
- nodeId=n007-action; actionKind=Change; summary=@annotation 'Refresh to trigger DS microflow' CHANGE $Tool @annotation 'Refresh to trigger DS microflow' CHANGE $Tool

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-act-tool-validate.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-18T20-49-03.032Z/modules/Inspection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-18T20-49-03.032Z/modules/Inspection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-49-03.032Z
