---
objectType: flow
module: Inspection
qualifiedName: Inspection.ACT_Tool_Validate
stableId: 5081f960-a45e-4f9b-b57d-7a87b0d8a26c
slug: inspection-act-tool-validate
layer: L1
l0: inspection-act-tool-validate.abstract.md
l2Path: ../../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-act-tool-validate.json
l2Logical: flow:Inspection.ACT_Tool_Validate
sourceRun: cli_2026-03-18T20-44-56.522Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Inspection.ACT_Tool_Validate

## Summary

- Likely acts as a save, process, or background step for Inspection.Booking because it mutates data without showing a page.
- L0: [abstract](inspection-act-tool-validate.abstract.md)
- L2: [json](../../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-act-tool-validate.json)

## Main Steps

- RetrieveAction: retrieve Booking from Inspection.Booking retrieve Booking from Inspection.Booking
- $IsValid IsValid? expression=$IsValid
- $Booking = empty Empty? expression=$Booking = empty
- ChangeObjectAction: change Tool (refreshInClient=true) change Tool (refreshInClient=true)
- CreateObjectAction: create Inspection.Booking as NewBooking (Booking_Equipment=$Tool, Date=$Tool/ReservationDate) create Inspection.Booking as NewBooking (Booking_Equipment=$Tool, Date=$Tool/ReservationDate)

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

- nodeId=2cc427e7-f4c6-4036-871b-78c7feb97dcd; sourceKind=Database; entity=Inspection.Booking; summary=RetrieveAction: retrieve Booking from Inspection.Booking retrieve Booking from Inspection.Booking
- nodeId=6f1556d2-5631-4688-9d04-04f367a19d6f; caption=IsValid?; expression=$IsValid IsValid? expression=$IsValid
- nodeId=ea8859e8-06f8-4728-a6a9-392d5ea809aa; caption=Empty?; expression=$Booking = empty Empty? expression=$Booking = empty
- nodeId=84c11f64-8195-40b7-8281-79bd45515d78; actionKind=Change; members=refreshInClient=true; summary=ChangeObjectAction: change Tool (refreshInClient=true) change Tool (refreshInClient=true)
- nodeId=f49ca909-ded1-4323-8cc4-ea472bac4dfb; actionKind=Create; entity=Inspection.Booking; members=Booking_Equipment=$Tool, Date=$Tool/ReservationDate; summary=CreateObjectAction: create Inspection.Booking as NewBooking (Booking_Equipment=$Tool, Date=$Tool/ReservationDate) create Inspection.Booking as NewBooking (Booking_Equipment=$Tool, Date=$Tool/ReservationDate)

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-act-tool-validate.json)
- Aggregate export: [flows.json](../../../../../mendix-data-p05-legacy/app-overview/cli_2026-03-18T20-44-56.522Z/modules/Inspection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../mendix-data-p05-legacy/app-overview/cli_2026-03-18T20-44-56.522Z/modules/Inspection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-44-56.522Z
