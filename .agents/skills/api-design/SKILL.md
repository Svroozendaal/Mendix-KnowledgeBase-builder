# SKILL: api-design

## Purpose

Shared API and interface design principles for contract-first development. Use when designing, modifying, or reviewing APIs, service interfaces, or data contracts.

## When to Use

- Architect is designing a new API, service interface, or data contract.
- Developer is implementing or modifying an API endpoint or data contract.
- Reviewer is assessing an API change for consistency, correctness, and forwards-compatibility.

## Procedure

When designing or modifying an API, service interface, or data contract, follow these principles:

1. **Contract first** — Define the input shape, output shape, and error codes before implementation. Document the contract in a docblock, OpenAPI spec, or interface definition.
2. **Version or namespace changes** — If an endpoint or interface may evolve, plan for versioning from the start. Never introduce breaking changes without explicit approval.
3. **Validate at the boundary** — Never trust the caller; validate all inputs at the entry point. Use the `security-review` skill for input sanitisation checks.
4. **Consistent error responses** — Return errors in a predictable format without leaking internal details. Define the error schema as part of the contract.
5. **Document the contract** — The interface definition must be clear about what the code does and what it requires. Include: purpose, inputs (params and types), outputs (return shape and status codes), error cases, and side effects.

## Output / Expected Result

```markdown
## API Contract - [Endpoint/Interface Name]
Purpose: [what this endpoint does]
Input: [shape, types, required fields]
Output: [shape, status codes]
Errors: [error format, codes, messages]
Versioning: [strategy or N/A]
Side effects: [none or description]
```

## Notes

- For new APIs, produce the contract before any implementation begins.
- For modifications to existing APIs, document the delta and confirm impact with Architect and Designer (if frontend-facing).
- Agents that should reference this skill: Architect, Developer, Reviewer.
