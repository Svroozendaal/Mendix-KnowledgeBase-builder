# PROMPT 10: Create the KB Content Enrichment Agent

## Priority

High â€” this is the agent that makes the KB genuinely useful for AI consumers, adding the reasoning layer that deterministic scripts cannot provide.

## Context

Read before starting:

1. `.agents/AGENTS.md` and `.agents/FRAMEWORK.md`
2. `.app-info/product-plan/01-END_STATE_KB_SPEC.md` â€” AI consumption strategy and content density contract.
3. `.app-info/product-plan/02-CONTENT_MODEL_CUSTOM_DEPTH.md` â€” behaviour-first narrative template.
4. Prompt 08 (`AGENTS_POST_COMPOSITION_ROLE.md`) â€” must be completed first or at least understood for role separation.
5. `.app-info/agents/OVERVIEW_KB_BUILDER.md` â€” current builder agent (to be refactored/replaced).

## Problem Statement

After the deterministic composer runs, the KB is structurally complete but semantically shallow. Tables are accurate, cross-references work, and required headings are present. But:

1. The mission summary is generic ("centres on custom modules").
2. Module purpose descriptions repeat the same 3 phrases for all modules.
3. XPath plain-language translations are mechanical substitutions.
4. Role names (FBG, Parent) are unexplained.
5. Flow intent lines are derived from code patterns, not business meaning.
6. Anomalies (orphan entities, unsecured pages, naming typos) go unflagged.
7. Non-custom modules have no dependency-relevance context for custom modules.

An AI consumer reading this KB can navigate the structure but cannot understand the domain â€” it knows SmartExpenses has a `Transaction` entity with 7 attributes but doesn't know that transactions track family income and expenditure.

**The enrichment agent bridges this gap.** It reads the composer output plus the raw JSON source data and applies domain reasoning to produce genuinely useful content.

## Entry Criteria

1. The deterministic composer has run and produced a KB that passes the quality gate.
2. The source JSON export is available in the run folder.
3. The product plan has been read for content expectations.

## Deliverable

A new agent file: `.app-info/agents/OVERVIEW_KB_ENRICHER.md`

This agent is called by `KNOWLEDGEBASE_CREATOR` after the composer and quality gate steps. It receives the KB root path and the source run folder path.

## Agent Specification

### Role

Improve the semantic quality of a deterministically-generated KB by adding domain reasoning, business context, and anomaly detection that cannot be computed mechanically.

### Required Inputs

1. `.agents/AGENTS.md` and `.agents/FRAMEWORK.md`
2. `.app-info/skills/mendix-overview-general-interpretation/SKILL.md` (updated per Prompt 09)
3. `.app-info/skills/mendix-overview-module-interpretation/SKILL.md` (updated per Prompt 09)
4. `.app-info/skills/mendix-overview-routing-synthesis/SKILL.md` (updated per Prompt 09)
5. `<kb-root>/` â€” the composer-generated KB
6. `<run-folder>/` â€” the raw JSON export
7. `KnowledgeBase-Creator/wizard/run-kb-quality-gate.ps1` â€” for validation after enrichment

### Core Workflow

#### Phase 1: Read and Understand

1. Read `<kb-root>/READER.md` and `<kb-root>/ROUTING.md` to understand the KB structure.
2. Read `<run-folder>/general/all-modules.json` to identify custom, marketplace, and system modules.
3. Read `<run-folder>/general/user-roles.json` to understand security model.
4. For each custom module, read:
   - `<run-folder>/modules/<Module>/domain-model.json` â€” entity names, attributes, associations, access rules.
   - `<run-folder>/modules/<Module>/flows.json` â€” flow names, pseudocode, annotations, node details.
   - `<run-folder>/modules/<Module>/pages.json` â€” page titles (often in the app's language), parameters, roles.
   - `<run-folder>/modules/<Module>/resources.json` â€” constants with default values, scheduled events.

#### Phase 2: Domain Inference

Before writing any changes, build a mental model of the application domain:

1. **App purpose**: What does this app do? Infer from:
   - Custom entity names (Transaction, Balance, BudgetType, FBGProfile â†’ personal finance / budget management).
   - Flow prefixes and names (ACT_Transaction_NewEdit_Save, ACT_BudgetType_Save â†’ CRUD operations on financial entities).
   - Page titles (especially non-English titles which reveal the target audience's language).
   - Role names (FBG = Family Budget Guardian, Parent = parental observer role).
   - Constants (REST URLs, configuration values).

2. **Module purposes**: What does each module do? Infer from:
   - Its entity set and naming patterns.
   - Its flow prefixes and call targets.
   - Its cross-module dependencies (what it calls, what calls it).
   - Known marketplace modules (ExcelImporter, Administration, etc.).

3. **Role semantics**: What does each role mean? Infer from:
   - Module role assignments (which modules each user role has access to).
   - Entity access rules (which entities each role can create/read/update/delete).
   - Page permissions (which pages each role can see).
   - XPath constraints (what data scoping each role has).

4. **Anomalies**: What looks suspicious? Check for:
   - Entities with 0 access rules.
   - Pages with empty allowed roles.
   - Naming typos in flow or entity names.
   - Orphan entities not referenced by any flow.
   - Modules with null category.
   - Test/debug artefacts (entities named "New_entity", pages named "datagid").

#### Phase 3: Enrich App-Level Content

Modify these files in-place, preserving all existing headings and tables:

##### `app/APP_OVERVIEW.md` â€” Mission Summary

Replace the generic mission summary with a domain-specific 2-3 sentence description. Include:
- What the app does (e.g. "family budget management").
- Who uses it (e.g. "FBG users and parent observers").
- What the core capabilities are (e.g. "transaction tracking, budget configuration, balance monitoring").

Mark the enriched summary as `Confidence: Inferred (AI-enriched from entity/flow/page naming patterns)`.

##### `app/MODULE_LANDSCAPE.md` â€” Module Purpose Descriptions

Replace generic "Implements app-specific behaviour" / "Support capability from marketplace" strings with module-specific descriptions. For well-known marketplace modules (Administration, ExcelImporter, MxModelReflection, etc.), use standard descriptions. For custom modules, infer from entity/flow naming.

##### `app/SECURITY.md` â€” XPath Plain Language and Role Descriptions

1. Replace mechanical XPath substitutions with genuine plain-language explanations that describe the business meaning.
2. Add a `## Role Descriptions` section (or enhance the existing role matrix) with 1-2 sentence descriptions of each user role's business purpose.

#### Phase 4: Enrich Module-Level Content

For each **custom** module:

##### `modules/<Module>/README.md` â€” Purpose Section

Replace the generic purpose text with a domain-specific description. Example for SmartExpenses: "Core application module for family budget management. Handles budget profiles (FBGProfile), budget categories (BudgetType) and terms (BudgetTerm), financial transactions (Transaction), and account balances (Balance)."

##### `modules/<Module>/FLOWS.md` â€” Tier 1 Intent Lines

Review each Tier 1 narrative's intent line. If the intent is still mechanical ("Creates a BudgetType entity"), enrich it with domain context ("Creates a new budget category for a family profile, such as groceries or utilities"). Only improve intents where the domain meaning is reasonably clear from naming patterns.

For **non-custom** modules, add a "Custom-Module Relevance" note to `README.md` if cross-module dependencies exist.

#### Phase 5: Flag Anomalies

Add a `## Anomalies and Observations` section to `ROUTING.md` (or a separate `_reports/enrichment-notes.md`):

1. List all detected anomalies with severity (Info, Warning, Concern).
2. Include the file and location where the anomaly was found.
3. Do not remove or change anomalous data â€” only flag it.

#### Phase 6: Validate

After all enrichments:

1. Run the quality gate:
   ```powershell
   .\KnowledgeBase-Creator\run-kb-quality-gate.ps1 -OutputRoot mendix-data/knowledge-base -AppName <app-name>
   ```
2. Run the semantic benchmark:
   ```powershell
   .\KnowledgeBase-Creator\run-kb-semantic-benchmark.ps1 -KBRoot <kb-root> -AppName <app-name>
   ```
3. If either fails, identify which enrichment caused the failure and revert or fix it.

### Guardrails

1. **Never remove content** â€” only add or replace text within existing sections.
2. **Never change table structure** â€” only modify cell content or add new rows/sections.
3. **Never remove required headings** â€” the quality gate depends on them.
4. **Preserve deterministic content** â€” tables, metrics, and cross-references from the composer must not be altered.
5. **Mark enriched content** â€” use `Confidence: Inferred (AI-enriched)` or similar markers to distinguish AI additions from export-backed facts.
6. **Be conservative** â€” only make claims that are clearly supported by naming patterns and structural evidence. When unsure, use "likely" or "appears to" qualifiers.
7. **Preserve the original language** â€” if page titles or enum values are in Dutch (or any other language), keep them. Add English translations in parentheses if helpful.
8. **Run validation after every file change** â€” do not batch all changes and validate at the end.

### Output Template

```markdown
## KB Enrichment Report - [AppName]

KB root: [path]
Source: [run folder]

Enrichments applied:
1. Mission summary: [rewritten / no change needed]
2. Module purposes: [n modules updated]
3. XPath translations: [n constraints translated]
4. Role descriptions: [n roles described]
5. Flow intent improvements: [n flows improved]
6. Anomalies flagged: [n items]

Validation:
- Quality gate: [pass/fail]
- Semantic benchmark: [score]

Confidence notes:
- All enriched content is marked as Inferred (AI-enriched).
- Export-backed content is preserved unchanged.
```

## Acceptance Criteria

1. `OVERVIEW_KB_ENRICHER.md` exists with the complete specification above.
2. The agent follows the six-phase workflow (Read â†’ Infer â†’ Enrich App â†’ Enrich Modules â†’ Flag â†’ Validate).
3. Guardrails prevent destructive changes to composer output.
4. The agent is callable from `KNOWLEDGEBASE_CREATOR.md` as a post-composition step.
5. The output template enables tracking of what was enriched.
6. Quality gate passes after enrichment.
7. Benchmark score does not decrease.

## Verification Steps

After creating the agent file:

1. Read the agent file and verify it covers all six enrichment tasks.
2. Execute the enricher agent manually on the SmartExpenses KB.
3. Verify that APP_OVERVIEW.md now has a domain-specific mission summary.
4. Verify that SECURITY.md has genuine plain-language XPath translations.
5. Verify that at least one module README.md has an improved purpose description.
6. Verify that anomalies are flagged (e.g. SmartExpenses.New_entity with 0 access rules).
7. Verify quality gate passes.
8. Verify benchmark score >= 85.

## Exit Criteria

1. Agent file created and complete.
2. Agent integrated into KNOWLEDGEBASE_CREATOR workflow.
3. Successfully enriches the SmartExpenses KB with measurable improvements.
4. Quality gate passes after enrichment.
5. Benchmark score >= 85.

## Estimated Scope

New agent file (~200-250 lines) plus integration update to KNOWLEDGEBASE_CREATOR.md (~10 lines).

