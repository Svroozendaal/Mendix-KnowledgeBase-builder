# Domain: FeedbackModule

## Entities

| Entity | Persistable | Attribute count | Access rule count |
|---|---|---:|---:|
| FeedbackModule.Feedback | False | 16 | 1 |
| FeedbackModule.ResponseHelper | False | 1 | 1 |

Confidence: Export-backed

## Entity Lifecycle Matrix

| Entity | Create flows | Update flows | Delete flows | Read flows |
|---|---|---|---|---|
| FeedbackModule.Feedback | FeedbackModule.SUB_Feedback_GetOrCreate | none | none | none |
| FeedbackModule.ResponseHelper | none | none | none | none |

Confidence: Inferred

## Role impacts per sensitive entity

| Entity | Module roles | Default member rights | XPath constraint |
|---|---|---|---|
| FeedbackModule.Feedback | FeedbackModule.User | ReadWrite | none |
| FeedbackModule.ResponseHelper | FeedbackModule.User | None | none |

Confidence: Export-backed

## Associations

| Association | Parent | Child | Cardinality | Type | Owner |
|---|---|---|---|---|---|
| none | none | none | none | none | none |

## Enumerations

| Enumeration | Value count | Sample values |
|---|---:|---|
| FeedbackModule.LogNodes | 1 | FeedbackModule |
| FeedbackModule.TranslationLanguages | 8 | Dutch, English, French, German |

## Entity Index

<a id="entity-feedbackmodule-feedback"></a>
### FeedbackModule.Feedback

- Generalization: none.
- Lifecycle: create=FeedbackModule.SUB_Feedback_GetOrCreate; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/FeedbackModule/domain-model.pseudo.txt) / [domain-model.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/FeedbackModule/domain-model.json).
<a id="entity-feedbackmodule-responsehelper"></a>
### FeedbackModule.ResponseHelper

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/FeedbackModule/domain-model.pseudo.txt) / [domain-model.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/FeedbackModule/domain-model.json).

## Source

- Domain export pseudo: [domain-model.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/FeedbackModule/domain-model.pseudo.txt)
- Domain export json: [domain-model.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/FeedbackModule/domain-model.json)
