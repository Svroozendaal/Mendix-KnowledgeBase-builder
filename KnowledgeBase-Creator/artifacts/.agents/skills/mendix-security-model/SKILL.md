# SKILL: Mendix Security Model Reference

## Purpose

Reference for the Mendix security architecture: project security levels, user roles, module roles, entity access rules, page access, microflow access, and demo users. Use this skill to write correct security configurations in implementation plans.

## Used By

Mendix Syntax, Mendix Developer, KB Security Reviewer, Best Practice Recommender

## When to Use

- Defining access rules for new or modified entities.
- Specifying which roles can access pages and microflows.
- Configuring row-level security with XPath constraints.
- Reviewing the security implications of a proposed change.

## Security Architecture Overview

```
Project Security
  └── User Roles (project-level, assigned to users)
        └── Module Roles (per-module, map to user roles)
              ├── Entity Access Rules (CRUD + XPath row filter)
              ├── Microflow Access (allowed to execute)
              └── Page Access (allowed to view)
```

### Three Levels

1. **Project security** — global on/off and security level.
2. **User roles** — project-wide roles assigned to user accounts.
3. **Module roles** — per-module permission sets; user roles map to module roles.

## Project Security Levels

| Level | Behaviour | Use Case |
|---|---|---|
| **Off** | No security enforced; every user has full access | Local development only |
| **Prototype / demo** | Security enabled but not strictly enforced; sign-in required | Early prototyping, demos |
| **Production** | Full security enforced; all access rules checked on every operation | Production deployment |

- **Always develop with Production security** to catch access rule issues early.

## User Roles

```
User Role: RoleName
Description: "What this role represents"
Module roles:
  - ModuleA.RoleName
  - ModuleB.RoleName
  - Administration.Administrator (or Administration.User)
```

- User roles are defined at the project level.
- Each user role maps to one or more module roles.
- A user account is assigned one or more user roles.
- At runtime, the effective permissions are the **union** of all module role permissions.

## Module Roles

```
Module: ModuleName
Module roles:
  - Administrator
  - Manager
  - User
```

- Module roles are defined per module.
- They group entity access, page access, and microflow access within that module.
- Multiple user roles can map to the same module role.

## Entity Access Rules

### Rule Structure

```
Entity: Module.EntityName
Access rules:

  Rule 1:
    Module role(s): Administrator
    Allow create: Yes
    Allow read: Yes (all attributes) / Yes (specific: Attr1, Attr2)
    Allow write: Yes (all attributes) / Yes (specific: Attr1, Attr2)
    Allow delete: Yes
    XPath constraint: (none — sees all records)

  Rule 2:
    Module role(s): User
    Allow create: Yes
    Allow read: Yes (specific: Name, Status, CreatedDate)
    Allow write: Yes (specific: Name)
    Allow delete: No
    XPath constraint: [Module.Entity_Owner/Module.Owner/Module.Owner_Account = '[%CurrentUser%]']
```

### CRUD Permissions per Rule

| Permission | Meaning |
|---|---|
| **Create** | Can create new objects of this entity |
| **Read** | Can retrieve/view objects (filtered by XPath if set) |
| **Write** | Can modify attributes (can restrict to specific attributes) |
| **Delete** | Can delete objects (filtered by XPath if set) |

### Attribute-Level Security

- Read and Write permissions can be granted for **all attributes** or a **specific subset**.
- Attributes not included in the allowed set are invisible to the role.
- Use this to hide sensitive fields (e.g., salary, internal notes) from certain roles.

### XPath Row-Level Security

XPath constraints on access rules filter which **rows** the role can see and act on.

```
XPath constraint: [Module.Entity_Owner = '[%CurrentUser%]']
```

- Applied automatically on every database query for this role.
- Stacks with any additional XPath constraints in page data sources.
- An empty XPath constraint means the role sees all records.

### Common Access Rule Patterns

#### Personal Data Pattern

Users see only their own records:

```
XPath: [Module.Entity_Account = '[%CurrentUser%]']
```

#### Team Data Pattern

Users see records belonging to their team:

```
XPath: [Module.Entity_Team/Module.Team/Module.Team_Members = '[%CurrentUser%]']
```

#### Manager Pattern

Managers see records of their direct reports:

```
XPath: [Module.Employee_Manager = '[%CurrentUser%]']
```

#### Status-Based Access

Users can only modify records in certain states:

```
Rule for User role:
  Allow write: Yes (specific: limited attributes)
  XPath: [Status = 'Module.StatusEnum.Draft' and Module.Entity_Owner = '[%CurrentUser%]']
```

#### Full Access for Admin

```
Rule for Administrator role:
  Allow create: Yes
  Allow read: Yes (all attributes)
  Allow write: Yes (all attributes)
  Allow delete: Yes
  XPath constraint: (none)
```

## Page Access

```
Page: Module.PageName
Allowed roles:
  - ModuleName.Administrator
  - ModuleName.User
```

- If a role is not in the allowed list, the page is inaccessible (404/403).
- Navigation items pointing to inaccessible pages are automatically hidden.
- Page access is a coarse gate — entity access rules still apply to the data shown.

## Microflow Access

```
Microflow: Module.MicroflowName
Allowed roles:
  - ModuleName.Administrator
  - ModuleName.Manager
```

- If a role is not allowed, calling the microflow returns a security error.
- Applies to microflows triggered from the client (buttons, data sources).
- Sub-microflows called from other microflows inherit the caller's security context — they do not need separate access rules.

## Nanoflow Access

- Nanoflows run client-side. There is no explicit nanoflow access configuration.
- Security is enforced when the nanoflow interacts with the server (retrieve, commit) — entity access rules apply.
- Sensitive logic should be in microflows, not nanoflows.

## Anonymous Access

```
Project security:
  Allow anonymous users: Yes / No
  Anonymous user role: Module.AnonymousRole
  Sign-in page: Module.Login_Page
```

- Anonymous users get a specific user role with limited module role mappings.
- Typically used for public-facing pages (landing page, registration, login).
- Keep the anonymous role's entity access minimal.

## Demo Users

```
Demo user:
  Name: demo_admin
  User role: Administrator
  Password: 1 (auto-generated for demo mode)
```

- Demo users are created automatically when running locally with Prototype/demo security.
- One demo user per user role is common practice.
- Not deployed to production — they exist for local testing only.

## Security Checklist for New Features

When adding a new entity:

1. Define access rules for every module role that needs access.
2. Add XPath constraints for row-level security where needed.
3. Restrict attribute-level read/write to only what each role needs.
4. Index attributes used in XPath access rule constraints.

When adding a new page:

5. Set allowed roles in page properties.
6. Ensure the data source respects entity access rules.
7. Add the page to navigation only for the intended roles.

When adding a new microflow:

8. Set allowed roles for microflows called from the client.
9. Sub-microflows called only from other microflows do not need access rules.
10. If the microflow bypasses access rules (via sudo/system context), document why.

When adding a new module:

11. Define module roles that align with the project's user role structure.
12. Map module roles to user roles in project security.

## Notes

- Entity access rules are the **primary security mechanism** in Mendix. Pages and microflows are secondary gates.
- If an entity has no access rules for a role, that role has **zero access** (denied by default).
- Access rules apply to all retrieval paths: page data sources, microflow retrieves, REST/OData endpoints.
- Test security by switching between demo users in the Mendix local runtime.
- The `System.User` entity is the anchor for `'[%CurrentUser%]'` — all user-specific XPath constraints ultimately trace back to it via associations.
