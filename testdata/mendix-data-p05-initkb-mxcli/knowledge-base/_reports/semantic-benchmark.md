# Semantic Benchmark Report

## Summary

- App: Emixa_InspectionApp_P05_InitKb_MxCli
- KB Root: C:\Workspaces\Mendix-KnowledgeBase-builder-mendix-cli-implementation\mendix-data-p05-initkb-mxcli\knowledge-base
- Generated at: 2026-03-18T20:48:20Z
- Structural score: 100 / 100 (min 80), critical failures: 0, passed: True
- Custom benchmark: skipped
- Final weighted score: 100 / 100
- Weights: structural=0.7, custom=0.3
- Final verdict: True

## Structural Benchmark

| Check | Critical | Status | Evidence hits | Score |
|---|---|---|---|---|
| S1 | True | PASS | 1/1 | 10/10 |
| S2 | True | PASS | 2/2 | 10/10 |
| S3 | True | PASS | 1/1 | 10/10 |
| S4 | False | PASS | 8/8 | 10/10 |
| S5 | False | PASS | 1/1 | 10/10 |
| S6 | False | PASS | 1/1 | 10/10 |
| S7 | False | PASS | 1/1 | 10/10 |
| S8 | False | PASS | 1/1 | 10/10 |
| S9 | False | PASS | 1/1 | 10/10 |
| S10 | False | PASS | 1/1 | 10/10 |

### Structural Evidence Details

| Check | Question | Evidence evaluation |
|---|---|---|
| S1 | At least one custom flow has a Tier 1 deep narrative. | Tier 1 narrative found in module Inspection. |
| S2 | Entity lifecycle matrix exists and is non-empty for every custom module. | 2/2 custom modules contain non-empty lifecycle evidence. |
| S3 | Cross-module dependency table has non-zero rows when callEdges exist. | Source cross-module edges=5; index has rows=True. |
| S4 | Page-flow linkage rows are non-Unknown where show-page evidence exists. | 8/8 pages linked with non-Unknown flows. |
| S5 | Security role-to-module-role matrix is populated. | Role matrix populated=True. |
| S6 | ROUTING.md known-gaps section exists and is honest. | HasKnownGaps=True; UnknownTodoCount=101; Honest=True. |
| S7 | READER.md confidence legend is present. | Confidence legend present=True. |
| S8 | At least one route index has non-Unknown cross-references. | Route cross-reference evidence present=True. |
| S9 | Hub/leaf classification exists in cross-module.md. | Hub/leaf section present=True. |
| S10 | Source metadata files are present and non-empty. | Manifest+source-ref populated=True. |

## App-Specific Benchmark

Not run (no -CustomScenarios provided).



### App-Specific Evidence Details
