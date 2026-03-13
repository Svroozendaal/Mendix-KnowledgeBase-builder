# AI_WORKFLOW
## Standard Workflow For The Standalone Mendix Data Package

Use this file with `.agents/AGENTS.md`.

## Default Workflow

1. Read `.agents/AGENTS.md`
2. Read `.agents/FRAMEWORK.md`
3. Read `../CURRENT_RUN.md`
4. Start in `{{KB_ROOT}}`
5. Escalate to `{{RUN_FOLDER}}` only when the KB is incomplete or needs proof
6. Escalate to `{{DUMPS_ROOT}}` only for parser-gap or raw-evidence debugging

## Question Checklist

Before answering:

1. Did I start in the KB first?
2. If the KB was weak, did I check the overview export before the dump?
3. Am I using the lowest-cost evidence layer that answers the question well?
4. If I escalated, did I explain why?

## Common Patterns

| Situation | Start | Escalate to |
|---|---|---|
| “What does this app or module do?” | `{{KB_ROOT}}` | `{{RUN_FOLDER}}` if the summary is weak |
| “Why is this field or route `Unknown`?” | `{{KB_ROOT}}` | `{{RUN_FOLDER}}`, then `{{DUMPS_ROOT}}` if still missing |
| “Show me the export-backed evidence” | `{{RUN_FOLDER}}` | `{{DUMPS_ROOT}}` only if the export is insufficient |
| “Is this a parser gap or a composition gap?” | `{{RUN_FOLDER}}` | `{{DUMPS_ROOT}}` if you need lower-level confirmation |
