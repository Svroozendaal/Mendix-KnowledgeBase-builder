---
objectType: flow
module: Administration
qualifiedName: Administration.ShowMyPasswordForm
stableId: 073cbe28-966d-44c2-94ed-a65986361ed0
slug: administration-showmypasswordform
layer: L1
l0: administration-showmypasswordform.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/Administration/flows/administration-showmypasswordform.json
l2Logical: flow:Administration.ShowMyPasswordForm
sourceRun: cli_2026-03-18T20-53-14.243Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Administration.ShowMyPasswordForm

## Summary

- Likely acts as a UI entry or navigation handler because it shows Administration.ChangeMyPasswordForm.
- L0: [abstract](administration-showmypasswordform.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/Administration/flows/administration-showmypasswordform.json)

## Main Steps

- show page Administration.ChangeMyPasswordForm
- create Administration.AccountPasswordData (AccountPasswordData_Account = $Account)

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

- nodeId=n002-create; actionKind=Create; entity=Administration.AccountPasswordData; members=(AccountPasswordData_Account = $Account); summary=create Administration.AccountPasswordData (AccountPasswordData_Account = $Account)

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/Administration/flows/administration-showmypasswordform.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-18T20-53-14.243Z/modules/marketplace/Administration/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-18T20-53-14.243Z/modules/marketplace/Administration/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-53-14.243Z
