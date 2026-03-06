# PROMPT 02: Surface Annotation Nodes as Intent Descriptions

## Priority

High — developer-written annotations are the most directly useful business-intent descriptions available.

## Context

Read before starting:

1. `.agents/AGENTS.md` and `.agents/FRAMEWORK.md`
2. `.app-info/product-plan/02-CONTENT_MODEL_CUSTOM_DEPTH.md` — behaviour-first narrative template.
3. `.app-info/product-plan/05-KB_COMPOSER_SPEC.md` — composer specification.
4. Prompt 01 (`COMPOSER_PSEUDOCODE_NARRATIVES.md`) must be completed first — this prompt builds on its narrative structure.

## Problem Statement

Mendix developers place `Annotation` nodes on the flow canvas to document intent, assumptions, or business logic. The parser correctly captures these as nodes with `nodeType: "Annotation"` and the developer's text in the `label` field. Examples from the SmartExpenses export:

```json
{
  "nodeId": "...",
  "nodeType": "Annotation",
  "label": "Creates the ExcelFile entity and a popup to upload it. The 'ExcelFileImport' entity will be used to attach the real excelfile to...",
  "detail": null
}
```

These annotations are **already in the parsed JSON** but are completely ignored by the composer. They never appear in any KB output. This is a significant loss — annotations are the closest thing to developer intent documentation available from the model export.

## Entry Criteria

1. Prompt 01 has been completed (Tier 1 narratives now include pseudocode).
2. The `pseudocode` field is already being loaded by the composer.
3. Annotation nodes exist in `flows.json` with `nodeType: "Annotation"`.

## Acceptance Criteria

1. Annotation text from flow nodes is surfaced in the Tier 1 narrative section as a "Developer notes" field.
2. When a flow has no annotation nodes, the "Developer notes" field is omitted (not shown as "none").
3. Annotation text is displayed verbatim — no interpretation or summarisation.
4. Multiple annotations in the same flow are concatenated with a separator.
5. Annotations are also used to improve the `Intent` line: if an annotation exists, it takes precedence over the pseudocode-derived intent from Prompt 01.
6. Quality gate and benchmark still pass.
7. Deterministic output preserved.

## Scope

### Files to Modify

1. `KnowledgeBase-Creator/run-kb-compose.ps1` — the only file that needs changes.

### Specific Code Locations and Changes

#### Step 1: Extract annotation text during fact-building

When iterating flow nodes to build `$flowFacts` (the section that processes `$flow.nodes`), add annotation extraction. For each flow:

1. Filter nodes where `$node.nodeType -eq "Annotation"`.
2. Collect the `label` text from each annotation node.
3. Store as an array property on the flow fact object: `$factObj.annotations = @($annotationTexts)`.

The raw node structure:

```json
{
  "nodeId": "some-guid",
  "nodeType": "Annotation",
  "label": "Developer's annotation text here.",
  "detail": null,
  "loopOwnerId": null,
  "isExecutable": false,
  "calls": []
}
```

#### Step 2: Use annotations in intent derivation

Modify the `Get-FlowIntentSummary` function (added in Prompt 01):

1. Accept an optional `$Annotations` parameter (array of strings).
2. If annotations exist and the first annotation is >= 10 characters, use it as the primary intent description (truncated to 200 characters if longer, with "..." appended).
3. If annotations are empty or too short (< 10 chars), fall back to the pseudocode-based derivation from Prompt 01.

Priority order for intent:
1. Developer annotation text (most trustworthy — human-written intent).
2. Pseudocode-derived summary (deterministic but mechanical).
3. Prefix-based label ("User action flow" etc.) as final fallback.

#### Step 3: Add "Developer notes" to Tier 1 narrative block

In the Tier 1 narrative template (modified in Prompt 01), add a conditional "Developer notes" line:

```markdown
### SmartExpenses.ACT_ExcelFileImport_Create

- **Intent**: Creates the ExcelFile entity and a popup to upload it.
- **Developer notes**: "Creates the ExcelFile entity and a popup to upload it. The 'ExcelFileImport' entity will be used to attach the real excelfile to..."
- **Trigger**: ...
[rest of narrative]
```

Rules:
- Only include "Developer notes" if annotations exist (do not show "none").
- Wrap annotation text in quotes to distinguish it from generated content.
- If multiple annotations exist, join them with " | " separator.
- Escape any markdown-breaking characters in annotation text (pipes, backticks).

#### Step 4: Include annotations in Tier 2 brief summaries

If a Tier 2 flow has annotations, include them as the primary description instead of the pseudocode-derived key actions:

```markdown
### SmartExpenses.DS_BudgetType_ByFBGProfile

- **Intent**: [annotation text or pseudocode-derived].
- **Developer note**: "[annotation text]"
```

### What NOT to Change

1. Do not modify annotation text — preserve it verbatim from the export.
2. Do not add annotations to Tier 3 (catalogue-only) flows.
3. Do not modify the flow catalogue tables.
4. Do not change any other KB files beyond `FLOWS.md` content generation.
5. Do not modify the quality gate or benchmark scripts.

## Verification Steps

After implementing:

1. Run the full pipeline:
   ```powershell
   cd KnowledgeBase-Creator
   .\run-dump-parser.ps1
   ```
2. Open `mendix-data/knowledge-base/SmartExpenses/modules/ImporterHelper/FLOWS.md` — the ImporterHelper flows have known annotations. Verify they appear.
3. Check that flows without annotations do not show a "Developer notes: none" line.
4. Verify quality gate passes.
5. Verify benchmark score >= 85.
6. Verify determinism (two runs produce identical output).

## Exit Criteria

1. Annotation text from flow nodes appears in Tier 1 and Tier 2 narratives where available.
2. Annotations improve the `Intent` line when present.
3. Flows without annotations are unaffected.
4. Quality gate passes.
5. Benchmark score >= 85.

## Estimated Scope

Changes are confined to `run-kb-compose.ps1`:

- Modify fact-building loop to extract annotation nodes (~5 lines).
- Modify `Get-FlowIntentSummary` to accept and prefer annotations (~10 lines).
- Modify Tier 1 narrative template to include developer notes (~5 lines).
- Modify Tier 2 summary template to include annotations (~5 lines).
