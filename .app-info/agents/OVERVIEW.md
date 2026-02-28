# agents/
## App-Specific Agent Extensions

This folder contains app-specific extensions for generic agents defined in `.agents/agents/`.

## How Extensions Work

An extension file supplements or overrides behaviour from the base agent without modifying it.

- **Sections without a marker** → add to the base section (default).
- **Sections marked `[OVERRIDE]`** → fully replace the base section.
- **Sections absent from the extension** → inherited unchanged from the base.

Read `.agents/FRAMEWORK.md` for the full extension model.
Use `.agents/skills/agent-extender/SKILL.md` to write a new extension correctly.

## Contents

| Agent | File | What the extension adds |
|---|---|---|
| Designer | `DESIGNER.md` | App token system skill reference, Elementor guardrails, WellBased breakpoints, container widths, column defaults, JS file routing |
| Developer | `DEVELOPER.md` | WordPress/PHP skill reference, CONTEXT.MD and plugin map inputs, WP API preference, `constants.php` sensitivity, migration scope |
| Deployment | `DEPLOYMENT.md` | WellBased branch policy (development/docs/staging/main), CI/CD workflows, js-loader version bump rule, Cloudways, plugin-only hygiene |
| Documenter | `DOCUMENTER.md` | WellBased `core/*/info_*.MD` indexing convention, `templates/*/info_*.MD` convention, WordPress entry-point checklist |
| Light | `LIGHT.md` | App-specific escalation triggers (ACF, constants.php, webhooks), agent handoff map |
| Commit Message Writer | `COMMIT_MESSAGE_WRITER.md` | Mendix export to technical commit text workflow with rule-gap capture and iterative rule growth |
| Prompt Refiner | `PROMPT_REFINER.md` | Deterministic prompt linting and refinement workflow with hard-pointer rules, blockers, and skill mapping defaults |
| GAPSMITH | `GAPSMITH.md` | End-to-end gap loop for dump diff rules (`Dxxx`) and display-text/commit rules (`Cxxx`/`Axxx`) with implementation mapping |
| OVERVIEWSMITH | `OVERVIEWSMITH.md` | Full-model overview export workflow for single-dump parsing, flow ordering, and app/module pseudocode artefacts |

## Notes

These extensions were derived from the WellBased WordPress plugin project. The base agents (`.agents/agents/`) are generic and reusable in any project. The heavy app-specific detail (token names, WP API functions, component rules) belongs in `.app-info/skills/` — the extensions here reference those skills rather than duplicating them.

## Adding a New Extension

1. Use the `agent-extender` skill (`.agents/skills/agent-extender/SKILL.md`).
2. Create `<AGENT>.md` in this folder using the required preamble format.
3. Add a row to the Contents table above.
4. Run the Structure Guardian to validate.
