# SKILL: Mendix Pages and Widgets Reference

## Purpose

Reference for Mendix page structure, layout model, core widgets, data source configuration, and UI patterns. Use this skill to write correct page and widget instructions in implementation plans.

## Used By

Mendix Syntax, Mendix Developer, KB UX Interpreter, Best Practice Recommender

## When to Use

- Specifying page layout and widget configuration in an implementation plan.
- Choosing the right widget for a data display or input requirement.
- Configuring data sources for list and detail views.
- Defining conditional visibility, editability, and validation feedback.

## Page Structure

### Page Properties

```
Page: Module.PageName
Layout: Module.LayoutName (e.g., Atlas_Default, Atlas_TopBar)
Allowed roles: Role1, Role2
Navigation profile: Responsive / Tablet / Phone / Native mobile
```

### Layout Model

Pages are built on **layouts** which define the structural regions (header, sidebar, content area, footer). The page fills the content placeholder(s) defined by the layout.

```
Layout hierarchy:
  Atlas_Default (master layout)
    └── Atlas_Default_Responsive (responsive variant)
         ├── HeaderRegion
         ├── SidebarRegion (optional)
         ├── ContentRegion ← page content goes here
         └── FooterRegion
```

## Data Containers

### Data View

Displays and edits a **single object**.

```
Widget: Data view
Entity: Module.EntityName
Data source:
  - Context (object passed from caller)
  - Microflow: Module.DS_EntityName_GetDetail
  - Nanoflow: Module.DS_EntityName_GetDetail_NF
  - Listen to widget: [another list widget on the same page]
Editable: Yes / No / Conditional
```

- **Context**: The page receives the object from the calling page or microflow (Show Page activity).
- **Microflow data source**: Calls a microflow to retrieve/create the object.
- **Listen to widget**: Updates when the user selects a row in a connected list widget.

### List View

Displays a **list of objects** with a customisable template per item.

```
Widget: List view
Entity: Module.EntityName
Data source:
  - Database (XPath): [optional constraint]
  - Microflow: Module.DS_EntityName_GetList
  - Nanoflow: Module.DS_EntityName_GetList_NF
  - Association: Module.ParentEntity_ChildEntity
Page size: 20 (items per page)
```

- Use for card-like or custom layouts.
- Each item renders the template content.

### Data Grid

Displays a **list of objects** in a table with columns, sorting, and search.

```
Widget: Data grid
Entity: Module.EntityName
Data source:
  - Database (XPath): [optional constraint]
  - Microflow: Module.DS_EntityName_GetList
  - Association: Module.ParentEntity_ChildEntity
Columns:
  - AttributeName (caption: "Display Name", width: auto/fixed)
  - AssociationPath/AttributeName (for associated data)
Search bar: Yes / No
  Search fields:
    - AttributeName (type: text / dropdown / date range)
Selection mode: Single / Multi / None
Default button: Edit / (custom)
Paging: Yes (page size: 20)
```

- Best for tabular data with search and sort requirements.
- Supports inline editing, row selection, and custom buttons.

### Template Grid

Displays objects in a **grid/tile layout** with customisable template per item.

```
Widget: Template grid
Entity: Module.EntityName
Data source: Database / Microflow / Association
Rows: 2
Columns: 3
Page size: 6 (rows × columns)
```

- Use for card/tile views (e.g., product catalogue, dashboard cards).

## Input Widgets

### Text Box

```
Widget: Text box
Attribute: Module.Entity/StringAttribute
Label: "Label text"
Placeholder: "Enter value..."
Show label: Yes / No
Editable: Always / Never / Conditional
Read-only style: Control / Text
Validation: Required / Regex / Custom
On change: Microflow / Nanoflow (optional)
```

### Text Area

```
Widget: Text area
Attribute: Module.Entity/StringAttribute
Max length: 1000
Rows: 5 (initial visible rows)
Counter: Yes / No (show character count)
```

### Numeric Input (Integer, Decimal, Long)

```
Widget: Text box (numeric)
Attribute: Module.Entity/DecimalAttribute
Decimal precision: 2
Group digits: Yes / No
Placeholder: "0.00"
```

### Date Picker

```
Widget: Date picker
Attribute: Module.Entity/DateTimeAttribute
Format: Date / Time / DateTime / Custom
Custom format: "dd-MM-yyyy HH:mm"
Placeholder: "Select date..."
```

### Drop-Down (Enumeration)

```
Widget: Drop-down
Attribute: Module.Entity/EnumAttribute
Empty option caption: "(Select...)"
```

### Check Box

```
Widget: Check box
Attribute: Module.Entity/BooleanAttribute
Label: "Label text"
```

### Radio Buttons (Enumeration or Boolean)

```
Widget: Radio buttons
Attribute: Module.Entity/EnumAttribute
Orientation: Horizontal / Vertical
```

### Reference Selector

Selects a **single associated object** from a dropdown.

```
Widget: Reference selector
Association: Module.Entity_AssociatedEntity
Display attribute: AssociatedEntity/Name
Selectable objects:
  - Database (XPath): [optional constraint]
  - Microflow: Module.DS_EntityName_GetOptions
Select page: Module.Entity_Select (optional, for pop-up selection)
```

### Reference Set Selector

Selects **multiple associated objects** (many-to-many).

```
Widget: Reference set selector
Association: Module.Entity_AssociatedEntity (reference set)
Display attribute: AssociatedEntity/Name
Add/remove buttons: Yes
Constraint: [optional XPath]
```

### Input Reference Set Selector

Inline grid for managing many-to-many associations.

```
Widget: Input reference set selector
Association: Module.Entity_AssociatedEntity (reference set)
Columns: [attribute columns to display]
Add button: Calls selection page or microflow
Remove button: Removes association (does not delete object)
```

### File Manager / Image Uploader

```
Widget: File manager / Image uploader
Entity: Module.Document (specialisation of System.FileDocument or System.Image)
Max file size: 5 (MB)
Allowed extensions: jpg, png, pdf
Show file name: Yes / No
```

## Action Widgets

### Buttons

```
Widget: Action button
Caption: "Save"
Style: Default / Primary / Success / Warning / Danger / Link
Icon: (optional Mendix icon)
On click:
  - Call microflow: Module.ACT_Entity_Save
  - Call nanoflow: Module.ACT_Entity_Save_NF
  - Save changes (commits all objects on the page)
  - Cancel changes (rolls back and closes page)
  - Close page
  - Show page: Module.TargetPage
  - Delete object
  - Sign out
```

### Common Button Patterns

| Pattern | On Click Action | Typical Caption |
|---|---|---|
| Save and close | Call microflow `ACT_Entity_Save` (validate + commit + close) | "Save" |
| Cancel | Cancel changes | "Cancel" |
| New | Show page `Entity_NewEdit` with new empty object | "New" |
| Edit | Show page `Entity_NewEdit` with selected object | "Edit" |
| Delete | Call microflow `ACT_Entity_Delete` or Delete object action | "Delete" |

## Conditional Visibility

```
Widget: [any widget]
Visible: Based on attribute value
  Attribute: Module.Entity/BooleanAttribute
  Condition: true → visible / false → hidden
```

Or based on module role:

```
Visible: Based on module role
  Roles: Administrator, Manager (visible)
  Roles: User (hidden)
```

- Conditional visibility hides widgets without removing them from the DOM.
- For security-sensitive hiding, use page access rules in addition to visibility.

## Conditional Editability

```
Widget: [input widget]
Editable: Conditional
  Attribute: Module.Entity/Status
  Condition: Status = 'Open' → editable / otherwise → read-only
```

- Use to lock fields based on object state (e.g., approved orders become read-only).

## Page Data Source Patterns

### Overview Page (List)

```
Page: Entity_Overview
  Data grid
    Entity: Module.Entity
    Data source: Database (XPath)
    Search bar: Yes
    Buttons: New, Edit, Delete
```

### Detail Page (View/Edit)

```
Page: Entity_NewEdit
  Data view
    Entity: Module.Entity
    Data source: Context (passed object) or Microflow (for new objects)
    Editable: Yes
    Contents:
      - Input widgets for each editable attribute
      - Reference selectors for associations
      - Save button -> ACT_Entity_Save
      - Cancel button -> Cancel changes
```

### Dashboard Page

```
Page: Dashboard_Home
  Container (row)
    Data view (microflow source: DS_Dashboard_GetStats)
      - Statistic widgets
    Data grid (top 10 recent items)
    List view (pending approvals)
```

## Navigation

### Adding a Page to Navigation

```
Navigation:
  Menu item: "Entity Overview"
  Icon: (optional)
  Target page: Module.Entity_Overview
  Visible for roles: Role1, Role2
```

- Navigation items are defined in the project's Navigation document.
- Separate navigation profiles exist for responsive, tablet, phone, and native mobile.

## Notes

- All widgets must be inside a data container (data view, list view, etc.) to access entity data.
- Nested data views are allowed (e.g., data view inside a list view item template).
- Widgets inherit their context object from the nearest enclosing data container.
- Page titles, button captions, and labels support parameterised text with `{1}` placeholders.
