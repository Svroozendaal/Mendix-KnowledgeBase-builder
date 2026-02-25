# DOCUMENTER — App Extension
## Extends: `.agents/agents/DOCUMENTER.md`
## Merge rule: Sections here ADD TO the base unless marked [OVERRIDE].

---

## Required Inputs

6. `/developer/CONTEXT.MD` — product and platform context; used when behaviour lives outside this repo.
7. `/developer/WellBased_Plugin.MD` — high-level plugin map; keep as an overview and pointers only.

## Module Indexing — App Conventions [OVERRIDE]

### `core/*` modules

For every folder under `core/<module>`, maintain a sibling doc:

```
core/<module>/info_<module>.MD
```

**What to capture (minimum checklist):**

- Purpose (1–3 bullets)
- Files and their responsibilities
- Public entry points: shortcodes (`add_shortcode`), AJAX actions (`wp_ajax_*`/`wp_ajax_nopriv_*`), hooks/filters (`add_action`/`add_filter`), admin menu pages
- Data/storage: user meta keys, post meta keys, options, ACF field names (and where they attach: user/post/term)
- Dependencies: plugins (ACF, Ultimate Member), frontend assumptions (jQuery, templates)
- Operational notes: one-off migrations (must be disabled by default), known risks, TODO hardening

If a module introduces new loading paths or major functionality, propose updates to `/developer/WellBased_Plugin.MD` and to `.agents/AGENTS.md` if a new agent responsibility emerges.

### `templates/*`

Maintain:
- `templates/info_templates.MD` — high-level overview and pointers
- `templates/<group>/info_<group>.MD` — for each direct subfolder

**For `templates/info_templates.MD`:** purpose, folder map, shared dependencies/assumptions (Tailwind, Elementor, required variables), where templates are referenced from (shortcodes, hooks, includes).

**For each `templates/<group>/info_<group>.MD`:** purpose, file list and responsibilities, expected inputs/variables, output/side effects (HTML structure, enqueue assumptions), known risks/gotchas (Elementor overrides, caching, logged-in state).

Keep template docs as a map and contract (inputs/outputs/assumptions) — never turn them into full HTML dumps.
