---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.Column_SetDetails
stableId: c8d7cddd-b5d9-44e5-a486-0d67c3c3997c
slug: excelimporter-column-setdetails
layer: L1
l0: excelimporter-column-setdetails.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-column-setdetails.json
l2Logical: flow:ExcelImporter.Column_SetDetails
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.Column_SetDetails

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](excelimporter-column-setdetails.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-column-setdetails.json)

## Main Steps

- retrieve Member over association Column_MxObjectMember from pColumn
- retrieve Reference over association Column_MxObjectReference from pColumn
- $pColumn/MappingType expression=$pColumn/MappingType
- ChangeObjectAction: change pColumn (Details='Reference: ' + (if $Reference != empty then $Reference/CompleteName else 'nothing selected' )+ '/' + (if $ReferenceObjectType != empty then $ReferenceObjectType/CompleteName else ...; refreshInClient=false) change pColumn (Details='Reference: ' + (if $Reference != empty then $Reference/CompleteName else 'nothing selected' )+ '/' + (if $ReferenceObjectType != empty then $ReferenceObjectType/CompleteName else ...; refreshInClient=false)
- ChangeObjectAction: change pColumn (Details=if( $Member != empty ) then 'Attribute: ' + $Member/AttributeName + ', type: ' + $Member/AttributeType else 'Nothing selected'; refreshInClient=false) change pColumn (Details=if( $Member != empty ) then 'Attribute: ' + $Member/AttributeName + ', type: ' + $Member/AttributeType else 'Nothing selected'; refreshInClient=false)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by ExcelImporter.BCo_Column.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: ExcelImporter.BCo_Column

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=a5eb1876-1c56-4b44-8d29-77d49006048e; sourceKind=Association; association=Column_MxObjectMember; summary=retrieve Member over association Column_MxObjectMember from pColumn
- nodeId=b722d411-c15f-4b7c-901b-1c6f15b8f6b1; sourceKind=Association; association=Column_MxObjectReference; summary=retrieve Reference over association Column_MxObjectReference from pColumn
- nodeId=fa3208f0-2ac6-470e-9042-b3d1658e171c; sourceKind=Association; association=Column_MxObjectMember_Reference; summary=retrieve ReferenceMember over association Column_MxObjectMember_Reference from pColumn
- nodeId=a26fd51c-e3e0-434c-9662-8879187555ae; sourceKind=Association; association=Column_MxObjectType_Reference; summary=retrieve ReferenceObjectType over association Column_MxObjectType_Reference from pColumn
- nodeId=3817c304-d631-4637-b097-ad8641f9595a; caption=none; expression=$pColumn/MappingType expression=$pColumn/MappingType
- nodeId=3aa01e89-8212-4e4d-abf0-faaa42393bd3; actionKind=Change; members=Details='Reference: ' + (if $Reference != empty then $Reference/CompleteName else 'nothing selected'; summary=ChangeObjectAction: change pColumn (Details='Reference: ' + (if $Reference != empty then $Reference/CompleteName else 'nothing selected' )+ '/' + (if $ReferenceObjectType != empty then $ReferenceObjectType/CompleteName else ...; refreshInClient=false) change pColumn (Details='Reference: ' + (if $Reference != empty then $Reference/CompleteName else 'nothing selected' )+ '/' + (if $ReferenceObjectType != empty then $ReferenceObjectType/CompleteName else ...; refreshInClient=false)
- nodeId=fdfd4094-5067-4ed1-bef0-03b5d090d6bd; actionKind=Change; members=Details=if( $Member != empty; summary=ChangeObjectAction: change pColumn (Details=if( $Member != empty ) then 'Attribute: ' + $Member/AttributeName + ', type: ' + $Member/AttributeType else 'Nothing selected'; refreshInClient=false) change pColumn (Details=if( $Member != empty ) then 'Attribute: ' + $Member/AttributeName + ', type: ' + $Member/AttributeType else 'Nothing selected'; refreshInClient=false)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-column-setdetails.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
