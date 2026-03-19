---
objectType: flow
module: Administration
qualifiedName: Administration.SaveNewAccount
stableId: 137d9cb9-393b-40d1-b0d4-34ab92277360
slug: administration-savenewaccount
layer: L1
l0: administration-savenewaccount.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/Administration/flows/administration-savenewaccount.json
l2Logical: flow:Administration.SaveNewAccount
sourceRun: cli_2026-03-18T20-56-46.385Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Administration.SaveNewAccount

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](administration-savenewaccount.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/Administration/flows/administration-savenewaccount.json)

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

- nodeId=57d8048e-e523-4aaa-b760-0dc518597fe3; sourceKind=Association; association=AccountPasswordData_Account; summary=RetrieveAction: retrieve Account over association AccountPasswordData_Account from AccountPasswordData retrieve Account over association AccountPasswordData_Account from AccountPasswordData
- nodeId=f570e84d-1056-4b9d-8eb8-530fe496bd2e; caption=Passwords equal?; expression=$AccountPasswordData/NewPassword = $AccountPasswordData/ConfirmPassword Passwords equal? expression=$AccountPasswordData/NewPassword = $AccountPasswordData/ConfirmPassword
- nodeId=2846576f-a2b7-4bdf-9c54-03405f11cdac; actionKind=Delete; members=refreshInClient=false; summary=DeleteAction: delete AccountPasswordData (refreshInClient=false) delete AccountPasswordData (refreshInClient=false)
- nodeId=963632c1-60c6-4eaf-b16d-944dab2ebfe2; actionKind=Change; members=Password=$AccountPasswordData/NewPassword; refreshInClient=true; summary=ChangeObjectAction: change Account (Password=$AccountPasswordData/NewPassword; refreshInClient=true) change Account (Password=$AccountPasswordData/NewPassword; refreshInClient=true)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/Administration/flows/administration-savenewaccount.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-18T20-56-46.385Z/modules/marketplace/Administration/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-18T20-56-46.385Z/modules/marketplace/Administration/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-56-46.385Z
