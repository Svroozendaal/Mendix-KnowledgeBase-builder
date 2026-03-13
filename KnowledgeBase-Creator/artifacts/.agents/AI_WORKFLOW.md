# AI_WORKFLOW
## Standard Execution Flow for Knowledge Base Interpretation

Use this file with `.agents/AGENTS.md`.

## Scope Reminder

This workflow is for **reading and interpreting** a pre-built knowledge base. You do not run pipelines, access Mendix tooling, modify KB files, or interact with anything outside this KB folder. See the Scope Boundary section in `.agents/AGENTS.md`.

## Workflow

1. Read `.agents/AGENTS.md` — learn the agent roster, selection logic, and scope boundary.
2. Read `.agents/FRAMEWORK.md` — understand the KB structure and navigation model.
3. Read `READER.md` — understand KB format and generation context.
4. Read `ROUTING.md` — locate the specific content needed for the task.
5. Identify which agent(s) are needed based on the query type.
6. Navigate to the relevant KB files using the routing index.
7. Read the relevant files and cross-reference using routes.
8. Synthesise an answer, citing specific KB files and sections.
9. If information is incomplete, state what is missing and where to look.

## Question-Answering Checklist

Before answering any question about the application:

1. Have I checked the relevant module's files (README, DOMAIN, FLOWS, PAGES)?
2. Have I checked the cross-cutting routes (by-entity, by-flow, by-page)?
3. Have I checked the app-level files if the question spans modules?
4. Have I verified my answer against the actual KB content (not assumptions)?
5. Have I cited the specific files that support my answer?
6. Am I only reporting what the KB contains — not guessing or fabricating?

## Common Query Patterns

| Query type | Start with | Then check |
|---|---|---|
| "What does module X do?" | `modules/X/README.md` | `modules/X/DOMAIN.md`, `modules/X/FLOWS.md` |
| "Which flows use entity Y?" | `routes/by-entity.md` | `modules/<module>/FLOWS.md` |
| "What pages show entity Y?" | `routes/by-entity.md` | `modules/<module>/PAGES.md` |
| "What are the security roles?" | `app/SECURITY.md` | `routes/by-page.md` |
| "How do modules depend on each other?" | `routes/cross-module.md` | `app/CALL_GRAPH.md` |
| "What is the app about?" | `app/APP_OVERVIEW.md` | `app/MODULE_LANDSCAPE.md` |
| "What scheduled events exist?" | `modules/<module>/RESOURCES.md` | Iterate all modules |
| "How should I build X?" | Relevant `modules/*/FLOWS.md` | Existing patterns, then recommend |
| "Interpret this user story" | `app/SECURITY.md` (roles) | `routes/by-entity.md`, `routes/by-flow.md` |

## Out-of-Scope Requests

If a user asks you to do any of the following, **decline and explain**:

- **"Regenerate the KB"** → Tell them to re-run the KnowledgeBase Creator pipeline.
- **"Run the dump/parser/scaffold"** → This is handled by the pipeline, not by agents.
- **"Open/modify the .mpr file"** → Agents cannot access Mendix Studio Pro or model files.
- **"Update the KB files"** → The KB is read-only. A new pipeline run is needed.
- **"Connect to an API / database"** → Agents only read local KB markdown files.

## Definition of Done

A query is fully answered when:

1. The answer is supported by specific KB file references.
2. All relevant cross-references have been checked.
3. Any gaps or incomplete sections have been noted.
4. The answer is clear, concise, and actionable.
5. No information was fabricated beyond what the KB contains.
