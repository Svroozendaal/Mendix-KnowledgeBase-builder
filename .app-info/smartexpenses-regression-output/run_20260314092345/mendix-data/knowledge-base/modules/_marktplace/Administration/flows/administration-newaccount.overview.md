---
objectType: flow
module: Administration
qualifiedName: Administration.NewAccount
stableId: 47b53023-9646-4029-9a89-d2037b732b78
slug: administration-newaccount
layer: L1
l0: administration-newaccount.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/Administration/flows/administration-newaccount.json
l2Logical: flow:Administration.NewAccount
sourceRun: cli_2026-03-14T09-23-46.259Z
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
- CreateObjectAction: create Administration.Account as NewAccount create Administration.Account as NewAccount
- CreateObjectAction: create Administration.AccountPasswordData as AccountPasswordData (AccountPasswordData_Account=$NewAccount) create Administration.AccountPasswordData as AccountPasswordData (AccountPasswordData_Account=$NewAccount)

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

- nodeId=85ea3469-4b4a-459b-bcf2-e4ad3f93c8f9; actionKind=Create; entity=Administration.Account; summary=CreateObjectAction: create Administration.Account as NewAccount create Administration.Account as NewAccount
- nodeId=e4d4e7ee-d8a1-4e1d-b9aa-e25257a0daf1; actionKind=Create; entity=Administration.AccountPasswordData; members=AccountPasswordData_Account=$NewAccount; summary=CreateObjectAction: create Administration.AccountPasswordData as AccountPasswordData (AccountPasswordData_Account=$NewAccount) create Administration.AccountPasswordData as AccountPasswordData (AccountPasswordData_Account=$NewAccount)

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/Administration/flows/administration-newaccount.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/Administration/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/Administration/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
