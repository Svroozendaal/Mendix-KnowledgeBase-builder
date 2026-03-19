---
objectType: page
module: Inspection
qualifiedName: Inspection.Equipment_Overview
stableId: Inspection.Equipment_Overview
slug: inspection-equipment-overview
layer: L1
l0: inspection-equipment-overview.abstract.md
l2Path: ../../../../app-overview/current/modules/Inspection/pages/inspection-equipment-overview.json
l2Logical: page:Inspection.Equipment_Overview
sourceRun: cli_2026-03-18T20-49-03.032Z
collectionL0: INDEX.abstract.md
collectionL1: ../PAGES.md
---
# Page Overview: Inspection.Equipment_Overview

## Summary

- Equipment Overview. Likely serves as an overview or browse page for reviewing records and starting related tasks.
- L0: [abstract](inspection-equipment-overview.abstract.md)
- L2: [json](../../../../app-overview/current/modules/Inspection/pages/inspection-equipment-overview.json)

## Roles and Entry Provenance

- Roles: Inspection.Inspector, Inspection.Manager
- Entry provenance: MenuItem

## Parameters

- none

## Datasource Summary

- sourceId=dataGrid2; sourceType=Database; entity=Inspection.Accessory; summary=Database datasource: Inspection.Accessory
- sourceId=dataGrid3; sourceType=Database; entity=Inspection.Tool; summary=Database datasource: Inspection.Tool
- sourceId=dataView1; sourceType=Microflow; flow=Inspection.DS_Booking_RetrieveUpcomming; summary=Microflow datasource: Inspection.DS_Booking_RetrieveUpcomming

## Client Actions

- actionId=actionButton1; actionType=MicroflowClientAction; flow=Inspection.ACT_Accessory_Create; summary=MicroflowClientAction, flow=Inspection.ACT_Accessory_Create
- actionId=actionButton7; actionType=PageClientAction; targetPage=Inspection.Assessory_NewEdit; summary=PageClientAction, page=Inspection.Assessory_NewEdit
- actionId=actionButton2; actionType=MicroflowClientAction; flow=Inspection.ACT_Assessory_Delete; summary=MicroflowClientAction, flow=Inspection.ACT_Assessory_Delete
- actionId=actionButton6; actionType=MicroflowClientAction; flow=Inspection.ACT_Tool_Create; summary=MicroflowClientAction, flow=Inspection.ACT_Tool_Create
- actionId=actionButton4; actionType=PageClientAction; targetPage=Inspection.Tool_NewEdit; summary=PageClientAction, page=Inspection.Tool_NewEdit

## Shown by Flows

- No ShowPageAction was resolved from exported flows; this page may be reached from navigation or a client-side action. Check L2 JSON if exact provenance matters.

## Navigation/Homepage Provenance

- provenanceId=nav-da4df37641fa; sourceType=MenuItem; summary=Menu item "Equipment management" in profile Responsive

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/Inspection/pages/inspection-equipment-overview.json)
- Aggregate export: [pages.json](../../../../app-overview/cli_2026-03-18T20-49-03.032Z/modules/Inspection/pages.json)
- Aggregate pseudo: [pages.pseudo.txt](../../../../app-overview/cli_2026-03-18T20-49-03.032Z/modules/Inspection/pages.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-49-03.032Z
