# SKILL: code-quality

## Purpose

Shared code quality checklist for any agent verifying the structural quality of implemented code. Covers single responsibility, duplication, naming, error handling, hardcoded values, and testability.

## When to Use

- Developer is completing implementation work and needs a pre-handoff quality check.
- Reviewer is assessing the quality of a change before approval.
- Tester is verifying structural quality alongside functional correctness.

## Procedure

Before marking work complete, verify every item on the checklist below for all changed or newly created code.

1. **Single responsibility** — Each function, class, or module does one thing and does it well.
2. **No unnecessary duplication** — Shared logic is extracted, referenced, or inherited — not copied.
3. **Naming is clear and consistent** — Functions, variables, and classes use naming conventions from the codebase.
4. **Error paths are explicit** — All failure modes are handled; no silent failures or uncaught exceptions.
5. **No hardcoded values** — Credentials, magic numbers, and environment-specific strings are in config or constants, not in code.
6. **Testable in isolation** — New functions have minimal hidden dependencies; they can be tested without the full stack.

Mark each item as **PASS**, **FAIL**, or **N/A**.

If any item is **FAIL**, log it as an open item with a recommended fix.

## Output / Expected Result

```markdown
## Code Quality Review - [Scope]
- Single responsibility: PASS / FAIL / N/A
- No duplication: PASS / FAIL / N/A
- Naming: PASS / FAIL / N/A
- Error paths explicit: PASS / FAIL / N/A
- No hardcoded values: PASS / FAIL / N/A
- Testable in isolation: PASS / FAIL / N/A

Findings:
- [open items / none]
```

## Notes

- This checklist complements the `security-review` skill — run both when reviewing implementation work.
- Agents that should reference this skill: Developer, Reviewer, Tester.
