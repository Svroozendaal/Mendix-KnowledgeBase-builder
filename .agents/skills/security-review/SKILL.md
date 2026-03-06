# SKILL: security-review

## Purpose

Shared security review checklist for any agent verifying the security posture of endpoints, form handlers, data-writing operations, or access-control boundaries.

## When to Use

- Developer is implementing or modifying an endpoint, handler, or data operation.
- Reviewer is assessing a change that touches authentication, authorisation, or data boundaries.
- Tester is verifying security-related acceptance criteria.
- Any agent encounters code that handles user input, secrets, or permissions.

## Procedure

For each endpoint, form handler, data-writing operation, or access-control boundary in scope, verify every item on the checklist below.

1. **Authentication** — Is the user's identity verified before this action runs?
2. **Authorisation** — Does the user have the right role, capability, or scope for this action?
3. **Input sanitisation** — Is all incoming data sanitised before use (query params, body, headers, file uploads)?
4. **Output escaping** — Is all dynamic output escaped at the point of rendering (HTML, JSON, SQL, shell)?
5. **Sensitive data** — Are secrets, tokens, config values, and PII kept out of responses, logs, and error messages?

Mark each item as **PASS**, **FAIL**, or **N/A**.

If any item is **FAIL**, raise it as a **MUST FIX** finding before proceeding.

## Output / Expected Result

```markdown
## Security Review - [Scope]
- Authentication: PASS / FAIL / N/A
- Authorisation: PASS / FAIL / N/A
- Input sanitisation: PASS / FAIL / N/A
- Output escaping: PASS / FAIL / N/A
- Sensitive data: PASS / FAIL / N/A

Findings:
- [MUST FIX / none]
```

## Notes

- This checklist is a minimum bar, not an exhaustive penetration test.
- For OWASP-specific concerns beyond this checklist, escalate to the user or Architect.
- Agents that should reference this skill: Developer, Reviewer, Tester.
