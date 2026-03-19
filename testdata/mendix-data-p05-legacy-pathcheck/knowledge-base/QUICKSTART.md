# Quick Start â€” Emixa_InspectionApp_P05_Legacy_PathCheck

Generated at: 2026-03-18T20:45:19.1648241+00:00 | Format: 1.0 | Enriched: No

## This App

The application centres on the custom modules Inspection, Notification and orchestrates data and UI behaviour through model-driven flows and pages.

## Modules

| Module | Type | Key Entities | Custom Flows | Priority |
|---|---|---|---|---|
| Inspection | Custom | Accessory, Booking, CoverPhoto +9 | 41 | 136 |
| Notification | Custom | Notification | 5 | 16 |
| System | System | ConsumedODataConfiguration, Error, FileDocument +38 | 1 | 125 |
| Administration | Marketplace | Account, AccountPasswordData | 9 | 34 |
| Atlas_Web_Content | Marketplace | LoginContext | 2 | 7 |
| NanoflowCommons | Marketplace | Geolocation, Position | 0 | 6 |
| Unknown |  | none | 0 | 0 |
| Atlas_Core | Marketplace | none | 0 | 0 |
| DataWidgets | Marketplace | none | 0 | 0 |


## Security Roles

- **Administrator**: Administration.Administrator, Inspection.Administrator, Notification.Administrator, System.Administrator
- **Inspector**: Administration.User, Inspection.Inspector, Notification.Inspector, System.User
- **Manager**: Administration.User, Inspection.Manager, Notification.Manager, System.User
- **Anonymous**: Inspection.Anonymous, System.User

## How to Find Things

| I want to... | Read this file |
|---|---|
| Understand the app | `app/APP_OVERVIEW.md` |
| Find an entity | `routes/by-entity.md` or `routes/keyword-index.md` |
| Find a flow | `routes/by-flow.md` or `routes/keyword-index.md` |
| Find a page | `routes/by-page.md` |
| Understand a module | `modules/<Name>/README.md` |
| See cross-module dependencies | `routes/cross-module.md` |
| Check security | `app/SECURITY.md` |
| Plan a feature | `/develop` â†’ `.agents/agents/DEVELOPMENT_TEAM.md` |

## Agent Routing

| Question type | Agent/Skill |
|---|---|
| User story or `/develop` | Development Team |
| "How does X work?" (feature) | KB Feature Interpreter |
| "Trace flow X" | KB Flow Tracer |
| "What if I change X?" | KB Analyst (impact-analysis) |
| Security question | KB Security Reviewer |
| "How do I build X?" | Mendix Developer |
| Lookup / navigation | KB Navigator |

## Scope Rules

- This KB is **read-only**. Exception: `/enrichkb` can add AI narrative.
- Only cite what is in the KB. Do not fabricate.
- Only target **custom modules** for development. Marketplace/system modules are reference-only.
- Use UK English.
- Cite file paths in all answers.

## Reading Depth Guide

- **Quick answer**: ROUTING.md -> 1 module README -> answer
- **Feature understanding**: + FLOWS.md + top 3 L0 abstracts + 1 L1 overview
- **Full investigation**: + all related L1 overviews + DOMAIN.md + INTERPRETATION.md
- **Implementation plan**: everything above + routes + SECURITY.md

## Full Reference

For detailed governance: `.agents/AGENTS.md`
For KB structure detail: `.agents/FRAMEWORK.md`
For complete workflow: `.agents/AI_WORKFLOW.md`
For navigation rules: `READER.md`
For full module index: `ROUTING.md`
