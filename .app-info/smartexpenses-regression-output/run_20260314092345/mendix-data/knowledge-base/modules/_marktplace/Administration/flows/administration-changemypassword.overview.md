---
objectType: flow
module: Administration
qualifiedName: Administration.ChangeMyPassword
stableId: e58a2368-e322-4eba-9580-2614945e80cf
slug: administration-changemypassword
layer: L1
l0: administration-changemypassword.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/Administration/flows/administration-changemypassword.json
l2Logical: flow:Administration.ChangeMyPassword
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Administration.ChangeMyPassword

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](administration-changemypassword.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/Administration/flows/administration-changemypassword.json)

## Main Steps

- retrieve Account over association AccountPasswordData_Account from AccountPasswordData
- $OldPasswordOkay Old password okay? expression=$OldPasswordOkay
- $AccountPasswordData/NewPassword = $AccountPasswordData/ConfirmPassword Passwords equal? expression=$AccountPasswordData/NewPassword = $AccountPasswordData/ConfirmPassword
- ChangeObjectAction: change Account (Password=$AccountPasswordData/NewPassword; refreshInClient=true) change Account (Password=$AccountPasswordData/NewPassword; refreshInClient=true)
- DeleteAction: delete AccountPasswordData (refreshInClient=false) delete AccountPasswordData (refreshInClient=false)

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

- nodeId=6786030e-6c15-473b-bbc1-f597237d2d9f; sourceKind=Association; association=AccountPasswordData_Account; summary=retrieve Account over association AccountPasswordData_Account from AccountPasswordData
- nodeId=9bbbba4e-3d2f-44c4-95e9-b05b72374d4b; caption=Old password okay?; expression=$OldPasswordOkay Old password okay? expression=$OldPasswordOkay
- nodeId=7e678fc8-abf7-4e5c-97c0-9109d88cd5e9; caption=Passwords equal?; expression=$AccountPasswordData/NewPassword = $AccountPasswordData/ConfirmPassword Passwords equal? expression=$AccountPasswordData/NewPassword = $AccountPasswordData/ConfirmPassword
- nodeId=e6afca3b-e8a6-485d-87f5-b6e10a23d758; actionKind=Change; members=Password=$AccountPasswordData/NewPassword; refreshInClient=true; summary=ChangeObjectAction: change Account (Password=$AccountPasswordData/NewPassword; refreshInClient=true) change Account (Password=$AccountPasswordData/NewPassword; refreshInClient=true)
- nodeId=a9dfc77e-2c29-44f2-acdd-66a9111edfe2; actionKind=Delete; members=refreshInClient=false; summary=DeleteAction: delete AccountPasswordData (refreshInClient=false) delete AccountPasswordData (refreshInClient=false)

## Warnings/Unknowns

- Rollback hint detected in node detail.
- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/Administration/flows/administration-changemypassword.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/Administration/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/Administration/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
