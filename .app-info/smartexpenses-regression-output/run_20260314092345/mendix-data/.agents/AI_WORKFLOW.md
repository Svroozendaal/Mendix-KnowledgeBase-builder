# AI_WORKFLOW
## Standard Workflow For The Standalone Mendix Data Package

Use this file with `.agents/AGENTS.md`.

## Default Workflow

1. Read `.agents/AGENTS.md`
2. Read `.agents/FRAMEWORK.md`
3. Read `../CURRENT_RUN.md`
4. Start in `C:\Workspaces\Mendix-KnowledgeBase-builder\.app-info\smartexpenses-regression-output\run_20260314092345\mendix-data\knowledge-base`
5. Escalate to `C:\Workspaces\Mendix-KnowledgeBase-builder\.app-info\smartexpenses-regression-output\run_20260314092345\mendix-data\app-overview\cli_2026-03-14T09-23-46.259Z` only when the KB is incomplete or needs proof
6. Escalate to `dumps/` only for parser-gap or raw-evidence debugging

## Question Checklist

Before answering:

1. Did I start in the KB first?
2. If the KB was weak, did I check the overview export before the dump?
3. Am I using the lowest-cost evidence layer that answers the question well?
4. If I escalated, did I explain why?

## Common Patterns

| Situation | Start | Escalate to |
|---|---|---|
| â€œWhat does this app or module do?â€ | `C:\Workspaces\Mendix-KnowledgeBase-builder\.app-info\smartexpenses-regression-output\run_20260314092345\mendix-data\knowledge-base` | `C:\Workspaces\Mendix-KnowledgeBase-builder\.app-info\smartexpenses-regression-output\run_20260314092345\mendix-data\app-overview\cli_2026-03-14T09-23-46.259Z` if the summary is weak |
| â€œWhy is this field or route `Unknown`?â€ | `C:\Workspaces\Mendix-KnowledgeBase-builder\.app-info\smartexpenses-regression-output\run_20260314092345\mendix-data\knowledge-base` | `C:\Workspaces\Mendix-KnowledgeBase-builder\.app-info\smartexpenses-regression-output\run_20260314092345\mendix-data\app-overview\cli_2026-03-14T09-23-46.259Z`, then `dumps/` if still missing |
| â€œShow me the export-backed evidenceâ€ | `C:\Workspaces\Mendix-KnowledgeBase-builder\.app-info\smartexpenses-regression-output\run_20260314092345\mendix-data\app-overview\cli_2026-03-14T09-23-46.259Z` | `dumps/` only if the export is insufficient |
| â€œIs this a parser gap or a composition gap?â€ | `C:\Workspaces\Mendix-KnowledgeBase-builder\.app-info\smartexpenses-regression-output\run_20260314092345\mendix-data\app-overview\cli_2026-03-14T09-23-46.259Z` | `dumps/` if you need lower-level confirmation |

