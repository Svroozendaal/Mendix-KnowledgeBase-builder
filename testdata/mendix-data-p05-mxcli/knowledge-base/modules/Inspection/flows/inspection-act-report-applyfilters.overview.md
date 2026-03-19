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
sourceRun: cli_2026-03-18T20-44-56.521Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Inspection.ACT_Report_ApplyFilters

## Summary

- Likely acts as a save, process, or background step for Inspection.Report, Inspection.Task because it mutates data without showing a page.
- L0: [abstract](inspection-act-report-applyfilters.abstract.md)
- L2: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-act-report-applyfilters.json)

## Main Steps

- retrieve from Inspection.Task WHERE Created >= $ReportHelper/StartDate] [DueDate <= $ReportHelper/EndDate] [_Type = $ReportHelper/Category
- $TaskList_Filtered != empty
- create list of Inspection.Task
- create Inspection.Report (Name = 'Filtered Task Report')

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

- nodeId=n002-retrieve; sourceKind=Database; entity=Inspection.Task; xPath=Created >= $ReportHelper/StartDate] [DueDate <= $ReportHelper/EndDate] [_Type = $ReportHelper/Category; summary=retrieve from Inspection.Task WHERE Created >= $ReportHelper/StartDate] [DueDate <= $ReportHelper/EndDate] [_Type = $ReportHelper/Category
- nodeId=n003-decision; caption=IF; expression=$TaskList_Filtered != empty
- nodeId=n004-create; actionKind=Create; entity=Inspection.Task; summary=create list of Inspection.Task
- nodeId=n005-create; actionKind=Create; entity=Inspection.Report; members=(Name = 'Filtered Task Report'); summary=create Inspection.Report (Name = 'Filtered Task Report')
- nodeId=n007-commit; actionKind=Commit; entity=Inspection.Task; summary=commit $TaskList_ToCommit WITH EVENTS ON ERROR ROLLBACK

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-act-report-applyfilters.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-18T20-44-56.521Z/modules/Inspection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-18T20-44-56.521Z/modules/Inspection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-44-56.521Z
