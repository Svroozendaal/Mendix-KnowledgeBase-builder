---
name: mendix-technical-commit-message
description: Convert Mendix export JSON (`changes[*].modelChangesByModule`) into a technical commit message grouped by module with one dash-prefixed line per changed element. Use when drafting commit text from Studio Pro export data and when iteratively expanding rule coverage for new `details` patterns.
---

# MENDIX TECHNICAL COMMIT MESSAGE

## TASKS

1. Read commit export input from `mendix-data/exports/*.json`.
2. Use `modelChangesByModule` as the primary input shape.
3. Produce technical commit text grouped by module.
4. Write one line per changed element, each line starting with `-`.
5. Apply converter rules from Part 1 of `references/RULE_LIBRARY.md` for deterministic row formatting.
6. Apply AI rules from Part 2 of `references/RULE_LIBRARY.md` for `details` interpretation.
7. Persist approved rules back into `references/RULE_LIBRARY.md`.

## INPUT CONTRACT

Expect this path in each export file:

- `changes[*].modelChangesByModule[*].module`
- `changes[*].modelChangesByModule[*].domainModel[*]`
- `changes[*].modelChangesByModule[*].microflows[*]`
- `changes[*].modelChangesByModule[*].pages[*]`
- `changes[*].modelChangesByModule[*].nanoflows[*]`
- `changes[*].modelChangesByModule[*].resources[*]`

Each change row is expected to contain:

- `changeType`
- `elementType`
- `elementName`
- `details`

## OUTPUT CONTRACT

1. Print one module heading at a time.
2. Under each module, print one element row per change.
3. Every row starts with `-`.
4. Keep technical names explicit and concise.
5. If module prefix exists in `elementName` (`Module.Name`), show only `Name` in the row label.

## PROCEDURE

1. Load the latest export file unless the user selects a specific file.
2. Iterate modules in stable alphabetical order.
3. For each module, process categories in this order:
- `domainModel`
- `microflows`
- `pages`
- `nanoflows`
- `resources`
4. For each change item, apply converter rules first (name normalisation, NEW marker, abbreviation, final row shape).
5. For each change item, apply AI rules to derive the `details` segment when interpretation is needed.
6. If no applicable converter or AI rule matches:
- add a `Missing Rules` entry with module, category, element type, change type, and raw details
- ask the user to define a new rule for that exact pattern (`Cxxx` for converter or `Axxx` for AI)
- after approval, append the rule to `references/RULE_LIBRARY.md` with a new rule id
7. Regenerate the commit message once rule gaps are resolved.

## STARTER FORMAT RULE

Use the global row shape from the rule library:

- `- <NEW|DEL|empty> <ABBR|empty> <ElementName> : <Details>`

## MISSING RULE QUESTION TEMPLATE

Use this exact question pattern for uncovered details:

`I found an uncovered pattern for <ElementType> (<ChangeType>) in module <Module>.`
`Raw details: "<Details>"`
`What output line format should I use for this pattern?`

## RULE MAINTENANCE

1. Add only approved rules.
2. Keep each rule deterministic and testable.
3. Include one real input/output example per rule.
4. Never delete existing rules unless explicitly requested.
5. Prefer additive growth of rule coverage across runs.
