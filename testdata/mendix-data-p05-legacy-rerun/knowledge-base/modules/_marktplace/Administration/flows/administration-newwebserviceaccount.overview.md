---
objectType: flow
module: Administration
qualifiedName: Administration.NewWebServiceAccount
stableId: 9d45d3a4-5b98-4e31-bbea-51ca9e4bf933
slug: administration-newwebserviceaccount
layer: L1
l0: administration-newwebserviceaccount.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/Administration/flows/administration-newwebserviceaccount.json
l2Logical: flow:Administration.NewWebServiceAccount
sourceRun: cli_2026-03-18T20-52-48.461Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Administration.NewWebServiceAccount

## Summary

- Likely acts as a UI entry or navigation handler because it shows Administration.Account_New.
- L0: [abstract](administration-newwebserviceaccount.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/Administration/flows/administration-newwebserviceaccount.json)

## Main Steps

- ShowPageAction: show page Administration.Account_New show page Administration.Account_New
- CreateObjectAction: create Administration.Account as NewAccount create Administration.Account as NewAccount
- ChangeObjectAction: change NewAccount (WebServiceUser=true; refreshInClient=false) change NewAccount (WebServiceUser=true; refreshInClient=false)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: Shows Administration.Account_New.

## Key Entities Touched

- Administration.Account, Administration.AccountPasswordData

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- Administration.Account_New

## Important Retrieves/Decisions/Mutations

- nodeId=3982ff02-2c75-477c-af02-a70087a9e6cf; actionKind=Create; entity=Administration.Account; summary=CreateObjectAction: create Administration.Account as NewAccount create Administration.Account as NewAccount
- nodeId=ad55b416-08bf-4edc-ba0c-c32b7543be28; actionKind=Change; members=WebServiceUser=true; refreshInClient=false; summary=ChangeObjectAction: change NewAccount (WebServiceUser=true; refreshInClient=false) change NewAccount (WebServiceUser=true; refreshInClient=false)
- nodeId=d32e2e61-13e8-47a4-892d-1f3703b7bacd; actionKind=Create; entity=Administration.AccountPasswordData; members=AccountPasswordData_Account=$NewAccount; summary=CreateObjectAction: create Administration.AccountPasswordData as AccountPasswordData (AccountPasswordData_Account=$NewAccount) create Administration.AccountPasswordData as AccountPasswordData (AccountPasswordData_Account...

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/Administration/flows/administration-newwebserviceaccount.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/marketplace/Administration/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/marketplace/Administration/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-52-48.461Z
