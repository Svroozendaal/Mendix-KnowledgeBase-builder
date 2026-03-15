# Semantic Benchmark Report

## Summary

- App: SmartExpenses
- KB Root: C:\Workspaces\Mendix-KnowledgeBase-builder\.app-info\smartexpenses-regression-output\run_20260314092612\mendix-data\knowledge-base
- Generated at: 2026-03-14T09:27:09Z
- Structural score: 100 / 100 (min 80), critical failures: 0, passed: True
- Custom score: 100 / 100 (min 85), critical failures: 0, passed: True
- Final weighted score: 100 / 100
- Weights: structural=0.7, custom=0.3
- Final verdict: True

## Structural Benchmark

| Check | Critical | Status | Evidence hits | Score |
|---|---|---|---|---|
| S1 | True | PASS | 1/1 | 10/10 |
| S2 | True | PASS | 3/3 | 10/10 |
| S3 | True | PASS | 1/1 | 10/10 |
| S4 | False | PASS | 9/9 | 10/10 |
| S5 | False | PASS | 1/1 | 10/10 |
| S6 | False | PASS | 1/1 | 10/10 |
| S7 | False | PASS | 1/1 | 10/10 |
| S8 | False | PASS | 1/1 | 10/10 |
| S9 | False | PASS | 1/1 | 10/10 |
| S10 | False | PASS | 1/1 | 10/10 |

### Structural Evidence Details

| Check | Question | Evidence evaluation |
|---|---|---|
| S1 | At least one custom flow has a Tier 1 deep narrative. | Tier 1 narrative found in module ImporterHelper. |
| S2 | Entity lifecycle matrix exists and is non-empty for every custom module. | 3/3 custom modules contain non-empty lifecycle evidence. |
| S3 | Cross-module dependency table has non-zero rows when callEdges exist. | Source cross-module edges=11; index has rows=True. |
| S4 | Page-flow linkage rows are non-Unknown where show-page evidence exists. | 9/9 pages linked with non-Unknown flows. |
| S5 | Security role-to-module-role matrix is populated. | Role matrix populated=True. |
| S6 | ROUTING.md known-gaps section exists and is honest. | HasKnownGaps=True; UnknownTodoCount=291; Honest=True. |
| S7 | READER.md confidence legend is present. | Confidence legend present=True. |
| S8 | At least one route index has non-Unknown cross-references. | Route cross-reference evidence present=True. |
| S9 | Hub/leaf classification exists in cross-module.md. | Hub/leaf section present=True. |
| S10 | Source metadata files are present and non-empty. | Manifest+source-ref populated=True. |

## App-Specific Benchmark

Executed from: C:\Workspaces\Mendix-KnowledgeBase-builder\KnowledgeBase-Creator\benchmarks\smartexpenses-custom-scenarios.json

| Check | Critical | Status | Evidence hits | Score |
|---|---|---|---|---|
| Q1 | True | PASS | 2/2 | 10/10 |
| Q2 | True | PASS | 3/3 | 10/10 |
| Q3 | True | PASS | 2/2 | 10/10 |
| Q4 | False | PASS | 2/2 | 10/10 |
| Q5 | False | PASS | 1/1 | 10/10 |
| Q6 | False | PASS | 2/2 | 10/10 |
| Q7 | True | PASS | 2/2 | 10/10 |
| Q8 | False | PASS | 2/2 | 10/10 |
| Q9 | True | PASS | 2/2 | 10/10 |
| Q10 | False | PASS | 2/2 | 10/10 |

### App-Specific Evidence Details

| Check | Question | Evidence evaluation |
|---|---|---|
| Q1 | How is a transaction created and saved? | modules/SmartExpenses/FLOWS.md: ok ; modules/SmartExpenses/PAGES.md: ok |
| Q2 | Which flows can change SmartExpenses.Transaction and under which role constraints? | modules/SmartExpenses/DOMAIN.md: ok ; modules/SmartExpenses/FLOWS.md: ok ; app/SECURITY.md: ok |
| Q3 | What does ImporterHelper call in SmartExpenses? | routes/cross-module.md: ok ; app/CALL_GRAPH.md: ok |
| Q4 | Which pages are shown during budget type management? | modules/SmartExpenses/PAGES.md: ok ; routes/by-page.md: ok |
| Q5 | What entity lifecycle exists for BudgetTerm? | modules/SmartExpenses/DOMAIN.md: ok |
| Q6 | Which user roles can access parent home paths? | app/SECURITY.md: ok ; routes/by-page.md: ok |
| Q7 | Where is transaction status determined? | modules/SmartExpenses/FLOWS.md: ok ; routes/by-flow.md: ok |
| Q8 | What scheduled/system automation affects custom modules? | modules/SmartExpenses/RESOURCES.md: ok ; routes/cross-module.md: ok |
| Q9 | Which module is the custom orchestration hub? | app/CALL_GRAPH.md: ok ; routes/cross-module.md: ok |
| Q10 | What is still unknown and why? | READER.md: ok ; modules/SmartExpenses/README.md: ok |
