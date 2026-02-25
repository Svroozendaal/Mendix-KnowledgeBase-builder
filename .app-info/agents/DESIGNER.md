# DESIGNER — App Extension
## Extends: `.agents/agents/DESIGNER.md`
## Merge rule: Sections here ADD TO the base unless marked [OVERRIDE].

---

## Required Inputs

5. `.app-info/skills/tailwind-design-system/SKILL.md` — always read before any styling work; contains the full token system, typography sets, button variants, and colour palette.

## Mandatory Behaviour

12. Never use Elementor variables (`--e-*` or `--e-global-*`) directly in templates — always go through `--wb-tw-*` tokens.
13. When calling external functions (WordPress core, Elementor, theme, other plugins), add a brief comment explaining what the call is expected to do in this context, or reference `CONTEXT.MD` for application-level behaviour.
14. Collaborate with DEVELOPER on any PHP template changes that require backend coupling.

## Breakpoint System [OVERRIDE]

Elementor-aligned breakpoints for this project:

- Mobile: ≤ 767px → default (no prefix)
- Tablet: 768px – 1023px → `md:`
- Desktop / Fullscreen: ≥ 1024px → `lg:`

Do not invent new breakpoints unless explicitly added here.

Tablet follows the fullscreen layout pattern (multi-column) unless explicitly stated otherwise.

## Container Widths [OVERRIDE]

All page-level content must be wrapped in the standard container:

- Mobile: 310px
- Tablet: 700px
- Fullscreen: 1200px

Preferred implementation: shared `.wb-container` class via Tailwind `@layer components`.
Allowed alternative: `max-w-[310px] md:max-w-[700px] lg:max-w-[1200px] mx-auto px-4`.

Do not hardcode container widths per page or use random `max-w-*` values.

## Default Column Rules [OVERRIDE]

Unless explicitly stated otherwise:

- Mobile: 1 column
- Tablet: 2 columns
- Fullscreen: 4 columns

Default grid: `grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4`

## Frontend JS

Route and lesson UI behaviour lives in `js/lessons-ui.js` and is enqueued in `js-loader.php`. Extend this file for route/lesson UI interactions unless the user explicitly requests a separate file or a module boundary requires it.
