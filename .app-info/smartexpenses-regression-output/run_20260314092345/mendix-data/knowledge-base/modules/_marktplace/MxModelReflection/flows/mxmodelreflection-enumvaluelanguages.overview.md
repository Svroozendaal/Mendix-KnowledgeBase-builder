---
objectType: flow
module: MxModelReflection
qualifiedName: MxModelReflection.EnumValueLanguages
stableId: 1ea98839-6a62-4353-9dc5-852decb4f633
slug: mxmodelreflection-enumvaluelanguages
layer: L1
l0: mxmodelreflection-enumvaluelanguages.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-enumvaluelanguages.json
l2Logical: flow:MxModelReflection.EnumValueLanguages
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: MxModelReflection.EnumValueLanguages

## Summary

- Likely acts as a save, process, or background step for MxModelReflection.StringValue because it mutates data without showing a page.
- L0: [abstract](mxmodelreflection-enumvaluelanguages.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-enumvaluelanguages.json)

## Main Steps

- CreateObjectAction: create MxModelReflection.StringValue as NewStringValue (Value=$languages) create MxModelReflection.StringValue as NewStringValue (Value=$languages)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- MxModelReflection.StringValue

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=6bff440d-eb1c-4875-9082-2f3659075f07; actionKind=Create; entity=MxModelReflection.StringValue; members=Value=$languages; summary=CreateObjectAction: create MxModelReflection.StringValue as NewStringValue (Value=$languages) create MxModelReflection.StringValue as NewStringValue (Value=$languages)

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-enumvaluelanguages.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
