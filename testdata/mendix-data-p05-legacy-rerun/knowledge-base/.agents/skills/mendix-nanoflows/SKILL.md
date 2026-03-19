# SKILL: Mendix Nanoflows Reference

## Purpose

Reference for Mendix nanoflow capabilities, limitations, and when to choose nanoflows over microflows. Use this skill to correctly specify nanoflow-based logic in implementation plans.

## Used By

Mendix Syntax, Mendix Developer, Best Practice Recommender

## When to Use

- Deciding whether to implement logic as a nanoflow or microflow.
- Specifying nanoflow activities in an implementation plan.
- Reviewing client-side logic patterns.

## Nanoflow vs Microflow

| Aspect | Microflow | Nanoflow |
|---|---|---|
| Execution | Server (Mendix Runtime) | Client (browser / device) |
| Database access | Full (retrieve, commit, delete) | Limited (retrieve from client cache or database, commit, delete) |
| Performance | Network round-trip per call | Instant (no server call) |
| Offline support | No (requires server) | Yes (operates on local database) |
| Java actions | Yes | No |
| External service calls | REST, SOAP, OData | REST only (via Call REST in nanoflow) |
| Error handling | Full (abort, custom, continue) | Limited (no custom with rollback) |
| Transaction | Full database transaction | No transaction support |
| Security | Entity access rules enforced server-side | Client-side only; access rules apply on sync |

## When to Use Nanoflows

1. **Quick UI logic** — show/hide elements, toggle visibility, format values.
2. **Offline-first apps** — all logic that must work without connectivity.
3. **Client-side validation** — instant feedback without server call.
4. **Navigation actions** — open pages, close pages, show messages.
5. **Simple data manipulation** — change attribute values on objects already in client memory.
6. **Performance-sensitive actions** — button clicks, on-change handlers where latency matters.

## When NOT to Use Nanoflows

1. **Complex business logic** — use a microflow for multi-step operations.
2. **Batch operations** — nanoflows do not have efficient bulk processing.
3. **Operations requiring Java actions** — only microflows can call Java.
4. **Operations needing transaction rollback** — nanoflows have no transaction support.
5. **Scheduled events** — only microflows can be scheduled.
6. **Before/after commit events** — entity event handlers must be microflows.
7. **Security-sensitive operations** — nanoflows run on the client and can be inspected.

## Available Nanoflow Activities

### Supported (same as microflow)

- Create object
- Change object
- Commit object(s)
- Delete object(s)
- Retrieve (from database or by association)
- Exclusive split / Merge
- Loop
- Create variable / Change variable
- Show page / Close page
- Show message
- Validation feedback
- Call nanoflow
- Call microflow (triggers server round-trip)
- Log message

### Nanoflow-Only Activities

- **Call JavaScript action** — execute a custom JavaScript action (for native mobile or web).

### NOT Available in Nanoflows

- Call web service (SOAP)
- Import/export mapping (XML)
- Java action call
- Generate document
- Download file

## Nanoflow Data Retrieval

### From Client Cache

```
Activity: Retrieve
Source: Database
Entity: Module.EntityName
XPath constraint: [constraint]
```

- In an **online app**, this queries the server database.
- In an **offline app**, this queries the **local device database**.
- Objects already loaded in the client may be returned from memory.

### By Association

```
Activity: Retrieve
Source: By association
Starting object: $ParentEntity
Association: Module.Association_Name
```

- Follows the association. If the associated object is already in client memory, no server call.
- If not in memory, triggers a lazy load from the server (online only).

## Nanoflow Naming Conventions

- Use the same prefix conventions as microflows.
- Optionally suffix with `_NF` to distinguish: `ACT_Cart_AddItem_NF`.
- Common nanoflow prefixes:
  - `ACT_` — user-triggered client action.
  - `DS_` — data source for a widget.
  - `OCH_` — on-change handler (instant client-side response).
  - `OAF_` — on-after-fill handler.

## Error Handling in Nanoflows

| Setting | Behaviour |
|---|---|
| **Abort** (default) | Shows error dialog to user |
| **Custom without rollback** | Continues to a custom error path |
| **Continue** | Ignores the error and continues |

- **Custom with rollback** is NOT available in nanoflows (no transaction support).
- Always add error handling to `Call microflow` and `Call REST service` activities within nanoflows.

## Common Nanoflow Patterns

### Toggle Visibility

```
Nanoflow: ACT_ToggleFilter_NF
1. Change object: $PageParameter/ShowFilter = not($PageParameter/ShowFilter)
```

### Quick Client Validation

```
Nanoflow: VAL_Order_QuickCheck_NF
1. Exclusive split: $Order/Quantity > 0
   True -> continue
   False -> Validation feedback: "Quantity must be greater than zero"
             Close page (optional)
```

### Open Page with Context

```
Nanoflow: ACT_Customer_ShowDetail_NF
1. Show page: Customer_Detail
   Object to pass: $Customer
```

### Call Server Then Navigate

```
Nanoflow: ACT_Order_Submit_NF
1. Call microflow: ACT_Order_Submit (server-side validation + commit)
2. Exclusive split: $Result = true
   True -> Close page + Show message: "Order submitted"
   False -> Show message: "Submission failed"
```

## Notes

- Nanoflows are defined in the same editor as microflows but run entirely in the client.
- In native mobile apps, nanoflows are the primary flow type.
- Nanoflows can call microflows (triggers a server request) but microflows cannot call nanoflows.
- For offline apps, nanoflows operate on the local SQLite database and sync later.
