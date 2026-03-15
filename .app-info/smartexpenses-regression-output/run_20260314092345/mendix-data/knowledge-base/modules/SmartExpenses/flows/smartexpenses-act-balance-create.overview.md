---
objectType: flow
module: SmartExpenses
qualifiedName: SmartExpenses.ACT_Balance_Create
stableId: da4b416d-3998-463a-a951-448fc5064f4e
slug: smartexpenses-act-balance-create
layer: L1
l0: smartexpenses-act-balance-create.abstract.md
l2Path: ../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-balance-create.json
l2Logical: flow:SmartExpenses.ACT_Balance_Create
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: SmartExpenses.ACT_Balance_Create

## Summary

- Likely acts as a UI entry or navigation handler because it shows SmartExpenses.Balance_NewEdit.
- L0: [abstract](smartexpenses-act-balance-create.abstract.md)
- L2: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-balance-create.json)

## Main Steps

- retrieve User over association Session_User from currentSession
- ShowPageAction: show page SmartExpenses.Balance_NewEdit show page SmartExpenses.Balance_NewEdit
- ChangeObjectAction: change currentSession (SessionId='test'; refreshInClient=false) change currentSession (SessionId='test'; refreshInClient=false)
- CommitAction: commit currentSession (refreshInClient=false, withEvents=true) commit currentSession (refreshInClient=false, withEvents=true)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: Shows SmartExpenses.Balance_NewEdit.

## Key Entities Touched

- SmartExpenses.Balance

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- SmartExpenses.Balance_NewEdit

## Important Retrieves/Decisions/Mutations

- nodeId=2929a54d-ac54-4c0a-83ad-9a6cb2ae155c; sourceKind=Association; association=Session_User; summary=retrieve User over association Session_User from currentSession
- nodeId=e022fd46-6fe9-4a52-9b31-fc8c26232094; actionKind=Change; members=SessionId='test'; refreshInClient=false; summary=ChangeObjectAction: change currentSession (SessionId='test'; refreshInClient=false) change currentSession (SessionId='test'; refreshInClient=false)
- nodeId=e74c8102-b8dd-4466-a540-fe57614b24b7; actionKind=Commit; members=refreshInClient=false, withEvents=true; summary=CommitAction: commit currentSession (refreshInClient=false, withEvents=true) commit currentSession (refreshInClient=false, withEvents=true)
- nodeId=37421bf1-d425-4c0b-bbfe-0740635c9325; actionKind=Create; entity=SmartExpenses.Balance; members=Balance_FBGProfile=$FBGProfile; summary=CreateObjectAction: create SmartExpenses.Balance as NewBalance (Balance_FBGProfile=$FBGProfile) create SmartExpenses.Balance as NewBalance (Balance_FBGProfile=$FBGProfile)
- nodeId=a492b26c-bcdc-494e-a97c-c7fd2514bbc3; actionKind=Create; summary=Simple microflow to create a Balance, connect it to the FBGProfile and open the NewEdit page.

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-balance-create.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
