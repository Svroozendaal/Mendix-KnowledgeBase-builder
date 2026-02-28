# skills/
## App-Specific Skills

This folder contains skills that are specific to this application. These complement the generic skills in `.agents/skills/`.

## When to Use App-Specific Skills

App-specific skills are used when:
- The task requires knowledge of this application's domain, stack, or conventions.
- The task involves platform-specific procedures (e.g. Mendix SDK operations).
- The task requires applying project-specific rules (e.g. styling guidelines, data contracts).

## Contents

| Skill | Folder | Description |
|---|---|---|
| Mendix SDK | `mendix-sdk/` | Mendix SDK usage and model manipulation |
| Mendix Studio Pro 10 | `mendix-studio-pro-10/` | Studio Pro 10 extension development constraints |
| Mendix Model Dump Inspection | `mendix-model-dump-inspection/` | Inspecting dump outputs, maintaining diff parser contracts, and evolving deterministic diff rules (`Dxxx`) |
| Mendix Model Overview Export | `mendix-model-overview-export/` | Building full-model overview exports (app + modules) from single dumps, including deterministic flow execution ordering and pseudocode output |
| Mendix Commit Structuring | `mendix-commit-structuring/` | Structuring commit data for the parser pipeline |
| Mendix Technical Commit Message | `mendix-technical-commit-message/` | Rule-driven conversion of module-grouped export data into technical commit message lines |

## Adding a New App-Specific Skill

Use the `skill-writer` skill (`.agents/skills/skill-writer/SKILL.md`) and place the new skill in a subfolder here.
Then update this OVERVIEW.md with a new row in the Contents table.
