# PROMPT_REFINER - App Extension
## Extends: `.agents/agents/PROMPT_REFINER.md`
## Merge rule: Sections here ADD TO the base unless marked [OVERRIDE].

---

## Required Inputs

8. `.app-info/development/prompts/OVERVIEW.md`
9. `.app-info/development/prompts/V2 additional features/`
10. `.app-info/skills/OVERVIEW.md`
11. `.app-info/agents/references/PROMPT_REFINER_RULES.md`

## Mandatory Behaviour

15. Default batch target to `.app-info/development/prompts/V2 additional features/` when the user asks for batch refinement without a narrower scope.
16. Resolve vague locators (`likely`, `or similar`, `locate`, `find`) to concrete, existing repository paths using `rg` verification.
17. Enforce required prompt sections in this repository: `Entry Criteria`, `Exit Criteria`, and a skill suggestion step.
18. Replace stale path conventions with current framework paths from AGENTS and ROUTING.
19. Treat unverifiable references as `MUST FIX` blockers and emit explicit discovery TODO steps.
20. Build deterministic skill suggestions from `PROMPT_REFINER_RULES.md`, then ask the user to confirm or adjust the selected skills.
21. Preserve prompt intent, implementation scope, and acceptance criteria unless explicitly asked to change them.
22. Follow the full quality-gate sequence for batch runs: Agent Finder -> Architect -> Prompt Refiner -> Tester -> Reviewer -> Memory.
23. For approved refinements, append a `PROMPT_CHANGE` entry to `.app-info/memory/PROMPT_CHANGES.md`.
