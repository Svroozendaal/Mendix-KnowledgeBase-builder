# Quick Start — {{AppName}}

Generated at: {{GeneratedAt}} | Format: {{FormatVersion}} | Enriched: {{EnrichedStatus}}

## This App

{{AppMissionSummary}}

## Modules

| Module | Type | Key Entities | Custom Flows | Priority |
|---|---|---|---|---|
{{ModuleRows}}

## Security Roles

{{RoleSummary}}

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
| Plan a feature | `/develop` → `.agents/agents/DEVELOPMENT_TEAM.md` |
| Apply an approved plan | `/applyplan` -> `.agents/agents/MENDIX_CLI_EXECUTOR.md` |

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

- This KB is **read-only** for normal interpretation. Controlled exceptions: `/enrichkb`, `/initkb`, `/applyplan`.
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
