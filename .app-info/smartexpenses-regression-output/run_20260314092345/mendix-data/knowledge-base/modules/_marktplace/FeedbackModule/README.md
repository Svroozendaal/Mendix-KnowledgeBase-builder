# Module: FeedbackModule

Category: Marketplace
Module roles: User

## Summary

- Entities: 2
- Flows: 16
- Pages: 6
- Constants: 1

## Purpose

- Export-backed: module category and inventory from overview export.
- Inferred: module role is support capability.
- Deterministic fallback: This module appears to provide supporting capability for data such as feedback and response helper, flows such as feedback clear form, feedback clear image, and feedback trigger screenshot mode, pages such as feedback submitted and something went wrong, and supporting configuration and runtime resources based on its exported entities, pages, flows, and resources.

## Capability Map

| Capability prefix | Flow count | Representative flow |
|---|---:|---|
| ACT | 5 | FeedbackModule.ACT_Feedback_ClearForm |
| DS | 1 | FeedbackModule.DS_Feedback_Populate |
| OCH | 1 | FeedbackModule.OCH_Feedback_SaveToLocalStorage |
| OTHER | 3 | FeedbackModule.ConvertBase64String |
| SUB | 5 | FeedbackModule.SUB_Feedback_GetOrCreate |
| VAL | 1 | FeedbackModule.VAL_Feedback |

## Primary User Journeys

| Entry flow | UI result | Entities touched |
|---|---|---|
| FeedbackModule.VAL_Feedback | none | none |
| FeedbackModule.ACT_Feedback_UploadImage | FeedbackModule.ShareFeedback | none |
| FeedbackModule.SUB_Feedback_SendToServer | none | none |

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

- Domain export: [domain-model.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/FeedbackModule/domain-model.pseudo.txt) and [domain-model.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/FeedbackModule/domain-model.json).
- Flow export: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/FeedbackModule/flows.pseudo.txt) and [flows.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/FeedbackModule/flows.json).
- Page export: [pages.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/FeedbackModule/pages.pseudo.txt) and [pages.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/FeedbackModule/pages.json).
- Resource export: [resources.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/FeedbackModule/resources.pseudo.txt) and [resources.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/FeedbackModule/resources.json).
- Use `DOMAIN.md` for entity shape, lifecycle, access rules, associations, and XPath summaries.
- Use `FLOWS.md` and `flows/INDEX.abstract.md` for flow routing and compact module-level flow context.
- Use `PAGES.md` and `pages/INDEX.abstract.md` for page routing and compact module-level page context.
- Use `RESOURCES.md` for constants, scheduled events, and supporting module resources.

## Cross-Module Dependencies

- Calls to: none
- Called by: none
- Shared entities via associations: none

## Source

- Export module: FeedbackModule
- Run folder: cli_2026-03-14T09-23-46.259Z
