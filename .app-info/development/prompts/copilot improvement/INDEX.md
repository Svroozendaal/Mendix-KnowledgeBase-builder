# Copilot Improvement Prompts — INDEX

## Purpose

These prompts improve the generated Knowledge Base and the bot workflow that reads it. They were identified by simulating a bot reading only the KB and trying to help with feature development, then noting friction points, token waste, and information gaps.

## Context

Read before starting any prompt:

1. `.agents/AGENTS.md`
2. `.agents/FRAMEWORK.md`
3. `.app-info/ROUTING.md`
4. The generated KB at `mendix-data/knowledge-base/READER.md`

## Prompt Registry

| # | Prompt | Priority | Impact | Effort | Target |
|---|---|---|---|---|---|
| 01 | [Pre-Computed Keyword Index](01-KEYWORD_INDEX.md) | Critical | High — saves thousands of tokens per query | Low | KB Creator pipeline |
| 02 | [Entity Attribute Details in DOMAIN.md](02-ENTITY_ATTRIBUTES.md) | Critical | High — unblocks development planning | Low | KB Creator pipeline |
| 03 | [QUICKSTART.md Fast Context](03-QUICKSTART.md) | Critical | High — cuts bootstrap from 6 files to 1 | Low | KB Creator pipeline |
| 04 | [Merge Story Intake and Investigation](04-MERGE_INTAKE_INVESTIGATION.md) | High | Medium — removes redundant pass | Low | KB agent workflow |
| 05 | [Reading Budgets and Stop Signals](05-READING_BUDGETS.md) | High | Medium — prevents token waste | Low | KB agent workflow |
| 06 | [INTERPRETATION.md as First-Class Citizen](06-INTERPRETATION_FIRST_CLASS.md) | High | Medium — improves answer quality | Medium | KB Creator pipeline + agent workflow |
| 07 | [Collapse Interpretation Agents into Skills](07-COLLAPSE_AGENTS.md) | Medium | Medium — reduces persona overhead | Medium | KB agent framework |
| 08 | [Query Gap Feedback Loop](08-QUERY_GAP_FEEDBACK.md) | Medium | Medium — improves future KBs | Low | KB agent workflow |
| 09 | [Syntax Cheat Sheets](09-SYNTAX_CHEAT_SHEETS.md) | Medium | Low-Medium — convenience | Low | KB agent framework |
| 10 | [Cross-Module Worked Example](10-CROSS_MODULE_EXAMPLE.md) | Low | Low — future-proofing | Low | KB agent workflow |

## Execution Order

Prompts 01–03 are independent and can be implemented in parallel. They target the KB Creator pipeline (compose step).

Prompts 04–06 should be done in order — they progressively refine the agent workflow and require understanding the changes from earlier prompts.

Prompts 07–10 are independent improvements that can be done in any order after 01–06.

## Scope

All prompts target either:
- **KB Creator pipeline** — changes to how the knowledge base is generated (compose templates, scaffold, quality gate).
- **KB agent framework** — changes to the `.agents/` files inside the generated KB.

No prompt modifies the parent repository's `.agents/` framework or the KnowledgeBase-Copilot application code.
