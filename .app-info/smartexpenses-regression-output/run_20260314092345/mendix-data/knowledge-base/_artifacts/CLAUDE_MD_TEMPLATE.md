# Claude Code - {{APP_NAME}} Knowledge Base

This is an AI-navigable knowledge base for the **{{APP_NAME}}** Mendix application.

Before executing any task, read the following files in order:

1. `.agents/AGENTS.md` - governance, agent roster, and orchestration logic.
2. `.agents/FRAMEWORK.md` - knowledge base structure and navigation model.
3. `.agents/AI_WORKFLOW.md` - standard operating flow for KB interpretation.
4. `READER.md` - how to read this knowledge base.
5. `ROUTING.md` - quick lookup for modules, entities, flows, and pages.

## Scope

This knowledge base is a **read-only artifact for normal interpretation**. The one explicit enrichment command is `/enrichkb`, which may enrich this KB in place by using the linked source run folder from `_sources/creator-link.json`. `/initkb` remains available as a compatibility entry point and rebuild handoff. Do not run pipelines, access `.mpr` files, or interact with external systems from this folder.

## Quick start

- **What is this app?** -> `app/APP_OVERVIEW.md`
- **Which modules matter?** -> `app/MODULE_LANDSCAPE.md`
- **Find an entity/flow/page** -> `ROUTING.md`
- **Security roles** -> `app/SECURITY.md`
- **Add the AI narrative layer to this KB?** -> `/enrichkb`
- **Rebuild from source?** -> `/initkb`

Generated at: {{GENERATED_AT_UTC}} | Format version: {{KB_FORMAT_VERSION}}
