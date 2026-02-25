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
12. For domain model entity additions, apply the starter format: `- DM : <EntityName>: added with attributes '<AttributeList>'`.
13. For microflow modifications, summarise actions in order and apply the starter format: `- <MicroflowName> : retrieve ..., change ..., commit ...`.
14. If any `details` text cannot be mapped by an existing rule, ask the user for the missing rule and include a copyable candidate rule block.
15. Append approved new rules to `RULE_LIBRARY.md` with a stable rule id and at least one example input/output pair.

## Output Template [OVERRIDE]

```markdown
## Technical Commit Message
[ModuleName]
- [line per changed element]

[NextModuleName]
- [line per changed element]

## Missing Rules
- Rule needed for:
  - Module: [module]
  - Category: [domainModel|microflows|pages|nanoflows|resources]
  - Change type: [Added|Modified|Deleted]
  - Element type: [elementType]
  - Raw details: [details text]
  - Proposed rule id: [Rxxx]
  - Question: [exact question to user]
```
