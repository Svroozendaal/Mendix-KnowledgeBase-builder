---
objectType: flow
module: SmartExpenses
qualifiedName: SmartExpenses.ACT_StandardBudget_New
stableId: 816defd3-1d78-4280-82d4-61755fc68aa7
slug: smartexpenses-act-standardbudget-new
layer: L1
l0: smartexpenses-act-standardbudget-new.abstract.md
l2Path: ../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-standardbudget-new.json
l2Logical: flow:SmartExpenses.ACT_StandardBudget_New
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: SmartExpenses.ACT_StandardBudget_New

## Summary

- Likely acts as a UI entry or navigation handler because it shows SmartExpenses.StandardBudget_NewEdit.
- L0: [abstract](smartexpenses-act-standardbudget-new.abstract.md)
- L2: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-standardbudget-new.json)

## Main Steps

- ShowPageAction: show page SmartExpenses.StandardBudget_NewEdit show page SmartExpenses.StandardBudget_NewEdit
- CreateObjectAction: create SmartExpenses.Logo as NewLogo create SmartExpenses.Logo as NewLogo
- CreateObjectAction: create SmartExpenses.StandardBudget as StandardBudget (Logo_StandardBudget=$NewLogo) create SmartExpenses.StandardBudget as StandardBudget (Logo_StandardBudget=$NewLogo)

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

- nodeId=06a87d64-2bfd-4d01-a83c-bc980a852bbb; actionKind=Create; entity=SmartExpenses.Logo; summary=CreateObjectAction: create SmartExpenses.Logo as NewLogo create SmartExpenses.Logo as NewLogo
- nodeId=e1c9ce21-74f8-40b0-b799-1e3b9d1beeb9; actionKind=Create; entity=SmartExpenses.StandardBudget; members=Logo_StandardBudget=$NewLogo; summary=CreateObjectAction: create SmartExpenses.StandardBudget as StandardBudget (Logo_StandardBudget=$NewLogo) create SmartExpenses.StandardBudget as StandardBudget (Logo_StandardBudget=$NewLogo)

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-standardbudget-new.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
