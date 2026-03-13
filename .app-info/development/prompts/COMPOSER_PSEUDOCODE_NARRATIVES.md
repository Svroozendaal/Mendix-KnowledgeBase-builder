# PROMPT 01: Integrate Pseudocode into Tier 1 Narratives

## Priority

Critical â€” this is the single highest-impact improvement to KB output quality.

## Context

Read before starting:

1. `.agents/AGENTS.md` and `.agents/FRAMEWORK.md`
2. `.app-info/product-plan/02-CONTENT_MODEL_CUSTOM_DEPTH.md` â€” behaviour-first narrative template and tiered flow rules.
3. `.app-info/product-plan/05-KB_COMPOSER_SPEC.md` â€” composer specification.
4. `.app-info/product-plan/07-QUALITY_GATE_HYBRID_SPEC.md` â€” known evidence extraction limitations.

## Problem Statement

The `run-kb-compose.ps1` script generates Tier 1 "Deep Narratives" for custom-module flows in `FLOWS.md`. Currently, all 32 Tier 1 narratives for SmartExpenses are near-identical boilerplate. The fields `Intent`, `Trigger/entry`, `Inputs/outputs`, and `Security constraints` contain the same generic text for every flow:

```
- Intent: User action flow.
- Trigger\entry: microflow/nanoflow entry based on caller or UI action.
- Inputs\outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Security constraints: module roles derived via page permissions and entity access rules.
```

This renders the Tier 1 narratives useless for AI reasoning â€” an AI cannot understand what a flow does beyond what the catalogue table already shows.

## Root Cause

The raw parser export contains a `pseudocode` field on every flow object in `flows.json`. This field is a pre-rendered, human-readable, step-by-step representation of the flow logic, including:

- Variable names and assignments.
- Decision conditions (`ExclusiveSplit` expressions).
- Entity operations with full attribute mappings (`create SmartExpenses.BudgetType as NewBudgetType (Name=$Iterator/Name, ...)`).
- Sub-flow calls with return types.
- Loop structures with iterators.
- Show-page actions.
- Error/message actions with text content.

This `pseudocode` field is **never read by the composer**. It is the single richest source of behavioural information available.

## Entry Criteria

1. Composer script exists at `KnowledgeBase-Creator/wizard/run-kb-compose.ps1`.
2. A valid app-overview export exists under `mendix-data/app-overview/`.
3. The `pseudocode` field is present on flow objects in `flows.json` files.

## Acceptance Criteria

1. Tier 1 flow narratives include the `pseudocode` content, formatted as a readable step-by-step section.
2. Each Tier 1 narrative has a unique, flow-specific description â€” no two narratives should have identical text.
3. The `Intent` field is derived from the first meaningful action in the pseudocode (e.g. "Creates a new BudgetType entity and associates it with the current FBGProfile" rather than "User action flow").
4. The narrative template from `02-CONTENT_MODEL_CUSTOM_DEPTH.md` is followed: trigger â†’ flow chain â†’ entity mutations â†’ UI impact â†’ security â†’ external dependencies â†’ known unknowns.
5. All existing quality gate checks still pass after the change.
6. The semantic benchmark score does not decrease.
7. Determinism is preserved: same input produces the same output.

## Scope

### Files to Modify

1. `KnowledgeBase-Creator/wizard/run-kb-compose.ps1` â€” the only file that needs changes.

### Specific Code Locations

The Tier 1 narrative generation is at approximately lines 980-993 in the composer. The current code:

```powershell
foreach ($f in @($moduleFlows | Where-Object { $_.tier -eq 1 } | Sort-Object localName)) {
    $intent = if ($f.localName.StartsWith("ACT_")) { "User action flow" }
              elseif ($f.localName.StartsWith("VAL_")) { "Validation flow" }
              elseif ($f.localName.StartsWith("ACR_")) { "Access/creation orchestration flow" }
              else { "Behaviour-critical flow" }
    $tier1Sections.Add(@"
### $($f.qualifiedName)

- Intent: $intent.
- Trigger\entry: microflow/nanoflow entry based on caller or UI action.
- Inputs\outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read\write entities: $(Join-OrDefault -Items $f.touchesEntities -Default "none from export token evidence").
- UI interactions (shown pages): $(Join-OrDefault -Items $f.shownPages -Default "none").
- Calls\called-by: out=$($f.fanOut), in=$($f.fanIn).
- Security constraints: module roles derived via page permissions and entity access rules.
- Failure\rollback notes: ...
"@) | Out-Null
}
```

### Required Changes

#### Step 1: Load `pseudocode` field during fact-building

When building `$flowList` / `$flowFacts` (approximately lines 230-350), the composer iterates flow objects from JSON. Add `pseudocode` to the fact object for each flow. The raw flow JSON structure is:

```json
{
  "flowId": "...",
  "kind": "Microflow",
  "qualifiedName": "SmartExpenses.ACT_BudgetType_Save",
  "module": "SmartExpenses",
  "nodes": [...],
  "edges": [...],
  "calls": [...],
  "pseudocode": "FLOW Microflow: SmartExpenses.ACT_BudgetType_Save\nNODES=12; EDGES=9\n1. START\n2. RetrieveAction: retrieve ...\n..."
}
```

Capture `$flow.pseudocode` and store it on the fact object.

#### Step 2: Derive a specific intent summary from pseudocode

Write a function `Get-FlowIntentSummary` that takes the pseudocode string and returns a 1-2 sentence intent description. Logic:

1. Parse the pseudocode lines (split on `\n`).
2. Skip the header line (`FLOW Microflow: ...`) and the stats line (`NODES=...; EDGES=...`).
3. Skip `START` and `END` nodes.
4. Collect the first 3-5 meaningful action lines (CreateObjectAction, RetrieveAction, ChangeObjectAction, ShowPageAction, MicroflowCallAction, ExclusiveSplit, ShowMessageAction, etc.).
5. Build a concise summary sentence from these key actions. For example:
   - If the flow starts with a `CreateObjectAction` for `SmartExpenses.BudgetType`, the intent is "Creates a new BudgetType entity...".
   - If the flow contains `ShowPageAction`, include "...and shows the [PageName] page".
   - If the flow contains `ExclusiveSplit` with a validation expression, include "Validates that...".
   - If the flow only calls other flows, include "Orchestrates [called flow names]".
6. Keep the summary deterministic â€” same pseudocode always produces the same intent string.
7. Fallback: if pseudocode is empty/null, fall back to the current prefix-based label ("User action flow" etc.).

#### Step 3: Include pseudocode as a "Logic steps" section in each Tier 1 narrative

Replace the current boilerplate narrative with a richer structure:

```markdown
### SmartExpenses.ACT_BudgetType_Save

- **Intent**: [derived from Get-FlowIntentSummary].
- **Trigger**: [microflow/nanoflow] entry; called by [caller names or "UI action"].
- **Read/write entities**: [from existing touchesEntities evidence].
- **UI interactions**: [from existing shownPages evidence].
- **Calls/called-by**: out=[fanOut], in=[fanIn]. [If fanIn > 0, list caller names.]
- **Security**: [from existing role derivation].
- **Rollback**: [from existing rollback hint logic].

<details>
<summary>Logic steps (from export pseudocode)</summary>

```
[pseudocode content, trimmed of the FLOW header and NODES/EDGES stats line]
```

</details>
```

#### Step 4: For Tier 2 flows, include a shortened pseudocode (first 5 lines only)

Tier 2 flows currently have no narrative section. Add a brief behavioural summary:

```markdown
### SmartExpenses.DS_BudgetType_ByFBGProfile

- **Intent**: [derived intent summary].
- **Key actions**: [first 3 action lines from pseudocode, one-line each].
```

#### Step 5: Enhance the "Called by" information

Currently only counts are shown (`in=3`). When a flow has inbound callers, list the caller qualified names. The data is available from `$flowFacts` â€” for each flow in the call graph, the callers are known. Include the names, especially flagging cross-module callers.

### What NOT to Change

1. Do not change the Tier 1/2/3 classification logic â€” it is correct.
2. Do not change the flow catalogue tables â€” they are correct.
3. Do not change the existing `touchesEntities` or `shownPages` derivation â€” those remain as-is.
4. Do not change any other KB files (DOMAIN.md, PAGES.md, etc.) in this prompt.
5. Do not modify the quality gate or benchmark scripts.
6. Do not add external dependencies.

## Verification Steps

After implementing:

1. Run the full pipeline:
   ```powershell
   cd KnowledgeBase-Creator
   .\run-dump-parser.ps1
   ```
2. Open `mendix-data/knowledge-base/SmartExpenses/modules/SmartExpenses/FLOWS.md`.
3. Verify that Tier 1 narratives are now unique per flow and contain pseudocode steps.
4. Verify that the intent line is specific (not "User action flow").
5. Verify that `run-kb-quality-gate.ps1` still passes.
6. Verify that `run-kb-semantic-benchmark.ps1` still scores >= 85.
7. Spot-check three specific flows:
   - `SmartExpenses.ACT_Transaction_NewEdit_Save` â€” should now show its save logic.
   - `SmartExpenses.SUB_Transaction_setStatus` â€” should now show its status-setting logic.
   - `SmartExpenses.ACR_FBGProfile_setStandardBudgets` â€” should show the BudgetType/BudgetTerm creation loop.
8. Verify determinism: run the composer twice on the same input and diff the output. Must be identical.

## Exit Criteria

1. All Tier 1 narratives contain unique, flow-specific content derived from pseudocode.
2. No boilerplate "User action flow" / "Behaviour-critical flow" strings remain as sole intent descriptions.
3. Quality gate passes.
4. Benchmark score >= 85.
5. Deterministic output confirmed.

## Estimated Scope

Changes are confined to `run-kb-compose.ps1`:

- Add 1 new function (`Get-FlowIntentSummary`, ~30-50 lines).
- Modify 1 existing code block (Tier 1 narrative generation, ~30 lines â†’ ~50 lines).
- Add 1 new code block (Tier 2 brief summary, ~15 lines).
- Modify fact-building loop to capture `pseudocode` field (~2 lines).

