---
objectType: flow
module: Inspection
qualifiedName: Inspection.ACT_Report_ApplyFilters
stableId: 7f8544ed-92db-4a35-a561-84a9768625a6
slug: inspection-act-report-applyfilters
layer: L1
l0: inspection-act-report-applyfilters.abstract.md
l2Path: ../../../../app-overview/current/modules/Inspection/flows/inspection-act-report-applyfilters.json
l2Logical: flow:Inspection.ACT_Report_ApplyFilters
sourceRun: cli_2026-03-18T20-44-56.522Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Inspection.ACT_Report_ApplyFilters

## Summary

- Likely acts as a save, process, or background step for Inspection.Report, Inspection.Task because it mutates data without showing a page.
- L0: [abstract](inspection-act-report-applyfilters.abstract.md)
- L2: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-act-report-applyfilters.json)

## Main Steps

- RetrieveAction: retrieve TaskList_Filtered from Inspection.Task retrieve TaskList_Filtered from Inspection.Task
- $TaskList_Filtered != empty any tasks found according to the filter? expression=$TaskList_Filtered != empty
- CommitAction: commit TaskList_ToCommit (refreshInClient=false, withEvents=true) commit TaskList_ToCommit (refreshInClient=false, withEvents=true)
- ChangeObjectAction: change IteratorTask (Task_Report=$NewReport; refreshInClient=false) change IteratorTask (Task_Report=$NewReport; refreshInClient=false)

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

- nodeId=2289f538-5ab9-4b0d-b92c-88799d340148; sourceKind=Database; entity=Inspection.Task; summary=RetrieveAction: retrieve TaskList_Filtered from Inspection.Task retrieve TaskList_Filtered from Inspection.Task
- nodeId=3759ae4e-64ba-40b9-948e-2986a311bfc2; caption=any tasks found according to the filter?; expression=$TaskList_Filtered != empty any tasks found according to the filter? expression=$TaskList_Filtered != empty
- nodeId=1e7d9967-b777-4fb1-8d40-d7ba69208f06; actionKind=Commit; members=refreshInClient=false, withEvents=true; summary=CommitAction: commit TaskList_ToCommit (refreshInClient=false, withEvents=true) commit TaskList_ToCommit (refreshInClient=false, withEvents=true)
- nodeId=2306d5d6-1284-4034-90ad-5905eda93e1b; actionKind=Change; members=Task_Report=$NewReport; refreshInClient=false; summary=ChangeObjectAction: change IteratorTask (Task_Report=$NewReport; refreshInClient=false) change IteratorTask (Task_Report=$NewReport; refreshInClient=false)
- nodeId=2b2a4cad-5a32-450c-9947-03f50f3c5417; actionKind=Commit; entity=Inspection.Task; members=output=TaskList_ToCommit, entity=Inspection.Task, errorHandlingType=Rollback; summary=CreateListAction: CreateListAction (output=TaskList_ToCommit, entity=Inspection.Task, errorHandlingType=Rollback) CreateListAction (output=TaskList_ToCommit, entity=Inspection.Task, errorHandlingType=Rollback)
- nodeId=c8740334-815e-44b1-8bb4-9b560d028a4d; actionKind=Create; entity=Inspection.Report; members=Name='Filtered Task Report'; summary=CreateObjectAction: create Inspection.Report as NewReport (Name='Filtered Task Report') create Inspection.Report as NewReport (Name='Filtered Task Report')

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-act-report-applyfilters.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-18T20-44-56.522Z/modules/Inspection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-18T20-44-56.522Z/modules/Inspection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-44-56.522Z
