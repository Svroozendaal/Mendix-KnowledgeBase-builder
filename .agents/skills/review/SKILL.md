# SKILL: review

## Purpose

Structured code review procedure with severity classification and actionable feedback. Use when assessing implementation quality before approval.

## When to Use

- Reviewer is running the final quality gate on a change.
- Developer is self-reviewing before handing off to Reviewer.
- Any agent needs to assess a change against quality and security criteria.

## Procedure

1. **Scope** — Identify all files and changes under review. Read each changed file fully before assessing.

2. **Run companion skills** — Apply the following skills to the changes:
   - `security-review` — for any code touching endpoints, handlers, data operations, or permissions.
   - `code-quality` — for all changed or newly created code.

3. **Classify findings** — For each issue found, classify by severity:
   - **MUST FIX** — Blocks approval. Security vulnerabilities, data loss risks, broken contracts, or logic errors.
   - **SHOULD FIX** — Does not block, but should be addressed. Code quality issues, missing edge cases, unclear naming.
   - **NICE TO HAVE** — Optional improvements. Style nits, minor readability gains, opportunistic cleanups.

4. **Reference exactly** — Every finding must include the exact file path and a description of the issue. Do not raise vague concerns.

5. **Verdict** — Based on findings:
   - **APPROVED** — No MUST FIX items remain.
   - **CHANGES REQUIRED** — One or more MUST FIX items are unresolved.

6. **Log findings** — Write findings to `.app-info/memory/REVIEW_NOTES.md` using the FINDING template.

## Output / Expected Result

```markdown
## Review Verdict - [Scope]

MUST FIX:
- [file] — [issue]

SHOULD FIX:
- [file] — [issue]

NICE TO HAVE:
- [file] — [issue]

Security review: PASS / FAIL
Code quality review: PASS / FAIL

Verdict: APPROVED / CHANGES REQUIRED
```

## Notes

- Approval is blocked only by unresolved MUST FIX items.
- Companion to the `.agents/commands/review.md` command guidance.
- Agents that should reference this skill: Reviewer, Developer (self-review).
