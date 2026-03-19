---
objectType: flow
module: Inspection
qualifiedName: Inspection.VAL_Tool_Validate
stableId: 43b0ec21-c41a-4461-9604-e9a6a19d87d5
slug: inspection-val-tool-validate
layer: L1
l0: inspection-val-tool-validate.abstract.md
l2Path: ../../../../app-overview/current/modules/Inspection/flows/inspection-val-tool-validate.json
l2Logical: flow:Inspection.VAL_Tool_Validate
sourceRun: cli_2026-03-18T20-57-13.045Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Inspection.VAL_Tool_Validate

## Summary

- Likely serves as a helper flow invoked from Inspection.ACT_Tool_Validate.
- L0: [abstract](inspection-val-tool-validate.abstract.md)
- L2: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-val-tool-validate.json)

## Main Steps

- $Tool/ReservationDate != empty
- $Tool/ReservationDate >= [%CurrentDateTime%]

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by Inspection.ACT_Tool_Validate.
- Output/UI context: No page output was exported; check L2 JSON if the exact user-facing effect matters.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: Inspection.ACT_Tool_Validate

## Shown Pages

- No ShowPageAction was exported for this flow; it may serve validation, background processing, or delegate work to other flows.

## Important Retrieves/Decisions/Mutations

- nodeId=n003-decision; caption=IF; expression=$Tool/ReservationDate != empty
- nodeId=n006-decision; caption=IF; expression=$Tool/ReservationDate >= [%CurrentDateTime%]

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-val-tool-validate.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-18T20-57-13.045Z/modules/Inspection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-18T20-57-13.045Z/modules/Inspection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-57-13.045Z
