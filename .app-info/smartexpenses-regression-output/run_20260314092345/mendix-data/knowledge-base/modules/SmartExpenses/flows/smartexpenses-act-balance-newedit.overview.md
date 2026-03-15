---
objectType: flow
module: SmartExpenses
qualifiedName: SmartExpenses.ACT_Balance_NewEdit
stableId: 2c6b571e-6418-4a91-a7b2-bb31b0b34972
slug: smartexpenses-act-balance-newedit
layer: L1
l0: smartexpenses-act-balance-newedit.abstract.md
l2Path: ../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-balance-newedit.json
l2Logical: flow:SmartExpenses.ACT_Balance_NewEdit
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: SmartExpenses.ACT_Balance_NewEdit

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](smartexpenses-act-balance-newedit.abstract.md)
- L2: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-balance-newedit.json)

## Main Steps

- $IsValid IsValid? expression=$IsValid
- true test expression=true
- CommitAction: commit Balance (refreshInClient=true, withEvents=true) commit Balance (refreshInClient=true, withEvents=true)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: SmartExpenses.VAL_Balance_NewEdit
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=cccee6d8-f934-4a2d-92ec-393f84f5922a; caption=IsValid?; expression=$IsValid IsValid? expression=$IsValid
- nodeId=2607e7c3-14d4-43d6-be5d-ae76c54383bf; caption=test; expression=true test expression=true
- nodeId=cb43f434-ce20-49c4-a5ac-2a5678d1a6be; actionKind=Commit; members=refreshInClient=true, withEvents=true; summary=CommitAction: commit Balance (refreshInClient=true, withEvents=true) commit Balance (refreshInClient=true, withEvents=true)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-balance-newedit.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
