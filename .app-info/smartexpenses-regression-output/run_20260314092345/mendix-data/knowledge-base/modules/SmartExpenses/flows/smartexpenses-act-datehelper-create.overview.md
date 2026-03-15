---
objectType: flow
module: SmartExpenses
qualifiedName: SmartExpenses.ACT_DateHelper_Create
stableId: 0a2f1651-0bd9-4051-800a-9b66469d81f4
slug: smartexpenses-act-datehelper-create
layer: L1
l0: smartexpenses-act-datehelper-create.abstract.md
l2Path: ../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-datehelper-create.json
l2Logical: flow:SmartExpenses.ACT_DateHelper_Create
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: SmartExpenses.ACT_DateHelper_Create

## Summary

- Likely acts as a save, process, or background step for SmartExpenses.DateHelper because it mutates data without showing a page.
- L0: [abstract](smartexpenses-act-datehelper-create.abstract.md)
- L2: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-datehelper-create.json)

## Main Steps

- CreateObjectAction: create SmartExpenses.DateHelper as NewDateHelper (SelectedDate=[%BeginOfCurrentDay%], DateHelper_FBGProfile=$FBGProfile) create SmartExpenses.DateHelper as NewDateHelper (SelectedDate=[%BeginOfCurrentDay%], DateHelper_FBGProfile=$FBGProfile)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by SmartExpenses.ACT_BudgetType_OpenOverviewPAge.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- SmartExpenses.DateHelper

## Called / Called By

- Calls: none
- Called by: SmartExpenses.ACT_BudgetType_OpenOverviewPAge

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=6f49bd48-2c66-4d8f-ab11-21071be54e62; actionKind=Create; entity=SmartExpenses.DateHelper; members=SelectedDate=[%BeginOfCurrentDay%], DateHelper_FBGProfile=$FBGProfile; summary=CreateObjectAction: create SmartExpenses.DateHelper as NewDateHelper (SelectedDate=[%BeginOfCurrentDay%], DateHelper_FBGProfile=$FBGProfile) create SmartExpenses.DateHelper as NewDateHelper (SelectedDate=[%BeginOfCurrentDay%], DateHelper_FBGProfile=$FBGProfile)

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-datehelper-create.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
