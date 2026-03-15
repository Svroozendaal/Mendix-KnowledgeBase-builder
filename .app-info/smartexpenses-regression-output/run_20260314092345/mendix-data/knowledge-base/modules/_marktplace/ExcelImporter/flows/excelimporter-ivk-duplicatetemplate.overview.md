---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.IVK_DuplicateTemplate
stableId: 164cb110-44de-4bb0-9308-70eaf755e799
slug: excelimporter-ivk-duplicatetemplate
layer: L1
l0: excelimporter-ivk-duplicatetemplate.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ivk-duplicatetemplate.json
l2Logical: flow:ExcelImporter.IVK_DuplicateTemplate
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.IVK_DuplicateTemplate

## Summary

- Likely acts as a save, process, or background step for ExcelImporter.Column, ExcelImporter.ReferenceHandling, ExcelImporter.Template because it mutates data without showing a page.
- L0: [abstract](excelimporter-ivk-duplicatetemplate.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ivk-duplicatetemplate.json)

## Main Steps

- retrieve AdditionalProperties over association Template_AdditionalProperties from Template
- retrieve AdditionalProperties_Copy over association Template_AdditionalProperties from Template
- ChangeObjectAction: change AdditionalProperties_Copy (PrintStatisticsMessages=$AdditionalProperties/PrintStatisticsMessages, PrintNotFoundMessages_MainObject=$AdditionalProperties/PrintNotFoundMessages_MainObject, IgnoreEmptyKeys=$AdditionalProperties/IgnoreEmptyKeys, CommitUnchangedObjects_MainObject=$AdditionalProperties/CommitUnchangedObjects_MainObject, RemoveUnsyncedObjects=$AdditionalProperties/RemoveUnsyncedObjects, ResetEmptyAssociations=$AdditionalProperties/ResetEmptyAssociations, AdditionalProperties_MxObjectMember_RemoveIndicator=$AdditionalProperties/ExcelImporter.AdditionalProperties_MxObjectMember_RemoveIndicator; refreshInClient=true) change AdditionalProperties_Copy (PrintStatisticsMessages=$AdditionalProperties/PrintStatisticsMessages, PrintNotFoundMessages_MainObject=$AdditionalProperties/PrintNotFoundMessages_MainObject, IgnoreEmptyKeys=$AdditionalProperties/IgnoreEmptyKeys, CommitUnchangedObjects_MainObject=$AdditionalProperties/CommitUnchangedObjects_MainObject, RemoveUnsyncedObjects=$AdditionalProperties/RemoveUnsyncedObjects, ResetEmptyAssociations=$AdditionalProperties/ResetEmptyAssociations, AdditionalProperties_MxObjectMember_RemoveIndicator=$AdditionalProperties/ExcelImporter.AdditionalProperties_MxObjectMember_RemoveIndicator; refreshInClient=true)
- ChangeObjectAction: change NewColumn (ColNumber=$Column/ColNumber, Text=$Column/Text, MappingType=$Column/MappingType, IsKey=$Column/IsKey, IsReferenceKey=$Column/IsReferenceKey, Status=$Column/Status, Details=$Column/Details, CaseSensitive=$Column/CaseSensitive, +13 more; refreshInClient=true) change NewColumn (ColNumber=$Column/ColNumber, Text=$Column/Text, MappingType=$Column/MappingType, IsKey=$Column/IsKey, IsReferenceKey=$Column/IsReferenceKey, Status=$Column/Status, Details=$Column/Details, CaseSensitive=$Column/CaseSensitive, +13 more; refreshInClient=true)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- ExcelImporter.Column, ExcelImporter.ReferenceHandling, ExcelImporter.Template

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=8ad2d33b-2c1d-490f-b841-74636ecc2c50; sourceKind=Association; association=Template_AdditionalProperties; summary=retrieve AdditionalProperties over association Template_AdditionalProperties from Template
- nodeId=0b96cdc4-988d-4357-b5b6-0cdca0bacbcc; sourceKind=Association; association=Template_AdditionalProperties; summary=retrieve AdditionalProperties_Copy over association Template_AdditionalProperties from Template
- nodeId=1ed5bde6-45cc-4fcd-969e-a24dc58389e8; sourceKind=Database; entity=ExcelImporter.Column; summary=retrieve ColumnList from ExcelImporter.Column
- nodeId=93551da8-d759-4cb5-8ed3-3f945057da46; sourceKind=Database; entity=ExcelImporter.ReferenceHandling; summary=retrieve ReferenceHandlingList from ExcelImporter.ReferenceHandling
- nodeId=33485f63-6004-4d37-8b0c-936f965baff3; sourceKind=Database; entity=ExcelImporter.ReferenceHandling; summary=retrieve ReferenceHandling_copy from ExcelImporter.ReferenceHandling
- nodeId=d4fa6758-8e04-4f59-aeac-29a04132cfbb; actionKind=Change; entity=ExcelImporter.AdditionalProperties_MxObjectMember_RemoveIndicator; members=PrintStatisticsMessages=$AdditionalProperties/PrintStatisticsMessages, PrintNotFoundMessages_MainObject=$AdditionalProperties/PrintNotFoundMessages_MainObject, IgnoreEmptyKeys=$AdditionalProperties/IgnoreEmptyKeys, CommitUnchangedObjects_MainObject=$AdditionalProperties/CommitUnchangedObjects_MainObject, RemoveUnsyncedObjects=$AdditionalProperties/RemoveUnsyncedObjects, ResetEmptyAssociations=$AdditionalProperties/ResetEmptyAssociations, AdditionalProperties_MxObjectMember_RemoveIndicator=$AdditionalProperties/ExcelImporter.AdditionalProperties_MxObjectMember_RemoveIndicator; refreshInClient=true; summary=ChangeObjectAction: change AdditionalProperties_Copy (PrintStatisticsMessages=$AdditionalProperties/PrintStatisticsMessages, PrintNotFoundMessages_MainObject=$AdditionalProperties/PrintNotFoundMessages_MainObject, IgnoreEmptyKeys=$AdditionalProperties/IgnoreEmptyKeys, CommitUnchangedObjects_MainObject=$AdditionalProperties/CommitUnchangedObjects_MainObject, RemoveUnsyncedObjects=$AdditionalProperties/RemoveUnsyncedObjects, ResetEmptyAssociations=$AdditionalProperties/ResetEmptyAssociations, AdditionalProperties_MxObjectMember_RemoveIndicator=$AdditionalProperties/ExcelImporter.AdditionalProperties_MxObjectMember_RemoveIndicator; refreshInClient=true) change AdditionalProperties_Copy (PrintStatisticsMessages=$AdditionalProperties/PrintStatisticsMessages, PrintNotFoundMessages_MainObject=$AdditionalProperties/PrintNotFoundMessages_MainObject, IgnoreEmptyKeys=$AdditionalProperties/IgnoreEmptyKeys, CommitUnchangedObjects_MainObject=$AdditionalProperties/CommitUnchangedObjects_MainObject, RemoveUnsyncedObjects=$AdditionalProperties/RemoveUnsyncedObjects, ResetEmptyAssociations=$AdditionalProperties/ResetEmptyAssociations, AdditionalProperties_MxObjectMember_RemoveIndicator=$AdditionalProperties/ExcelImporter.AdditionalProperties_MxObjectMember_RemoveIndicator; refreshInClient=true)
- nodeId=5728b973-6418-4c9b-a751-9b3e6e90e53e; actionKind=Change; members=ColNumber=$Column/ColNumber, Text=$Column/Text, MappingType=$Column/MappingType, IsKey=$Column/IsKey, IsReferenceKey=$Column/IsReferenceKey, Status=$Column/Status, Details=$Column/Details, CaseSensitive=$Column/CaseSensitive, +13 more; refreshInClient=true; summary=ChangeObjectAction: change NewColumn (ColNumber=$Column/ColNumber, Text=$Column/Text, MappingType=$Column/MappingType, IsKey=$Column/IsKey, IsReferenceKey=$Column/IsReferenceKey, Status=$Column/Status, Details=$Column/Details, CaseSensitive=$Column/CaseSensitive, +13 more; refreshInClient=true) change NewColumn (ColNumber=$Column/ColNumber, Text=$Column/Text, MappingType=$Column/MappingType, IsKey=$Column/IsKey, IsReferenceKey=$Column/IsReferenceKey, Status=$Column/Status, Details=$Column/Details, CaseSensitive=$Column/CaseSensitive, +13 more; refreshInClient=true)
- nodeId=8af5d534-973e-40cd-8a93-042f73ddc6b7; actionKind=Change; members=refreshInClient=true; summary=ChangeObjectAction: change NewTemplate (refreshInClient=true) change NewTemplate (refreshInClient=true)

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ivk-duplicatetemplate.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
