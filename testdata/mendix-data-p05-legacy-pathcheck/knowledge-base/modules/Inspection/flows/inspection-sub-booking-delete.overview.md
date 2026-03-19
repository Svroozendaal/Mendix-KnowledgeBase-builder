---
objectType: flow
module: Inspection
qualifiedName: Inspection.SUB_Booking_Delete
stableId: 0787625d-8f0f-407a-b62a-5cba6ad16f9e
slug: inspection-sub-booking-delete
layer: L1
l0: inspection-sub-booking-delete.abstract.md
l2Path: ../../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-sub-booking-delete.json
l2Logical: flow:Inspection.SUB_Booking_Delete
sourceRun: cli_2026-03-18T20-44-56.522Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Inspection.SUB_Booking_Delete

## Summary

- Likely acts as a save, process, or background step for Inspection.Booking because it mutates data without showing a page.
- L0: [abstract](inspection-sub-booking-delete.abstract.md)
- L2: [json](../../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-sub-booking-delete.json)

## Main Steps

- RetrieveAction: retrieve BookingList from Inspection.Booking retrieve BookingList from Inspection.Booking
- DeleteAction: delete BookingList (refreshInClient=false) delete BookingList (refreshInClient=false)

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

- nodeId=31af6eff-f26b-460a-af4c-102e1d4c0b93; sourceKind=Database; entity=Inspection.Booking; summary=RetrieveAction: retrieve BookingList from Inspection.Booking retrieve BookingList from Inspection.Booking
- nodeId=7422a9c5-cabf-4866-9e6c-91082cb8177e; actionKind=Delete; members=refreshInClient=false; summary=DeleteAction: delete BookingList (refreshInClient=false) delete BookingList (refreshInClient=false)

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-sub-booking-delete.json)
- Aggregate export: [flows.json](../../../../../mendix-data-p05-legacy/app-overview/cli_2026-03-18T20-44-56.522Z/modules/Inspection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../mendix-data-p05-legacy/app-overview/cli_2026-03-18T20-44-56.522Z/modules/Inspection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-44-56.522Z
