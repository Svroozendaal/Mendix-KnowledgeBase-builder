# PROMPT_CHANGES

## TEMPLATE

```markdown
## PROMPT_CHANGE - [id] - [timestamp]
REQUESTED_BY: [...]
FILES_UPDATED: [...]
SUMMARY: [...]
COMPATIBILITY: BACKWARD_COMPATIBLE | BREAKING
```

## LIVE_LOG

## PROMPT_CHANGE - 001 - 2026-02-18
REQUESTED_BY: Developer
FILES_UPDATED: .agents/*
SUMMARY: Rebuilt `.agents` framework in English, moved Mendix constraints into a dedicated skill, and standardised governance around AGENTS-first and question-first execution.
COMPATIBILITY: BREAKING

## PROMPT_CHANGE - 002 - 2026-02-18
REQUESTED_BY: Developer
FILES_UPDATED: .agents/AGENTS.md, .agents/AI_WORKFLOW.md, .agents/agents/*, .agents/prompts/*, .agents/agent-memory/INCIDENTS.md
SUMMARY: Added WAIT_FOR_APPROVAL policy with AUTO_APPROVE exception, made prompts require entry and exit criteria, added skill-suggestion step in prompts, updated role defaults (Implementer, Tester, Reviewer, Prompt Refiner), and added incident tracking template.
COMPATIBILITY: BACKWARD_COMPATIBLE

## PROMPT_CHANGE - 003 - 2026-02-18
REQUESTED_BY: User
FILES_UPDATED: .agents/prompts/PHASE_6_DATA_COLLECTION.md
SUMMARY: Expanded phase 6 with explicit workflow alignment, skill defaults, schema and folder contracts, validation coverage, memory-log expectations, and clearer parser hand-off criteria.
COMPATIBILITY: BACKWARD_COMPATIBLE
