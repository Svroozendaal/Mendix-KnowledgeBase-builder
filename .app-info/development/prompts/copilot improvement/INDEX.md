# Copilot Improvement Prompts — INDEX

## Purpose

These prompts improve the generated Knowledge Base and the bot workflow that reads it. They were identified by simulating a bot reading only the KB and trying to help with feature development, then noting friction points, token waste, and information gaps.

**All changes are made in the KB Creator pipeline source** (`KnowledgeBase-Creator/`), not directly in a generated knowledge base. Changes propagate to all future KB generations automatically.

## Context

Read before starting any prompt:

1. `.agents/AGENTS.md`
2. `.agents/FRAMEWORK.md`
3. `.app-info/ROUTING.md`
4. The generated KB at `mendix-data/knowledge-base/READER.md` (to understand the output)

## Creator Source Locations

All prompts target files under `KnowledgeBase-Creator/`:

| Source Folder | Purpose | Propagates To |
|---|---|---|
| `artifacts/.agents/` | Agent definitions and skills | `{KB}/.agents/` (copied recursively) |
| `artifacts/templates/` | Compose templates for KB content | `{KB}/_artifacts/` and used to generate content files |
| `wizard/run-dump-parser.ps1` | Main pipeline orchestrator | Controls what gets copied and when |
| `wizard/run-kb-compose.ps1` | Content composition | Generates KB content from templates + export data |
| `wizard/run-kb-scaffold.ps1` | KB folder structure | Creates directories and copies manifests |
| `wizard/run-kb-quality-gate.ps1` | Quality validation | Checks generated KB content |
| `wizard/src/.../WizardRuntime.cs` | GUI wizard | `UpdateKbAgentsAsync()` copies agents |

## Prompt Registry

| # | Prompt | Priority | Impact | Effort | Target |
|---|---|---|---|---|---|
| 01 | [Pre-Computed Keyword Index](01-KEYWORD_INDEX.md) | Critical | High — saves thousands of tokens per query | Low | Compose script + template + agent skill |
| 02 | [Entity Attribute Details in DOMAIN.md](02-ENTITY_ATTRIBUTES.md) | Critical | High — unblocks development planning | Low | Compose script + domain template |
| 03 | [QUICKSTART.md Fast Context](03-QUICKSTART.md) | Critical | High — cuts bootstrap from 6 files to 1 | Low | Compose script + new template + CLAUDE.md template |
| 04 | [Merge Story Intake and Investigation](04-MERGE_INTAKE_INVESTIGATION.md) | High | Medium — removes redundant pass | Low | Agent artifacts |
| 05 | [Reading Budgets and Stop Signals](05-READING_BUDGETS.md) | High | Medium — prevents token waste | Low | Agent artifacts |
| 06 | [INTERPRETATION.md as First-Class Citizen](06-INTERPRETATION_FIRST_CLASS.md) | High | Medium — improves answer quality | Medium | Compose script + agent artifacts + templates |
| 07 | [Collapse Interpretation Agents into Skills](07-COLLAPSE_AGENTS.md) | Medium | Medium — reduces persona overhead | Medium | Agent artifacts |
| 08 | [Query Gap Feedback Loop](08-QUERY_GAP_FEEDBACK.md) | Medium | Medium — improves future KBs | Low | Compose script + agent artifacts |
| 09 | [Syntax Cheat Sheets](09-SYNTAX_CHEAT_SHEETS.md) | Medium | Low-Medium — convenience | Low | Agent artifacts |
| 10 | [Cross-Module Worked Example](10-CROSS_MODULE_EXAMPLE.md) | Low | Low — future-proofing | Low | Agent artifacts |

## Execution Order

Prompts 01–03 are independent and can be implemented in parallel. They primarily target the compose step and templates.

Prompts 04–06 should be done in order — they progressively refine the agent workflow and require understanding the changes from earlier prompts.

Prompts 07–10 are independent improvements that can be done in any order after 01–06.

## Scope

All prompts modify files within `KnowledgeBase-Creator/`:

- **Compose pipeline** (`wizard/run-kb-compose.ps1`, `wizard/run-dump-parser.ps1`) — changes to how KB content is generated.
- **Content templates** (`artifacts/templates/`) — changes to KB content structure and headings.
- **Agent artifacts** (`artifacts/.agents/`) — changes to agents and skills copied into every generated KB.
- **Quality gate** (`wizard/run-kb-quality-gate.ps1`) — new validation rules.

No prompt modifies the parent repository's `.agents/` framework, the KnowledgeBase-Copilot application code, or any generated KB instance directly.
