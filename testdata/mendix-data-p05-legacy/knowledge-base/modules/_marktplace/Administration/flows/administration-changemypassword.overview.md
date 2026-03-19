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
sourceRun: cli_2026-03-18T20-44-56.522Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Administration.ChangeMyPassword

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](administration-changemypassword.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/Administration/flows/administration-changemypassword.json)

## Main Steps

- RetrieveAction: retrieve Account over association AccountPasswordData_Account from AccountPasswordData retrieve Account over association AccountPasswordData_Account from AccountPasswordData
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

- nodeId=e004ebb3-d53c-40ee-b276-09841346cd89; sourceKind=Association; association=AccountPasswordData_Account; summary=RetrieveAction: retrieve Account over association AccountPasswordData_Account from AccountPasswordData retrieve Account over association AccountPasswordData_Account from AccountPasswordData
- nodeId=d5e2f970-9ed1-49d5-ab09-6b4f4c32752d; caption=Old password okay?; expression=$OldPasswordOkay Old password okay? expression=$OldPasswordOkay
- nodeId=d7cc9db7-b346-4188-9997-13d7b90dc955; caption=Passwords equal?; expression=$AccountPasswordData/NewPassword = $AccountPasswordData/ConfirmPassword Passwords equal? expression=$AccountPasswordData/NewPassword = $AccountPasswordData/ConfirmPassword
- nodeId=75ae3ce9-320f-477b-afcf-d219618b2410; actionKind=Change; members=Password=$AccountPasswordData/NewPassword; refreshInClient=true; summary=ChangeObjectAction: change Account (Password=$AccountPasswordData/NewPassword; refreshInClient=true) change Account (Password=$AccountPasswordData/NewPassword; refreshInClient=true)
- nodeId=bfc3f1b6-5f57-42b0-9521-692148a3c101; actionKind=Delete; members=refreshInClient=false; summary=DeleteAction: delete AccountPasswordData (refreshInClient=false) delete AccountPasswordData (refreshInClient=false)

## Warnings/Unknowns

- Rollback hint detected in node detail.
- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/Administration/flows/administration-changemypassword.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-18T20-44-56.522Z/modules/marketplace/Administration/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-18T20-44-56.522Z/modules/marketplace/Administration/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-44-56.522Z
