# SKILL: Feature Search

## Purpose

Map natural language feature questions to relevant KB files. This skill translates business-level queries like "How does budget management work?" into a ranked set of KB file paths that together describe the feature.

## Used By

KB Feature Interpreter, KB Navigator, User Story Interpreter

## When to Use

- The user asks about a business feature, capability, or process by name.
- The user asks "what features does this app have?" or "how does X work?"
- An agent needs to locate which modules, flows, entities, and pages relate to a business concept.

## Procedure

1. **Extract keywords.** Parse the question and extract feature keywords. Strip common words (the, a, how, does, what). Keep nouns and domain verbs (e.g., "budget", "transaction", "import", "recalculate", "registration").

2. **Entity match.** Scan `routes/by-entity.md` entity names for keyword matches (case-insensitive substring). Record matching entities, their modules, and their CRUD flows.

3. **Flow match.** Scan `routes/by-flow.md` flow names for keyword substring matches. Record matching flows with their module, tier, and L0/L1 links. Prioritise Tier 1 flows over Tier 2/3.

4. **Module match.** Scan `app/MODULE_LANDSCAPE.md` module names and the "Why this module exists" column for keyword matches. Record matching modules.

5. **Capability match.** For each candidate module from steps 2-4, read `modules/<Module>/README.md` (or `modules/_marktplace/<Module>/README.md` for marketplace modules). Scan the Capability Map table for rows whose prefix or representative flow name matches a keyword. Scan the Primary User Journeys table for matching entry flows, UI results, or entities.

6. **Narrative match (if enriched).** For candidate modules, check whether `modules/<Module>/INTERPRETATION.md` contains enriched content (not just placeholder stubs). If enriched, scan the Module Purpose, Domain Narrative, Flow Narrative, and Page Narrative sections for keyword occurrences.

7. **Rank results.** Apply the following ranking:
   - Custom modules rank above marketplace and system modules.
   - Tier 1 flows rank above Tier 2 and Tier 3.
   - Entity matches with CRUD flows rank above entities with no lifecycle coverage.
   - Modules with more keyword hits rank higher.
   - Narrative matches (INTERPRETATION.md) provide supplementary ranking, not primary.

8. **Return results.** Produce a ranked list of KB file paths grouped by relevance tier (High / Medium / Low).

## Output

```markdown
## Feature Search Results: [keywords]

### High relevance
| KB file | Match type | Detail |
|---|---|---|

### Medium relevance
| KB file | Match type | Detail |
|---|---|---|

### Low relevance
| KB file | Match type | Detail |
|---|---|---|
```

## Notes

- This skill performs keyword matching against existing KB file content. It does not require a pre-computed feature index.
- When the KB has an enriched INTERPRETATION.md with business narrative, search quality improves significantly.
- If no results are found, broaden the keyword set by trying synonyms or related domain terms.
- For structural gaps in feature-level data, see `AI_WORKFLOW.md` section "Known Structural KB Gaps".
