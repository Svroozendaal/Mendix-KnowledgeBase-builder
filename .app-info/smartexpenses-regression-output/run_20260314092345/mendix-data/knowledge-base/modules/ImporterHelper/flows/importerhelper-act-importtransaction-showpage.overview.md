---
objectType: flow
module: ImporterHelper
qualifiedName: ImporterHelper.ACT_ImportTransaction_ShowPage
stableId: 1a6d88d3-4d88-4eca-bcd3-51282f06e67c
slug: importerhelper-act-importtransaction-showpage
layer: L1
l0: importerhelper-act-importtransaction-showpage.abstract.md
l2Path: ../../../../app-overview/current/modules/ImporterHelper/flows/importerhelper-act-importtransaction-showpage.json
l2Logical: flow:ImporterHelper.ACT_ImportTransaction_ShowPage
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ImporterHelper.ACT_ImportTransaction_ShowPage

## Summary

- Likely acts as a UI entry or navigation handler because it shows ImporterHelper.ImportTransaction_Overview.
- L0: [abstract](importerhelper-act-importtransaction-showpage.abstract.md)
- L2: [json](../../../../app-overview/current/modules/ImporterHelper/flows/importerhelper-act-importtransaction-showpage.json)

## Main Steps

- ShowPageAction: show page ImporterHelper.ImportTransaction_Overview show page ImporterHelper.ImportTransaction_Overview
- CreateObjectAction: create ImporterHelper.ImportTransactionHelper as NewImportTransactionHelper create ImporterHelper.ImportTransactionHelper as NewImportTransactionHelper

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: Shows ImporterHelper.ImportTransaction_Overview.

## Key Entities Touched

- ImporterHelper.ImportTransactionHelper

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- ImporterHelper.ImportTransaction_Overview

## Important Retrieves/Decisions/Mutations

- nodeId=5db7a28a-f7aa-43fe-9bf0-cc0903d860be; actionKind=Create; entity=ImporterHelper.ImportTransactionHelper; summary=CreateObjectAction: create ImporterHelper.ImportTransactionHelper as NewImportTransactionHelper create ImporterHelper.ImportTransactionHelper as NewImportTransactionHelper

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/ImporterHelper/flows/importerhelper-act-importtransaction-showpage.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/ImporterHelper/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/ImporterHelper/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
