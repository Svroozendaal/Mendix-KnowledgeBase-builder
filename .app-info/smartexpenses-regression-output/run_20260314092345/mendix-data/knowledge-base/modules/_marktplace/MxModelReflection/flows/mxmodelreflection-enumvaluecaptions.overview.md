---
objectType: flow
module: MxModelReflection
qualifiedName: MxModelReflection.EnumValueCaptions
stableId: 1027e315-e95d-48fc-a43f-d30b3b4c7f43
slug: mxmodelreflection-enumvaluecaptions
layer: L1
l0: mxmodelreflection-enumvaluecaptions.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-enumvaluecaptions.json
l2Logical: flow:MxModelReflection.EnumValueCaptions
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: MxModelReflection.EnumValueCaptions

## Summary

- Likely acts as a save, process, or background step for MxModelReflection.StringValue because it mutates data without showing a page.
- L0: [abstract](mxmodelreflection-enumvaluecaptions.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-enumvaluecaptions.json)

## Main Steps

- CreateObjectAction: create MxModelReflection.StringValue as NewStringValue (Value=$captions) create MxModelReflection.StringValue as NewStringValue (Value=$captions)

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

- nodeId=744e2d8b-19b8-4d4d-863e-ad7efb4fa38b; actionKind=Create; entity=MxModelReflection.StringValue; members=Value=$captions; summary=CreateObjectAction: create MxModelReflection.StringValue as NewStringValue (Value=$captions) create MxModelReflection.StringValue as NewStringValue (Value=$captions)

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-enumvaluecaptions.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
