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
sourceRun: cli_2026-03-18T20-52-48.461Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Inspection.VAL_Tool_Validate

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](inspection-val-tool-validate.abstract.md)
- L2: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-val-tool-validate.json)

## Main Steps

- $Tool/ReservationDate != empty ReservationDate filled? expression=$Tool/ReservationDate != empty
- $Tool/ReservationDate >= [%CurrentDateTime%] ReservationDate valid? expression=$Tool/ReservationDate >= [%CurrentDateTime%]
- CreateVariableAction: create variable IsValid=true create variable IsValid=true
- ChangeVariableAction: change variable IsValid=false change variable IsValid=false

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by Inspection.ACT_Tool_Validate.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: Inspection.ACT_Tool_Validate

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=4a5a3bd8-4656-4138-8de8-42f16ba8dfb5; caption=ReservationDate filled?; expression=$Tool/ReservationDate != empty ReservationDate filled? expression=$Tool/ReservationDate != empty
- nodeId=a49e7f1d-2fc3-481e-a262-ae221161d7a8; caption=ReservationDate valid?; expression=$Tool/ReservationDate >= [%CurrentDateTime%] ReservationDate valid? expression=$Tool/ReservationDate >= [%CurrentDateTime%]
- nodeId=1495553d-b7d3-4d2d-93f8-573828828e46; actionKind=Create; summary=CreateVariableAction: create variable IsValid=true create variable IsValid=true
- nodeId=3e166267-377b-42c1-ab96-3efbbfd0ac79; actionKind=Change; summary=ChangeVariableAction: change variable IsValid=false change variable IsValid=false
- nodeId=f4c1070a-6925-4fc2-b50f-02e24cf515e6; actionKind=Change; summary=ChangeVariableAction: change variable IsValid=false change variable IsValid=false

## Warnings/Unknowns

- Rollback hint detected in node detail.
- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-val-tool-validate.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/Inspection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/Inspection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-52-48.461Z
