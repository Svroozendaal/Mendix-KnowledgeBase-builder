---
objectType: flow
module: Inspection
qualifiedName: Inspection.ACT_ReportHelper_Create
stableId: ee715edb-77a3-4a1b-a7d7-1c557d01867d
slug: inspection-act-reporthelper-create
layer: L1
l0: inspection-act-reporthelper-create.abstract.md
l2Path: ../../../../app-overview/current/modules/Inspection/flows/inspection-act-reporthelper-create.json
l2Logical: flow:Inspection.ACT_ReportHelper_Create
sourceRun: cli_2026-03-18T20-44-56.521Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Inspection.ACT_ReportHelper_Create

## Summary

- Likely acts as a UI entry or navigation handler because it shows Inspection.Report_NewEdit.
- L0: [abstract](inspection-act-reporthelper-create.abstract.md)
- L2: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-act-reporthelper-create.json)

## Main Steps

- show page Inspection.Report_NewEdit
- create Inspection.ReportHelper

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: Shows Inspection.Report_NewEdit.

## Key Entities Touched

- Inspection.ReportHelper

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- Inspection.Report_NewEdit

## Important Retrieves/Decisions/Mutations

- nodeId=n002-create; actionKind=Create; entity=Inspection.ReportHelper; summary=create Inspection.ReportHelper

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-act-reporthelper-create.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-18T20-44-56.521Z/modules/Inspection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-18T20-44-56.521Z/modules/Inspection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-44-56.521Z
