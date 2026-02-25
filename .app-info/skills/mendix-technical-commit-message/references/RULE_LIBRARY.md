# RULE_LIBRARY

This file is the evolving rule set for technical commit message rendering.

## Rule Schema

Use this schema for each rule:

- `Rule ID`: Stable identifier (`R001`, `R002`, ...)
- `Applies to`: category + element type + change type
- `Match condition`: How to detect the pattern in source data
- `Output template`: Exact rendered line format
- `Example input`
- `Example output`

## Rules

### R001 - Domain Model Entity Added with Attributes

- Rule ID: `R001`
- Applies to: `domainModel`, `elementType = Entity`, `changeType = Added`
- Match condition:
  - `details` contains `attributes added`
- Output template:
  - `- DM : <EntityName>: added with attributes '<AttributeList>'`
- Example input:
  - `elementName = SmartExpenses.New_entity`
  - `details = attributes added (1): newAttribute`
- Example output:
  - `- DM : New_entity: added with attributes 'newAttribute'`

### R002 - Microflow Modified with Retrieve, Change, Commit Actions

- Rule ID: `R002`
- Applies to: `microflows`, `elementType = Microflow`, `changeType = Modified`
- Match condition:
  - `details` contains one or more of:
    - `RetrieveAction:`
    - `ChangeObjectAction:`
    - `CommitAction:`
- Output template:
  - `- <MicroflowName> : retrieve <RetrieveSummary>, change <ChangeSummary>, commit <CommitSummary>`
- Parsing notes:
  - `RetrieveSummary`: extract object/entity target from `RetrieveAction`.
  - `ChangeSummary`: extract changed object and key fields from `ChangeObjectAction`.
  - `CommitSummary`: extract committed object from `CommitAction`.
  - Keep action order as retrieve -> change -> commit when present.
- Example input:
  - `elementName = SmartExpenses.ACT_Balance_Create`
  - `details` includes:
    - `RetrieveAction: retrieve User over association Session_User from currentSession`
    - `ChangeObjectAction: change currentSession (SessionId='test'; refreshInClient=false)`
    - `CommitAction: commit currentSession (refreshInClient=false, withEvents=true)`
- Example output:
  - `- ACT_Balance_Create : retrieve User object, change currentSession (SessionId), commit currentSession`

### R003 - New Flow (Microflow or Nanoflow)

- Rule ID: `R003`
- Applies to: `microflows|nanoflows`, `elementType = Microflow|Nanoflow`, `changeType = Added`
- Match condition:
  - Flow is added.
  - If action details exist, parse with the same action-summary logic as modified microflows.
- Output template:
  - `- New <FlowName> : <FlowSummary>`
- Parsing notes:
  - Microflow and nanoflow rules are the same.
  - Keep flow summary order as retrieve -> change -> commit when present.
  - If no flow details are present, use `added`.
- Example input:
  - `elementName = SmartExpenses.NEW_MICROFLOW_test`
  - `details` includes `ChangeObjectAction`, `CommitAction`, and `RetrieveAction`.
- Example output:
  - `- New NEW_MICROFLOW_test : retrieve User object, change currentSession (SessionId), commit currentSession`

### R004 - New Enumeration

- Rule ID: `R004`
- Applies to: `resources`, `elementType = Enumeration`, `changeType = Added`
- Match condition:
  - Enumeration is added.
- Output template:
  - `- New ENUM : <EnumerationName>`
- Example input:
  - `elementName = SmartExpenses.NEW_ENUMMMERATION`
- Example output:
  - `- New ENUM : NEW_ENUMMMERATION`

### R005 - New Export Mapping

- Rule ID: `R005`
- Applies to: `resources`, `elementType = ExportMapping`, `changeType = Added`
- Match condition:
  - Export mapping is added.
- Output template:
  - `- New EM : <MappingName>`
- Example input:
  - `elementName = SmartExpenses.NEW_ExportMapping`
- Example output:
  - `- New EM : NEW_ExportMapping`

### R006 - New Import Mapping

- Rule ID: `R006`
- Applies to: `resources`, `elementType = ImportMapping`, `changeType = Added`
- Match condition:
  - Import mapping is added.
- Output template:
  - `- New IM : <MappingName>`
- Example input:
  - `elementName = SmartExpenses.NEW_ImportMapping`
- Example output:
  - `- New IM : NEW_ImportMapping`

### R007 - New Workflow

- Rule ID: `R007`
- Applies to: `resources`, `elementType = Workflow`, `changeType = Added`
- Match condition:
  - Workflow is added.
- Output template:
  - `- New WF : <WorkflowName>`
- Example input:
  - `elementName = SmartExpenses.NEW_WORKFLOW`
- Example output:
  - `- New WF : NEW_WORKFLOW`

## Pending Rule Slots

- `R008` next available
