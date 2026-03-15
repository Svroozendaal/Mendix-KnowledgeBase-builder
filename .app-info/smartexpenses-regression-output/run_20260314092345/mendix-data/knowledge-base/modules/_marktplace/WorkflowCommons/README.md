# Module: WorkflowCommons

Category: Marketplace
Module roles: Administrator, User

## Summary

- Entities: 26
- Flows: 186
- Pages: 32
- Constants: 2

## Purpose

- Export-backed: module category and inventory from overview export.
- Inferred: module role is support capability.
- Deterministic fallback: This module appears to provide supporting capability for data such as assignment helper, audit trail viewer, and cleanup helper, flows such as assignee migrate, attachment create, and attachment download, pages such as default workflow admin and expense request approval, and supporting configuration and runtime resources based on its exported entities, pages, flows, and resources.

## Capability Map

| Capability prefix | Flow count | Representative flow |
|---|---:|---|
| ACT | 67 | WorkflowCommons.ACT_Assignee_Migrate |
| ASU | 2 | WorkflowCommons.ASu_Assignee_Migrate |
| DASHBOARDCONTEXT | 2 | WorkflowCommons.DashboardContext_GetSelectedWorkflowDefinition |
| DS | 30 | WorkflowCommons.DS_AuditTrailViewer |
| OCH | 6 | WorkflowCommons.OCh_CleanupHelper_UpdateCount |
| OCL | 1 | WorkflowCommons.OCl_WorkflowSummary |
| SE | 1 | WorkflowCommons.SE_WorkflowAuditTrailRecord_CleanUp |
| SUB | 76 | WorkflowCommons.SUB_Assignee_Migrate |
| WFEH | 1 | WorkflowCommons.WFEH_WorkflowEvent_AuditTrail |

## Primary User Journeys

| Entry flow | UI result | Entities touched |
|---|---|---|
| WorkflowCommons.SUB_Duration_Calculate | none | WorkflowCommons.DurationHelper |
| WorkflowCommons.SUB_CleanupHelper_Execute_Workflow | none | System.Workflow |
| WorkflowCommons.SUB_CleanupHelper_Execute_WorkflowView | none | WorkflowCommons.WorkflowView |

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

- Domain export: [domain-model.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/domain-model.pseudo.txt) and [domain-model.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/domain-model.json).
- Flow export: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt) and [flows.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json).
- Page export: [pages.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/pages.pseudo.txt) and [pages.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/pages.json).
- Resource export: [resources.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/resources.pseudo.txt) and [resources.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/resources.json).
- Use `DOMAIN.md` for entity shape, lifecycle, access rules, associations, and XPath summaries.
- Use `FLOWS.md` and `flows/INDEX.abstract.md` for flow routing and compact module-level flow context.
- Use `PAGES.md` and `pages/INDEX.abstract.md` for page routing and compact module-level page context.
- Use `RESOURCES.md` for constants, scheduled events, and supporting module resources.

## Cross-Module Dependencies

- Calls to: none
- Called by: none
- Shared entities via associations: none

## Source

- Export module: WorkflowCommons
- Run folder: cli_2026-03-14T09-23-46.259Z
