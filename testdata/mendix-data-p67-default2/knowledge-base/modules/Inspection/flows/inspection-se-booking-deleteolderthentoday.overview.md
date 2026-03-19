---
objectType: flow
module: Inspection
qualifiedName: Inspection.SE_Booking_DeleteOlderThenToday
stableId: d79b7af1-348b-489e-a422-6129bef83531
slug: inspection-se-booking-deleteolderthentoday
layer: L1
l0: inspection-se-booking-deleteolderthentoday.abstract.md
l2Path: ../../../../app-overview/current/modules/Inspection/flows/inspection-se-booking-deleteolderthentoday.json
l2Logical: flow:Inspection.SE_Booking_DeleteOlderThenToday
sourceRun: cli_2026-03-18T21-15-38.461Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Inspection.SE_Booking_DeleteOlderThenToday

## Summary

- Likely orchestrates downstream flow calls without direct UI output.
- L0: [abstract](inspection-se-booking-deleteolderthentoday.abstract.md)
- L2: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-se-booking-deleteolderthentoday.json)

## Main Steps

- No compact step summary was derivable from the exported flow actions.

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; this likely delegates work to downstream flows.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: Inspection.SUB_Booking_Delete
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it may serve validation, background processing, or delegate work to other flows.

## Important Retrieves/Decisions/Mutations

- No retrieve, decision, or mutation metadata was exported for this flow; inspect L2 JSON if node-level evidence matters.

## Warnings/Unknowns

- Rollback hint detected in node detail.
- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-se-booking-deleteolderthentoday.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-18T21-15-38.461Z/modules/Inspection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-18T21-15-38.461Z/modules/Inspection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T21-15-38.461Z
