---
objectType: flow
module: Administration
qualifiedName: Administration.ChangeMyPassword
stableId: 6a9c5ff6-ac65-4739-8b5d-d9c3462afbfc
slug: administration-changemypassword
layer: L1
l0: administration-changemypassword.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/Administration/flows/administration-changemypassword.json
l2Logical: flow:Administration.ChangeMyPassword
sourceRun: cli_2026-03-18T20-54-38.903Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Administration.ChangeMyPassword

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](administration-changemypassword.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/Administration/flows/administration-changemypassword.json)

## Main Steps

- retrieve over association $AccountPasswordData/Administration.AccountPasswordData_Account
- $OldPasswordOkay
- $AccountPasswordData/NewPassword = $AccountPasswordData/ConfirmPassword
- delete $AccountPasswordData

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=n002-retrieve; sourceKind=Association; association=$AccountPasswordData/Administration.AccountPasswordData_Account; summary=retrieve over association $AccountPasswordData/Administration.AccountPasswordData_Account
- nodeId=n004-decision; caption=IF; expression=$OldPasswordOkay
- nodeId=n005-decision; caption=IF; expression=$AccountPasswordData/NewPassword = $AccountPasswordData/ConfirmPassword
- nodeId=n008-delete; actionKind=Delete; entity=Administration.AccountPasswordData; summary=delete $AccountPasswordData

## Warnings/Unknowns

- Rollback hint detected in node detail.
- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/Administration/flows/administration-changemypassword.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-18T20-54-38.903Z/modules/marketplace/Administration/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-18T20-54-38.903Z/modules/marketplace/Administration/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-54-38.903Z
