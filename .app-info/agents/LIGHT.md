# LIGHT — App Extension
## Extends: `.agents/agents/LIGHT.md`
## Merge rule: Sections here ADD TO the base unless marked [OVERRIDE].

---

## When NOT to Use — App-Specific Escalation Triggers

Escalate immediately (in addition to the base rules) when:

- ACF schema or data model changes are involved (new fields, field keys, `acf-json/` sync impact).
- `constants.php` is involved (secrets/config — treat as sensitive; escalate).
- Production webhooks or external integrations are affected (Zapier, Slack, Moneybird, analytics).
- New AJAX endpoints, shortcodes, or hooks are needed.
- Deployment or release is requested — hand off to DEPLOYMENT.

## Agent Handoff Map (App-specific)

| Boundary crossed | Hand off to |
|---|---|
| UI/Tailwind/token/responsive complexity | DESIGNER |
| PHP/WP security, data, hooks, permissions, ACF schema | DEVELOPER |
| Deploy/release/staging/main | DEPLOYMENT |
| Documentation indexing | DOCUMENTER |
