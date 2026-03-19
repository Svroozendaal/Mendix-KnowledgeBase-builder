# SKILL: Mendix XPath Reference

## Purpose

Comprehensive reference for Mendix XPath syntax, operators, tokens, and query patterns. Use this skill to write correct XPath expressions for entity access rules, data retrieval, and page data sources.

## Used By

Mendix Syntax, Mendix Developer, KB Security Reviewer, Best Practice Recommender

## When to Use

- Writing or reviewing XPath access rule constraints.
- Configuring XPath data sources for pages or widgets.
- Writing retrieve activities with XPath constraints in microflows.
- Reviewing or explaining existing XPath expressions from the KB.

## XPath Syntax Fundamentals

### Basic Structure

```
//Module.Entity[constraint]
```

- `//` — required prefix, selects all instances of the entity.
- `Module.Entity` — fully qualified entity name (module dot entity).
- `[constraint]` — optional filter expression in square brackets.

### Attribute Constraints

```xpath
//Sales.Order[Status = 'Open']
//Sales.Order[TotalAmount > 100]
//Sales.Order[OrderDate > '[%BeginOfCurrentDay%]']
//HR.Employee[IsActive = true()]
//HR.Employee[not(IsActive)]
```

### Comparison Operators

| Operator | Meaning | Example |
|---|---|---|
| `=` | Equal | `[Status = 'Active']` |
| `!=` | Not equal | `[Status != 'Cancelled']` |
| `>` | Greater than | `[Amount > 500]` |
| `>=` | Greater or equal | `[Amount >= 500]` |
| `<` | Less than | `[Quantity < 10]` |
| `<=` | Less or equal | `[Quantity <= 10]` |

### Boolean Operators

```xpath
//Sales.Order[Status = 'Open' and TotalAmount > 100]
//Sales.Order[Status = 'Open' or Status = 'Pending']
//Sales.Order[not(Status = 'Cancelled')]
```

- `and` — both conditions must be true.
- `or` — either condition must be true.
- `not()` — negation function.

### Association Traversal

Navigate associations using the fully qualified association name followed by the target entity:

```xpath
//Sales.Order[Sales.Order_Customer/Sales.Customer/Name = 'Acme']
```

**Reading this**: Start from `Order`, follow the `Order_Customer` association to `Customer`, read the `Name` attribute.

**Multi-hop traversal** (chaining associations):

```xpath
//Sales.OrderLine[Sales.OrderLine_Order/Sales.Order/Sales.Order_Customer/Sales.Customer/Name = 'Acme']
```

**Reverse traversal** (child to parent via reference set):

```xpath
//Sales.Customer[Sales.Order_Customer/Sales.Order/Status = 'Open']
```

### System Tokens

| Token | Resolves To | Use Case |
|---|---|---|
| `'[%CurrentUser%]'` | Logged-in user account object | Row-level security, personal data |
| `'[%CurrentObject%]'` | Object in context | Listening data views, reference selectors |
| `'[%BeginOfCurrentDay%]'` | Start of today (00:00) | Date filtering |
| `'[%EndOfCurrentDay%]'` | End of today (23:59:59) | Date filtering |
| `'[%BeginOfCurrentWeek%]'` | Monday 00:00 of current week | Weekly reports |
| `'[%BeginOfCurrentMonth%]'` | 1st of current month 00:00 | Monthly reports |
| `'[%BeginOfCurrentYear%]'` | Jan 1st of current year 00:00 | Annual reports |
| `'[%DayLength%]'` | 86400000 (ms in a day) | Date arithmetic |
| `'[%WeekLength%]'` | 604800000 (ms in a week) | Date arithmetic |
| `'[%HourLength%]'` | 3600000 (ms in an hour) | Date arithmetic |

### Date Arithmetic with Tokens

```xpath
//Sales.Order[OrderDate > '[%BeginOfCurrentDay%]' - '[%WeekLength%]']
//HR.Leave[StartDate >= '[%BeginOfCurrentMonth%]' and EndDate <= '[%EndOfCurrentMonth%]']
```

### Functions

| Function | Purpose | Example |
|---|---|---|
| `contains(attr, 'text')` | Substring match | `[contains(Name, 'John')]` |
| `starts-with(attr, 'text')` | Prefix match | `[starts-with(Code, 'PRD-')]` |
| `string-length(attr)` | Character count | `[string-length(Description) > 0]` |
| `not(expr)` | Negation | `[not(Status = 'Deleted')]` |
| `true()` | Boolean true | `[IsActive = true()]` |
| `false()` | Boolean false | `[IsActive = false()]` |

### Empty / Null Checks

```xpath
//Sales.Order[Description != empty]
//Sales.Order[Description = empty]
//Sales.Order[Sales.Order_Customer = empty]
```

- `empty` checks for null/unset values.
- Association `= empty` checks whether the association is not set.

### Enumeration Values

```xpath
//Sales.Order[Status = 'Sales.OrderStatus.Open']
```

Format: `'Module.EnumerationName.Value'`.

## Common Patterns

### Row-Level Security (Current User)

Restrict entity access so users only see their own records:

```xpath
[Module.Entity_Account = '[%CurrentUser%]']
```

Via association chain:

```xpath
[Module.Entity_Owner/Module.Owner/Module.Owner_Account = '[%CurrentUser%]']
```

### Manager Sees Team Records

```xpath
[Module.Employee_Manager/Module.Manager/Module.Manager_Account = '[%CurrentUser%]']
```

### Date Range Filtering

```xpath
[CreatedDate >= '[%BeginOfCurrentWeek%]' and CreatedDate < '[%EndOfCurrentWeek%]']
```

### Reference Selector Constraint

Limit selectable objects in a reference selector:

```xpath
[Module.Entity_Parent = '[%CurrentObject%]']
```

### Excluding Specific Values

```xpath
[Status != 'Module.StatusEnum.Archived' and Status != 'Module.StatusEnum.Deleted']
```

### Combined Association + Attribute Filter

```xpath
[Module.Order_Customer/Module.Customer/IsActive = true() and TotalAmount > 0]
```

## XPath in Different Contexts

### Entity Access Rules

- Applied automatically by the runtime on every database query.
- Must use `'[%CurrentUser%]'` for user-specific filtering.
- Cannot call microflows or use complex logic.
- Keep access rule XPaths as simple as possible for performance.

### Retrieve Activities (Microflows)

- Used in the XPath constraint of a Retrieve action.
- Can reference `$variable` parameters via tokens.
- Executes within the current transaction context.

### Page Data Sources (XPath)

- Used when a list view, data grid, or template grid uses XPath as its data source.
- Applied in addition to entity access rules (both must pass).
- Supports all standard XPath syntax.

### Reference Selector / Input Reference Set Selector

- Constrains which objects appear in the dropdown.
- Often uses `'[%CurrentObject%]'` to filter by context.

## Performance Considerations

1. **Index attributes used in XPath constraints** — especially in access rules, as they run on every query.
2. **Avoid deep association chains** (3+ hops) in access rules — each hop adds a database join.
3. **Prefer direct attribute comparisons** over `contains()` and `starts-with()` — substring functions prevent index usage.
4. **Keep access rule XPaths narrow** — broad `or` conditions force the runtime to evaluate multiple paths.

## Notes

- XPath in Mendix is a subset of standard XPath 1.0, adapted for the Mendix data model.
- Association names are always fully qualified: `Module.AssociationName`.
- Entity names are always fully qualified: `Module.EntityName`.
- String comparisons are case-sensitive.
- For case-insensitive matching, use `contains()` on a lowercased stored attribute, or handle in a microflow.
