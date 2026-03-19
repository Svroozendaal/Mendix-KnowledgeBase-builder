---
objectType: flow
module: Administration
qualifiedName: Administration.NewAccount
stableId: 75e636c0-6dd7-4430-9b1d-7f9b71bcd86f
slug: administration-newaccount
layer: L1
l0: administration-newaccount.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/Administration/flows/administration-newaccount.json
l2Logical: flow:Administration.NewAccount
sourceRun: cli_2026-03-18T20-52-48.461Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Administration.NewAccount

## Summary

- Likely acts as a UI entry or navigation handler because it shows Administration.Account_New.
- L0: [abstract](administration-newaccount.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/Administration/flows/administration-newaccount.json)

## Main Steps

- ShowPageAction: show page Administration.Account_New show page Administration.Account_New
- CreateObjectAction: create Administration.AccountPasswordData as AccountPasswordData (AccountPasswordData_Account=$NewAccount) create Administration.AccountPasswordData as AccountPasswordData (AccountPasswordData_Account...
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

- nodeId=abda1f93-7598-4c0f-bc17-9f70e42d0a41; actionKind=Create; entity=Administration.AccountPasswordData; members=AccountPasswordData_Account=$NewAccount; summary=CreateObjectAction: create Administration.AccountPasswordData as AccountPasswordData (AccountPasswordData_Account=$NewAccount) create Administration.AccountPasswordData as AccountPasswordData (AccountPasswordData_Account...
- nodeId=f921395c-4b14-42df-bc6c-ed00200ac698; actionKind=Create; entity=Administration.Account; summary=CreateObjectAction: create Administration.Account as NewAccount create Administration.Account as NewAccount

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/Administration/flows/administration-newaccount.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/marketplace/Administration/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/marketplace/Administration/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-52-48.461Z
