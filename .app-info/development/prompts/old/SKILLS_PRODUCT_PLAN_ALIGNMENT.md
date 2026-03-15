# PROMPT 09: Align Skills with Product Plan Knowledge

## Priority

High — skills are the detailed instruction sets agents follow. Without product plan alignment, agents can't produce quality-compliant output.

## Context

Read before starting:

1. `.agents/AGENTS.md` and `.agents/FRAMEWORK.md`
2. `.app-info/product-plan/01-END_STATE_KB_SPEC.md` — content density contract.
3. `.app-info/product-plan/02-CONTENT_MODEL_CUSTOM_DEPTH.md` — tiered flow model, entity lifecycle model, confidence semantics.
4. `.app-info/product-plan/06-ROUTING_AND_INDEX_SPEC.md` — routing synthesis rules.

Current skill files to modify:

5. `.app-info/skills/mendix-overview-general-interpretation/SKILL.md`
6. `.app-info/skills/mendix-overview-module-interpretation/SKILL.md`
7. `.app-info/skills/mendix-overview-routing-synthesis/SKILL.md`
8. `KnowledgeBase-Creator/.agents/skills/mendix-overview-general-interpretation/SKILL.md`
9. `KnowledgeBase-Creator/.agents/skills/mendix-overview-module-interpretation/SKILL.md`
10. `KnowledgeBase-Creator/.agents/skills/mendix-overview-routing-synthesis/SKILL.md`

## Problem Statement

The three interpretation skills contain output templates and guardrails that were written before the product plan. They are missing critical knowledge that the product plan defines:

### What skills are missing

#### `mendix-overview-general-interpretation`

1. **No reference to the behaviour-first narrative template** (02-CONTENT_MODEL_CUSTOM_DEPTH.md).
2. **APP_OVERVIEW.md template** specifies an `## Identity` + `## Summary` + `## Security` structure — but the composer produces `## Mission Summary` + `## Core Business Capabilities` + `## Top Behavioural Entry Points`. The skill template conflicts with what the composer actually generates.
3. **MODULE_LANDSCAPE.md template** specifies separate Custom/Marketplace tables — but the composer produces a single `## Module Categories` table with a Category column. The skill template conflicts.
4. **SECURITY.md template** doesn't mention the entity lifecycle or role semantic enrichment that the product plan expects.
5. **CALL_GRAPH.md template** specifies a full dependency matrix and fan-in/fan-out tables — but the composer produces a simpler structure. The skill template partially conflicts.
6. **No mention of confidence semantics** (`Export-backed`, `Inferred`, `Unknown`) beyond a brief note.
7. **No reference to the quality gate thresholds** or the semantic benchmark.

#### `mendix-overview-module-interpretation`

1. **No tiered flow model** — the skill doesn't know about Tier 1/2/3 classification or that Tier 1 flows require deep narratives.
2. **No entity lifecycle matrix** — the skill doesn't describe the CRUD lifecycle mapping that the product plan requires.
3. **No pseudocode field** — the skill doesn't mention using the `pseudocode` field from flow JSON.
4. **No annotation nodes** — the skill doesn't mention extracting developer annotations.
5. **No generalisation chains** — the skill doesn't mention entity inheritance.
6. **DOMAIN.md template** specifies per-entity sections — but the composer produces tables. The template conflicts.
7. **FLOWS.md template** specifies a flat catalogue — but the composer produces prefix-grouped tables + Tier 1 narratives. The template conflicts.
8. **No custom vs non-custom depth rules** — the skill applies the same depth to all modules.
9. **No mention of `defaultValue` for constants** — the skill template shows it but the guardrails don't enforce it.

#### `mendix-overview-routing-synthesis`

1. **ROUTING.md template** specifies a different structure from what the composer produces (no quick-lookup table with question types, no completeness section with metrics).
2. **by-entity.md** doesn't mention the entity lifecycle columns (Create/Read/Update/Delete flows).
3. **by-flow.md** doesn't mention the Tier column or the distinction between custom and non-custom flow evidence requirements.
4. **cross-module.md** doesn't mention hub/leaf classification or the custom-boundary dependency lens.
5. **No reference to the determinism rules** from the product plan.
6. **No unknowns policy** — the skill doesn't distinguish acceptable vs unacceptable unknowns.

## Acceptance Criteria

1. All three `.app-info/skills/` files are updated to align with the product plan specs.
2. Output templates match what the composer actually produces (not a conflicting structure).
3. Tiered flow model, entity lifecycle, pseudocode, annotations, and generalisation are referenced in the module interpretation skill.
4. Confidence semantics (`Export-backed`, `Inferred`, `Unknown`) are clearly defined with the unknowns policy from the product plan.
5. Custom vs non-custom module depth rules are explicitly stated.
6. Quality gate thresholds and semantic benchmark requirements are referenced.
7. The skills clearly distinguish between deterministic composer output (what the script produces) and AI enrichment opportunities (what the agent should improve).
8. Portable package skills are updated as lightweight versions pointing to the product plan.

## Scope

### Specific Changes per Skill

#### `mendix-overview-general-interpretation/SKILL.md`

1. **Update output templates** to match the composer's actual output structure:
   - APP_OVERVIEW.md: `## Mission Summary` + `## Core Business Capabilities` (table) + `## Top Behavioural Entry Points` (table) + `## Source`.
   - MODULE_LANDSCAPE.md: `## Module Categories` (single table with Category column) + `## Custom Module Priority Ranking` (table) + `## Source`.
   - SECURITY.md: `## Role-to-Module-Role Matrix` (table) + `## Entity Access Summary` (table) + `## XPath Constraints (Plain Language)` (table) + `## Source`.
   - CALL_GRAPH.md: `## Cross-Module Dependency Table` + `## Custom Module Boundary` + `## Source`.

2. **Add AI enrichment responsibilities** (things the skill user should do beyond what the composer produces):
   - Write a domain-specific mission summary (not generic "centres on custom modules").
   - Add "Key observations" bullet points about the app's architecture.
   - Translate XPath constraints to genuine plain-language explanations.
   - Add role semantic descriptions (what does "FBG" mean? What can "Parent" do?).
   - Flag security anomalies (entities with 0 access rules, roles with unexpectedly broad access).

3. **Add confidence semantics section** referencing `02-CONTENT_MODEL_CUSTOM_DEPTH.md`.

4. **Add quality gate reference** — the output must pass `run-kb-quality-gate.ps1` thresholds.

#### `mendix-overview-module-interpretation/SKILL.md`

1. **Add tiered flow model section**:
   - Define Tier 1/2/3 rules from `02-CONTENT_MODEL_CUSTOM_DEPTH.md`.
   - Explain that the composer assigns tiers deterministically; the AI enricher should verify and improve narrative quality.
   - Tier 1 flows require deep narratives with pseudocode and intent descriptions.

2. **Add entity lifecycle matrix section**:
   - Define the CRUD lifecycle mapping from `02-CONTENT_MODEL_CUSTOM_DEPTH.md`.
   - Explain that the composer builds this from flow action evidence; the AI enricher should fill gaps.

3. **Add pseudocode and annotation sections**:
   - Explain that `flows.json` contains a `pseudocode` field per flow.
   - Explain that `Annotation` nodes contain developer-written intent descriptions.
   - Both should be used in flow narrative generation.

4. **Add entity generalisation section**:
   - Explain that `domain-model.json` entities have a `generalization` field.
   - Entities inheriting from `System.Image` or `System.FileDocument` should be flagged with inheritance notes.

5. **Add custom vs non-custom depth rules**:
   - Custom modules: deep behavioural extraction, tiered narratives, lifecycle matrices.
   - Non-custom modules: concise inventory, dependency relevance to custom modules, no Tier 1 narratives.

6. **Update output templates** to match the composer's actual output structure:
   - DOMAIN.md: entity summary table + entity lifecycle matrix + role impacts + associations + enumerations (not per-entity sections).
   - FLOWS.md: prefix-grouped catalogue tables + flow details table + Tier 1 deep narratives (not flat catalogue).
   - PAGES.md: page inventory table + page-flow links table + journey fragments table + snippets note.
   - RESOURCES.md: constants table (with defaultValue and exposedToClient) + scheduled events + other resources.
   - README.md: summary table + purpose + capability map + primary user journeys + risks/unknowns + navigation + cross-module dependencies + source.

7. **Add AI enrichment responsibilities**:
   - Write module purpose descriptions based on entity/flow/page naming patterns.
   - Improve Tier 1 flow intent lines beyond mechanical pseudocode summaries.
   - Flag anomalous patterns (empty entities, orphan pages, naming typos).
   - Add domain context to entity descriptions where inferable.

#### `mendix-overview-routing-synthesis/SKILL.md`

1. **Update output templates** to match the composer's actual output:
   - ROUTING.md: quick-lookup matrix + module index with complexity + completeness section with metrics + source.
   - by-entity.md: Entity | Module | Create flows | Update flows | Delete flows | Read flows | Shown on pages.
   - by-flow.md: Flow | Type | Module | Tier | Calls | Called by | Shows Pages | Touches Entities.
   - cross-module.md: flow-call edges table + hub/leaf classification + custom-boundary dependency lens.

2. **Add unknowns policy**:
   - Reference acceptable and unacceptable unknowns from `02-CONTENT_MODEL_CUSTOM_DEPTH.md`.
   - `Known gaps: none` is only valid when no derivable unknowns remain.

3. **Add determinism rules**:
   - Stable sorting, stable tie-breakers, no unstable timestamps in content body.

4. **Add quality gate threshold references**:
   - Metric A (page-flow linkage): >= 95%.
   - Metric B (flow entity touch): >= 90%.
   - Metric C (entity lifecycle): >= 90%.

### Portable Package Skills (`KnowledgeBase-Creator/.agents/skills/`)

Keep these as lightweight summaries (~20-30 lines each) that:
1. Reference the composer as the primary generation tool.
2. List the key fields and patterns to look for.
3. Note that the full product plan specs live in `.app-info/product-plan/`.
4. Match output templates to the composer's actual format.

### What NOT to Change

1. Do not change the composer script.
2. Do not change the quality gate or benchmark scripts.
3. Do not change the generic `.agents/skills/` framework skills (those are project-agnostic).
4. Do not remove existing skill capabilities — only add, align, and correct.

## Verification Steps

After implementing:

1. Read each updated skill and verify output templates match what the composer actually produces.
2. Verify that tiered flow model, entity lifecycle, pseudocode, annotations, and generalisation are referenced in the module interpretation skill.
3. Verify confidence semantics and unknowns policy are present in all three skills.
4. Verify custom vs non-custom depth rules are in the module interpretation skill.
5. Verify quality gate threshold references are in the routing synthesis skill.
6. Run the full pipeline and then execute the enricher agent using the updated skills. Verify that the agent produces higher-quality output than before.

## Exit Criteria

1. All six skill files updated (3 app-info + 3 portable package).
2. Output templates match the composer's actual output.
3. Product plan concepts (tiers, lifecycle, pseudocode, confidence semantics, unknowns policy) are integrated.
4. AI enrichment responsibilities are clearly separated from deterministic composer output.
5. No conflicts between skill instructions and composer behaviour.

## Estimated Scope

Major documentation rewrite:

- `.app-info/skills/`: 3 files, each ~150-250 lines (significant rewrites of output templates and guardrails).
- `KnowledgeBase-Creator/.agents/skills/`: 3 files, each ~30-40 lines (lightweight updates).
