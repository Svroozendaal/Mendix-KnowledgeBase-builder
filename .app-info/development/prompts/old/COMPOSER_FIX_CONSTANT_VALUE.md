# PROMPT 03: Fix Constant defaultValue Bug

## Priority

High â€” this is a data-loss bug where available information is silently dropped.

## Context

Read before starting:

1. `.agents/AGENTS.md` and `.agents/FRAMEWORK.md`
2. `.app-info/product-plan/05-KB_COMPOSER_SPEC.md` â€” composer specification.

## Problem Statement

The composer renders constant values in `RESOURCES.md` with an empty "Value" column despite the raw JSON containing the `defaultValue` field. This is a field-name mismatch bug.

### Raw JSON structure (`resources.json`):

```json
{
  "constants": [
    {
      "qualifiedName": "ImporterHelper.CONST_RESTTransactionURL",
      "name": "CONST_RESTTransactionURL",
      "type": "StringType",
      "defaultValue": "http://localhost:8079/rest/restproducts/v1/transaction",
      "documentation": null,
      "exposedToClient": false
    }
  ]
}
```

### Current composer code (line ~1104):

```powershell
$constantRows.Add("| $([string]$c.name) | $([string]$c.type) | $(Escape-Md ([string]$c.value)) |") | Out-Null
```

The bug: `$c.value` should be `$c.defaultValue`. The field `value` does not exist on constant objects, so PowerShell resolves it to `$null` and the column renders empty.

### Current KB output (`ImporterHelper/RESOURCES.md`):

```markdown
| CONST_RESTTransactionURL | StringType |  |
```

### Expected KB output:

```markdown
| CONST_RESTTransactionURL | StringType | http://localhost:8079/rest/restproducts/v1/transaction |
```

## Entry Criteria

1. Composer script exists at `KnowledgeBase-Creator/wizard/run-kb-compose.ps1`.
2. At least one module has constants in its `resources.json` (ImporterHelper has 1).

## Acceptance Criteria

1. Constants in `RESOURCES.md` show their `defaultValue` in the "Value" column.
2. The `exposedToClient` flag is surfaced as an additional column or inline marker.
3. The `documentation` field is surfaced when non-null.
4. Quality gate and benchmark still pass.

## Scope

### Files to Modify

1. `KnowledgeBase-Creator/wizard/run-kb-compose.ps1` â€” single line fix plus minor enhancements.

### Specific Changes

#### Fix 1: Correct the field name (critical, 1 line)

At approximately line 1104, change:

```powershell
# BEFORE (buggy):
$(Escape-Md ([string]$c.value))

# AFTER (fixed):
$(Escape-Md ([string]$c.defaultValue))
```

#### Fix 2: Add `exposedToClient` indicator

The `exposedToClient` flag indicates whether a constant's value is visible in the browser (a security concern). Add it to the table:

```powershell
$exposed = if ($c.exposedToClient -eq $true) { "Yes" } else { "No" }
$constantRows.Add("| $([string]$c.name) | $([string]$c.type) | $(Escape-Md ([string]$c.defaultValue)) | $exposed |") | Out-Null
```

Update the table header to match:

```markdown
| Name | Type | Default Value | Exposed to Client |
|---|---|---|---|
```

#### Fix 3: Add documentation when available

If `$c.documentation` is non-null and non-empty, append it in a secondary row or as a tooltip-style note. Keep it simple â€” an extra column or an inline note after the value:

```powershell
$doc = if (-not [string]::IsNullOrWhiteSpace([string]$c.documentation)) { " â€” $([string]$c.documentation)" } else { "" }
```

#### Fix 4: Update the template file

Update `KnowledgeBase-Creator/artifacts/MODULE_RESOURCES_TEMPLATE.md` to match the new table header format so the scaffold and quality gate heading contracts stay consistent.

### What NOT to Change

1. Do not change scheduled events or other resources rendering in this prompt.
2. Do not change the `RESOURCES.md` file structure beyond the constants table.
3. Do not modify any other KB files.

## Verification Steps

After implementing:

1. Run the full pipeline:
   ```powershell
   cd KnowledgeBase-Creator
   .\run-dump-parser.ps1
   ```
2. Open `mendix-data/knowledge-base/SmartExpenses/modules/ImporterHelper/RESOURCES.md`.
3. Verify that `CONST_RESTTransactionURL` shows its value: `http://localhost:8079/rest/restproducts/v1/transaction`.
4. Verify the `Exposed to Client` column shows `No`.
5. Open `mendix-data/knowledge-base/SmartExpenses/modules/SmartExpenses/RESOURCES.md` â€” constants section should still show `none` (SmartExpenses has no constants).
6. Verify quality gate passes.
7. Verify benchmark score >= 85.

## Exit Criteria

1. Constant `defaultValue` renders correctly in all module `RESOURCES.md` files.
2. `exposedToClient` column present.
3. Template file updated to match.
4. Quality gate passes.
5. Benchmark score >= 85.

## Estimated Scope

Minimal change:

- Fix 1 property name on 1 line.
- Add 1 column to constant table rendering (~3 lines).
- Update 1 template file header.

