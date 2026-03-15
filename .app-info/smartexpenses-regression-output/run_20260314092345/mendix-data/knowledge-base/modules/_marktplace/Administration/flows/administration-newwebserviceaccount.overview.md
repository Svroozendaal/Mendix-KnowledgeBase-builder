---
objectType: flow
module: Administration
qualifiedName: Administration.NewWebServiceAccount
stableId: 3de594d7-3180-4e16-9e90-946b44220078
slug: administration-newwebserviceaccount
layer: L1
l0: administration-newwebserviceaccount.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/Administration/flows/administration-newwebserviceaccount.json
l2Logical: flow:Administration.NewWebServiceAccount
sourceRun: cli_2026-03-14T09-23-46.259Z
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
- ChangeObjectAction: change NewAccount (WebServiceUser=true; refreshInClient=false) change NewAccount (WebServiceUser=true; refreshInClient=false)
- CreateObjectAction: create Administration.Account as NewAccount create Administration.Account as NewAccount

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

- nodeId=0d02ad5f-36a1-48a6-91e5-a05eba1d45c8; actionKind=Change; members=WebServiceUser=true; refreshInClient=false; summary=ChangeObjectAction: change NewAccount (WebServiceUser=true; refreshInClient=false) change NewAccount (WebServiceUser=true; refreshInClient=false)
- nodeId=0f5d4d01-7f81-4ec5-a48f-4c0353c1a475; actionKind=Create; entity=Administration.Account; summary=CreateObjectAction: create Administration.Account as NewAccount create Administration.Account as NewAccount
- nodeId=652fc4fd-af06-42dc-b54e-b394f406286b; actionKind=Create; entity=Administration.AccountPasswordData; members=AccountPasswordData_Account=$NewAccount; summary=CreateObjectAction: create Administration.AccountPasswordData as AccountPasswordData (AccountPasswordData_Account=$NewAccount) create Administration.AccountPasswordData as AccountPasswordData (AccountPasswordData_Account=$NewAccount)

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/Administration/flows/administration-newwebserviceaccount.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/Administration/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/Administration/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
