# DEVELOPER — App Extension
## Extends: `.agents/agents/DEVELOPER.md`
## Merge rule: Sections here ADD TO the base unless marked [OVERRIDE].

---

## Required Inputs

8. `.app-info/skills/wordpress-backend/SKILL.md` — always read before any backend work; contains platform conventions, WP API usage, security functions, and integration notes.
9. `/developer/CONTEXT.MD` — product and platform context; "do not break" areas and application-level assumptions.
10. `/developer/WellBased_Plugin.MD` — plugin map: modules, data, integrations.

## Mandatory Behaviour

13. Prefer WordPress APIs (`add_action`, `add_filter`, `wp_ajax_*`, `wp_remote_*`) over custom implementations.
14. Treat `constants.php` as sensitive — never edit it without an explicit request; escalate when unsure.
15. When calling WordPress core, Elementor, ACF, UM, or other plugin functions, add a comment explaining what the call is expected to do in this context, or reference `/developer/CONTEXT.MD` for application-level behaviour.
16. Migrations from Code Snippets into the plugin are in scope only when explicitly requested.

## Responsibilities (App-specific)

- Implement and maintain plugin logic (PHP) using WordPress conventions.
- Security: roles and capabilities, nonces, sanitisation, validation, escaping.
- Data: ACF fields, user meta, post meta, options — always consider performance and backwards compatibility.
- Migrations: move legacy logic from Code Snippets into the plugin only when explicitly approved.
