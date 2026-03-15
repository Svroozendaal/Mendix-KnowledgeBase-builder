# AI_WORKFLOW
## Standard Execution Flow for Knowledge Base Interpretation

Use this file with `.agents/AGENTS.md`.

## Scope Reminder

This workflow is for reading and interpreting a pre-built knowledge base. The one controlled exception is `/enrichkb`, which may enrich this KB in place by reading the linked app-overview run folder from `_sources/creator-link.json`. `/initkb` remains a compatibility entry point and should behave the same when no rebuild is needed. Neither command may rerun pipelines or access Mendix tooling.

## Workflow

1. Read `.agents/AGENTS.md`.
2. Read `.agents/FRAMEWORK.md`.
3. Read `READER.md`.
4. Read `ROUTING.md`.
5. Identify which agent or skill is needed.
6. Navigate to the relevant KB files using the routing index.
7. Read the relevant files and cross-reference using routes.
8. Synthesize an answer, citing specific KB files and sections.
9. If information is incomplete, state what is missing and where to look.

## Question-Answering Checklist

Before answering any question about the application:

1. Have I checked the relevant module files?
2. Have I checked the cross-cutting routes?
3. Have I checked the app-level files if the question spans modules?
4. Have I verified my answer against the actual KB content?
5. Have I cited the specific files that support my answer?
6. Am I only reporting what the KB contains?

## Common Query Patterns

| Query type | Start with | Then check |
|---|---|---|
| "What does module X do?" | `modules/X/README.md` or `modules/_marktplace/X/README.md` | matching `DOMAIN.md`, `FLOWS.md` |
| "Which flows use entity Y?" | `routes/by-entity.md` | `modules/<module>/FLOWS.md` or `modules/_marktplace/<module>/FLOWS.md` |
| "What pages show entity Y?" | `routes/by-entity.md` | `modules/<module>/PAGES.md` or `modules/_marktplace/<module>/PAGES.md` |
| "What are the security roles?" | `app/SECURITY.md` | `routes/by-page.md` |
| "How do modules depend on each other?" | `routes/cross-module.md` | `app/CALL_GRAPH.md` |
| "What is the app about?" | `app/APP_OVERVIEW.md` | `app/MODULE_LANDSCAPE.md` |
| "What scheduled events exist?" | `modules/<module>/RESOURCES.md` or `modules/_marktplace/<module>/RESOURCES.md` | Iterate all modules |
| "How should I build X?" | Relevant `modules/*/FLOWS.md` and `modules/_marktplace/*/FLOWS.md` | Existing patterns, then recommend |
| "Interpret this user story" | `app/SECURITY.md` | `routes/by-entity.md`, `routes/by-flow.md` |

## Out-of-Scope Requests

If a user asks you to do any of the following, decline and explain:

- "Add the AI narrative layer to this KB" -> Use `/enrichkb` to enrich the current KB in place when creator-link metadata and `lastRunFolder` are present
- "Regenerate the KB from source" -> Use `/initkb` to delegate back to the KnowledgeBase Creator package when creator-link metadata is present; otherwise tell them to rerun the creator pipeline externally
- "Run the dump/parser/scaffold" -> This is handled by the pipeline, not by agents
- "Open/modify the .mpr file" -> Agents cannot access Mendix Studio Pro or model files
- "Update the KB files" -> Only `/enrichkb` or the compatibility entry `/initkb` may add AI enrichment. All other direct KB mutations are out of scope
- "Connect to an API / database" -> Agents only read local KB markdown files

## Definition of Done

A query is fully answered when:

1. The answer is supported by specific KB file references.
2. All relevant cross-references have been checked.
3. Any gaps or incomplete sections have been noted.
4. The answer is clear, concise, and actionable.
5. No information was fabricated beyond what the KB contains.
