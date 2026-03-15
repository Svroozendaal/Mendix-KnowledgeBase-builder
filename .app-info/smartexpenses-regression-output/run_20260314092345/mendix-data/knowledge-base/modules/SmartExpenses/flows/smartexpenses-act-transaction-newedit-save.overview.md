---
objectType: flow
module: SmartExpenses
qualifiedName: SmartExpenses.ACT_Transaction_NewEdit_Save
stableId: 73401cb5-286b-4115-93c7-1d83312dcb23
slug: smartexpenses-act-transaction-newedit-save
layer: L1
l0: smartexpenses-act-transaction-newedit-save.abstract.md
l2Path: ../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-transaction-newedit-save.json
l2Logical: flow:SmartExpenses.ACT_Transaction_NewEdit_Save
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: SmartExpenses.ACT_Transaction_NewEdit_Save

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](smartexpenses-act-transaction-newedit-save.abstract.md)
- L2: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-transaction-newedit-save.json)

## Main Steps

- $IsValid IsValid? expression=$IsValid
- CommitAction: commit Transaction (refreshInClient=true, withEvents=true) commit Transaction (refreshInClient=true, withEvents=true)
- Save new transaction: check and set status of transaction and commit

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: SmartExpenses.SUB_Transaction_setStatus, SmartExpenses.VAL_Transaction_NewEdit
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=75838940-2344-45ae-bced-8662efcc9197; caption=IsValid?; expression=$IsValid IsValid? expression=$IsValid
- nodeId=2fcc6351-38d9-49a0-8583-27d6678faf17; actionKind=Commit; members=refreshInClient=true, withEvents=true; summary=CommitAction: commit Transaction (refreshInClient=true, withEvents=true) commit Transaction (refreshInClient=true, withEvents=true)
- nodeId=53ccc93a-51cc-411b-afda-7faa35fbad20; actionKind=Commit; summary=Save new transaction: check and set status of transaction and commit

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-transaction-newedit-save.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
