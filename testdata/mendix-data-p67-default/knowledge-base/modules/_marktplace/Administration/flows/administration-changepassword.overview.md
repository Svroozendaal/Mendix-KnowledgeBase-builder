---
objectType: flow
module: Administration
qualifiedName: Administration.ChangePassword
stableId: b22998f9-45da-4ad1-ba8d-af8549c364c9
slug: administration-changepassword
layer: L1
l0: administration-changepassword.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/Administration/flows/administration-changepassword.json
l2Logical: flow:Administration.ChangePassword
sourceRun: cli_2026-03-18T21-10-02.160Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Administration.ChangePassword

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](administration-changepassword.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/Administration/flows/administration-changepassword.json)

## Main Steps

- retrieve over association $AccountPasswordData/Administration.AccountPasswordData_Account
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

- nodeId=n003-retrieve; sourceKind=Association; association=$AccountPasswordData/Administration.AccountPasswordData_Account; summary=retrieve over association $AccountPasswordData/Administration.AccountPasswordData_Account
- nodeId=n002-decision; caption=IF; expression=$AccountPasswordData/NewPassword = $AccountPasswordData/ConfirmPassword
- nodeId=n006-delete; actionKind=Delete; entity=Administration.AccountPasswordData; summary=delete $AccountPasswordData

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/Administration/flows/administration-changepassword.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-18T21-10-02.160Z/modules/marketplace/Administration/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-18T21-10-02.160Z/modules/marketplace/Administration/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T21-10-02.160Z
