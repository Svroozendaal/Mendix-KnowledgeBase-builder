---
objectType: flow
module: Administration
qualifiedName: Administration.ShowMyPasswordForm
stableId: aa2f9838-ebab-42ec-b218-8590a64a30a5
slug: administration-showmypasswordform
layer: L1
l0: administration-showmypasswordform.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/Administration/flows/administration-showmypasswordform.json
l2Logical: flow:Administration.ShowMyPasswordForm
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Administration.ShowMyPasswordForm

## Summary

- Likely acts as a UI entry or navigation handler because it shows Administration.ChangeMyPasswordForm.
- L0: [abstract](administration-showmypasswordform.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/Administration/flows/administration-showmypasswordform.json)

## Main Steps

- ShowPageAction: show page Administration.ChangeMyPasswordForm show page Administration.ChangeMyPasswordForm
- CreateObjectAction: create Administration.AccountPasswordData as AccountPasswordData (AccountPasswordData_Account=$Account) create Administration.AccountPasswordData as AccountPasswordData (AccountPasswordData_Account=$Account)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: Shows Administration.ChangeMyPasswordForm.

## Key Entities Touched

- Administration.AccountPasswordData

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- Administration.ChangeMyPasswordForm

## Important Retrieves/Decisions/Mutations

- nodeId=abe8ff36-516b-494d-82dd-263dcc3b2f54; actionKind=Create; entity=Administration.AccountPasswordData; members=AccountPasswordData_Account=$Account; summary=CreateObjectAction: create Administration.AccountPasswordData as AccountPasswordData (AccountPasswordData_Account=$Account) create Administration.AccountPasswordData as AccountPasswordData (AccountPasswordData_Account=$Account)

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/Administration/flows/administration-showmypasswordform.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/Administration/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/Administration/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
