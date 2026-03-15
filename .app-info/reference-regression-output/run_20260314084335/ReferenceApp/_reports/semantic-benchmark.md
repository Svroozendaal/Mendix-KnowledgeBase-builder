# Semantic Benchmark Report

## Summary

- App: ReferenceApp
- KB Root: reference/ReferenceApp
- Generated at: 2026-03-05T00:00:00Z
- Structural score: 80 / 100 (min 80), critical failures: 1, passed: False
- Custom benchmark: skipped
- Final weighted score: 80 / 100
- Weights: structural=0.7, custom=0.3
- Final verdict: False

## Structural Benchmark

| Check | Critical | Status | Evidence hits | Score |
|---|---|---|---|---|
| S1 | True | FAIL | 0/1 | 0/10 |
| S2 | True | PASS | 1/1 | 10/10 |
| S3 | True | PASS | 1/1 | 10/10 |
| S4 | False | PASS | 1/1 | 10/10 |
| S5 | False | PASS | 1/1 | 10/10 |
| S6 | False | PASS | 1/1 | 10/10 |
| S7 | False | PASS | 1/1 | 10/10 |
| S8 | False | PASS | 1/1 | 10/10 |
| S9 | False | FAIL | 0/1 | 0/10 |
| S10 | False | PASS | 1/1 | 10/10 |

### Structural Evidence Details

| Check | Question | Evidence evaluation |
|---|---|---|
| S1 | At least one custom flow has a Tier 1 deep narrative. | No custom module with Tier 1 deep narrative detected. |
| S2 | Entity lifecycle matrix exists and is non-empty for every custom module. | 1/1 custom modules contain non-empty lifecycle evidence. |
| S3 | Cross-module dependency table has non-zero rows when callEdges exist. | Source cross-module edges=1; index has rows=True. |
| S4 | Page-flow linkage rows are non-Unknown where show-page evidence exists. | 1/1 pages linked with non-Unknown flows. |
| S5 | Security role-to-module-role matrix is populated. | Role matrix populated=True. |
| S6 | ROUTING.md known-gaps section exists and is honest. | HasKnownGaps=True; UnknownTodoCount=0; Honest=True. |
| S7 | READER.md confidence legend is present. | Confidence legend present=True. |
| S8 | At least one route index has non-Unknown cross-references. | Route cross-reference evidence present=True. |
| S9 | Hub/leaf classification exists in cross-module.md. | Hub/leaf section present=False. |
| S10 | Source metadata files are present and non-empty. | Manifest+source-ref populated=True. |

## App-Specific Benchmark

Not run (no -CustomScenarios provided).



### App-Specific Evidence Details
