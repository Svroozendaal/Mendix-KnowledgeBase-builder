# SKILL: Mendix Domain Modelling Reference

## Purpose

Reference for Mendix domain model configuration: entity setup, attribute types, association mechanics, validation rules, event handlers, indexes, and generalisation (inheritance). Use this skill to write correct domain model instructions in implementation plans.

## Used By

Mendix Syntax, Mendix Developer, KB Domain Expert, Best Practice Recommender

## When to Use

- Defining new entities, attributes, or associations in an implementation plan.
- Specifying access rules, validation rules, or event handlers.
- Explaining how associations, inheritance, or indexes work.
- Reviewing domain model design decisions.

## Entity Configuration

### Creating an Entity

```
Entity: Module.EntityName
Persistable: Yes (default) / No (non-persistable)
Generalisation: None / Module.ParentEntity
```

- **Persistable** entities are stored in the database.
- **Non-persistable** entities exist only in memory (session scope). Use for view models, helper objects, search parameters.
- **Generalisation** creates an inheritance relationship (see Generalisation section below).

### Attribute Types

| Type | Description | Example Use |
|---|---|---|
| `AutoNumber` | Auto-incrementing integer | IDs, reference numbers |
| `Binary` | File content | Stored files (use with System.FileDocument or System.Image) |
| `Boolean` | True / False | Flags, toggles (`IsActive`, `HasDiscount`) |
| `DateTime` | Date and time | Timestamps, deadlines, birth dates |
| `Decimal` | High-precision number | Currency, measurements, percentages |
| `Enumeration` | Fixed set of named values | Status, category, priority |
| `Hashed String` | One-way encrypted string | Passwords (rarely used directly; use System.User) |
| `Integer` | 32-bit whole number | Counts, quantities, ages |
| `Long` | 64-bit whole number | Large counters, external IDs |
| `String` | Text (configurable length) | Names, descriptions, codes |

### Attribute Properties

```
Attribute: AttributeName
Type: String
Length: 200 (or Unlimited)
Default value: '' (optional)
```

- **String length**: Set a maximum length. Use `Unlimited` only when necessary (uses TEXT/CLOB in DB).
- **Default value**: Set for attributes that should have an initial value on creation.

### Enumeration Definition

```
Enumeration: Module.EnumerationName
Values:
  - Open (caption: "Open")
  - InProgress (caption: "In Progress")
  - Closed (caption: "Closed")
```

- Enumeration names are PascalCase.
- Values are PascalCase identifiers with human-readable captions.
- Enumerations are defined at the module level and used as attribute types.

## Associations

### Association Types

| Type | Cardinality | Owner | Example |
|---|---|---|---|
| Reference | Many-to-one (*/1) | Child entity | `Order_Customer` — many orders belong to one customer |
| Reference (1/1) | One-to-one | Either entity | `Employee_Account` — one employee has one account |
| Reference set | Many-to-many (*/*) | Either entity (both for bidirectional) | `Product_Category` — products have many categories |

### Defining an Association

```
Association: Module.ParentEntity_ChildEntity
Type: Reference (*/1) / Reference set (*/*)
Owner: ParentEntity / ChildEntity / Both (reference set only)
Delete behaviour:
  - Owner delete: Keep / Delete referred objects
  - Referred delete: Keep / Delete owner objects
```

### Association Naming

- Format: `Entity_Entity` with the owner on the left.
- One-to-many: `Order_OrderLine` (Order is the "one" side).
- Many-to-many: `Product_Category`.
- Self-referencing: `Employee_Manager` (same entity, descriptive suffix).

### Delete Behaviour

| Setting | Meaning |
|---|---|
| **Keep** (default) | Deleting the owner leaves referred objects intact |
| **Delete referred objects** | Deleting the owner cascades deletion to referred objects |
| **Delete owner objects** | Deleting the referred object cascades deletion to owners |

- Configure carefully — cascading deletes can remove large object graphs.
- Mendix prevents deletion when it would violate a required association.

## Generalisation (Inheritance)

```
Entity: Module.SpecialisedEntity
Generalisation: Module.ParentEntity
Additional attributes:
  - SpecificAttribute: Type
```

- The specialised entity inherits all attributes, associations, and access rules from the parent.
- The specialised entity can add its own attributes and associations.
- Queries on the parent entity return all specialised entities as well.
- Limit inheritance depth to 2-3 levels for performance.

### Common Generalisation Patterns

- `System.FileDocument` → `MyModule.Document` (adds metadata attributes).
- `System.Image` → `MyModule.ProductImage` (adds product association).
- `Administration.Account` → `MyModule.ExtendedAccount` (adds app-specific profile fields).

## Validation Rules

```
Validation rule: Module.EntityName.RuleName
Attribute: AttributeName
Rule type: Required / Unique / Range / Regular expression / Custom (microflow)
Message: "Error message to display"
```

### Rule Types

| Type | Configuration | Example |
|---|---|---|
| **Required** | Attribute must not be empty | `Name` is required |
| **Unique** | Value must be unique across all objects | `Code` must be unique |
| **Range** | Numeric/date within bounds | `Quantity >= 1 and Quantity <= 9999` |
| **Regular expression** | String matches regex pattern | Email format: `^[^@]+@[^@]+\.[^@]+$` |
| **Maximum length** | String length limit | `Description` max 500 characters |

- Validation rules fire on commit (before-commit).
- They produce client-side feedback highlighting the invalid field.
- For complex validation, use a before-commit microflow (`BCO_Entity_Validate`).

## Event Handlers

```
Event handler: Module.EntityName
Event: Before commit / After commit / Before delete / After delete
Microflow: Module.MicroflowName
Raise an error to prevent commit: Yes / No (before-commit only)
```

### Event Handler Types

| Event | Timing | Common Use |
|---|---|---|
| **Before commit** | Before the object is persisted | Validation, set calculated fields, enforce business rules |
| **After commit** | After the object is persisted | Send notifications, trigger follow-up logic, audit logging |
| **Before delete** | Before the object is deleted | Check referential integrity, prevent deletion |
| **After delete** | After the object is deleted | Cleanup related data, audit logging |

### Event Handler Naming

- `BCO_Entity_Purpose` — before commit.
- `ACO_Entity_Purpose` — after commit.
- `BDE_Entity_Purpose` — before delete.
- `ADE_Entity_Purpose` — after delete.

## Indexes

```
Index: Module.EntityName
Attributes: Attribute1, Attribute2 (composite index)
```

- Add indexes to attributes used frequently in XPath constraints, especially in entity access rules.
- Add indexes to attributes used in sorting or searching.
- Composite indexes should list the most selective attribute first.
- Do not over-index — each index slows write operations.

### When to Add an Index

1. Attribute appears in an entity access rule XPath constraint.
2. Attribute is used as a data grid search field.
3. Attribute is used for sorting in a frequently accessed list.
4. Attribute is used in a microflow retrieve with high row count.

## Non-Persistable Entities

```
Entity: Module.SearchCriteria
Persistable: No
Attributes:
  - SearchTerm: String
  - DateFrom: DateTime
  - DateTo: DateTime
  - StatusFilter: Module.StatusEnum
```

### Common Uses

- **Search/filter helpers** — hold form input before executing a search microflow.
- **View models** — aggregate data from multiple entities for display.
- **Wizard state** — hold multi-step form progress.
- **API request/response wrappers** — temporary structures for REST calls.

### Non-Persistable Entity Rules

- Exist only in memory for the duration of the session.
- Cannot be retrieved from the database.
- Cannot have before/after-commit or delete events.
- Can have associations to persistable entities (reference only, not stored in DB).
- Garbage collected when no longer referenced.

## Notes

- Domain model changes in Studio Pro automatically generate database migration scripts.
- Renaming an entity or attribute updates all references in the project.
- Deleting an entity removes it from the database on next deployment (data loss — Mendix warns).
- Always review the `Errors` pane in Studio Pro after domain model changes to catch broken references.
