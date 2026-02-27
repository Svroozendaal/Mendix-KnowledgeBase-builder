# COMMIT_MESSAGE_WRITER - App Extension
## Extends: `.agents/agents/COMMIT_MESSAGE_WRITER.md`
## Merge rule: Sections here ADD TO the base unless marked [OVERRIDE].

---

## Required Inputs

5. `.app-info/skills/mendix-technical-commit-message/SKILL.md`
6. `.app-info/skills/mendix-technical-commit-message/references/RULE_LIBRARY.md`
7. Latest export payload from `mendix-data/exports/` using `changes[*].modelChangesByModule`.

## Mandatory Behaviour

9. Build commit text per module (`modelChangesByModule[*].module`), with one line per changed element and each line starting with `-`.
10. Use these category buckets exactly: `domainModel`, `microflows`, `pages`, `nanoflows`, `resources`.
11. For element labels, remove the module prefix from `elementName` when it is in the form `<Module>.<Name>`.
12. Apply converter rules from `RULE_LIBRARY.md` Part 1 to build deterministic row structure.
13. Apply AI rules from `RULE_LIBRARY.md` Part 2 only for the `details` segment.
14. If any `details` text cannot be mapped by an existing AI rule, ask the user for the missing rule and include a copyable candidate rule block.
15. Append approved new rules to `RULE_LIBRARY.md` with a stable rule id (`Cxxx` for converter, `Axxx` for AI) and at least one example input/output pair.

## Output Template [OVERRIDE]

```markdown
## Technical Commit Message
[ModuleName]
- [line per changed element]

[NextModuleName]
- [line per changed element]

## Missing Rules
- Rule needed for:
  - Rule type: [Converter|AI]
  - Module: [module]
  - Category: [domainModel|microflows|pages|nanoflows|resources]
  - Change type: [Added|Modified|Deleted]
  - Element type: [elementType]
  - Raw details: [details text]
  - Proposed rule id: [Cxxx|Axxx]
  - Question: [exact question to user]
```
