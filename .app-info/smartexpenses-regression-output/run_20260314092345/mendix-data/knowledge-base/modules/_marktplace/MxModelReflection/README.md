# Module: MxModelReflection

Category: Marketplace
Module roles: ModelAdministrator, Readonly, TokenUser

## Summary

- Entities: 15
- Flows: 33
- Pages: 17
- Constants: 0

## Purpose

- Export-backed: module category and inventory from overview export.
- Inferred: module role is support capability.
- Deterministic fallback: This module appears to provide supporting capability for data such as db size estimate, inherits from container, and microflows, flows such as association is reference set, asu check metamodel, and show member page, and pages such as edit db size estimate and select an enumeration value based on its exported entities, pages, flows, and resources.

## Capability Map

| Capability prefix | Flow count | Representative flow |
|---|---:|---|
| ACT | 1 | MxModelReflection.ACT_ShowMemberPage |
| ASU | 1 | MxModelReflection.ASu_CheckMetamodel |
| BCO | 4 | MxModelReflection.BCo_MxObjectMember_CreateCompleteMemberName |
| BDE | 1 | MxModelReflection.BDe_MxObjectType |
| CH | 4 | MxModelReflection.Ch_Member |
| DSL | 1 | MxModelReflection.DSL_Modules |
| DSO | 1 | MxModelReflection.DSO_InheritsFromContainer |
| IVK | 6 | MxModelReflection.IVK_deleteAll |
| MB | 2 | MxModelReflection.MB_TestThePattern |
| OC | 1 | MxModelReflection.OC_FindObjectType |
| OTHER | 11 | MxModelReflection.AssociationIsReferenceSet |

## Primary User Journeys

| Entry flow | UI result | Entities touched |
|---|---|---|
| MxModelReflection.IVK_RecalculateSize | none | MxModelReflection.DbSizeEstimate, MxModelReflection.MxObjectMember |
| MxModelReflection.BCo_Token | none | none |
| MxModelReflection.AssociationIsReferenceSet | none | none |

## Top risks/unknowns in model understanding
- Some flows have behavioural actions without explicit entity name tokens (parser gap).
- Some pages have no explicit ShowPageAction evidence in exported flows.

## Navigation

- [DOMAIN.md](DOMAIN.md)
- [FLOWS.md](FLOWS.md) - module flow overview
- [flows/INDEX.abstract.md](flows/INDEX.abstract.md) - flow routing file
- [PAGES.md](PAGES.md) - module page overview
- [pages/INDEX.abstract.md](pages/INDEX.abstract.md) - page routing file
- [RESOURCES.md](RESOURCES.md)
- [INTERPRETATION.md](INTERPRETATION.md) - AI narrative layer
- Open collection abstracts first, then object overview files, and use stable JSON only when exact export-backed detail is required.

## Source Pointers

- Domain export: [domain-model.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/domain-model.pseudo.txt) and [domain-model.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/domain-model.json).
- Flow export: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/flows.pseudo.txt) and [flows.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/flows.json).
- Page export: [pages.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/pages.pseudo.txt) and [pages.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/pages.json).
- Resource export: [resources.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/resources.pseudo.txt) and [resources.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/resources.json).
- Use `DOMAIN.md` for entity shape, lifecycle, access rules, associations, and XPath summaries.
- Use `FLOWS.md` and `flows/INDEX.abstract.md` for flow routing and compact module-level flow context.
- Use `PAGES.md` and `pages/INDEX.abstract.md` for page routing and compact module-level page context.
- Use `RESOURCES.md` for constants, scheduled events, and supporting module resources.

## Cross-Module Dependencies

- Calls to: none
- Called by: ExcelImporter
- Shared entities via associations: none

## Source

- Export module: MxModelReflection
- Run folder: cli_2026-03-14T09-23-46.259Z
