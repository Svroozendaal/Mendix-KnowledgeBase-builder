---
objectType: flow
module: SmartExpenses
qualifiedName: SmartExpenses.ACT_StandardBudget_Edit
stableId: 899b21c7-ef5d-4cc7-93ae-a8a37e504578
slug: smartexpenses-act-standardbudget-edit
layer: L1
l0: smartexpenses-act-standardbudget-edit.abstract.md
l2Path: ../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-standardbudget-edit.json
l2Logical: flow:SmartExpenses.ACT_StandardBudget_Edit
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: SmartExpenses.ACT_StandardBudget_Edit

## Summary

- Likely acts as a UI entry or navigation handler because it shows SmartExpenses.StandardBudget_NewEdit.
- L0: [abstract](smartexpenses-act-standardbudget-edit.abstract.md)
- L2: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-standardbudget-edit.json)

## Main Steps

- $StandardBudget/SmartExpenses.Logo_StandardBudget/SmartExpenses.Logo != empty logo object excist? expression=$StandardBudget/SmartExpenses.Logo_StandardBudget/SmartExpenses.Logo != empty
- $StandardBudget != empty StandardBudget exists? expression=$StandardBudget != empty
- ShowPageAction: show page SmartExpenses.StandardBudget_NewEdit show page SmartExpenses.StandardBudget_NewEdit
- ChangeObjectAction: change StandardBudget (Logo_StandardBudget=$NewLogo_1; refreshInClient=false) change StandardBudget (Logo_StandardBudget=$NewLogo_1; refreshInClient=false)
- CreateObjectAction: create SmartExpenses.Logo as NewLogo create SmartExpenses.Logo as NewLogo

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: Shows SmartExpenses.StandardBudget_NewEdit.

## Key Entities Touched

- SmartExpenses.Logo, SmartExpenses.StandardBudget

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- SmartExpenses.StandardBudget_NewEdit

## Important Retrieves/Decisions/Mutations

- nodeId=e64f9a71-da88-417a-8660-7058a953b5ec; caption=logo object excist?; expression=$StandardBudget/SmartExpenses.Logo_StandardBudget/SmartExpenses.Logo != empty logo object excist? expression=$StandardBudget/SmartExpenses.Logo_StandardBudget/SmartExpenses.Logo != empty
- nodeId=6b5f8415-acae-4707-ba41-df86963352fa; caption=StandardBudget exists?; expression=$StandardBudget != empty StandardBudget exists? expression=$StandardBudget != empty
- nodeId=17b63414-400a-42c9-a20b-43cbf178f987; actionKind=Change; members=Logo_StandardBudget=$NewLogo_1; refreshInClient=false; summary=ChangeObjectAction: change StandardBudget (Logo_StandardBudget=$NewLogo_1; refreshInClient=false) change StandardBudget (Logo_StandardBudget=$NewLogo_1; refreshInClient=false)
- nodeId=7049344b-054c-4aa2-abb7-05ad34b91e27; actionKind=Create; entity=SmartExpenses.Logo; summary=CreateObjectAction: create SmartExpenses.Logo as NewLogo create SmartExpenses.Logo as NewLogo
- nodeId=c64f0979-d9d7-433c-8279-6678827b8322; actionKind=Create; entity=SmartExpenses.Logo; summary=CreateObjectAction: create SmartExpenses.Logo as NewLogo_1 create SmartExpenses.Logo as NewLogo_1
- nodeId=387177a2-c546-4d41-be41-28009b1002b1; actionKind=Create; entity=SmartExpenses.StandardBudget; members=Logo_StandardBudget=$NewLogo; summary=CreateObjectAction: create SmartExpenses.StandardBudget as StandardBudget_2 (Logo_StandardBudget=$NewLogo) create SmartExpenses.StandardBudget as StandardBudget_2 (Logo_StandardBudget=$NewLogo)

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-standardbudget-edit.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
