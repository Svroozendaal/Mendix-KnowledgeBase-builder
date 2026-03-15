---
objectType: flow
module: MxModelReflection
qualifiedName: MxModelReflection.BCo_Token
stableId: 1b6dd2a1-477c-4d75-a347-55bb286da399
slug: mxmodelreflection-bco-token
layer: L1
l0: mxmodelreflection-bco-token.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-bco-token.json
l2Logical: flow:MxModelReflection.BCo_Token
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: MxModelReflection.BCo_Token

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](mxmodelreflection-bco-token.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-bco-token.json)

## Main Steps

- retrieve Member over association Token_MxObjectMember from Token
- retrieve MemberReference over association Token_MxObjectMember from Token
- $Member != empty and $MxObjectTypeStart != empty has all associations expression=$Member != empty and $MxObjectTypeStart != empty
- $MemberReference != empty and $MxObjectReference != empty and $MxObjectTypeStart != empty and $MxObjectTypeReference != ... has all associations expression=$MemberReference != empty and $MxObjectReference != empty and $MxObjectTypeStart != empty and $MxObjectTypeReference != ...
- ChangeObjectAction: change Token (CombinedToken=$Token/Prefix + $Token/Token + $Token/Suffix, Description=if $Token/Description = empty or $Token/Description = '' then $Token/Token else $Token/Description; refreshInClient=false) change Token (CombinedToken=$Token/Prefix + $Token/Token + $Token/Suffix, Description=if $Token/Description = empty or $Token/Description = '' then $Token/Token else $Token/Description; refreshInClient=false)
- ChangeObjectAction: change Token (Status=MxModelReflection.Status.Invalid; refreshInClient=false) change Token (Status=MxModelReflection.Status.Invalid; refreshInClient=false)

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

- nodeId=ee757778-2846-4999-9d73-941625998060; sourceKind=Association; association=Token_MxObjectMember; summary=retrieve Member over association Token_MxObjectMember from Token
- nodeId=d9fa4cb5-25cd-4365-b450-776da99c1f78; sourceKind=Association; association=Token_MxObjectMember; summary=retrieve MemberReference over association Token_MxObjectMember from Token
- nodeId=81e5a077-5884-44f7-bf09-44d0cbaaa9a7; sourceKind=Association; association=Token_MxObjectReference; summary=retrieve MxObjectReference over association Token_MxObjectReference from Token
- nodeId=66b082a3-c639-4ef6-a6c5-5f3a8c2346ff; sourceKind=Association; association=Token_MxObjectType_Referenced; summary=retrieve MxObjectTypeReference over association Token_MxObjectType_Referenced from Token
- nodeId=e6bcf02a-e319-4b3d-aff2-e258b7d55969; sourceKind=Association; association=Token_MxObjectType_Start; summary=retrieve MxObjectTypeStart over association Token_MxObjectType_Start from Token
- nodeId=c27c0abf-0558-4607-a493-41225007bffa; caption=has all associations; expression=$Member != empty and $MxObjectTypeStart != empty has all associations expression=$Member != empty and $MxObjectTypeStart != empty
- nodeId=bfcc3a3e-4e67-41b4-ba0f-492239a38eaf; caption=has all associations; expression=$MemberReference != empty and $MxObjectReference != empty and $MxObjectTypeStart != empty and $MxObjectTypeReference != ... has all associations expression=$MemberReference != empty and $MxObjectReference != empty and $MxObjectTypeStart != empty and $MxObjectTypeReference != ...
- nodeId=1108bcf4-e954-4aa7-837f-515848359a21; caption=Token type; expression=$Token/TokenType Token type expression=$Token/TokenType

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-bco-token.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
