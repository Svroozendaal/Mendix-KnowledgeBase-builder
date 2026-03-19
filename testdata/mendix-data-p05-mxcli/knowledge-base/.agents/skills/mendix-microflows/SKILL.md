# SKILL: Mendix Microflows Reference

## Purpose

Comprehensive reference for Mendix microflow activities, configuration, error handling, and transaction behaviour. Use this skill to write correct microflow instructions in implementation plans.

## Used By

Mendix Syntax, Mendix Developer, Todo Maker, Best Practice Recommender

## When to Use

- Describing microflow steps in an implementation plan.
- Specifying activity configurations (retrieves, creates, changes, commits).
- Defining error handling strategy for a flow.
- Understanding transaction behaviour and commit timing.

## Microflow Activities Reference

### Object Activities

#### Create Object

Creates a new object in memory (not yet persisted).

```
Activity: Create object
Entity: Module.EntityName
Member initialisation:
  - AttributeName = value / $variable / expression
  - Association = $associatedObject
Output variable: $NewEntity
```

- Object exists only in memory until committed.
- Set initial attribute values and associations here.
- Use `commit` separately or rely on an end-of-flow auto-commit.

#### Change Object

Modifies attributes or associations of an existing object.

```
Activity: Change object
Variable: $Entity
Commit: Yes / No
Refresh in client: Yes / No
Members:
  - AttributeName = newValue
  - Association = $otherObject
```

- **Commit: Yes** — immediately persists to database and fires after-commit events.
- **Commit: No** — changes stay in memory; must be committed separately or at end of flow.
- **Refresh in client: Yes** — pushes changes to the UI immediately.

#### Commit Object(s)

Persists object changes to the database.

```
Activity: Commit object(s)
Variable: $Entity or $EntityList
With events: Yes / No
```

- **With events: Yes** — fires before-commit and after-commit event handlers.
- **With events: No** — skips event handlers (use sparingly, e.g., bulk operations).
- Commits everything in the current transaction context.

#### Delete Object(s)

Removes object(s) from the database.

```
Activity: Delete object(s)
Variable: $Entity or $EntityList
Refresh in client: Yes / No
```

- Cascades delete through associations configured with "delete" behaviour (owner/delete-referred-object).
- Raises before-delete and after-delete events.

#### Rollback Object

Reverts uncommitted changes to an object.

```
Activity: Rollback object
Variable: $Entity
Refresh in client: Yes / No
```

- Restores the object to its last committed state.
- Useful in validation flows when the user cancels.

### Retrieve Activities

#### Retrieve from Database

```
Activity: Retrieve
Source: Database
Entity: Module.EntityName
XPath constraint: [constraint expression]
Range: All / First / Custom
  Custom: Offset = N, Amount = M
Sorting:
  - AttributeName: Ascending / Descending
Output variable: $EntityList or $Entity (if First)
```

- Retrieves committed data from the database.
- Applies entity access rules automatically.
- Use **First** when expecting a single result.

#### Retrieve by Association

```
Activity: Retrieve
Source: By association
Starting object: $ParentEntity
Association: Module.Association_Name
Output variable: $AssociatedEntity or $AssociatedList
```

- Follows an association from a starting object.
- Returns the associated object(s) from memory or database.
- Faster than an XPath retrieve when you already have the parent object.

### Flow Control Activities

#### Exclusive Split (Decision)

```
Activity: Exclusive split
Expression: $Entity/Attribute = 'value'
           or: $Variable > 0
           or: $Entity != empty
Paths:
  True -> [activities]
  False -> [activities]
```

- Evaluates a boolean expression.
- Exactly one path is followed.
- For enumeration splits, each enum value becomes a path.

#### Enumeration Split

```
Activity: Exclusive split
Expression: $Entity/Status
Type: Enumeration split
Paths:
  Open -> [activities]
  InProgress -> [activities]
  Closed -> [activities]
```

#### Merge

```
Activity: Merge
```

- Joins multiple execution paths back into a single flow.
- No configuration needed — it is a connector.

#### Loop

```
Activity: Loop
Iterate over: $EntityList
Loop variable: $IteratorEntity
```

- Executes the contained activities once per item in the list.
- The loop variable is scoped to the loop body.

### Integration Activities

#### Call Microflow

```
Activity: Call microflow
Microflow: Module.MicroflowName
Parameters:
  - ParameterName = $variable
Output variable: $Result (if the called flow returns a value)
```

#### Call REST Service

```
Activity: Call REST service
Location: URL or from consumed REST service
HTTP method: GET / POST / PUT / PATCH / DELETE
Request:
  Headers: [key-value pairs]
  Body: $Variable or custom mapping
Response:
  Import mapping: Module.MappingName
  Output variable: $ResponseEntity
```

#### Call Web Service

```
Activity: Call web service
Operation: Module.ServiceName.OperationName
Request mapping: Module.RequestMapping
Response mapping: Module.ResponseMapping
Output variable: $ResponseEntity
```

### Client Activities

#### Show Page

```
Activity: Show page
Page: Module.PageName
Object to pass: $Entity (optional)
```

- Opens a page in the client.
- If the page expects a context object, pass it.

#### Show Message

```
Activity: Show message
Template: "Message text with {1} placeholders"
Parameters: $Variable1, $Variable2
Type: Information / Warning / Error
Blocking: Yes / No
```

#### Close Page

```
Activity: Close page
Number of pages: 1 (or more)
```

#### Validation Feedback

```
Activity: Validation feedback
Variable: $Entity
Member: AttributeName
Template: "Validation message"
```

- Highlights the specified attribute on the page with an error message.
- Use in validation microflows to show field-level errors.

### Variable Activities

#### Create Variable

```
Activity: Create variable
Data type: String / Integer / Decimal / Boolean / DateTime / Enumeration
Value: expression
Output variable: $VariableName
```

#### Change Variable

```
Activity: Change variable
Variable: $VariableName
Value: new expression
```

### List Activities

#### List Operation

```
Activity: List operation
Operation: Union / Intersect / Subtract / Contains / Head / Tail / Sort / Filter / Find / Map
List: $EntityList
```

#### Aggregate List

```
Activity: Aggregate list
List: $EntityList
Function: Sum / Average / Count / Minimum / Maximum
Attribute: AttributeName (except Count)
Output variable: $Result
```

## Microflow Parameters

```
Parameter: Module.EntityName or primitive type
Name: $ParameterName
```

- Entity parameters pass the object by reference (changes affect the original).
- Primitive parameters (String, Integer, Boolean, etc.) pass by value.
- Parameters are defined in the microflow properties, not as activities.

## Return Values

```
Return type: Boolean / String / Entity / List / Void / Enumeration
Return value: $Variable or expression
```

- Set in the End Event of the microflow.
- Void (Nothing) microflows have no return value.

## Error Handling

### Error Handler on Activities

Each activity can have an error handler:

| Setting | Behaviour |
|---|---|
| **Abort** (default) | Rolls back the entire transaction and shows error to user |
| **Custom without rollback** | Continues to a custom error path; transaction stays open |
| **Custom with rollback** | Rolls back, then continues to a custom error path |
| **Continue** | Ignores the error and continues the main path |

### Error Handling Best Practices

1. **Always add error handling to external calls** (REST, web service, Java actions).
2. **Use Custom without rollback** when you want to log the error and continue.
3. **Use Custom with rollback** when the error invalidates all prior changes in the flow.
4. **Create a `$LatestError` variable** in the custom error path — Mendix populates it automatically with the error message.

## Transaction Behaviour

1. A microflow runs in a **single database transaction** by default.
2. All changes are committed at the end of a successful execution.
3. If an error occurs without custom handling, **everything rolls back**.
4. **Explicit commits** (Commit activity) flush to the database immediately — they are NOT rolled back on later errors.
5. Sub-microflows share the same transaction as the caller by default.

## Microflow Naming Conventions

| Prefix | Purpose | Example |
|---|---|---|
| `ACT_` | User-triggered action | `ACT_Order_Submit` |
| `DS_` | Data source for a page widget | `DS_Order_GetOpenOrders` |
| `VAL_` | Validation (before-commit or explicit) | `VAL_Order_CheckRequiredFields` |
| `SUB_` | Reusable sub-microflow | `SUB_Email_Send` |
| `SE_` | Scheduled event handler | `SE_Order_CleanupExpired` |
| `OCH_` | On-change event handler | `OCH_Order_StatusChanged` |
| `ACO_` | After-commit event handler | `ACO_Order_SendNotification` |
| `BCO_` | Before-commit event handler | `BCO_Order_SetDefaults` |
| `BDE_` | Before-delete event handler | `BDE_Order_CheckDeletable` |

## Notes

- Microflows execute on the **server** (Mendix Runtime).
- They have full access to the database, external services, and Java actions.
- Use nanoflows for client-side logic instead (see `mendix-nanoflows` skill).
- Each microflow activity should do one thing. Keep flows readable by extracting complex logic into sub-microflows.
