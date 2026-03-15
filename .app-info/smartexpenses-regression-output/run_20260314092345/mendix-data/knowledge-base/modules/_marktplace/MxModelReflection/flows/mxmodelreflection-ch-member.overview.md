---
objectType: flow
module: MxModelReflection
qualifiedName: MxModelReflection.Ch_Member
stableId: aaeb7b35-4d53-492c-b33d-e185125f0080
slug: mxmodelreflection-ch-member
layer: L1
l0: mxmodelreflection-ch-member.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-ch-member.json
l2Logical: flow:MxModelReflection.Ch_Member
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: MxModelReflection.Ch_Member

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](mxmodelreflection-ch-member.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-ch-member.json)

## Main Steps

- retrieve MxObjectMember over association Token_MxObjectMember from Token
- ChangeObjectAction: change Token (FindMember=$MxObjectMember/AttributeName, FindMemberReference=$MxObjectMember/AttributeName; refreshInClient=true) change Token (FindMember=$MxObjectMember/AttributeName, FindMemberReference=$MxObjectMember/AttributeName; refreshInClient=true)

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

- nodeId=963f8ca6-4419-4aa9-8bf0-5e94407eb661; sourceKind=Association; association=Token_MxObjectMember; summary=retrieve MxObjectMember over association Token_MxObjectMember from Token
- nodeId=31185a68-2461-4343-b417-cbb2c7421a73; actionKind=Change; members=FindMember=$MxObjectMember/AttributeName, FindMemberReference=$MxObjectMember/AttributeName; refreshInClient=true; summary=ChangeObjectAction: change Token (FindMember=$MxObjectMember/AttributeName, FindMemberReference=$MxObjectMember/AttributeName; refreshInClient=true) change Token (FindMember=$MxObjectMember/AttributeName, FindMemberReference=$MxObjectMember/AttributeName; refreshInClient=true)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-ch-member.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
