---
objectType: flow
module: SmartExpenses
qualifiedName: SmartExpenses.DS_FBGProfile_Retreive_current
stableId: e0fbb6fd-b188-47a5-9ded-065a5de3475e
slug: smartexpenses-ds-fbgprofile-retreive-current
layer: L1
l0: smartexpenses-ds-fbgprofile-retreive-current.abstract.md
l2Path: ../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-ds-fbgprofile-retreive-current.json
l2Logical: flow:SmartExpenses.DS_FBGProfile_Retreive_current
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: SmartExpenses.DS_FBGProfile_Retreive_current

## Summary

- Likely acts as a save, process, or background step for Administration.Account, SmartExpenses.FBGProfile because it mutates data without showing a page.
- L0: [abstract](smartexpenses-ds-fbgprofile-retreive-current.abstract.md)
- L2: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-ds-fbgprofile-retreive-current.json)

## Main Steps

- retrieve Account from Administration.Account
- retrieve FBGProfile over association FBGProfile_Account from Account
- $FBGProfile != empty FBGProfile exists? expression=$FBGProfile != empty
- CreateObjectAction: create SmartExpenses.FBGProfile as NewFBGProfile (FBGProfile_Account=$Account) create SmartExpenses.FBGProfile as NewFBGProfile (FBGProfile_Account=$Account)
- Create FBGProfile for user when account does not have any

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- Administration.Account, SmartExpenses.FBGProfile

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=db087929-a19f-4414-9e3b-89b5249866ef; sourceKind=Database; entity=Administration.Account; summary=retrieve Account from Administration.Account
- nodeId=8a53ce71-fb66-4d4e-9f80-ae6b5ce54a1c; sourceKind=Association; association=FBGProfile_Account; summary=retrieve FBGProfile over association FBGProfile_Account from Account
- nodeId=b2c5d02e-756c-41e1-b294-4277d5c43101; caption=FBGProfile exists?; expression=$FBGProfile != empty FBGProfile exists? expression=$FBGProfile != empty
- nodeId=d711bf37-dedd-469f-8b0d-8f669882779a; actionKind=Create; entity=SmartExpenses.FBGProfile; members=FBGProfile_Account=$Account; summary=CreateObjectAction: create SmartExpenses.FBGProfile as NewFBGProfile (FBGProfile_Account=$Account) create SmartExpenses.FBGProfile as NewFBGProfile (FBGProfile_Account=$Account)
- nodeId=9b7fab18-857f-432a-a686-e9ea0d81cf60; actionKind=Create; summary=Create FBGProfile for user when account does not have any

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-ds-fbgprofile-retreive-current.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
