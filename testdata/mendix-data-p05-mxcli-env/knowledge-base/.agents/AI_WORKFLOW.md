# AI_WORKFLOW
## Standard Execution Flow for Knowledge Base Interpretation

Use this file with `.agents/AGENTS.md`.

## Scope Reminder

This workflow is for reading and interpreting a pre-built knowledge base. The one controlled exception is `/enrichkb`, which may enrich this KB in place by reading the linked app-overview run folder from `_sources/creator-link.json`. `/initkb` remains a compatibility entry point and should behave the same when no rebuild is needed. Neither command may rerun pipelines or access Mendix tooling.

`/develop` is another controlled exception: it may create implementation plan files in the `_plans/` folder at KB root. It does not modify any existing KB content.

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
| "How does feature X work?" | `routes/by-flow.md`, `routes/by-entity.md` (keyword search) | `modules/<module>/README.md`, `INTERPRETATION.md` → KB Feature Interpreter |
| "What features does this app have?" | `app/APP_OVERVIEW.md`, `app/MODULE_LANDSCAPE.md` | `modules/*/README.md` Capability Maps → KB Feature Interpreter |
| "Trace flow X" / "What happens when X runs?" | `routes/by-flow.md` (locate flow) | L1 overview → `flow-chain-tracing` skill → KB Flow Tracer |
| "What is affected if I change X?" | `routes/by-flow.md` or `routes/by-entity.md` | `impact-analysis` skill → KB Analyst |
| "Explain the X process" | `routes/by-flow.md` (keyword search) | L0/L1 overviews, `INTERPRETATION.md` → KB Feature Interpreter |
| "Implement this user story" / `/develop` | `.agents/agents/DEVELOPMENT_TEAM.md` | Full 7-phase orchestrated workflow |

## Feature-Level Query Workflow

When a user asks about a business feature or capability:

1. Route to **KB Feature Interpreter**.
2. The interpreter invokes the `feature-search` skill to locate candidate KB files from keywords.
3. It reads app-level context (`APP_OVERVIEW.md`, `MODULE_LANDSCAPE.md`).
4. It reads module-level context (`README.md` Capability Maps, `INTERPRETATION.md` narratives).
5. It reads flow-level detail (L0 abstracts for triage, L1 overviews for top matches).
6. If the feature involves a multi-step process, it invokes `flow-chain-tracing` to build the chain.
7. It synthesises a Feature Report with modules, entities, flows, pages, and gaps.

## Flow Tracing Query Workflow

When a user asks to trace or follow a specific flow:

1. Route to **KB Flow Tracer**.
2. The tracer locates the flow in `routes/by-flow.md`.
3. It invokes the `flow-chain-tracing` skill to build the complete call tree.
4. It adds entry context (who calls this flow?).
5. It cross-references entities (`routes/by-entity.md`) and pages (`routes/by-page.md`).
6. It annotates module boundaries, security implications, and data flow patterns.
7. If the user also asks "what if I change this?", it invokes the `impact-analysis` skill.

## Impact Analysis Query Workflow

When a user asks about the blast radius of a change:

1. Route to **KB Analyst**.
2. The analyst identifies the target artefact type (flow, entity, or page).
3. It invokes the `impact-analysis` skill with the appropriate procedure.
4. It cross-references `routes/cross-module.md` and `app/SECURITY.md`.
5. It rates the blast radius (Small / Medium / Large) and synthesises recommendations.

## Development Workflow (`/develop`)

When a developer provides a user story or feature request:

1. Route to **Development Team**.
2. Phase 1 — **Intake**: Development Team delegates to **User Story Interpreter** to parse and map the story. Asks clarifying questions about where to develop.
3. Phase 2 — **Investigation**: Delegates to **KB Feature Interpreter** (with `feature-search`) and optionally **KB Flow Tracer** (with `flow-chain-tracing`) and **KB Analyst** to find related elements.
4. Phase 3 — **High-Level Solution**: Delegates to **Mendix Developer** for a conceptual, functional solution. Flags high-impact flows. Iterates with developer.
5. Phase 4 — **Detailed Solution**: Delegates to **Mendix Developer** and **Planner** for a structured conceptual design. Optionally consults **Best Practice Recommender**.
6. Phase 5 — **Impact Analysis**: Delegates to **KB Analyst** (with `impact-analysis`) for full blast radius assessment.
7. Phase 6 — **Security Review**: Delegates to **KB Security Reviewer** for access rules, role assignments, and XPath constraints.
8. Phase 7 — **Implementation Plan**: Delegates to **Todo Maker** for single-artifact task breakdown. Saves to `_plans/STORY_<slug>.md`.

Each phase has an approval gate. The developer must confirm before the next phase begins. For small-scope stories, phases 3+4 and 5+6 may be bundled.

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
