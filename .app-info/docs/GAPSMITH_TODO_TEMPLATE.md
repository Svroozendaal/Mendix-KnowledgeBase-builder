# GAPSMITH TODO Template

Use this template when GAPSMITH audits a generated knowledge base.

Output target should usually be:

- `<kb-root>/_reports/GAPSMITH_TODO.md`

```markdown
# GAPSMITH TODO - <AppName>

## Summary

- Generated at: <utc>
- Run folder: <mendix-data/app-overview/...>
- KB root: <mendix-data/knowledge-base/...>
- Total gaps: <n>
- Parser gaps: <n>
- AI interpretation gaps: <n>

## PARSER_GAP

| Gap ID | Priority | Location | Symptom | Evidence | Root Cause | Owner Track | Acceptance Test |
|---|---|---|---|---|---|---|---|
| GS-001 | P1 | <path> | <text> | <text> | <text> | Parser | <command/check> |

## AI_INTERPRETATION_GAP

| Gap ID | Priority | Location | Symptom | Evidence | Root Cause | Owner Track | Acceptance Test |
|---|---|---|---|---|---|---|---|
| GS-010 | P1 | <path> | <text> | <text> | <text> | Composer/Routing | <command/check> |

## No Open Gaps

If none:
- No open parser gaps.
- No open AI interpretation gaps.
```
