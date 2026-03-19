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
sourceRun: cli_2026-03-18T20-52-48.461Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Inspection.ACT_Report_Generate

## Summary

- Likely acts as a save, process, or background step for Inspection.Report, Inspection.Task because it mutates data without showing a page.
- L0: [abstract](inspection-act-report-generate.abstract.md)
- L2: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-act-report-generate.json)

## Main Steps

- RetrieveAction: retrieve TaskList_All from Inspection.Task retrieve TaskList_All from Inspection.Task
- ChangeObjectAction: change IteratorTask (Task_Report=$NewReport; refreshInClient=false) change IteratorTask (Task_Report=$NewReport; refreshInClient=false)
- CreateObjectAction: create Inspection.Report as NewReport (Name='Tasks report') create Inspection.Report as NewReport (Name='Tasks report')

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

- nodeId=06a18412-7dac-4c24-a2b0-dca3a125f70e; sourceKind=Database; entity=Inspection.Task; summary=RetrieveAction: retrieve TaskList_All from Inspection.Task retrieve TaskList_All from Inspection.Task
- nodeId=0460d7a2-5501-4a6b-be66-db331cf9515a; actionKind=Change; members=Task_Report=$NewReport; refreshInClient=false; summary=ChangeObjectAction: change IteratorTask (Task_Report=$NewReport; refreshInClient=false) change IteratorTask (Task_Report=$NewReport; refreshInClient=false)
- nodeId=477017a1-0773-4533-9ad0-f8da50a902e4; actionKind=Create; entity=Inspection.Report; members=Name='Tasks report'; summary=CreateObjectAction: create Inspection.Report as NewReport (Name='Tasks report') create Inspection.Report as NewReport (Name='Tasks report')
- nodeId=dfb67248-194d-49c5-b75c-32478dcb8d7c; actionKind=Commit; members=refreshInClient=false, withEvents=true; summary=CommitAction: commit NewReport (refreshInClient=false, withEvents=true) commit NewReport (refreshInClient=false, withEvents=true)

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-act-report-generate.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/Inspection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/Inspection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-52-48.461Z
