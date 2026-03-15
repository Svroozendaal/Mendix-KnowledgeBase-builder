---
objectType: flow
module: Atlas_Web_Content
qualifiedName: Atlas_Web_Content.ACT_Login
stableId: d80b6a77-aa25-4b90-b08e-d5aaa9776394
slug: atlas-web-content-act-login
layer: L1
l0: atlas-web-content-act-login.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/Atlas_Web_Content/flows/atlas-web-content-act-login.json
l2Logical: flow:Atlas_Web_Content.ACT_Login
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Atlas_Web_Content.ACT_Login

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](atlas-web-content-act-login.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/Atlas_Web_Content/flows/atlas-web-content-act-login.json)

## Main Steps

- $StatusCode = 0 Network error? expression=$StatusCode = 0
- $StatusCode = 200 Response OK? expression=$StatusCode = 200
- ChangeObjectAction: change LoginContext (ValidationMessage=''; refreshInClient=true) change LoginContext (ValidationMessage=''; refreshInClient=true)
- ChangeObjectAction: change LoginContext (ValidationMessage='No connection, please try again later.', Password=''; refreshInClient=true) change LoginContext (ValidationMessage='No connection, please try again later.', Password=''; refreshInClient=true)

## Trigger/Input/Output Context

- Kind: Nanoflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=1660ad53-a0ec-4aee-b7be-d391cd9f65c3; caption=Network error?; expression=$StatusCode = 0 Network error? expression=$StatusCode = 0
- nodeId=7389bea4-1825-4863-83d3-6c961501c0de; caption=Response OK?; expression=$StatusCode = 200 Response OK? expression=$StatusCode = 200
- nodeId=ad9ca8b4-c398-4416-9b29-78ff110a8553; caption=Unauthorized?; expression=$StatusCode = 401 Unauthorized? expression=$StatusCode = 401
- nodeId=3642e041-a448-4c62-a829-4adbb19c55c3; actionKind=Change; members=ValidationMessage=''; refreshInClient=true; summary=ChangeObjectAction: change LoginContext (ValidationMessage=''; refreshInClient=true) change LoginContext (ValidationMessage=''; refreshInClient=true)
- nodeId=ed1853bd-1992-4c59-9d4e-e375ae6285ef; actionKind=Change; members=ValidationMessage='No connection, please try again later.', Password=''; refreshInClient=true; summary=ChangeObjectAction: change LoginContext (ValidationMessage='No connection, please try again later.', Password=''; refreshInClient=true) change LoginContext (ValidationMessage='No connection, please try again later.', Password=''; refreshInClient=true)
- nodeId=578f3455-ccaf-406e-928f-b355d3e948e1; actionKind=Change; members=ValidationMessage='The username or password you entered is incorrect.', Password=''; refreshInClient=true; summary=ChangeObjectAction: change LoginContext (ValidationMessage='The username or password you entered is incorrect.', Password=''; refreshInClient=true) change LoginContext (ValidationMessage='The username or password you entered is incorrect.', Password=''; refreshInClient=true)
- nodeId=ed03c696-1e74-4ccc-98f8-d4daa505c3f6; actionKind=Change; members=ValidationMessage='Unknown error occurred.', Password=''; refreshInClient=true; summary=ChangeObjectAction: change LoginContext (ValidationMessage='Unknown error occurred.', Password=''; refreshInClient=true) change LoginContext (ValidationMessage='Unknown error occurred.', Password=''; refreshInClient=true)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/Atlas_Web_Content/flows/atlas-web-content-act-login.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/Atlas_Web_Content/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/Atlas_Web_Content/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
