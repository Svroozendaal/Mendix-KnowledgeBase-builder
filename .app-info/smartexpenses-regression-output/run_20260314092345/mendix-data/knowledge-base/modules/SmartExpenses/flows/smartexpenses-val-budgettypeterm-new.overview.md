---
objectType: flow
module: SmartExpenses
qualifiedName: SmartExpenses.VAL_BudgetTypeTerm_New
stableId: 1a167812-c42e-4ba1-bcf8-ce98381e0012
slug: smartexpenses-val-budgettypeterm-new
layer: L1
l0: smartexpenses-val-budgettypeterm-new.abstract.md
l2Path: ../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-val-budgettypeterm-new.json
l2Logical: flow:SmartExpenses.VAL_BudgetTypeTerm_New
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: SmartExpenses.VAL_BudgetTypeTerm_New

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](smartexpenses-val-budgettypeterm-new.abstract.md)
- L2: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-val-budgettypeterm-new.json)

## Main Steps

- trim($BudgetTerm_BudgetAmountValidationFeedback) = '' expression=trim($BudgetTerm_BudgetAmountValidationFeedback) = ''
- $BudgetTerm/BudgetAmount > -0.01 Is Hoeveelheid greater than 0? expression=$BudgetTerm/BudgetAmount > -0.01
- ChangeVariableAction: change variable BudgetTerm_BudgetAmountValidationFeedback=$BudgetTerm_BudgetAmountValidationFeedback + 'Vul een hoeveelheid in' change variable BudgetTerm_BudgetAmountValidationFeedback=$BudgetTerm_BudgetAmountValidationFeedback + 'Vul een hoeveelheid in'
- ChangeVariableAction: change variable BudgetTerm_BudgetAmountValidationFeedback=if trim($BudgetTerm_BudgetAmountValidationFeedback) = '' then 'Hoeveelheid mag niet lager zijn dan 0' else $BudgetTerm_BudgetAmountValidationFeedback + ' ' + 'Hoeveelheid mag niet lager zijn dan 0' change variable BudgetTerm_BudgetAmountValidationFeedback=if trim($BudgetTerm_BudgetAmountValidationFeedback) = '' then 'Hoeveelheid mag niet lager zijn dan 0' else $BudgetTerm_BudgetAmountValidationFeedback + ' ' + 'Hoeveelheid mag niet lager zijn dan 0'

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by SmartExpenses.ACT_BudgetType_Save.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: SmartExpenses.ACT_BudgetType_Save

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=5992c531-584b-4962-a4cd-a35ac1820ffd; caption=none; expression=trim($BudgetTerm_BudgetAmountValidationFeedback) = '' expression=trim($BudgetTerm_BudgetAmountValidationFeedback) = ''
- nodeId=bb2ea2f0-21b0-43e2-bfce-c7b5dda3f30e; caption=Is Hoeveelheid greater than 0?; expression=$BudgetTerm/BudgetAmount > -0.01 Is Hoeveelheid greater than 0? expression=$BudgetTerm/BudgetAmount > -0.01
- nodeId=020eeb22-3a55-48f9-8ace-05379cbe3669; caption=Is Hoeveelheid not empty?; expression=$BudgetTerm/BudgetAmount != empty Is Hoeveelheid not empty? expression=$BudgetTerm/BudgetAmount != empty
- nodeId=c7552589-a963-474a-a979-38d754a950d7; caption=Is Naam not empty?; expression=trim($BudgetType/Name) != '' Is Naam not empty? expression=trim($BudgetType/Name) != ''
- nodeId=161cdca1-0a87-4f28-bf21-c5546801127c; actionKind=Change; summary=ChangeVariableAction: change variable BudgetTerm_BudgetAmountValidationFeedback=$BudgetTerm_BudgetAmountValidationFeedback + 'Vul een hoeveelheid in' change variable BudgetTerm_BudgetAmountValidationFeedback=$BudgetTerm_BudgetAmountValidationFeedback + 'Vul een hoeveelheid in'
- nodeId=3983df1b-a794-43aa-a6ba-183d0f699303; actionKind=Change; members=$BudgetTerm_BudgetAmountValidationFeedback; summary=ChangeVariableAction: change variable BudgetTerm_BudgetAmountValidationFeedback=if trim($BudgetTerm_BudgetAmountValidationFeedback) = '' then 'Hoeveelheid mag niet lager zijn dan 0' else $BudgetTerm_BudgetAmountValidationFeedback + ' ' + 'Hoeveelheid mag niet lager zijn dan 0' change variable BudgetTerm_BudgetAmountValidationFeedback=if trim($BudgetTerm_BudgetAmountValidationFeedback) = '' then 'Hoeveelheid mag niet lager zijn dan 0' else $BudgetTerm_BudgetAmountValidationFeedback + ' ' + 'Hoeveelheid mag niet lager zijn dan 0'
- nodeId=01d92e84-f1d3-4514-acd9-a0a2583397b7; actionKind=Change; summary=ChangeVariableAction: change variable IsValid=false change variable IsValid=false
- nodeId=68e17b9d-de71-4cca-b161-8103483319d7; actionKind=Change; summary=ChangeVariableAction: change variable IsValid=false change variable IsValid=false

## Warnings/Unknowns

- Rollback hint detected in node detail.
- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-val-budgettypeterm-new.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
