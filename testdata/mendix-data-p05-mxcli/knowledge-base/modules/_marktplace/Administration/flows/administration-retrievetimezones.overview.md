---
objectType: flow
module: Administration
qualifiedName: Administration.RetrieveTimeZones
stableId: 5e692cf3-f200-4ae6-8043-e8cc9c9ed6c5
slug: administration-retrievetimezones
layer: L1
l0: administration-retrievetimezones.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/Administration/flows/administration-retrievetimezones.json
l2Logical: flow:Administration.RetrieveTimeZones
sourceRun: cli_2026-03-18T20-44-56.521Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Administration.RetrieveTimeZones

## Summary

- Deterministic overview derived from exported flow structure.
- L0: [abstract](administration-retrievetimezones.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/Administration/flows/administration-retrievetimezones.json)

## Main Steps

- retrieve from System.TimeZone SORT BY System.TimeZone.RawOffset ASC, System.TimeZone.Description ASC

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; check L2 JSON if the exact user-facing effect matters.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it may serve validation, background processing, or delegate work to other flows.

## Important Retrieves/Decisions/Mutations

- nodeId=n002-retrieve; sourceKind=Database; entity=System.TimeZone; summary=retrieve from System.TimeZone SORT BY System.TimeZone.RawOffset ASC, System.TimeZone.Description ASC

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/Administration/flows/administration-retrievetimezones.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-18T20-44-56.521Z/modules/marketplace/Administration/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-18T20-44-56.521Z/modules/marketplace/Administration/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-44-56.521Z
