# GAPSMITH - App Extension
## Extends: `.agents/agents/DEVELOPER.md`
## Merge rule: Sections here ADD TO the base unless marked [OVERRIDE].

---

## Mission

Close rule and implementation gaps between:
- dump diff extraction (`MendixModelDiffService`)
- display text conversion (`MendixModelChangeDisplayTextFormatter`)

The output is a repeatable rule-growth loop that keeps export quality and UI text quality aligned.

## Generalization First

- Prefer general, reusable rules over scenario-specific one-offs.
- Build rules around stable structural anchors (for example: delta blocks, typed action lists, typed descriptors), not specific module or element names.
- Use concrete examples only as validation evidence; do not encode example-specific logic.
- If a gap cannot be solved generically, pause and propose the smallest general contract before implementing.

## Required Inputs

1. `.app-info/skills/mendix-model-dump-inspection/SKILL.md`
2. `.app-info/skills/mendix-model-dump-inspection/references/PARSER_LIBRARY.md`
3. `.app-info/skills/mendix-model-dump-inspection/references/RULE_LIBRARY.md`
4. `.app-info/skills/mendix-technical-commit-message/SKILL.md`
5. `.app-info/skills/mendix-technical-commit-message/references/RULE_LIBRARY.md`
6. Target export payload in `mendix-data/exports/`
7. Matching dump folder in `mendix-data/dumps/` with `working-dump.json` and `head-dump.json`

## Gap Classification Workflow

1. Parse export rows by module/category.
2. Flag rows with:
- missing/empty `details`
- low-signal `details` (`updated`, `changed`, or generic-only fallback)
- invalid/low-signal `displayText`
3. Classify each gap:
- `DIFF_GAP`: `details` quality is insufficient because extraction logic is missing.
- `CONVERTER_GAP`: `details` is acceptable but `displayText` formatting/abbreviation/details rendering is insufficient.
- `DUAL_GAP`: both are insufficient.

## DIFF_GAP Protocol

1. Inspect matching resources in both dumps.
2. Identify deterministic parseable fields and select/add rule IDs (`Dxxx`) in:
- `.app-info/skills/mendix-model-dump-inspection/references/RULE_LIBRARY.md`
3. Add/update parser contracts in:
- `.app-info/skills/mendix-model-dump-inspection/references/PARSER_LIBRARY.md`
4. Implement corresponding extraction in:
- `studio-pro-extension-csharp/Processing/ModelDiff/MendixModelDiffService.cs`
5. Re-export and verify `details` is populated and stable.

## CONVERTER_GAP Protocol

1. Map issue to converter or AI rule:
- Converter (`Cxxx`) for deterministic row structure/abbreviation/normalisation.
- AI (`Axxx`) only for details interpretation logic.
2. Update:
- `.app-info/skills/mendix-technical-commit-message/references/RULE_LIBRARY.md`
3. Implement deterministic formatting changes in:
- `studio-pro-extension-csharp/Processing/Formatting/MendixModelChangeDisplayTextFormatter.cs`
4. Verify UI shows corrected `displayText` in:
- `studio-pro-extension-csharp/UI/Web/AutoCommitMessagePanelHtml.cs`

## Rule Governance

- Never delete prior rules without explicit approval.
- Additive changes only with stable IDs:
  - Diff: `Dxxx`
  - Converter: `Cxxx`
  - AI: `Axxx`
- Every new rule must include:
  - match scope
  - deterministic output contract
  - at least one real example from export/dump input

## Output Template [OVERRIDE]

```markdown
## Gap Report
- [DIFF_GAP|CONVERTER_GAP|DUAL_GAP] <Module> / <Category> / <ElementType> / <ElementName>
  - Current: <current details/displayText>
  - Cause: <why parser/formatter failed>
  - Rule updates: <Dxxx/Cxxx/Axxx>
  - Code updates: <file paths>
  - Verification: <what changed in export/UI>

## Applied Rule Changes
- Diff rules: <list of Dxxx>
- Commit/converter rules: <list of Cxxx/Axxx>

## Follow-up Questions
- <only when deterministic mapping is not possible>
```
