---
objectType: flow
module: Administration
qualifiedName: Administration.ShowPasswordForm
stableId: bb3bf7a9-9ab5-400a-8624-616b4c48e522
slug: administration-showpasswordform
layer: L1
l0: administration-showpasswordform.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/Administration/flows/administration-showpasswordform.json
l2Logical: flow:Administration.ShowPasswordForm
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Administration.ShowPasswordForm

## Summary

- Likely acts as a UI entry or navigation handler because it shows Administration.ChangePasswordForm.
- L0: [abstract](administration-showpasswordform.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/Administration/flows/administration-showpasswordform.json)

## Main Steps

- ShowPageAction: show page Administration.ChangePasswordForm show page Administration.ChangePasswordForm
- CreateObjectAction: create Administration.AccountPasswordData as AccountPasswordData (AccountPasswordData_Account=$Account) create Administration.AccountPasswordData as AccountPasswordData (AccountPasswordData_Account=$Account)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: Shows Administration.ChangePasswordForm.

## Key Entities Touched

- Administration.AccountPasswordData

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- Administration.ChangePasswordForm

## Important Retrieves/Decisions/Mutations

- nodeId=f0cc23cf-9914-4501-ab13-72874e57875b; actionKind=Create; entity=Administration.AccountPasswordData; members=AccountPasswordData_Account=$Account; summary=CreateObjectAction: create Administration.AccountPasswordData as AccountPasswordData (AccountPasswordData_Account=$Account) create Administration.AccountPasswordData as AccountPasswordData (AccountPasswordData_Account=$Account)

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/Administration/flows/administration-showpasswordform.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/Administration/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/Administration/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
