# PROMPT 08: Redefine Agent Roles for Post-Composition Enrichment

## Priority

High — agents currently describe a write-from-scratch workflow that conflicts with the deterministic composer.

## Context

Read before starting:

1. `.agents/AGENTS.md` and `.agents/FRAMEWORK.md`
2. `.app-info/product-plan/03-TOOLCHAIN_ARCHITECTURE.md` — pipeline architecture showing composer as step 5.
3. `.app-info/product-plan/02-CONTENT_MODEL_CUSTOM_DEPTH.md` — behaviour-first content expectations.
4. `.app-info/product-plan/01-END_STATE_KB_SPEC.md` — AI consumption strategy section.

Current agent files to modify:

5. `.app-info/agents/KNOWLEDGEBASE_CREATOR.md` — orchestrator agent.
6. `.app-info/agents/OVERVIEW_KB_BUILDER.md` — builder agent.
7. `.app-info/agents/OVERVIEW_KB_READER.md` — reader agent.
8. `KnowledgeBase-Creator/.agents/agents/KNOWLEDGEBASE_CREATOR.md` — portable package orchestrator.
9. `KnowledgeBase-Creator/.agents/agents/OVERVIEW_KB_BUILDER.md` — portable package builder.
10. `KnowledgeBase-Creator/.agents/AI_WORKFLOW.md` — portable package workflow.
11. `KnowledgeBase-Creator/.agents/AGENTS.md` — portable package agent roster.

## Problem Statement

The pipeline has two layers of KB generation:

1. **Deterministic layer** (`run-kb-compose.ps1`): generates all KB markdown files from JSON exports using regex pattern matching and structured rendering. This produces correct-but-mechanical output — accurate tables, deterministic tier assignments, entity lifecycle matrices, pseudocode inclusion.

2. **AI enrichment layer** (agents): should add the reasoning, interpretation, and domain insight that a deterministic script cannot produce. This includes mission summaries, purpose descriptions, XPath plain-language translation, anomaly detection, and quality narrative improvement.

**Current state**: both layers describe the same "write all KB content" workflow. The agents don't know the composer exists. They don't reference the product plan's content expectations. They contain output templates that conflict with the composer's actual output format. The portable package agents (`KnowledgeBase-Creator/.agents/`) are thin stubs that duplicate the `.app-info/agents/` versions without clear role separation.

**Target state**: the agents operate as a **post-composition enrichment** pipeline. The composer runs first (deterministic, fast, repeatable). Then the AI agents review and enhance the composer output — adding domain reasoning, improving narratives, translating technical content to plain language, and flagging gaps.

## Entry Criteria

1. All agent files listed above exist and have been read.
2. The composer (`run-kb-compose.ps1`) exists and produces output.
3. The product plan exists with content expectations defined.

## Acceptance Criteria

1. `KNOWLEDGEBASE_CREATOR.md` describes a workflow where the composer runs first and the AI enriches after.
2. `OVERVIEW_KB_BUILDER.md` is reframed as `OVERVIEW_KB_ENRICHER` (or renamed) — its role is to improve composer output, not generate from scratch.
3. A new `OVERVIEW_KB_ENRICHER.md` agent is created (if renaming is preferred over modifying the builder).
4. The workflow clearly separates deterministic steps (scripts) from AI enrichment steps (agents).
5. The portable package agents stay lightweight but correctly reference the enrichment workflow.
6. `OVERVIEW_KB_READER.md` is updated to reference the enriched KB content and the new consumption patterns from the product plan.
7. `AI_WORKFLOW.md` is updated to reflect the two-layer pipeline.

## Scope

### What the AI Enrichment Agent Should Do

These are tasks that require reasoning and cannot be done deterministically by the composer:

#### 1. Mission Summary Enrichment (APP_OVERVIEW.md)

The composer writes: "The application centres on the custom modules ImporterHelper, New_Module, SmartExpenses and orchestrates data and UI behaviour through model-driven flows and pages."

The AI should rewrite this to: "SmartExpenses is a family budget management application that tracks income and expenditure transactions, manages budget types and terms, and provides profile-based financial oversight for FBG (Family Budget Guardian) users and their associated parent accounts."

**How**: the AI reads entity names (Transaction, Balance, BudgetType, BudgetTerm, FBGProfile), flow names (ACT_Transaction_NewEdit_Save, ACT_BudgetType_Save), page titles (in Dutch: "Nieuwe transactie", "Overzicht van alle saldo's"), and role names (FBG, Parent) to infer the domain purpose.

#### 2. XPath Plain-Language Translation (SECURITY.md)

The composer writes mechanical substitutions. The AI should translate:

- `[SmartExpenses.Balance_FBGProfile/SmartExpenses.FBGProfile/SmartExpenses.FBGProfile_Account_Parent='current user']`
- Into: "Parent role can only access Balance records linked to an FBG Profile where the Parent account is the current user — i.e. parents can only see their own family's balances."

**How**: the AI reads the association chain, understands the entity relationships, and produces a business-meaningful explanation.

#### 3. Module Purpose Descriptions (MODULE_LANDSCAPE.md, per-module README.md)

The composer writes generic "Implements app-specific behaviour" for all custom modules. The AI should write:

- SmartExpenses: "Core application module managing family budget profiles, transaction tracking, balance calculations, and budget type/term configuration."
- ImporterHelper: "Data import module that accepts external transaction data via Excel files and REST endpoints, then delegates to SmartExpenses for processing."
- New_Module: "Development/test module with minimal entity structure. Appears to be a sandbox for testing domain model patterns."

**How**: the AI reads entity names, flow prefixes, page titles, and cross-module calls to infer module purpose.

#### 4. Anomaly and Risk Flagging

The composer does not flag suspicious patterns. The AI should identify and note:

- Entities with 0 access rules (potential security gap): `SmartExpenses.New_entity`.
- Pages with no allowed roles: `SmartExpenses.datagid` (likely a debug page).
- Flows with unexpectedly empty entity evidence despite high node counts.
- Naming typos in the source model: `ACT_BudgetType_OpenOverviewPAge` (capital A in Page).
- Orphan entities (no flows create/read/update/delete them).
- Modules with null category: `Unknown` module.

**How**: the AI scans the composer output and the source JSON for anomalous patterns.

#### 5. Flow Narrative Quality Improvement

Even after Prompt 01 integrates pseudocode, the intent lines and trigger descriptions can be improved by AI reasoning. The composer generates mechanical summaries; the AI can add domain context:

- Composer: "Creates a BudgetType entity and associates it with FBGProfile."
- AI enrichment: "Sets up a new budget category (e.g. groceries, utilities) for a family profile, linking it to the profile's budget structure and initialising default budget terms."

**How**: the AI reads the pseudocode, variable names, entity attributes, and enumeration values to infer business meaning.

#### 6. Role Semantic Descriptions (SECURITY.md)

The composer lists roles but doesn't explain what they mean in business terms. The AI should add:

- Administrator: "Full system access. Can manage all users, budgets, and transactions."
- FBG (Family Budget Guardian): "Primary user role. Manages their own family's budget profiles, transactions, and balances."
- Parent: "Read-only observer role. Can view balances and transactions for their family but cannot create or modify records."
- Anonymous: "Unauthenticated guest access. Limited to login and registration pages."

**How**: the AI reads module role mappings, entity access rules, and page permissions to infer role purposes.

### Specific File Changes

#### `.app-info/agents/KNOWLEDGEBASE_CREATOR.md`

Update the Core Workflow to:

```markdown
### Step 1: Run Deterministic Pipeline
Run the full pipeline (or partial re-run):
```powershell
.\KnowledgeBase-Creator\run-dump-parser.ps1 [-SkipDump] [-SkipParser] [-RunFolder <path>]
```
This produces structurally complete KB output with deterministic content.

### Step 2: Validate Pipeline Output
Check that quality gate and benchmark pass. If not, fix composer issues before enrichment.

### Step 3: Delegate AI Enrichment
Read and follow `.app-info/agents/OVERVIEW_KB_ENRICHER.md`. The enricher will:
1. Improve mission summary and module purpose descriptions.
2. Translate XPath constraints to genuine plain language.
3. Add role semantic descriptions.
4. Improve flow narrative intent lines.
5. Flag anomalies and suspicious patterns.

### Step 4: Re-Validate
Run quality gate and benchmark again after enrichment to confirm no regressions.

### Step 5: Report
Output completion report with enrichment notes.
```

#### `.app-info/agents/OVERVIEW_KB_BUILDER.md` → Rename or repurpose

Option A (recommended): Rename to `OVERVIEW_KB_ENRICHER.md` and rewrite with enrichment-focused workflow.
Option B: Keep the builder agent for backwards compatibility and add a new enricher agent that runs after it.

The enricher agent should:
1. Read the composer-generated KB output.
2. Read the source JSON for additional context (pseudocode, annotations, entity details).
3. Apply each enrichment task (mission summary, XPath, purposes, anomalies, narratives, roles).
4. Write improvements in-place to the existing KB files.
5. Preserve all required headings and structural contracts.
6. Run quality gate after each enrichment pass.

#### `KnowledgeBase-Creator/.agents/` (portable package)

Keep these lightweight but update them to:
1. Reference the composer as the primary generation step.
2. Describe the AI enrichment as an optional second pass.
3. Remove output templates that conflict with the composer's actual output format.
4. Update `AI_WORKFLOW.md` to show the two-layer pipeline.

#### `.app-info/agents/OVERVIEW_KB_READER.md`

Update to reference:
1. The enriched content (domain-specific mission summaries, plain-language XPath, role descriptions).
2. The AI consumption patterns from `01-END_STATE_KB_SPEC.md`.
3. The confidence semantics (export-backed vs inferred vs AI-enriched as a new tier).

### What NOT to Change

1. Do not change the composer script in this prompt (that's Prompts 01-05).
2. Do not change the quality gate or benchmark scripts.
3. Do not remove existing agent capabilities — only add and refocus.
4. Do not change the `.agents/` (repo-root generic framework) agent files — only the `.app-info/` and `KnowledgeBase-Creator/.agents/` app-specific ones.

## Verification Steps

After implementing:

1. Read the updated `KNOWLEDGEBASE_CREATOR.md` workflow — it should describe composer-first, enrichment-second.
2. Read the new/updated enricher agent — it should describe all six enrichment tasks with clear inputs, outputs, and guardrails.
3. Read the updated `AI_WORKFLOW.md` — it should show the two-layer pipeline.
4. Run the full pipeline and then manually execute the enricher agent on the SmartExpenses KB.
5. Verify that the enricher improves:
   - APP_OVERVIEW.md mission summary.
   - SECURITY.md XPath plain-language translations.
   - At least one module README.md purpose description.
6. Verify quality gate still passes after enrichment.
7. Verify benchmark score does not decrease.

## Exit Criteria

1. Agent files describe the correct two-layer pipeline (composer + enrichment).
2. Enricher agent exists with clear enrichment task definitions.
3. No conflicts between agent instructions and composer output.
4. Reader agent references enriched content.
5. Portable package agents are updated and lightweight.
6. Quality gate passes after enrichment run.

## Estimated Scope

Major documentation rewrite across 7 files:

- `KNOWLEDGEBASE_CREATOR.md`: rewrite Core Workflow (~50 lines changed).
- `OVERVIEW_KB_ENRICHER.md`: new file (~150-200 lines).
- `OVERVIEW_KB_READER.md`: minor updates (~20 lines changed).
- `KnowledgeBase-Creator/.agents/`: update 4 files (~30 lines each).
