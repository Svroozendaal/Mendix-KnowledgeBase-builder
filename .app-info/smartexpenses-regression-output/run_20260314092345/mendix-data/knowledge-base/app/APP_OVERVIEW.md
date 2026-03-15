# App Overview

## Mission Summary

The application centres on the custom modules ImporterHelper, New_Module, SmartExpenses and orchestrates data and UI behaviour through model-driven flows and pages.

Confidence: Inferred

## Core Business Capabilities

| Module | Flow Count | Tier 1 Flows | Detail |
|---|---:|---:|---|
| ImporterHelper | 7 | 5 | [FLOWS](../modules/ImporterHelper/FLOWS.md) |
| New_Module | 2 | 0 | [FLOWS](../modules/New_Module/FLOWS.md) |
| SmartExpenses | 39 | 32 | [FLOWS](../modules/SmartExpenses/FLOWS.md) |

Confidence: Export-backed

## Top Behavioural Entry Points (Top 10)

| Flow | Tier | Impact reason | Link |
|---|---:|---|---|
| SmartExpenses.ACT_Transaction_Recalculate_all | Tier 1 | fan-out 3, writes data | [Flow](../modules/SmartExpenses/FLOWS.md) |
| SmartExpenses.SUB_BudgetTerm_Recalculate | Tier 1 | fan-in 3, writes data | [Flow](../modules/SmartExpenses/FLOWS.md) |
| SmartExpenses.SUB_Balance_Recalculate | Tier 1 | fan-in 3, writes data | [Flow](../modules/SmartExpenses/FLOWS.md) |
| SmartExpenses.ACT_BudgetType_New | Tier 1 | shows UI, writes data | [Flow](../modules/SmartExpenses/FLOWS.md) |
| SmartExpenses.ACR_FBGProfile_setStandardBudgets | Tier 1 | writes data | [Flow](../modules/SmartExpenses/FLOWS.md) |
| SmartExpenses.ACT_Transaction_BulkEditSave | Tier 1 | fan-out 3, writes data | [Flow](../modules/SmartExpenses/FLOWS.md) |
| SmartExpenses.SUB_Transaction_setStatus | Tier 1 | cross-module, fan-in 3 | [Flow](../modules/SmartExpenses/FLOWS.md) |
| SmartExpenses.ACT_StandardBudget_New | Tier 1 | shows UI, writes data | [Flow](../modules/SmartExpenses/FLOWS.md) |
| SmartExpenses.ACT_StandardBudget_Edit | Tier 1 | shows UI, writes data | [Flow](../modules/SmartExpenses/FLOWS.md) |
| ImporterHelper.ACT_ImportTransaction_AcceptTransactions | Tier 1 | cross-module, writes data | [Flow](../modules/ImporterHelper/FLOWS.md) |

Confidence: Inferred

## Source

- Export summary: modules=18, flows=376, entities=109
- Generated at: 2026-03-14T09:23:57.5905497+00:00
