---
objectType: flow
module: Administration
qualifiedName: Administration.SaveNewAccount
stableId: eca3c4f4-36ae-4cb9-87fd-2963508d164d
slug: administration-savenewaccount
layer: L1
l0: administration-savenewaccount.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/Administration/flows/administration-savenewaccount.json
l2Logical: flow:Administration.SaveNewAccount
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Administration.SaveNewAccount

## Summary

- Likely acts as a save, process, or background step for SmartExpenses.FBGProfile because it mutates data without showing a page.
- L0: [abstract](administration-savenewaccount.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/Administration/flows/administration-savenewaccount.json)

## Main Steps

- retrieve Account over association AccountPasswordData_Account from AccountPasswordData
- $AccountPasswordData/NewPassword = $AccountPasswordData/ConfirmPassword Passwords equal? expression=$AccountPasswordData/NewPassword = $AccountPasswordData/ConfirmPassword
- ChangeObjectAction: change Account (Password=$AccountPasswordData/NewPassword; refreshInClient=true) change Account (Password=$AccountPasswordData/NewPassword; refreshInClient=true)
- CreateObjectAction: create SmartExpenses.FBGProfile as FBGEnvironment (FBGProfile_Account=$Account) create SmartExpenses.FBGProfile as FBGEnvironment (FBGProfile_Account=$Account)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- SmartExpenses.FBGProfile

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=f0030166-88ab-4581-abb6-0fbe78d53888; sourceKind=Association; association=AccountPasswordData_Account; summary=retrieve Account over association AccountPasswordData_Account from AccountPasswordData
- nodeId=0e568e70-4240-49d8-b467-e26c5149e88f; caption=Passwords equal?; expression=$AccountPasswordData/NewPassword = $AccountPasswordData/ConfirmPassword Passwords equal? expression=$AccountPasswordData/NewPassword = $AccountPasswordData/ConfirmPassword
- nodeId=8762bdf7-89d1-4eb3-9723-30845e2a013e; actionKind=Change; members=Password=$AccountPasswordData/NewPassword; refreshInClient=true; summary=ChangeObjectAction: change Account (Password=$AccountPasswordData/NewPassword; refreshInClient=true) change Account (Password=$AccountPasswordData/NewPassword; refreshInClient=true)
- nodeId=09f8de6a-0294-4673-bd13-48fc8575659a; actionKind=Create; entity=SmartExpenses.FBGProfile; members=FBGProfile_Account=$Account; summary=CreateObjectAction: create SmartExpenses.FBGProfile as FBGEnvironment (FBGProfile_Account=$Account) create SmartExpenses.FBGProfile as FBGEnvironment (FBGProfile_Account=$Account)
- nodeId=da53e425-6cf1-4f54-ba63-bac25f45380c; actionKind=Delete; members=refreshInClient=false; summary=DeleteAction: delete AccountPasswordData (refreshInClient=false) delete AccountPasswordData (refreshInClient=false)

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/Administration/flows/administration-savenewaccount.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/Administration/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/Administration/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
