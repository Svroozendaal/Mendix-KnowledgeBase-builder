---
objectType: flow
module: Administration
qualifiedName: Administration.ShowPasswordForm
stableId: 8b3eeffc-a98a-4ca2-a12e-1d685a35eaec
slug: administration-showpasswordform
layer: L1
l0: administration-showpasswordform.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/Administration/flows/administration-showpasswordform.json
l2Logical: flow:Administration.ShowPasswordForm
sourceRun: cli_2026-03-18T20-53-14.243Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Administration.ShowPasswordForm

## Summary

- Likely acts as a UI entry or navigation handler because it shows Administration.ChangePasswordForm.
- L0: [abstract](administration-showpasswordform.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/Administration/flows/administration-showpasswordform.json)

## Main Steps

- show page Administration.ChangePasswordForm
- create Administration.AccountPasswordData (AccountPasswordData_Account = $Account)

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

- nodeId=n002-create; actionKind=Create; entity=Administration.AccountPasswordData; members=(AccountPasswordData_Account = $Account); summary=create Administration.AccountPasswordData (AccountPasswordData_Account = $Account)

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/Administration/flows/administration-showpasswordform.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-18T20-53-14.243Z/modules/marketplace/Administration/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-18T20-53-14.243Z/modules/marketplace/Administration/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-53-14.243Z
