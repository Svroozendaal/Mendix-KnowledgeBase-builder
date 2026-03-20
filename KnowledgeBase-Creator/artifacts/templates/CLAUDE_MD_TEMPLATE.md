# Claude Code - {{APP_NAME}} Knowledge Base

This is an AI-navigable knowledge base for the **{{APP_NAME}}** Mendix application.

Before executing any task, read `QUICKSTART.md` for a fast-start overview.

For full detail, read:
1. `.agents/AGENTS.md` - governance and agent roster
2. `.agents/FRAMEWORK.md` - KB structure
3. `.agents/AI_WORKFLOW.md` - operating flow
4. `READER.md` - how to read this KB
5. `ROUTING.md` - module and route index

## Scope

This knowledge base is a **read-only artifact for normal interpretation**. Controlled commands are `/enrichkb`, `/initkb`, and `/applyplan`.

- `/enrichkb` may enrich this KB in place by using the linked source run folder from `_sources/creator-link.json`.
- `/initkb` remains a compatibility entry point and rebuild handoff.
- `/applyplan` may apply an approved `_plans/STORY_<slug>.md` to the linked `.mpr` through a preview-gated, confirmation-required workflow.

Do not run pipelines or direct Mendix tooling commands from this folder outside these controlled commands.

## Quick start

- **What is this app?** -> `app/APP_OVERVIEW.md`
- **Which modules matter?** -> `app/MODULE_LANDSCAPE.md`
- **Find an entity/flow/page** -> `ROUTING.md` or `routes/keyword-index.md`
- **Security roles** -> `app/SECURITY.md`
- **Add the AI narrative layer to this KB?** -> `/enrichkb`
- **Rebuild from source?** -> `/initkb`
- **Apply an approved plan to the linked app?** -> `/applyplan`

Generated at: {{GENERATED_AT_UTC}} | Format version: {{KB_FORMAT_VERSION}}
