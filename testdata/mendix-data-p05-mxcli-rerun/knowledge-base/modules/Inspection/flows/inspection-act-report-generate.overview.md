---
objectType: flow
module: Inspection
qualifiedName: Inspection.ACT_Report_Generate
stableId: 0d4bd6ee-299a-4bd3-b178-bb4c23bc643f
slug: inspection-act-report-generate
layer: L1
l0: inspection-act-report-generate.abstract.md
l2Path: ../../../../app-overview/current/modules/Inspection/flows/inspection-act-report-generate.json
l2Logical: flow:Inspection.ACT_Report_Generate
sourceRun: cli_2026-03-18T20-53-14.243Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Inspection.ACT_Report_Generate

## Summary

- Likely acts as a save, process, or background step for Inspection.Report, Inspection.Task because it mutates data without showing a page.
- L0: [abstract](inspection-act-report-generate.abstract.md)
- L2: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-act-report-generate.json)

## Main Steps

- retrieve from Inspection.Task
- create Inspection.Report (Name = 'Tasks report')
- change $IteratorTask (Inspection.Task_Report = $NewReport)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- Inspection.Report, Inspection.Task

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=n002-retrieve; sourceKind=Database; entity=Inspection.Task; summary=retrieve from Inspection.Task
- nodeId=n003-create; actionKind=Create; entity=Inspection.Report; members=(Name = 'Tasks report'); summary=create Inspection.Report (Name = 'Tasks report')
- nodeId=n005-change; actionKind=Change; entity=Inspection.Report; members=Inspection.Task_Report = $NewReport; summary=change $IteratorTask (Inspection.Task_Report = $NewReport)
- nodeId=n006-commit; actionKind=Commit; entity=Inspection.Report; summary=commit $NewReport WITH EVENTS ON ERROR ROLLBACK

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-act-report-generate.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-18T20-53-14.243Z/modules/Inspection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-18T20-53-14.243Z/modules/Inspection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-53-14.243Z
