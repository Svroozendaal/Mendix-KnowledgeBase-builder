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

2. **Read `routes/keyword-index.md`.** For each keyword, collect the matched entities, flows, modules, and pages from the index table. This is a single file read that replaces scanning multiple route files.

3. **Merge and rank results.** Combine all keyword hits and apply the following ranking:
   - Custom modules rank above marketplace and system modules.
   - Tier 1 flows rank above Tier 2 and Tier 3.
   - Entity matches with CRUD flows rank above entities with no lifecycle coverage.
   - Modules with more keyword hits rank higher.

4. **Fallback (only if no matches found).** If the keyword index returns no results, fall back to scanning `routes/by-flow.md` and `routes/by-entity.md` for substring matches.

5. **Deep context for matched modules only.** For each matched module, read `modules/<Module>/README.md` (or `modules/_marktplace/<Module>/README.md` for marketplace modules). Scan the Capability Map and Primary User Journeys tables for additional context. If `modules/<Module>/INTERPRETATION.md` contains enriched content (not placeholder stubs), scan it for supplementary narrative matches. Do not read READMEs or INTERPRETATION.md for unmatched modules.

6. **Return results.** Produce a ranked list of KB file paths grouped by relevance tier (High / Medium / Low).

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

- The keyword index is generated at compose time and provides a pre-computed lookup table, saving thousands of tokens per query.
- When the KB has an enriched INTERPRETATION.md with business narrative, search quality improves significantly.
- If no results are found, broaden the keyword set by trying synonyms or related domain terms.
- For structural gaps in feature-level data, see `AI_WORKFLOW.md` section "Known Structural KB Gaps".
