---
objectType: flow
module: Inspection
qualifiedName: Inspection.ACT_Assessory_Book
stableId: 55c66afc-5ad1-4865-aa64-1fb050493d8e
slug: inspection-act-assessory-book
layer: L1
l0: inspection-act-assessory-book.abstract.md
l2Path: ../../../../app-overview/current/modules/Inspection/flows/inspection-act-assessory-book.json
l2Logical: flow:Inspection.ACT_Assessory_Book
sourceRun: cli_2026-03-18T20-44-56.522Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Inspection.ACT_Assessory_Book

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](inspection-act-assessory-book.abstract.md)
- L2: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-act-assessory-book.json)

## Main Steps

- $Accessory/AmountInStock != 0 IsStock? expression=$Accessory/AmountInStock != 0
- $Accessory/AmountInStock > 10 AmountInStock > 10? expression=$Accessory/AmountInStock > 10
- CommitAction: commit Accessory (refreshInClient=true, withEvents=true) commit Accessory (refreshInClient=true, withEvents=true)
- ChangeObjectAction: change Accessory (EquipmentStatus=Inspection.ENUM_Accessory_Status.Out_of_stock; refreshInClient=true) change Accessory (EquipmentStatus=Inspection.ENUM_Accessory_Status.Out_of_stock; refreshInClient=...

## Trigger/Input/Output Context

- Kind: Microflow
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

- nodeId=4f9c3c8e-cc0f-4985-a28a-d74bbf32079b; caption=IsStock?; expression=$Accessory/AmountInStock != 0 IsStock? expression=$Accessory/AmountInStock != 0
- nodeId=db6617a7-02f6-4187-a1c6-a78aa104740d; caption=AmountInStock > 10?; expression=$Accessory/AmountInStock > 10 AmountInStock > 10? expression=$Accessory/AmountInStock > 10
- nodeId=e81512f0-6fc5-4b32-8720-10969939402a; caption=AmountInStock = 0; expression=$Accessory/AmountInStock = 0 AmountInStock = 0 expression=$Accessory/AmountInStock = 0
- nodeId=01b751fd-96a8-4fb8-9632-9ab248b3d201; actionKind=Commit; members=refreshInClient=true, withEvents=true; summary=CommitAction: commit Accessory (refreshInClient=true, withEvents=true) commit Accessory (refreshInClient=true, withEvents=true)
- nodeId=2c877347-bad9-46f1-8c6f-009ff5c46b35; actionKind=Change; entity=Inspection.ENUM_Accessory_Status; members=EquipmentStatus=Inspection.ENUM_Accessory_Status.Out_of_stock; refreshInClient=true; summary=ChangeObjectAction: change Accessory (EquipmentStatus=Inspection.ENUM_Accessory_Status.Out_of_stock; refreshInClient=true) change Accessory (EquipmentStatus=Inspection.ENUM_Accessory_Status.Out_of_stock; refreshInClient=...
- nodeId=3d02d895-4b71-4d28-83fa-fd06c79ea4c6; actionKind=Change; members=AmountInStock=$Accessory/AmountInStock - 1; refreshInClient=false; summary=ChangeObjectAction: change Accessory (AmountInStock=$Accessory/AmountInStock - 1; refreshInClient=false) change Accessory (AmountInStock=$Accessory/AmountInStock - 1; refreshInClient=false)
- nodeId=9ef8b7c5-87d3-4837-8c72-2f1da7072013; actionKind=Change; entity=Inspection.ENUM_Accessory_Status; members=EquipmentStatus=Inspection.ENUM_Accessory_Status.Almost_out_of_stock; refreshInClient=true; summary=ChangeObjectAction: change Accessory (EquipmentStatus=Inspection.ENUM_Accessory_Status.Almost_out_of_stock; refreshInClient=true) change Accessory (EquipmentStatus=Inspection.ENUM_Accessory_Status.Almost_out_of_stock; re...

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-act-assessory-book.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-18T20-44-56.522Z/modules/Inspection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-18T20-44-56.522Z/modules/Inspection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-44-56.522Z
