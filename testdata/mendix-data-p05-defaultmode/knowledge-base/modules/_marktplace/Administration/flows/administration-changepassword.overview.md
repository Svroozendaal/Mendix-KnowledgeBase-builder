---
objectType: flow
module: Administration
qualifiedName: Administration.ChangePassword
stableId: b22998f9-45da-4ad1-ba8d-af8549c364c9
slug: administration-changepassword
layer: L1
l0: administration-changepassword.abstract.md
l2Path: ../../../../../../mendix-data-p05-legacy/app-overview/current/modules/marketplace/Administration/flows/administration-changepassword.json
l2Logical: flow:Administration.ChangePassword
sourceRun: cli_2026-03-18T20-44-56.522Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Administration.ChangePassword

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](administration-changepassword.abstract.md)
- L2: [json](../../../../../../mendix-data-p05-legacy/app-overview/current/modules/marketplace/Administration/flows/administration-changepassword.json)

## Main Steps

- RetrieveAction: retrieve Account over association AccountPasswordData_Account from AccountPasswordData retrieve Account over association AccountPasswordData_Account from AccountPasswordData
- $AccountPasswordData/NewPassword = $AccountPasswordData/ConfirmPassword Passwords equal? expression=$AccountPasswordData/NewPassword = $AccountPasswordData/ConfirmPassword
- DeleteAction: delete AccountPasswordData (refreshInClient=false) delete AccountPasswordData (refreshInClient=false)
- ChangeObjectAction: change Account (Password=$AccountPasswordData/NewPassword; refreshInClient=true) change Account (Password=$AccountPasswordData/NewPassword; refreshInClient=true)

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

- nodeId=0f88ad55-f627-479b-b726-166f2aebf256; sourceKind=Association; association=AccountPasswordData_Account; summary=RetrieveAction: retrieve Account over association AccountPasswordData_Account from AccountPasswordData retrieve Account over association AccountPasswordData_Account from AccountPasswordData
- nodeId=cfef74e5-d05a-46f8-bea9-b3a9262e7dc4; caption=Passwords equal?; expression=$AccountPasswordData/NewPassword = $AccountPasswordData/ConfirmPassword Passwords equal? expression=$AccountPasswordData/NewPassword = $AccountPasswordData/ConfirmPassword
- nodeId=10735bf5-a8a3-4659-994f-405b87398758; actionKind=Delete; members=refreshInClient=false; summary=DeleteAction: delete AccountPasswordData (refreshInClient=false) delete AccountPasswordData (refreshInClient=false)
- nodeId=466c4eba-2c0b-4d43-a419-838a3c27a7e7; actionKind=Change; members=Password=$AccountPasswordData/NewPassword; refreshInClient=true; summary=ChangeObjectAction: change Account (Password=$AccountPasswordData/NewPassword; refreshInClient=true) change Account (Password=$AccountPasswordData/NewPassword; refreshInClient=true)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../../mendix-data-p05-legacy/app-overview/current/modules/marketplace/Administration/flows/administration-changepassword.json)
- Aggregate export: [flows.json](../../../../../../mendix-data-p05-legacy/app-overview/cli_2026-03-18T20-44-56.522Z/modules/marketplace/Administration/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../../mendix-data-p05-legacy/app-overview/cli_2026-03-18T20-44-56.522Z/modules/marketplace/Administration/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-44-56.522Z
