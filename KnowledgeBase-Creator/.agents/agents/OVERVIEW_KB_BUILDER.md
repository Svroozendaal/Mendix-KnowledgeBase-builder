# OVERVIEW_KB_BUILDER
## Role

Enrich the composed knowledge base with semantic narratives, business logic explanations, and domain stories.

## Context

By the time this agent runs, the pipeline has already filled all KB markdown files with export-backed data: entity tables, flow catalogues, page inventories, security matrices, and cross-reference indexes. This agent adds the **human-readable layer** that makes the KB genuinely useful.

For module documents, the pipeline now also writes deterministic pointer/evidence blocks. Treat those blocks as read-only. Add AI interpretation only in the reserved interpretation sections.

## Required Skills

1. `mendix-overview-general-interpretation` - app-level enrichment
2. `mendix-overview-module-interpretation` - per-module enrichment
3. `mendix-overview-routing-synthesis` - route validation and enrichment

## Inputs

1. Composed KB files at `mendix-data/knowledge-base/`
2. Source pseudo.txt files at `mendix-data/app-overview/<run-folder>/`
3. Unknown TODO report at `mendix-data/knowledge-base/_reports/UNKNOWN_TODO.md`

## Enrichment Procedure

### Step 1: Build understanding

Read the source pseudo.txt files to understand what the app actually does:
- `general/app-info.pseudo.txt` - app metadata
- `general/user-roles.pseudo.txt` - who uses this app
- For each custom module: `modules/<Name>/domain-model.pseudo.txt`, `flows.pseudo.txt`, `pages.pseudo.txt`

From entity names, flow names, page names, and their relationships, infer:
- What business domain does this app serve?
- What are the key business objects?
- What workflows exist?
- Who are the users and what can they do?

### Step 2: Enrich app-level docs

Read and enhance these files (use skill `mendix-overview-general-interpretation`):

**`app/APP_OVERVIEW.md`**
- Rewrite the Mission Summary with a specific, meaningful description of what the app does.
- Example: Instead of "The application centres on the custom modules X, Y", write "This is a training management application that allows administrators to create courses and training events, teachers to manage their sessions, and trainees to register for and track their training."

**`app/MODULE_LANDSCAPE.md`**
- Add a paragraph explaining why each custom module exists and how they relate to each other.

**`app/SECURITY.md`**
- Add plain-language explanation of what each role can do and why.

**`app/CALL_GRAPH.md`**
- Add architecture narrative explaining cross-module data flow, if applicable.

### Step 3: Enrich custom module docs

For each **custom** module (skip marketplace/system modules), use skill `mendix-overview-module-interpretation`:

**`modules/<Name>/README.md`**
- Replace "Unknown: product-owner intent text is not included in export" with a clear purpose statement inferred from the module's entities, flows, and pages.
- Add a "What this module does" paragraph under `## Interpretation`.

**`modules/<Name>/DOMAIN.md`**
- Add an "Entity Relationships" narrative section under `## Domain Interpretation` explaining what the domain model represents in business terms.
- Example: "Course is the central entity representing a training offering. Each Course can have multiple TrainingEvents (scheduled sessions). Trainees register via the Registration entity, which links a Trainee to a specific TrainingEvent."

**`modules/<Name>/FLOWS.md`**
- Under `## Flow Interpretation`, enhance Tier 1 flow narratives with:
  - Business intent (why does this flow exist?)
  - What triggers it (user action, scheduled event, another flow?)
  - What business rule does it enforce?

**`modules/<Name>/PAGES.md`**
- Under `## Page Interpretation`, add user journey context: what is the user trying to accomplish on each page?

### Step 4: Resolve unknowns

Read `_reports/UNKNOWN_TODO.md`. For each item:
- Cross-reference with source pseudo.txt data
- If resolvable, update the relevant KB file
- If not resolvable, leave the Unknown marker with a note explaining why

### Step 5: Validate routes

Use skill `mendix-overview-routing-synthesis`:
- Verify all relative links in `ROUTING.md` and `routes/*.md` still resolve
- Verify completeness stats in `ROUTING.md` are accurate after enrichment

## Guardrails

1. **Never remove export-backed data.** Only add narrative around it.
2. **Never change deterministic pointer/evidence blocks, table structures, headings, anchors, or link targets.** The quality gate checks these.
3. **Mark AI-added content as `Confidence: Inferred`.** Keep this distinct from `Export-backed`.
4. **Keep all relative links valid.**
5. **Be specific.** Infer business meaning from naming patterns (e.g., `ACT_Course_Create` means "user action to create a course").
6. **Cite your reasoning.** When inferring purpose, say "Inferred from entity names and flow patterns" rather than stating it as fact.
7. **Prioritise custom modules.** Marketplace modules rarely need enrichment.
